local tablex = require 'pl.tablex'
local List = require 'pl.List'
local Map = require 'pl.Map'
local class = require 'lib.middleclass'

-- A playback is an active source
local Playback = class('Playback')
function Playback:initialize(source, object, options)
  self.elapsed = 0
  self.source = source
  self.object = object
  self.options = options
  --self.old_position = object and object.getPosition and object:getPosition() or { 0, 0 }
  self.old_position = self.object and self.object.Position and {self.object.Position.x, self.object.Position.y} --or { 0, 0 }
  self.source:setAttenuationDistances(2, 12000)
  self.source:setRelative(true)
  self.source:setVolumeLimits(0, 1)
  self.source:play()
  
end

function Playback:setOptions(options)
	self.options = options
end

function Playback:update(dt)
  	-- Attenuation
	  --print(tostring(self.object.Position.x))
  if not self.source:isPlaying() then
	self.source:stop()
	local distance = self.source:getAttenuationDistances()
    return false
  end
  if self.object and self.object.Position then
    --    local x, y = unpack(self.object:getPostion())
	local x, y = unpack (self.object and self.object.Position and {self.object.Position.x, self.object.Position.y}) --or { 0, 0 })	
    --print(x^2/x, y^2/y)
    --local ox, oy = unpack (self.old_position)
    --local vx, vy = (x - ox) * dt, (y - oy) * dt
	self.old_position = {x,y}
	
	local objX, objY = self.object.Position.x, self.object.Position.y
	local cameraX, cameraY = unpack {System.camera:worldCoords(System.camera:position())}
	cameraX = cameraX - (System.w/2)
	local dx = cameraX - (objX * 32)
	local dy = cameraY - (objY * 32)
	local camDist = math.sqrt( dx * dx + dy * dy )
	
	local volMultiplier = System.audio:getSCVol(self.options.SoundClass)
	local clipVol = self.options.Volume
	if clipVol then volMultiplier = (clipVol * volMultiplier) end
	



	local attDist = 4000 - (camDist * volMultiplier)
	
	if attDist > 4000 then attDist = 4000
	elseif attDist < 0 then attDist = 0
	end
	
	self.source:setAttenuationDistances(attDist , 12000)
	--print(attDist)

	
	--print(camDist)
	--print(objX .. '_' .. objY)
	
	self.source:setPosition((dx * -32), 0, 0)
	--print(200 / camDist )
	--self.source:setVelocity(vx, vy, 0)
  end
	
  return true
  
end




local Clip = class('Clip')
Clip.Defaults = {
  SourceIdleMin = 1, -- More sources will be created if less than this many are available
  SourceIdleMax = 4, -- Idle sources will be culled if more than this many are available
  SourceMax = 16, -- Maximum number of active sources
  
  --self.source:setAttenuationDistances(1, 300)

  --AirAbsorption = 1,
  --AttenuationDistances = { 100, 100 },
  --Looping = false,
  --Pitch = 1,
  --Volume = 0.5,
  --Position = {0, 0, 0},
  --Velocity = {0, 0, 0},
  --Relative = false, -- Relative is used for UI so it doesn't move when the camera moves
}

function Clip:initialize(title, source, options, object)
  assert(title and type(title) == "string", "You must provide a title")
  assert(source, "You must provide a source")
  self.title = title
  self.object = object
  self.master = source           -- This copy of the source is cloned to make the sources used for playback
  self.idle = List.new()                  -- Idle sources
  self.active = Map{}                -- handle:Playback dict
  self.options = {}
  -- Populate `opt` with defaults, the apply supplied options
  local opt = tablex.deepcopy(Clip.Defaults)
  tablex.update(opt, options or {})
  -- Parse the options and store in self.options
  --self:ApplyOptions(options)
end




-- Apply options to the source
-- Supported: AirAbsorption, AttenuationDistances, Looping, Position, Velocity, Relative, Volume
-- Missing: Cone, Direction, Effect, Filter, Rolloff, VolumeLimits
-- Special: SourceIdleMin, SourceIdleMax, SourceMax
function Clip:ApplyOptions(options)
  options = options --or {}

for i = 0, #options do
  tablex.pairmap(function(k, v)
   --print("Apply Options ", k, " ", v)
	--i = i +1
    if k == 'AirAbsorption' and type(v) == 'number' then
      self.options[k] = v
      self.master:setAirAbsorption(v)
    elseif k == 'AttenuationDistances' and type(v) == 'table' and #v == 2 then
      self.options[k] = v
      self.master:setAttenuationDistances(v[1], v[2])
	elseif k == 'Looping' and type(v) == 'boolean' then
      self.options[k] = v
	  self.master:setLooping(v)
	  print(v)
    elseif k == 'Pitch' and type(v) == 'number' then
      self.options[k] = v
      self.master:setPitch(v)
    elseif k == 'Volume' and type(v) == 'number' then
      self.options[k] = v
      self.master:setVolume(v)
    elseif k == 'Position' and type(v) == 'table' and #v == 3 then
      self.options[k] = v
      self.master:setPosition(unpack(v))
    elseif k == 'Velocity' and type(v) == 'table' and #v == 3 then
      self.options[k] = v
      self.master:setVelocity(unpack(v))
    elseif k == 'Relative' and type(v) == 'boolean' then
      self.options[k] = v
      self.master:setRelative(v)
    elseif k == 'SourceIdleMin' and type(v) == 'number' then
      self.options[k] = v
    elseif k == 'SourceIdleMax' and type(v) == 'number' then
      self.options[k] = v
    elseif k == 'SourceMax' and type(v) == 'number' then
	  self.options[k] = v
	elseif k == 'SoundClass' and type(v) == 'string' then
	  self.options[k] = v
	  --self.volMultiplier = System.audio:getSCVol(v)
    else
      print("Unknown clip option: ", k, " ", v)
    end
  end, options)
  Playback:setOptions(options)
end

end

function Clip:update(dt)
  


  -- Update all the clips, save the handles of finished clips for removal
  local remove = List.new()
  tablex.pairmap(function(handle, playback)
     local active = playback:update(dt)
     if not active then
       remove:append(handle)
     end
   end, self.active)

   -- Recycle sources from finished clips
   remove:foreach(function(handle)
     self.idle:append(self.active[handle].source)
     self.active:set(handle, nil)
   end)

   Playback:update(dt)
   
   self:_manage_sources()
end

function Clip:play(handle, object, options, title)
  return self:_play(handle, object, options, title)
end

-- return an available source or create one if none are available
function Clip:_get_source()
  if #self.idle > 0 then
    local s = self.idle[#self.idle]
    self.idle[#self.idle] = nil
    return s
  elseif self.options.SourceMax == nil or #self.active < self.options.SourceMax then
    return self.master:clone()
  else
    return nil
  end
end

-- done with source, put in idle list
function Clip:_release_source(s)
  self.idle[#self.idle + 1] = s
end

-- options passed in are playback specific
-- Todo: do something with them
function Clip:_play(handle, object, options, title)
  local source = self:_get_source()
  if source == nil then return end  -- Bail if we didn't get a source, this might happen is the SourceMax limit has been hit
  local playback = Playback:new(source, object, options)
  self.title = title
  self.active[handle] = playback
  self:initialize(title, source, options, object)
  Playback:initialize(source, object, options)
  --print(title)
  self:ApplyOptions(options)
  self:_manage_sources()
end

-- Create or destroy sources to follow SourceIdleMax/SourceIdleMin limits
function Clip:_manage_sources()
  while self.options.SourceIdleMax and self.idle:len() > self.options.SourceIdleMax do
    self.idle:pop()
  end

  if self.options.SourceIdleMin and #self.idle < self.options.SourceIdleMin then
    self.idle:append(self.master:clone())
  end
end

return Clip

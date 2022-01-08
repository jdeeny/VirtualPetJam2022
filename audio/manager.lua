local pretty = require 'pl.pretty'
local Signal = require 'lib.hump.signal'
local tablex = require 'pl.tablex'
local Map = require 'pl.Map'
local List = require 'pl.List'
local class = require 'lib.middleclass'

local Clip = require 'audio.clip'
local Track = require 'audio.music'
local ClipOptions = require 'audio.options'

local AudioManager = class('AudioManager')
function AudioManager:initialize()
  self.tracks = Map{} -- name:Track dict of available tracks
  self.clips = Map{} -- name:Clip dict of available clips
  self.groups = Map{} -- name:{Clip} list of clips for each event
  self.active = Map{} -- handle:Clip dict of active clips and timeouts (a clip may be listed by more than one handle)

  self.music = nil
  self.aliases = tablex.copy(ClipOptions.Aliases) or {}
  self.handle_num = 1 -- used to hand out handles to callers
  self.isMusicPlaying = false

  self.soundclasses = {
	  Music = .7,
	  UI = .7,
	  Ambient = .4,
	  Gameplay = .5
	}

  self.musicTracks = {
	  'alternating loop',
	  'capitol drive comeback',
	  'cyclic loop',
    'Dead Ocean',
    'Beginnings',
    'Resource_Extraction',
    'Progress'
  }

  self:_load_tracks()
  self:_load_clips()
end


function AudioManager:update(dt)
  -- Update active clips
  tablex.pairmap(function(handle, clip)
	clip:update(dt)
  end, self.active)
  local lX, lY, lZ = {0,0,0} -- unpack {System.camera:position()}

  love.audio.setOrientation(1, 0, 0, 0, 0, 0)
  love.audio.setPosition(0, 1, 0)
  if not Track:update() then
  else
	self:playRandomMusic()
  end
  --print(lX)
end


-- Keep a list of the music assets
-- Just one level for now, eventually could have multiple subtracks
function AudioManager:_load_tracks()
  assert(Assets.music, "There is no music directory in assets")

  tablex.pairmap(function(key, value)
    if key ~= "_path" and key ~= "raw" and value and value.type and value:type() == 'Source' then
    local fullname = prefix or key
    print("Add track ", key, value, value:type())
    -- type of Source is an audio file
    self.tracks:set(key, Track:new(key, value))
  end
end, Assets.music)
end

-- Register a callback for each clip
function AudioManager:_register_clip(clip, name)
--print("Register clip ", name, clip)
--Signal.register(name, function(name, event_data) System.audio.play('cat', name) end)
end

-- Go through the audio assets and setup handers for each event
function AudioManager:_load_clips(table, prefix, register)
table = table or Assets.sound
prefix = prefix or ""
register = register or false
tablex.pairmap(
  function(key, value)
    if key ~= "_path" and key ~= "raw" and value and value.type and value:type() == 'Source' then
      local fullname = (prefix or "") .. key
      -- assert(value:getChannelCount() == 1, "Sound clips must be mono: " .. fullname)
      print("Load clip ", fullname, value)
      self.clips[fullname] = Clip:new(fullname, value, nil)
      if register then self:_register_clip(value, fullname) end

    elseif key ~= "_path" and key ~= "raw" and type(value) == 'table' then
      local subpath = (prefix or "") .. key .. "."
      local do_register = register
      --if key == 'ui' or key == 'worker' then -- Register clips found under these keys
      --  do_register = true
      --end
      self:_load_clips(value, subpath, do_register)
    end
  end, table)
end

function AudioManager:_new_handle()
  local h = self.handle_num
  self.handle_num = self.handle_num + 1
  return h
end

-- Play music
function AudioManager:music_play(track)
  if track == nil then
    if self.music then
      self.music:play()
    end
    return
  end
  local t = self.tracks[track]
  if self.music then self.music:pause() end
  self.music = t
  self.currentMusic = track
  self.isMusicPlaying = true
  if self.music then self.music:play() end
end

-- Stop all music
function AudioManager:music_stop()
  self.music:stop()
end

function AudioManager:play(category, object, clip, options)
  print("Play: ", category, clip, options)
  -- Replace with alias, should one exist
  --clip = (self.aliases and self.aliases[clip]) or clip
  -- Replace with a random selection from a group, if the requested is a group
  --clip = self.groups and self.groups[clip] and self.groups[clip][math.random(#self.groups[clip])]

  if clip == nil then
    print("Unknown clip")
    return
  end

  print("Play clip: "..clip)

  local c = self.clips[clip]
  if c then
    if category == 'ui' then
      options.update({Relative = true})
    elseif category == 'game' then
    else
      print("Category unknown: ".. category)
    end

	local h = self:_new_handle()
	local clipTitle = tostring(clip .. '_' .. h)
    c:play(h, object, options, clipTitle)
    self.active:set(h, c)
    return h
  else
    print("Couldn't play ".. clip)
  end

  return nil

end



function _get_sound(o, sound)
  if o == nil or type(o) ~= 'table' or o.Sounds == nil or o.Sounds[sound] == nil then return nil end

  local s = o.Sounds[sound]
  if type(s) == 'table' then
    return s[love.math.random(1, #s)]
  elseif type(s) == 'string' then
    return s
  else
    print("Attempt to get sound ", sound, " but found type ", type(s))
  end
  return nil
end

function AudioManager:getSCVol(soundclass)
	--print(self.soundclasses[soundclass])
	return self.soundclasses[soundclass]

end

function AudioManager:playRandomMusic()
	local newMusic = love.math.random(table.getn(self.musicTracks))
	self:music_play(self.musicTracks[newMusic])
end




return AudioManager

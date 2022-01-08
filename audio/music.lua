local tablex = require 'pl.tablex'
local class = require 'lib.middleclass'

local Track = class('Track')

function Track:initialize(title, source)
  assert(title and type(title) == "string", "You must provide a title")
  assert(source, "You must provide a source")
  self.title = title
  self.source = source
  self.source:setVolume(0.5)
  self.source:setLooping(true)
end

function Track:play()
  self.source:play()
end

function Track:stop()
  self.source:stop()
end

function Track:pause()
  self.source:pause()
end

function Track:update()
	if self.source then return self.source:isPlaying() end
end

return Track

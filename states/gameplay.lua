local class = require 'lib.middleclass'
local simTimer = Timer.new()

local Qix = require 'qix.qix'

local Gamestate = require 'states.gamestate'
local GamePlay = class('GamePlay', Gamestate)

function GamePlay:initialize(name)
    Gamestate.initialize(self, name)
    self.qix = nil
end

function GamePlay:enter(arg)
    System.audio:playRandomMusic()
    self.qix = Qix:new()
--    simTimer:every(1, function() Signal.emit(SignalList.TickUpdate) end)
end

function GamePlay:wheelmoved(x, y)
--    playArea.camera:zoomInDirection(y)
end

function GamePlay:update(dt)
    simTimer:update(dt)
    self.qix:update(dt)
end

function GamePlay:draw(dt)
    love.graphics.clear(0,0,0)
    self.qix:draw(dt)
end

return GamePlay

local class = require 'lib.middleclass'
local Gamestate = require 'states.gamestate'
local ExitState = class('ExitState', Gamestate)

function ExitState:initialize(name)
  Gamestate.initialize(self, name)
end

function ExitState:enter()
  print("enter ExitState")
  love.event.quit(0)
end

function ExitState:draw()
end

function ExitState:update()
end

return ExitState

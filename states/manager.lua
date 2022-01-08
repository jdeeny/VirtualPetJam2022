local class = require 'lib.middleclass'

local GamestateManager = class('GamestateManager')

function GamestateManager:initialize()
  self.states = {
    splash = require('states.splash'):new('splash'),
    mainmenu = require('states.mainmenu'):new('mainmenu'),
    --gameplay = require('states.gameplay'):new('gameplay'),
    --credits = require('states.credits'):new('credits'),
    exit = require('states.exit'):new('exit'),
  }
  self.current = { }
  self:setState('splash')
end

-- Sets the state, dropping any in the stack
function GamestateManager:setState(state)
  if not self.states[state] then
    print("Attempt to switch to nonexistant state " .. state)
    return
  end
  self.current = { }
  self:pushState(state)
end

-- Enter a state by pushing it on the stack
function GamestateManager:pushState(state)
  if not self.states[state] then
    print("Attempt to push and switch to nonexistant state " .. state)
    return
  end
  self.current[#self.current + 1] = state
  local st = self:getState()
  st:enter()
end

-- Leave a state by popping from the stack
function GamestateManager:exitState()
  self:getState():exit()
  self.current[#self.current] = nil
  self:getState():returnTo()
end

function GamestateManager:getCurrent()
  return self.current[#self.current]
end

function GamestateManager:getState()
  return self.states[self:getCurrent()]
end

function GamestateManager:update(dt)
  self:getState():update(dt)
end

-- Here we draw all states in the stack, so pause overlays the main game
function GamestateManager:draw()
  for _, state in ipairs(self.current) do
    self.states[state]:draw()
  end

  love.graphics.setColor(1,1,1,1)
end


function GamestateManager:mousepressed(x, y, button)
    self:getState():mousepressed(x, y, button)
end
function GamestateManager:mousemoved(x, y, dx, dy, istouch)
    self:getState():mousemoved(x, y, dx, dy, istouch)
end
function GamestateManager:mousereleased(x, y, button)
    self:getState():mousereleased(x, y, button)
end
function GamestateManager:wheelmoved(x, y)
    self:getState():wheelmoved(x, y)
end


return GamestateManager

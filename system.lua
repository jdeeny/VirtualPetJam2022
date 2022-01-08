local class = require 'lib.middleclass'

-- Pass callbacks through to gamestate
function love.mousepressed(x, y, button)
    if GameState then GameState:mousepressed(x, y, button) end
    if InputManager then InputManager:mousepressed(x,y,button) end
end
function love.mousemoved(x, y, dx, dy, istouch)
    if GameState then GameState:mousemoved(x, y, dx, dy, istouch) end
    if InputManager then InputManager:mousemoved(x,y,dx,dy,istouch) end
end
function love.mousereleased(x, y, button)
    if GameState then GameState:mousereleased(x, y, button) end
    if InputManager then InputManager:mousereleased(x, y, button) end
end
function love.wheelmoved(x, y)
    if GameState then GameState:wheelmoved(x, y) end
end
function love.resize(w, h)
    if System then System:updateWindowSize(w, h) end
end

local System = class('System')

function System:initialize()
    self:updateWindowSize(love.graphics.getWidth(), love.graphics.getHeight())
    self.flux = require('lib.flux')
    self.playerInput = require('controls')
	self.audio = require('audio.manager'):new()
	--self.mainMenu = require('mainmenu')
	
end

function System:updateWindowSize(w, h)
    self.w = w
    self.h = h
end

return System

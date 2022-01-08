local class = require 'lib.middleclass'
Assets = require('lib.cargo').init('assets')(true)
Timer = require ('lib.hump.timer')
Signals = require ('signals')
Fonts = { halgon = Assets.fonts.Halogen(72), }

function love.load()
    love.graphics.setDefaultFilter("linear","nearest",1)
    math.randomseed(os.time())
    System = require('system'):new()
    GameState = require('states/manager'):new()
end

function love.update(dt)
    System.flux.update(dt)
    System.playerInput:update(dt)
    GameState:update(dt)
    System.audio:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.clear(0, 0, 0)
    GameState:draw()
end

function love.quit()
end

function love.focus(f)
--   if not f and gameWorld.gameState:getCurrent() == 'gameplay' then
--     gameWorld.gameState:pushState('pause')
--   end
end


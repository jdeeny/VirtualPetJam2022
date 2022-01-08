local class = require 'lib.middleclass'
local Gamestate = require 'states.gamestate'
local Splash = class('Splash', Gamestate)

function Splash:initialize(name)
  Gamestate.initialize(self, name)
  self.forcewatch_time = 1.0
  self.fade = 1.0
end

function Splash:enter()
  print("enter splash")
  System.audio:music_play('free')
  self.forcewatch_time = love.timer.getTime() + 0.25
  self.fade = 1.0
  System.flux.to(self, 1.0, { fade = 0.0 }):ease("quadinout")
    --:oncomplete(function() System.audio:play('UI', nil, 'Simjam_vo', {}) end)
  System.audio:play('UI', nil, 'Simjam_vo', {})
end

function Splash:draw()
  love.graphics.setColor(1,1,1)
  local s = math.max(System.w/1280, System.h/720)
  local xo = 0
  local yo = 0
  love.graphics.draw(Assets.image.splash, xo, yo, 0, s, s)
  if self.fade > 0 then
    love.graphics.setColor(0.0, 0.0, 0.0, self.fade)
    love.graphics.rectangle('fill', 0, 0, System.w, System.h)
  end
end

function Splash:update()
  if (System.playerInput:pressed('action') or System.playerInput:pressed('pour') or System.playerInput:pressed('mb1'))
     and love.timer.getTime() > self.forcewatch_time and self.fade == 0
  then
    System.flux.to(self, 1.2, { fade = 1.0 }):ease("quadinout"):after(0.2, {}):oncomplete( function() GameState:setState('mainmenu') end )
  end
end

return Splash

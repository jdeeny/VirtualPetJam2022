local love = love
-- local pretty = require 'pl.pretty'
local tablex = require 'pl.tablex'
local class = require 'lib.middleclass'
local Gamestate = require 'states.gamestate'
local flux = System.flux
local text = require 'lib.text'

local MainMenu = class('MainMenu', Gamestate)

local play_item = {
  text = "Free Play",
  next_state = 'gameplay',
}
local credits_item = {
  text = "Credits",
  next_state = 'credits',
}
local exit_item = {
  next_state = 'exit',
  text = "Exit"
}

local title_x = 0.12
local title_y = 0.22
local menu_x = 0.12
local menu_y = 0.36
local menu_height = 0.4

function MainMenu:initialize(name)
  Gamestate.initialize(self, name)

  self.animations = {}
  self.images = {}

--  local brugga_arch = require('entities.archetypes.brugga')
--  for name, anim in pairs(brugga_arch.animations) do
--    self.animations[name] = anim8.newAnimation(anim.grid, anim.rate)
--    self.images[name] = anim.image
--  end

--  self.anim = 'idle'

  self.fade = 0.0


  self.mouse_posn = { 0, 0 }

  self.menu = {
    play_item,
    credits_item,
    exit_item
  }

  tablex.imap(function(v)
    v.text_obj = text.new(true, "left")
    v.text_obj.default_font = Assets.fonts.Halogen(72)
    v.text_obj:send(v.text, nil, true)
  end, self.menu)

  self.title = text.new(true, "left")
  self.title.default_font = Assets.fonts.Halogen(140)
  self.title:send("Watts UP", nil, true)
end

function MainMenu:enter()
  System.audio:play('UI', nil, 'Watts_Up_vo', {})
  System.audio.music_play('dihedral')
  --self.backsnow = require('ui.snow'):new()
  --self.snow = require('ui.snow'):new()
  self.fade = 1.0
  flux.to(self, 1, { fade = 0.0 }):ease("quadinout")
  self.lightAlpha = 0
  self.lightTween = flux.to(self, 1, { lightAlpha = 1 })
    :ease('elasticin')
--    :oncomplete(function() System.audio:play('UI', nil, 'Watts_Up_vo', {}) end)
    :after(self, .5, { lightAlpha = .5 })
    :ease('elasticout')
    :after(self, .5, { lightAlpha = 1 })
    :ease('elasticin')
end

local function _scale()
  local a = System.w / 1080
  local b = System.h / 720
  return math.min(math.floor(math.min(a, b)), 1)
end

function MainMenu:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.clear(0.5, 0.2, 0.2)
  self.title:draw(title_x * System.w, title_y * System.h, _scale())
  local i = 1
  tablex.imap(function(v)
    --print(v.text)
    local x = System.w * menu_x
    local y = System.h * menu_y + i * (System.h * menu_height) / #self.menu
    if self.selected == i then
      v.text_obj:draw(x, y, _scale() * 1.1)
    else
      v.text_obj:draw(x, y, _scale())
    end
    i = i + 1
  end, self.menu)

  self.mouse_posn = self.mouse_posn or { 0, 0 }
  local mx, my = unpack (self.mouse_posn)
  love.graphics.rectangle('fill', mx, my, 5, 5)

  ----
  --- BG
--  love.graphics.setColor(gameWorld.colors.white)
--  love.graphics.clear(gameWorld.colors.title_background)
--  love.graphics.draw(Assets.backdrops.TITLE_Layer1, 0, 0)
--  self.backsnow:draw()
--  love.graphics.draw(Assets.backdrops.TITLE_Layer2, 0, 0)
--  love.graphics.draw(Assets.backdrops.TITLE_Layer3_LIGHTSOFF, 0, 0)
--  love.graphics.setColor(1.0,1.0,1.0,self.lightAlpha)
--  love.graphics.draw(Assets.backdrops.TITLE_Layer3, 0, 0)
--  love.graphics.setColor(1.0,1.0,1.0,1.0)
--  --love.graphics.setColor(0.0,0.0,0.0,1.0)
--  --love.graphics.draw(self.title, (1280 - self.title:getWidth()) / 2, 100)
--  --love.graphics.setColor(1.0,1.0,1.0,1.0)
--  ----- Brugga
--  --self.animations[self.anim]:draw(self.images[self.anim], self.brugga_x, self.brugga_y)
--
--  self.menu:draw((1280 - self.menuWidth) / 2, 720 - self.menuHeight - 100 )
--  self.snow:draw()
  if self.fade > 0 then
    love.graphics.setColor(0.0, 0.0, 0.0, self.fade) --(0.0, 0.0, 0.0, self.fade)
    love.graphics.rectangle('fill', 0, 0, 1280, 720)
  end

end

function MainMenu:update(dt)
  self.title:update(dt)
  tablex.imap(function(v)
    --print("upd")
    v.text_obj:update(dt)
  end, self.menu)

  self.mouse_posn = { love.mouse.getPosition() }

  local x, y = unpack(self.mouse_posn or {0,0})
  x = x / System.w
  y = y / System.h

  local over = (y - menu_y) / (menu_height) * #self.menu
  --print("oveR: ", over, " y: ", y)
  if over <= 0 then --or over > #self.menu then
    self.selected = nil
  else
    self.selected = math.floor(over) --math.max(math.min(math.floor(over + 0.5), #self.menu, 1))
--    print("Sel:", self.selected)
  end


  if System.playerInput:pressed('action') then
    if self.selected and self.menu[self.selected] then
      flux.to(self, 0.2, { fade = 1.0 }):oncomplete(function() GameState:setState(self.menu[self.selected].next_state or 'splash') end)
    else
    end

    --flux.to(self, 0.2, { fade = 1.0 }):oncomplete(function() GameState:setState('gameplay') end)
  end

  --self.backsnow:update(dt*0.9)
  --self.snow:update(dt)
  --self.animations[self.anim]:update(dt)
end

return MainMenu



--[[
local class = require 'lib.middleclass'
local colors = require 'ui.colors'
local Text = require 'ui.text'
local Slider = require 'ui.slider'

local Menu = class('Menu')
local PI = 3.14159

function Menu:initialize(entries, w, h)
  local _entries = entries
  self.x = 1
  self.y = 1
  self.w = w or 700
  self.h = h or 350
  self.selected = 1
  self.font = gameWorld.assets.fonts.generic(42)
  self.vsize = self.h / #_entries
  self.vpad = 50
  self.spin = 0
  self.hpad = 25
  self.segments = 10
  self.sprites = {
    left = gameWorld.assets.sprites.ui.selectorLeft,
    right = gameWorld.assets.sprites.ui.selectorRight,
    slideLeft = gameWorld.assets.sprites.ui.selectorLeft,
    slideRight = gameWorld.assets.sprites.ui.selectorRight,
  }

  for _, entry in ipairs(_entries) do
    if entry.kind == 'text' then
      entry.text = Text:new(entry.label, { halign='center', valign='center', font=self.font })
      entry.width = entry.text:getWidth()
    elseif entry.kind == 'slider' then
      entry.text = Text:new(entry.label, { halign='left', valign='center', font=self.font })
      entry.slider = Slider:new(0, 1.0, 10, entry.get())
      entry.width = entry.slider:getWidth() + self.hpad + entry.text:getWidth()
    end
  end
  self.entries = _entries

  self.last_mouse = { love.mouse.getPosition() }

end

function Menu:update(dt)
  local current_entry = self.entries[self.selected]

  local m_pos = { love.mouse.getPosition() }
  local dx = m_pos[1] - self.last_mouse[1]
  local dy = m_pos[2] - self.last_mouse[2]
  if math.sqrt(dx*dx+dy*dy) > 2 or gameWorld.playerInput:pressed('mb1') then
    self.last_mouse = m_pos
    self:cursorInside()
  end

  if gameWorld.playerInput:pressed('action') then
    if gameWorld.playerInput:pressed('mb1') and not self:cursorInside() then
      return
    end

    if current_entry.kind == 'text' then
      gameWorld.sound:playUi('menuSelect')
      flux.to(self, 0.5, { spin = 1.0 }):oncomplete(function() self.spin = 0 end):oncomplete(current_entry.func)
    end
  elseif gameWorld.playerInput:pressed('down') then
    gameWorld.sound:playUi('menuSwitch')
    self.selected = self.selected + 1
    if self.selected > #self.entries then self.selected = 1 end
  elseif gameWorld.playerInput:pressed('up') then
    gameWorld.sound:playUi('menuSwitch')
    self.selected = self.selected - 1
    if self.selected == 0 then self.selected = #self.entries end
  elseif gameWorld.playerInput:pressed('left') then
    if current_entry.slider then
      if current_entry.label == 'Music' then
        gameWorld.sound:playUi('musicDecrease')
      else
        gameWorld.sound:playUi('volumeDecrease')
      end
      current_entry.slider:lower()
      current_entry.set(current_entry.slider.value)
    end
  elseif gameWorld.playerInput:pressed('right') then
    if current_entry.slider then
      if current_entry.label == 'Music' then
        gameWorld.sound:playUi('musicIncrease')
      else
        gameWorld.sound:playUi('volumeIncrease')
      end
      current_entry.slider:raise()
      current_entry.set(current_entry.slider.value)
    end
  end
end

function Menu:draw(x, y)
  self.x = x
  self.y = y
  for i, entry in ipairs(self.entries) do
    local _y = (i - 1) * self.vsize + y
    if entry.kind == 'text' then
      love.graphics.setColor(colors.menu_text)
      entry.text:draw(x, _y, self.w, self.h)
      if i == self.selected then
        local c = x + self.w / 2
        local l = c - entry.width / 2 - self.hpad - self.sprites.left:getWidth()
        local r = c + entry.width / 2 + self.hpad
        love.graphics.setColor(colors.white)
        love.graphics.draw(self.sprites.left, l + self.sprites.left:getWidth()/2, _y + self.vsize / 2 - 4, PI * 2 * self.spin, 1, 1, self.sprites.left:getWidth()/2, self.sprites.left:getHeight()/2)
        love.graphics.draw(self.sprites.right, r + self.sprites.right:getWidth()/2, _y + self.vsize / 2 - 4, 0 - PI * 2 * self.spin, 1, 1, self.sprites.right:getWidth()/2, self.sprites.right:getHeight()/2)
      end
    elseif entry.kind == 'slider' then
      love.graphics.setColor(colors.menu_text)
      entry.text:draw(x + self.w / 2 - entry.width / 2, _y, entry.text:getWidth(), self.h)
      love.graphics.setColor(colors.white)
      entry.slider:draw(x + self.w / 2 + entry.width / 2 - entry.slider:getWidth(), _y + self.vsize / 2 - entry.slider:getHeight() / 2)
      if i == self.selected then
        local c = x + self.w / 2
        local l = c - entry.width / 2 - self.hpad - self.sprites.slideLeft:getWidth()
        local r = c + entry.width / 2 + self.hpad
        love.graphics.draw(self.sprites.slideLeft, l, _y + self.vsize / 2 - self.sprites.slideLeft:getHeight() / 2 - 4)
        love.graphics.draw(self.sprites.slideRight, r, _y + self.vsize / 2 - self.sprites.slideRight:getHeight() / 2 - 4)
      end
    end



  end
end

function Menu:cursorInside()
  local x = self.last_mouse[1]
  local y = self.last_mouse[2]

  if x > self.x + 5 and x < self.x + self.w - 5 then
    if y > self.y + 5 and y < self.y + self.h - 5 then
      self.selected = math.floor((y - self.y) / self.vsize) + 1
      return true
    else
      return false
    end
  end

end

return Menu

--]]

local flux = System.flux
local class = require 'lib.middleclass'
local Gamestate = require 'states.gamestate'
local tablex = require 'pl.tablex'
local Credits = class('Credits', Gamestate)

local function shuffle(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end


local Contributor = class('Contributor')
function Contributor:initialize(name, contact, role, font)
  self.font = font
  self.name = name
  self.contact = contact
  self.role = role
  self.target = {}
  self.fade = 0
  self.start = {}
end

function Contributor:draw(x, y, h, w)
  local vsplit = h / 4
  love.graphics.setFont(self.font or Assets.fonts.generic(32))
  love.graphics.printf(self.name, x, y + vsplit, w, 'center')
  love.graphics.printf(self.role, x, y + vsplit * 2, w, 'center')
  love.graphics.printf(self.contact, x, y + vsplit * 3, w, 'center')
end



function Credits:initialize(name)
  Gamestate.initialize(self, name)
  self.fade = 0.0
  self.timer = 0.0
  self.idle = {}
  self.flying = {}
  self.scrolling = {}
  self.textfont = Assets.fonts.generic(32)
  self.contributors = {
      Contributor:new('John Deeny', 'jdeeny@gmail.com', 'code', self.textfont),
      Contributor:new('Raujinn', '@raujinn', 'art', self.textfont),
      Contributor:new('The Mooseman', 'themooseman.net', 'technical sound design', self.textfont),
      Contributor:new('Dieting Hippo', '@dietinghippo', 'gameplay', self.textfont),
      Contributor:new('TheOrange', '@TheOrange_JT', 'ui', self.textfont),
      Contributor:new('Jocko Homomorphism', 'jocko-homomorphism.bandcamp.com', 'music / vo', self.textfont),
      Contributor:new('Zack Booth / Otto\'s Hothouse', 'ottoshothouse@gmail.com', 'sound design', self.textfont),
      Contributor:new('Nihiloss', '', '3d renderings', self.textfont),
      Contributor:new('917', '@', 'music', self.textfont),
      Contributor:new('stellarsounds', '@', 'art', self.textfont),
      --Contributor:new('Michael A. Zekas', 'MichaelAZekas.com', 'voice', self.textfont),
    }




  self.title = love.graphics.newText(Assets.fonts.generic(120), 'Brugga the Brewer')
  self.subtitle = love.graphics.newText(self.textfont, 'Dec 25 - Dec 31 2018')

end


function Credits:enter()
  self.fade = 1.0
  flux.to(self, 1, { fade = 0.0 }):ease("quadinout")

  --self.backsnow = require('ui.snow'):new()
  --self.snow = require('ui.snow'):new()
  self.idle = shuffle(self.contributors)
  self.flying = {}
  self.timer = 0

  --gameWorld.sound:playMusic('credits')
  System.audio:music_play('dihedral')

end

function Credits:exit()
end

local lr = 0
function Credits:update(dt)
  if #self.idle == 0 then
    self.contributors = {
        Contributor:new('John Deeny', 'jdeeny@gmail.com', 'code', self.textfont),
        Contributor:new('Raujinn', '@raujinn', 'art', self.textfont),
        Contributor:new('The Mooseman', 'themooseman.net', 'technical sound design', self.textfont),
        Contributor:new('Dieting Hippo', '@dietinghippo', 'gameplay', self.textfont),
        Contributor:new('TheOrange', '@TheOrange_JT', 'ui', self.textfont),
        Contributor:new('Jocko Homomorphism', 'jocko-homomorphism.bandcamp.com', 'music / vo', self.textfont),
        Contributor:new('Zack Booth / Otto\'s Hothouse', 'ottoshothouse@gmail.com', 'sound design', self.textfont),
        Contributor:new('Nihiloss', '', '3d renderings', self.textfont),
        Contributor:new('917', '', 'music', self.textfont),
        Contributor:new('stellarsounds', '', 'music', self.textfont),

        Contributor:new('Sleve McDichael', '@sleve', 'asst to Mr Dieting Hippo', self.textfont),
        Contributor:new('Onson Sweemey', '@onson', 'puppeteering', self.textfont),
        Contributor:new('Darryl Archideld', '@therealdarryl', 'costume design', self.textfont),
        Contributor:new('Anatoli Smorin', '@roarin_smorin', 'key grip', self.textfont),
        Contributor:new('Rey McSriff', '@reyrey', 'asst key grip', self.textfont),
        Contributor:new('Glenallen Mixon', '@glenallen1981', 'grip', self.textfont),
        Contributor:new('Mario McRlwain', '@mario', 'grip\'s assistant', self.textfont),
        Contributor:new('Raul Chamgerlain', '@chamgerlain1', 'grip\'s boy', self.textfont),
        Contributor:new('Kevin Nogilny', '@Noggy', 'security', self.textfont),
        Contributor:new('Tony Smehrik', '@smehrik', 'best boy', self.textfont),
        Contributor:new('Bobson Dugnutt', '@dugnuttz', 'better boy', self.textfont),
        Contributor:new('Willie Dustice', '@dustice4all', 'hairdresser', self.textfont),
        Contributor:new('Jeromy Gride', '@gride', 'makeup', self.textfont),
        Contributor:new('Scott Dourque', '@not_a_dork', 'set design', self.textfont),
        Contributor:new('Shown Furcotte', '@furcotte_shown', 'production asst', self.textfont),
        Contributor:new('Dean Wesrey', '@deanbean', 'director of photography', self.textfont),
        Contributor:new('Mike Truk', '@monsterTruk', 'craft services', self.textfont),
        Contributor:new('Dwigt Rortugal', '@d_dubbs', 'craft services', self.textfont),
        Contributor:new('Tim Sanadaele', '@tim420xxx', 'craft services', self.textfont),
        Contributor:new('Karl Dandleton', '@karlito', 'craft services', self.textfont),
        Contributor:new('Mike Sernandez', 'mike@nintendo.com', 'craft services', self.textfont),
        Contributor:new('Todd Bonzalez', 'just todd', 'craft services', self.textfont),


        --Contributor:new('Michael A. Zekas', 'MichaelAZekas.com', 'voice', self.textfont),
      }
    self.idle = shuffle(self.contributors)
  end
  self.timer = self.timer + dt
  if self.timer > 2 then
    self.timer = 0
    local contrib = self.idle[#self.idle]
    if contrib then
      self.idle[#self.idle] = nil
      contrib.target = {0.5, 0.5}
      contrib.start = {lr == 0 and -0.2 or 1.2, love.math.random() * 1.2 - .1}
      contrib.fade = 0.0
      flux.to(contrib, 1, { fade = 1.0 }):ease("quadinout")
      :oncomplete(function()
        contrib.start = contrib.target
        contrib.target = {0.5, -0.2}
        contrib.fade = 0
        flux.to(contrib, 4, {fade = 1.0}):ease("linear")
      end)
      self.flying[#self.flying + 1] = contrib
    end
  end


  if System.playerInput:pressed('action') then
    flux.to(self, 0.2, { fade = 1.0 }):oncomplete(function() GameState:setState('mainmenu') end)
  end
end


function Credits:draw()
  love.graphics.setColor(1,1,1,1)
  love.graphics.clear(.2,.2,.2,1)
  --love.graphics.draw(gameWorld.assets.backdrops.title_background, 0, 0)

  --self.backsnow:draw()
  --love.graphics.draw(gameWorld.assets.backdrops.TITLE_Layer3, 0, 0)
  --love.graphics.setColor(gameWorld.colors.credits_title)
  --love.graphics.draw(self.title, 1280 / 2 - self.title:getWidth() / 2, 50)
  local x = 0
  --love.graphics.setColor(gameWorld.colors.credits_text)
  for i, contrib in ipairs(self.flying) do
    --local y = math.floor((i - 1) / 2) * ( (720 - 200 - 40) / math.floor(#self.contributors / 2 + 0.5))
    --local w = (1280 - 160) / 2
    local tx, ty = unpack(contrib.target)
    local sx, sy = unpack(contrib.start)

    local x = (contrib.fade * (tx-sx) + sx) * System.w
    local y = (contrib.fade * (ty-sy) + sy) * System.h

    contrib:draw(x,y, System.h / 6, System.w / 2.2)

    x = ((1280 - 100) / 2) - x
  end
  --love.graphics.draw(love.graphics.newText(self.textfont, 'v1.1'),  1200, 680)
  --love.graphics.setColor(gameWorld.colors.white)
  --self.snow:draw()


  if self.fade > 0 then
    love.graphics.setColor(0.0, 0.0, 0.0, self.fade) --(0.0, 0.0, 0.0, self.fade)
    love.graphics.rectangle('fill', 0, 0, 1280, 720)
  end
end

return Credits

local class = require 'lib.middleclass'
local Gamestate = class('Gamestate')

function Gamestate:initialize(name)
  self.name = name
end

-- Subclasses should replace these
function Gamestate:enter()
end
function Gamestate:exit()
end
function Gamestate:returnTo()
end
function Gamestate:draw()
end
function Gamestate:update(dt)
end

function Gamestate:mousepressed(x, y, button)
end
function Gamestate:mousemoved(x, y, dx, dy, istouch)
end
function Gamestate:mousereleased(x, y, button)
end
function Gamestate:wheelmoved(x, y)
end

return Gamestate

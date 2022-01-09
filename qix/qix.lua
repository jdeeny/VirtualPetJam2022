local class = require 'lib.middleclass'

local Path = require 'qix.path'
local Zone = require 'qix.zone'

local Qix = class('Qix')


function Qix:initialize()
    self.zones = {}
    self.cursor = {x = 0, y = 0}
    self.size = {x=1280,y=720}
    self.speed = 3
    self.current_path = nil
end

function Qix:update(dt)
    local input_x, input_y = System.playerInput:get 'move'
    local input_marker = System.playerInput:get 'action' == 1 or false

    self:move_cursor(input_x * self.speed, input_y * self.speed)
    if self.current_path then
        local result = self.current_path:extend_to(self.cursor.x, self.cursor.y)
        if result == "zone" then
            print("Convert path into zone")
        end
        if not input_marker then 
            self:endPath()
        end
    else
        if input_marker then
            self:beginPath()
        end
    end
end


-- x and y are -1 to 1 and indicate the amount of input
function Qix:move_cursor(x, y)
    local new_x = self.cursor.x + x
    local new_y = self.cursor.y + y
    new_x = math.min(new_x, self.size.x)
    new_x = math.max(new_x, 0)
    new_y = math.min(new_y, self.size.y)
    new_y = math.max(new_y, 0)
    -- additional logic about following lines?
    self.cursor.x = new_x
    self.cursor.y = new_y
end

function Qix:beginPath()
    if self.current_path then
        print("Tried to start new path while existing path is active")
        return
    end
    self.current_path = Path:new(self.size.x, self.size.y)
    self.current_path:beginPath(self.cursor.x, self.cursor.y)
end

function Qix:endPath()
    if not self.current_path then
        print("Tried to end path without active path existing")
        return
    end
    self.current_path:abort()
end

function Qix:draw()
    if self.current_path then
        self.current_path:draw()
    end
    for z in ipairs(self.zones) do
        z:draw()
    end
    -- draw cursor
    love.graphics.draw(Assets.ui.cursor, self.cursor.x, self.cursor.y)
end

return Qix
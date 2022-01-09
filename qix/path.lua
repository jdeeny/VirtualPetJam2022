local class = require 'lib.middleclass'

local Path = class('Path')

function Path:initialize(x_size, y_size)
    if x_size <= 0 or y_size <=0 then
        print( "Invalid path size, " .. x_size .. y_size)
        return
    end
    self.elapsed = 0
    self.last_color = 0
    self.size = {x=x_size, y=y_size}
    self.last = {x=nil, y=nil}
    local canvas_settings = {
        type = "2d",
        --format = "r32f",   --a single 32 bit float
        readable = true,
        msaa = 0,
        dpiscale = 1.0,
        mipmaps = "none"
    }
    self.canvas = love.graphics.newCanvas(self.size.x, self.size.y, canvas_settings)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0.1,0.2,0.3,1)
    love.graphics.setCanvas(nil)
    self.image_data = self.canvas:newImageData()
    self.image = love.graphics.newImage(self.image_data)
    self:reset_image()
    self.aborted = false
end

function Path:update(dt)
    if not self.aborted then
        self.elapsed = self.elapsed + dt
    else
        self.elapsed = math.max(self.elapsed - (dt * self.abort_speed), 0)
    end
end


local function pixelClear(x, y, r, g, b, a)
    return 0.3, 0.3, 0.3, 1.0
end
function Path:reset_image()
    print("cl")
    self.image_data:mapPixel(pixelClear)
end

function Path:beginPath(x, y)
    self.elapsed = 0
    --self:reset_image()
    self:setPixel(x,y)
    self.image:replacePixels(self.image_data)
end

function Path:setPixel(x, y)
    self.image_data:setPixel(x, y, 1,1,1,1)--self.elapsed, 1.0, 1.0, 1.0)
    self.last_color = self.elapsed
end
function Path:extend_to(x, y)
    print("Extend "..x.." "..y)
    self:setPixel(x, y)
    self.image:replacePixels(self.image_data)
end

function Path:endPath()
end

function Path:abort()
    self.aborted = true
end

function Path:checkPixel(x, y)
    if x > self.size.x or y > self.size.y then return false end
    local r, g, b, a = self.image_data:getPixel(x,y)
    return r >= self.last_color
end


-- If possible, return a filled zone based on the path
function Path:toZone()
end

function Path:draw()
    love.graphics.draw(self.image)
    print("draw path")
end

return Path
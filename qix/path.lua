local class = require 'lib.middleclass'

local Path = class('Path')

function Path:initialize(x_size, y_size)
    if x_size <= 0 or y_size <=0 then
        print( "Invalid path size, " .. x_size .. y_size)
        return
    end
    self.elapsed = 0
    self.last_color = 0
    self.abort_speed = 10
    self.size = {x=x_size, y=y_size}
    self.last = {x=nil, y=nil}
    local canvas_settings = {
        type = "2d",
        format = "r32f",   --a single 32 bit float
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
    print("path elapsed: ".. self.elapsed)
end


local function pixelClear(x, y, r, g, b, a)
    return 0, 0, 0, 1.0
end
function Path:reset_image()
    print("cl")
    self.image_data:mapPixel(pixelClear)
end

function Path:beginPath(x, y)
    self.elapsed = 0
    --self:reset_image()
    self.last = {x=0,y=0}
    self:setPixel(x,y)
    self.last_color = self.elapsed
    self.image:replacePixels(self.image_data)
end

function Path:setPixel(x, y)
    --print("set "..x.." "..y)
    local check = self:checkPixel(x,y)
    print(check)
    self.image_data:setPixel(x, y, self.elapsed, 0.1, 0.1, 1.0)
    self.last.x = x
    self.last.y = y
    --print("last color: "..self.last_color)
end

function Path:extend_to(x, y)
    print("Extend "..x.." "..y)
    local dx = math.abs(x - self.last.x)
    local dy = math.abs(y - self.last.y)
    local sx,sy
    if self.last.x < x then sx=1 else sx=-1 end
    if self.last.y < y then sy=1 else sy=-1 end
    local err = dx-dy


    print("dx "..dx.." dy "..dy)
    print("sx "..dx.." sy "..dy)

    local cont = true
    while cont do 
        self:setPixel(self.last.x, self.last.y)
        if (math.abs(self.last.x - x) < 1) and (math.abs(self.last.y - y) < 1) then
            cont = false
        end
        local e2 = 2*err
        if e2 > -dy then
            err = err-dy
            self.last.x  = self.last.x + sx
        end
        if e2 < dx then
            err = err+dx
            self.last.y = self.last.y + sy
        end
    end
    
--    self:setPixel(x, y)
    self.last_color = self.elapsed
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
    --print("draw path")
end

return Path
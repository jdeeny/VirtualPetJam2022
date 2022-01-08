local class = require 'lib.middleclass'
local HumpCamera = require 'lib.hump.camera'

local zoom = {
    factor = 1, 
    delta = .25
}

local worldPosition = {
    basespeed = 8,
    speed = 0,
    delta = {
        x = 0,
        y = 0
    }
}

local Camera = HumpCamera(0, 0)
Camera.zoom = zoom
Camera.worldPosition = worldPosition
Camera.gridwidth = 0
Camera.gridheight = 0
Camera.minzoom = 1
Camera.maxzoom = 2

function Camera:gridInit(map)
    self.gridwidth = map.width * map.tilewidth
    self.gridheight = map.height * map.tileheight
end

function Camera:zoomInDirection(direction)
    if direction > 0 and (self.zoom.factor - self.zoom.delta) < self.maxzoom then
        self.zoom.factor = self.zoom.factor + self.zoom.delta
    elseif direction < 0 and (self.zoom.factor - self.zoom.delta) > self.minzoom then
        self.zoom.factor = self.zoom.factor - self.zoom.delta
    end
end

function Camera:update(dt)
    -- Reset position move delta
    self.worldPosition.delta = { x = 0, y = 0 }

    -- Move faster when zoomed out
    self.worldPosition.speed = self.worldPosition.basespeed / self.zoom.factor

    -- Move camera worldPosition
    if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        self.worldPosition.delta.y = -self.worldPosition.speed
    elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        self.worldPosition.delta.y = self.worldPosition.speed
    end
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.worldPosition.delta.x = -self.worldPosition.speed
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.worldPosition.delta.x = self.worldPosition.speed
    end

    -- Set new camera position
    self:move(self.worldPosition.delta.x, self.worldPosition.delta.y)

    -- Get camera's new position
    local x,y = self:position()
    
    -- If boundaries are defined, check to see if crossed
    if self.gridwidth > 0 and self.gridheight > 0 then
        -- Get boundary limits
        local leftlimit = System.w / (2 * self.zoom.factor)
        local rightlimit = self.gridwidth - (leftlimit)
        local toplimit = System.h / (2 * self.zoom.factor)
        local bottomlimit = self.gridheight - (toplimit)
        -- Apply boundaries if applicable
        if x < leftlimit then x = leftlimit end
        if x > rightlimit then x = rightlimit end
        if y < toplimit then y = toplimit end
        if y > bottomlimit then y = bottomlimit end
        -- Move camera to adjusted position
        self:lookAt(x, y)
    end

    -- Update zoom amount
    self:zoomTo(self.zoom.factor)
end

return Camera
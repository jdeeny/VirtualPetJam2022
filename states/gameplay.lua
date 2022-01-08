local class = require 'lib.middleclass'
local simTimer = Timer.new()

local Gamestate = require 'states.gamestate'
local GamePlay = class('GamePlay', Gamestate)

function GamePlay:initialize(name)
    Gamestate.initialize(self, name)
end

function GamePlay:enter(arg)
    System.audio:playRandomMusic()

--    simTimer:every(1, function() Signal.emit(SignalList.TickUpdate) end)
end

-- Handle zoom input, placeholder for now
function GamePlay:wheelmoved(x, y)
--    playArea.camera:zoomInDirection(y)
end

function GamePlay:update(dt)
    simTimer:update(dt)

    -- Update grid using mouse world position
--    playArea:update(dt, playArea.camera:mousePosition())

    -- --- Debug
    -- -- Get ID # and name of selected terrain/building
--    selectedId, selectedName = playArea.terrainGrid:getSelectedTerrain()
--    selectedBuilding = playArea.buildingGrid:getSelectedBuilding()
end

function GamePlay:draw(dt)
    love.graphics.clear(0,0,0)

    -- Draw play area
--    playArea:draw(dt)

--    UIManager:draw()
--    TopBar:update()
end

return GamePlay

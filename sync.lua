local state = require("state")

local Sync = {}

local obj = state.Objects
local stgs = state.Settings

local dounoduway = sounds["sounds.DOUNODUWAY"] 
function pings.DOUNODUWAY(pos, pitch)
    if player:isLoaded() then
        dounoduway:setPos(pos):setPitch(pitch):play()
        obj.DOUNODUWAY:play()
    end
end

function pings.syncState(color, rainbow)
    stgs.color = color
    stgs.rainbow = rainbow
end

function Sync.tick()
    if world.getTime() % 200 == 0 then
        pings.changeColor(stgs.color)
        pings.syncState(stgs.color, stgs.rainbow)
    end

    dounoduway:setPos(player:getPos())
end

return Sync
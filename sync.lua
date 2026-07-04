local state = require("state")

local Sync = {}

local obj = state.Objects
local stgs = state.Settings
local data = state.Data

local dounoduway = sounds["sounds.DOUNODUWAY"] 
function pings.DOUNODUWAY(pos, pitch)
    if player:isLoaded() then
        dounoduway:setPos(pos):setPitch(pitch):play()
        obj.DOUNODUWAY:play()
    end
end

function pings.syncState(color, rainbow, invOpen)
    stgs.color = color
    stgs.rainbow = rainbow
    stgs.invOpen = invOpen
end

function pings.syncMouth(x, y, z, nose)
    data.mouth.x = x
    data.mouth.y = y
    data.mouth.z = z
    data.mouth.nose = nose
end

function pings.syncInv(open)
    if open then
        obj.INVENTORYCLOSE:stop()
        obj.INVENTORYOPEN:play()
        sounds:playSound("minecraft:block.barrel.open", player:getPos(), 0.5)
        stgs.invOpen = true
    else
        obj.INVENTORYOPEN:stop()
        obj.INVENTORYCLOSE:play()
        sounds:playSound("minecraft:block.barrel.close", player:getPos(), 0.5)
        stgs.invOpen = false
    end
end

function Sync.tick()
    if world.getTime() % 200 == 0 then
        pings.changeColor(stgs.color)
        pings.syncState(stgs.color, stgs.rainbow, stgs.invOpen)
    end

    if world.getTime() % 3 == 0 then
        pings.syncMouth(data.mouth.x, data.mouth.y, data.mouth.z, data.mouth.nose)
    end

    dounoduway:setPos(player:getPos())
end

return Sync
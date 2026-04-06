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

function pings.syncState(color, rainbow)
    stgs.color = color
    stgs.rainbow = rainbow
end

function pings.syncMouth(x, y, z, nose)
    data.mouth.x = x
    data.mouth.y = y
    data.mouth.z = z
    data.mouth.nose = nose
end


function Sync.tick()
    if world.getTime() % 200 == 0 then
        pings.changeColor(stgs.color)
        pings.syncState(stgs.color, stgs.rainbow)
    end

    if world.getTime() % 3 == 0 then
        pings.syncMouth(data.mouth.x, data.mouth.y, data.mouth.z, data.mouth.nose)
    end

    dounoduway:setPos(player:getPos())
end

return Sync
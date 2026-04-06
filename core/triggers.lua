local state = require("state")

local Triggers = {}

local obj = state.Objects
local stgs = state.Settings

local curItemM = nil
local prevItemM = nil
local curItemO = nil
local prevItemO = nil

obj.ACTIONKEY.press = function()
    local pitch = math.random(9.5, 10.5) / 10
    pings.DOUNODUWAY(player:getPos(), pitch)
end

obj.EKEY.press = function ()
    pings.syncInv(not stgs.invOpen)
end


function Triggers.init()
    curItemM = player:getItem(1)
    prevItemM = curItemM

    curItemO = player:getItem(2)
    prevItemO = curItemM
end


function Triggers.tick()
    curItemM = player:getItem(1)

    if curItemM.id ~= prevItemM.id then
        obj.CHANGEITEM:stop()
        obj.CHANGEITEM:play()
        prevItemM = curItemM
    end
end

return Triggers
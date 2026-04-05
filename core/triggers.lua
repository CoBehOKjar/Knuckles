local Triggers = {}

local curItemM = nil
local prevItemM = nil
local curItemO = nil
local prevItemO = nil

function Triggers.init()
    curItemM = player:getItem(1)
    prevItemM = curItemM

    curItemO = player:getItem(2)
    prevItemO = curItemM
end


function Triggers.tick()
    curItemM = player:getItem(1)

    if curItemM.id ~= prevItemM.id then
        animations.Knuckles.InventoryOpen:stop()
        animations.Knuckles.InventoryOpen:play()
        prevItemM = curItemM
    end
end

return Triggers
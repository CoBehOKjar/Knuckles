local state = require("state")

local Skin = {}

local obj = state.Objects
local stgs = state.Settings

local function checkMod(step)
    local mtep = step*0.01
    
    if obj.SHIFTKEY:isPressed() then
        mtep = mtep*10
    elseif obj.CTRLKEY:isPressed() then
        mtep = mtep*0.1
    end

    return mtep
end

function Skin.changeH(dir)
    local step = checkMod(dir)
    pings.changeColor(math.clamp(stgs.color.x+step, 0, 1), stgs.color.y, stgs.color.z)
end

function Skin.changeS(dir)
    local step = checkMod(dir)
    pings.changeColor(stgs.color.x, math.clamp(stgs.color.y+step, 0, 1), stgs.color.z)
end

function Skin.changeV(dir)
    local step = checkMod(dir)
    pings.changeColor(stgs.color.x, stgs.color.y, math.clamp(stgs.color.z+step,  0, 1))
end


function pings.changeColor(a, b, c)
    local h, s, v

    if type(a) == "Vector3" or (type(a) == "table" and a.x) then
        h = a.x or a.h or 0
        s = a.y or a.s or 0
        v = a.z or a.v or 0
    else
        h = a or 0
        s = b or 0
        v = c or 0
    end

    for _, part in ipairs(obj.skinParts) do
        part:setColor(vectors.hsvToRGB(h, s, v))
    end
    stgs.color = vec(h, s, v)

    obj.Wheels.colorH:setTitle(string.format("Цвет: "..string.format("%.3f", stgs.color.x).."\n§6Скролл\n§7ПКМ§f - Сброс"))
    obj.Wheels.colorS:setTitle(string.format("Насыщенность: "..string.format("%.3f", stgs.color.y).."\n§6Скролл\n§7ПКМ§f - Сброс"))
    obj.Wheels.colorV:setTitle(string.format("Яркость: "..string.format("%.3f", stgs.color.z).."\n§6Скролл\n§7ПКМ§f - Сброс"))
end

return Skin
local state = require("state")
local skin = require("render.skin")
local camera = require("render.camera")

local AW = {}

local obj = state.Objects
local stgs = state.Settings
local cfg = state.Config

function AW.titleUpdate(action, title)
    action:setTitle(title)
end


function AW.init()
    --.Creating action wheels
    local wheels = {
        action_wheel:newPage("Секундомер"),
        action_wheel:newPage("Утилиты"),
        action_wheel:newPage("Дебаг"),
    }

    action_wheel:setPage(wheels[1]) --?Default active wheel


    --.Adding navigation buttons to wheels
    for i, wheel in ipairs(wheels) do       --?Calculating next and prevous wheel
        local prevIndex = (i - 2) % #wheels + 1     --?Pervous
        local nextIndex = i % #wheels + 1           --?Next

        local nav = wheel:newAction()   --?Creating navigation button
            :title("§6< §fПред / След §6>\n§7ПКМ/ЛКМ | Скролл\n§6"..wheel:getTitle())
            :setTexture(obj.ICO_PAGES, 0, 0, 16, 16)
            :setHoverTexture(obj.ICO_PAGES, 16, 0, 16, 16)
            :onLeftClick(function()
                action_wheel:setPage(wheels[prevIndex])
            end)
            :onRightClick(function()
                action_wheel:setPage(wheels[nextIndex])
            end)
            :setOnScroll(function(dir)
                if dir > 0 then
                    action_wheel:setPage(wheels[nextIndex])
                else
                    action_wheel:setPage(wheels[prevIndex])
                end
            end)
        obj.Wheels["Nav"..i] = nav
    end

    local colorH = wheels[1]:newAction()
        :title(string.format("Цвет: "..string.format("%.3f", cfg.color.x).."\n§6Скролл\n§7ПКМ§f - Сброс"))
        :setTexture(obj.ICO_H, 0, 0, 16, 16)
        :setHoverTexture(obj.ICO_H, 16, 0, 16, 16)
        :onScroll(skin.changeH)
        :onRightClick(function() pings.changeColor(cfg.color.x, stgs.color.y, stgs.color.z) end)
    obj.Wheels.colorH = colorH

    local colorS = wheels[1]:newAction()
        :title("Насыщенность: "..string.format("%.3f", cfg.color.y).."\n§6Скролл\n§7ПКМ§f - Сброс")
        :setTexture(obj.ICO_S, 0, 0, 16, 16)
        :setHoverTexture(obj.ICO_S, 16, 0, 16, 16)
        :onScroll(skin.changeS)
        :onRightClick(function() pings.changeColor(stgs.color.x, cfg.color.y, stgs.color.z) end)
    obj.Wheels.colorS = colorS

    local colorV = wheels[1]:newAction()
        :title("Яркость: "..string.format("%.3f", cfg.color.z).."\n§6Скролл\n§7ПКМ§f - Сброс")
        :setTexture(obj.ICO_V, 0, 0, 16, 16)
        :setHoverTexture(obj.ICO_V, 16, 0, 16, 16)
        :onScroll(skin.changeV)
        :onRightClick(function() pings.changeColor(stgs.color.x, stgs.color.y, cfg.color.z) end)
    obj.Wheels.colorV = colorV


    local lowCam = wheels[1]:newAction()
        :title("Заниженная камера\n§7ЛКМ")
        :setTexture(obj.ICO_CAMERA, 0, 0, 16, 16)
        :setHoverTexture(obj.ICO_CAMERA, 16, 0, 16, 16)
        :onLeftClick(function() camera.toggleLow(not stgs.lowCam) end)
    obj.Wheels.lowCam = lowCam
end

return AW
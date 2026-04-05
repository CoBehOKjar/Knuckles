local state = require("state")

local Camera = {}

local stgs = state.Settings

local crawl = false
local wasCrawl = false

local function setLowCamera(enabled)
    if enabled then
        renderer:setEyeOffset(0, -0.8, 0)
        renderer:setOffsetCameraPivot(0, -0.8, 0)
    else
        renderer:setEyeOffset(0, 0, 0)
        renderer:setOffsetCameraPivot(0, 0, 0)
    end
end

function Camera.toggleLow(toggle)
    stgs.lowCam = toggle
    setLowCamera(stgs.lowCam)
end

function Camera.init()
    setLowCamera(stgs.lowCam)
end

function Camera.render()
    local pose = player:getPose()

    crawl = (pose == "SWIMMING" or pose == "SPIN_ATTACK" or pose == "FALL_FLYING" or player:getVehicle()) and stgs.lowCam

    if crawl ~= wasCrawl then
        setLowCamera(not crawl)
    end
    wasCrawl = crawl
end

return Camera
require("lib.GSAnimBlend")
local anims = require("lib.EZAnims")
local knuckles = anims:addBBModel(animations.Knuckles)
local squapi = require("lib.SquAPI")
local physBone = require("lib.physBoneAPI")
local SwingingPhysics = require("lib.swinging_physics")
local swingOnHead = SwingingPhysics.swingOnHead
local swingOnBody = SwingingPhysics.swingOnBody

vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

models.Knuckles.Root.Body.Head.Face.Eyes.EyeLeft:setPrimaryRenderType("CUTOUT_CULL")
models.Knuckles.Root.Body.Head.Face.Eyes.EyeRight:setPrimaryRenderType("CUTOUT_CULL")

animations.Knuckles.ArmRotation:play()

local skinParts = {
    models.Knuckles.Root.Body.Head.Head,
    models.Knuckles.Root.Body.Head.Head_Layer,
    models.Knuckles.Root.Body.Head.Hairs,
    models.Knuckles.Root.Body.Torso,
    models.Knuckles.Root.Body.Torso_Layer,
    models.Knuckles.Root.Body.Ass,
    models.Knuckles.Root.Body.Tail,
    models.Knuckles.Root.Body.RightArm.ShoulderRight,
    models.Knuckles.Root.Body.RightArm.ShoulderRightF.PreShoulderRight,
    models.Knuckles.Root.Body.LeftArm.ShoulderLeft,
    models.Knuckles.Root.Body.LeftArm.ShoulderLeftF.PreShoulderLeft,
    models.Knuckles.Root.Body.RightLeg.LegRight,
    models.Knuckles.Root.Body.LeftLeg.LegLeft,
    models.Knuckles.FirstPersonArm.FPPreShoulderRight
}

physBone:setPreset(
    "physH",
     0.1,
     3,
     nil,
     nil,
     nil,
     nil,
     nil,
     nil,
     nil,
     nil,
     nil,
     nil,
     3,
     2,
     0.5,
     0
    )

-- local baseColor = vectors.hexToRGB("#ef5d35")

-- local function shiftHue(color, hueShift)
--     local hsv = vectors.rgbToHSV(color)
--     hsv.x = (hsv.x + hueShift) % 1
--     return vectors.hsvToRGB(hsv)
-- end

-- local function setSkinHue(hueShift)
--     local shifted = shiftHue(baseColor, hueShift)
--     for _, part in ipairs(skinParts) do
--         part:setColor(shifted)
--     end
-- end

function events.entity_init()
    renderer:setEyeOffset(0, -0.8, 0)
    renderer:setOffsetCameraPivot(0, -0.8, 0)

    for _, part in ipairs(skinParts) do
        part:setColor(vectors.hexToRGB("#ef5d35"))
    end
end


function events.render(delta,context)
    models.Knuckles.FirstPersonArm
        :setVisible(context=="FIRST_PERSON")
        :setParentType(context=="FIRST_PERSON" and "RightArm" or "None")
end

--render event, called every time your avatar is rendered
--it have two arguments, "delta" and "context"
--"delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
--"context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context)
end

local prevVel = vec(0,0,0)
local curVel = vec(0,0,0)
function events.tick()
    prevVel = curVel
    curVel = player:getVelocity()
end

    local walkStr = 50
function events.render(delta)
        
    local vel = math.lerp(prevVel,curVel,delta):transform(matrices.rotation3(0, player:getRot().y)) * walkStr
    local moveRot = vec(-vel.z*0.7, 0, vel.x*0.7)

    models.Knuckles.Root:offsetRot(moveRot:clampLength(-20, 20))
    models.Knuckles.Root.Body.RightLeg:offsetRot(-moveRot:clampLength(-20, 20)/2)
    models.Knuckles.Root.Body.LeftLeg:offsetRot(-moveRot:clampLength(-20, 20)/2)
end
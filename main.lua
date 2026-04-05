require("lib.GSAnimBlend")
local anims = require("lib.EZAnims")
local knuckles = anims:addBBModel(animations.Knuckles)
local squapi = require("lib.SquAPI")
local physBone = require("lib.physBoneAPI")
local SwingingPhysics = require("lib.swinging_physics")
local swingOnHead = SwingingPhysics.swingOnHead
local swingOnBody = SwingingPhysics.swingOnBody

local state = require("state")
local physic = require("core.physic")
local triggers = require("core.triggers")
local skin = require("render.skin")
local aw = require("ui.aw")
local camera = require("render.camera")
local sync = require("sync")

local obj = state.Objects
local stgs = state.Settings
local cfg = state.Config

vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET_ITEM:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

models.Knuckles.Root.Body.Torso.Head.Face.Eyes.EyeLeft:setPrimaryRenderType("CUTOUT_EMISSIVE_SOLID")
models.Knuckles.Root.Body.Torso.Head.Face.Eyes.EyeRight:setPrimaryRenderType("CUTOUT_EMISSIVE_SOLID")

animations.Knuckles.ArmRotation:play()
animations.Knuckles.crouch:setBlendTime(0)
animations.Knuckles.crawl:setBlendTime(0)

function events.entity_init()
    aw.init()
    triggers.init()
    pings.changeColor(cfg.color)
    camera.init()
end


function events.tick()

    --Updating walking lean
    physic.tick()
    triggers.tick()
    sync.tick()
end


function events.render(delta,context)
    --Showing first person arm
    models.Knuckles.FirstPersonArm
        :setVisible(context=="FIRST_PERSON")
        :setParentType(context=="FIRST_PERSON" and "RightArm" or "None")

    --Updating walking lean
    physic.render(delta)
    camera.render()
end
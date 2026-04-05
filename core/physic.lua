local physBone = require("lib.physBoneAPI")
local squapi = require("lib.SquAPI")

local Physic = {}

squapi.bounceWalk:new(
    models.Knuckles,
    0.5
)

squapi.smoothHead:new(
    {
        models.Knuckles.Root.Body.Torso,
        models.Knuckles.Root.Body.Torso.Head
    },
	0.5,    --(1) strength(you can make this a table too)
    nil,    --(0.1) tilt
    nil,    --(1) speed
    nil,    --(true) keepOriginalHeadPos
    false,     --(true) fixPortrait
    nil,     --(nil) animStraightenList
    nil,     --(0.5) straightenMultiplier
    nil,     --(0.5) straightenSpeed
    nil      --(0.1) blendToConsiderStopped
)

squapi.eye:new(
    models.Knuckles.Root.Body.Torso.Head.Face.Eyes.PupilLeft,
    0.2,
    0.2,
    0.3,
    0.3
)
squapi.eye:new(
    models.Knuckles.Root.Body.Torso.Head.Face.Eyes.PupilRight,
    0.2,
    0.2,
    0.3,
    0.3
)

--Hairs setup
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

--Walking lean setup
local prevVel = vec(0,0,0)
local curVel = vec(0,0,0)
local walkStr = 50

function Physic.tick()
    prevVel = curVel
    curVel = player:getVelocity()
end


function Physic.render(delta)
    --Applying walking lean
    local vel = 
        math.lerp(prevVel,curVel,delta)
        :transform(matrices.rotation3(0, player:getRot().y)) * walkStr
    local moveRot = vec(-vel.z*0.7, 0, vel.x*0.7)

    local rot = moveRot:clampLength(-20, 20)
    models.Knuckles.Root:offsetRot(rot)
    models.Knuckles.Root.Body.RightLeg:offsetRot(rot/-2)
    models.Knuckles.Root.Body.LeftLeg:offsetRot(rot/-2)
end

return Physic
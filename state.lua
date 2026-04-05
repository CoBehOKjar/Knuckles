local State = {}


State.Settings = {
    lowCam = true,   --?Camera height in car
    color = nil,

    --.Debugging
    debugEvent = false,
    debugTick = false,
    debugTickTo = "ab", --?"ab" to actionbar, "ch" to chat
}


--*Objects
State.Objects = {
    Wheels = {},

    skinParts = {
        models.Knuckles.Root.Body.Torso.Head.Head,
        models.Knuckles.Root.Body.Torso.Head.Head_Layer,
        models.Knuckles.Root.Body.Torso.Head.Hairs,
        models.Knuckles.Root.Body.Torso.Torso,
        models.Knuckles.Root.Body.Torso.Torso_Layer,
        models.Knuckles.Root.Body.Ass,
        models.Knuckles.Root.Body.Ass.Tail,
        models.Knuckles.Root.Body.Torso.RightArm.ShoulderRight,
        models.Knuckles.Root.Body.Torso.RightArm.ShoulderRightF.PreShoulderRight,
        models.Knuckles.Root.Body.Torso.LeftArm.ShoulderLeft,
        models.Knuckles.Root.Body.Torso.LeftArm.ShoulderLeftF.PreShoulderLeft,
        models.Knuckles.Root.Body.RightLeg.LegRight,
        models.Knuckles.Root.Body.LeftLeg.LegLeft,
        models.Knuckles.FirstPersonArm.FPPreShoulderRight,
    },

    --?Input keys
    ALTKEY = keybinds:newKeybind("AltM", "key.keyboard.left.alt"),
    CTRLKEY = keybinds:newKeybind("CtrlM", "key.keyboard.left.control"),
    SHIFTKEY = keybinds:newKeybind("ShiftM", "key.keyboard.left.shift"),

    ACTIONKEY = keybinds:newKeybind("Dounoduway", "key.keyboard.k"),

    --?Textures
    ICO_PAGES = textures["textures.UI_Pages"] or textures["Knuckles.UI_Pages"],
    ICO_H = textures["textures.UI_H"] or textures["Knuckles.UI_H"],
    ICO_S = textures["textures.UI_S"] or textures["Knuckles.UI_S"],
    ICO_V = textures["textures.UI_V"] or textures["Knuckles.UI_V"],
    ICO_CAMERA = textures["textures.UI_Camera"] or textures["Knuckles.UI_Camera"],
}


--*Const
State.Config = {
    color = vectors.rgbToHSV(vectors.hexToRGB("#ef5d35"))
}


--*Runtime
State.Data = {

}


--*Nil protect
function State.init()
    --?Initial animations after entity init
    for k, v in pairs(animations["Knuckles"]) do
        State.Objects[k:upper()] = v
    end
end

return State
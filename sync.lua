local state = require("state")

local Sync = {}

local stgs = state.Settings

function Sync.tick()
    if world.getTime() % 200 == 0 then
        pings.changeColor(stgs.color)
    end
end

return Sync
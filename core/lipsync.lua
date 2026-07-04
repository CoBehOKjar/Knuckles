local state = require("state")

local Lipsync = {}

local obj = state.Objects
local data = state.Data

-- ========== CONFIG

local silenceThreshold = 0.003

local smooth = {
    x = 1,
    y = 1,
    z = 1,
    nose = 0
}

local lerpSpeed = 0.18

local baseSize = vec(1, 1, 1)

local mouthStrength = {
    width  = 0.35, -- x
    height = 0.75, -- y
    depth  = 0.30  -- z
}

local noseStrength = 60

-- динамический максимум для автокалибровки
local dyn = {
    volume = 0.02,
    low = 0.02,
    mid = 0.02,
    high = 0.02
}

-- ========== HELPERS

local function clamp01(v)
    return math.clamp(v, 0, 1)
end

local function bandEnergy(rawAudio, step)
    local energy = 0
    local count = 0

    for i = 0, 959 - step, step do
        local a = rawAudio[i] or 0
        local b = rawAudio[i + step] or 0
        local d = b - a

        energy = energy + math.abs(d)
        count = count + 1
    end

    return count > 0 and (energy / count) or 0
end

local function adaptiveNormalize(value, maxValue)
    if maxValue <= 0 then return 0 end
    return clamp01(value / maxValue)
end

local function smoothstep(x)
    x = clamp01(x)
    return x * x * (3 - 2 * x)
end

local function resetMouth()
    data.mouth.x = baseSize.x
    data.mouth.y = baseSize.y
    data.mouth.z = baseSize.z
    data.mouth.nose = 0
end

-- ========== ANALYSIS

function Lipsync.analyze(rawAudio)
    local sumAbs = 0

    for i = 0, 959 do
        sumAbs = sumAbs + math.abs(rawAudio[i] or 0)
    end

    local volume = sumAbs / 960

    local low  = bandEnergy(rawAudio, 12)
    local mid  = bandEnergy(rawAudio, 6)
    local high = bandEnergy(rawAudio, 2)

    -- автокалибровка под твой голос/микрофон
    dyn.volume = math.max(dyn.volume * 0.995, volume)
    dyn.low    = math.max(dyn.low    * 0.995, low)
    dyn.mid    = math.max(dyn.mid    * 0.995, mid)
    dyn.high   = math.max(dyn.high   * 0.995, high)

    local volN  = smoothstep(adaptiveNormalize(volume, dyn.volume))
    local lowN  = smoothstep(adaptiveNormalize(low,    dyn.low))
    local midN  = smoothstep(adaptiveNormalize(mid,    dyn.mid))
    local highN = smoothstep(adaptiveNormalize(high,   dyn.high))

    if volume < silenceThreshold then
        return {
            volume = 0,
            open = 0,
            wide = 0,
            round = 0,
            low = lowN,
            mid = midN,
            high = highN
        }
    end

    -- относительные формы, а не "абсолютные"
    local total = lowN + midN + highN + 0.0001
    local lowR  = lowN / total
    local midR  = midN / total
    local highR = highN / total

    local open  = clamp01(volN * 1.0 + midR * 0.7)
    local wide  = clamp01(highR * 1.8)
    local round = clamp01(lowR * 1.8)

    return {
        volume = volN,
        open = open,
        wide = wide,
        round = round,
        low = lowR,
        mid = midR,
        high = highR,
        rawVolume = volume,
        rawLow = low,
        rawMid = mid,
        rawHigh = high
    }
end

-- ========== TARGET BUILDING

function Lipsync.updateTargets(audioData)
    data.mouth.x = baseSize.x + (audioData.wide  * mouthStrength.width)
    data.mouth.y = baseSize.y + (audioData.open  * mouthStrength.height)
    data.mouth.z = baseSize.z + (audioData.round * mouthStrength.depth)

    data.mouth.nose = audioData.open * noseStrength
end

-- ========== APPLY

function Lipsync.tick()
    if not host:isHost() then return end

    if not voiceChat.get.isMicrophoneActive then
        resetMouth()
        return
    end

    local raw = voiceChat.get.rawAudioStream
    local rdata = Lipsync.analyze(raw)

    if rdata.volume <= 0 then
        resetMouth()
        return
    end

    Lipsync.updateTargets(rdata)
end

function Lipsync.render()
    smooth.x = math.lerp(smooth.x, data.mouth.x, lerpSpeed)
    smooth.y = math.lerp(smooth.y, data.mouth.y, lerpSpeed)
    smooth.z = math.lerp(smooth.z, data.mouth.z, lerpSpeed)
    smooth.nose = math.lerp(smooth.nose, data.mouth.nose, lerpSpeed)

    obj.MOUTH:setScale(smooth.x, smooth.y, smooth.z)
    obj.NOSE:setRot(smooth.nose, 0, 0)
end

return Lipsync
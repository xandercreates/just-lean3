---@alias multiple number | Vector | Matrix


local sin, cos, abs, lerp, map, pi = math.sin, math.cos, math.abs, math.lerp, math.map, math.pi

local vec2, vec3, vec4 = vectors.vec2, vectors.vec3, vectors.vec4

---@class easings: mathlib
---@field linear fun(a: multiple,b: multiple,t: number)
---@field inSine fun(a: multiple, b: multiple, t: number)
local easings = {}

function easings.linear(a,b,t)
    return lerp(a,b,t)
end

function easings.inSine(a,b,t)
    local v = 1 - cos((t * pi) / 2)
    return map(v, 0, 1, a, b)
end

function easings.outSine(a,b,t)
    local v = sin((t * pi) / 2)
    return map(v, 0, 1, a, b)
end

function easings.inOutSine(a,b,t)
    local v = -(cos(pi * t) - 1) / 2
    return map(v, 0, 1, a, b)
end

function easings.inQuad(a,b,t)
    local v = t ^ 2
    return map(v, 0, 1, a, b)
end

function easings.outQuad(a,b,t)
    local v =  1 - (1 - t) * (1 - t)
    return map(v, 0, 1, a, b)
end

function easings.inOutQuad(a,b,t)
    local v = t < 0.5 and 2 * t * t or 1 - ((-2 * t + 2) ^ 2) / 2
    return map(v, 0, 1, a, b)
end

function easings.inCubic(a,b,t)
    local v = t ^ 3
    return map(v, 0, 1, a, b)
end

function easings.outCubic(a,b,t)
    local v = 1 - ((1 - t)^3)
    return map(v, 0, 1, a, b)
end

function easings.inOutCubic(a,b,t)
    local v = t < 0.5 and 4 * t ^ 3 or 1 - ((-2 * t + 2) ^ 3) / 2
    return map(v, 0, 1, a, b)
end

function easings.inQuart(a,b,t)
    local v = t ^ 4
    return map(v, 0, 1, a, b)
end

function easings.outQuart(a,b,t)
    local v = 1 - ((1 - t) ^ 4)
    return map(v, 0, 1, a, b)
end

function easings.inOutQuart(a,b,t)
    local v = t < 0.5 and 8 * (t^4) or 1 - ((-2 * t + 2)^4) / 2
    return map(v, 0, 1, a, b)
end

function easings.inQuint(a,b,t)
    local v = t ^ 5
    return map(v, 0, 1, a, b)
end

function easings.outQuint(a,b,t)
    local v = 1 - ((1 - t) ^ 5)
    return map(v, 0, 1, a, b)
end

function easings.inOutQuint(a,b,t)
end

local function ease(a, b, t, s)
    return easings[s](a, b, t) --[[@as number | Vector| Matrix]]
end

math.ease = ease

local _pos, pos = vec
function events.tick()
end


function events.render(delta)
end
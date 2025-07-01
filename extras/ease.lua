---@alias multiple number | Vector | Matrix

---@alias validInterps: string
---| "linear"
---| "inSine"
---| "outSine"
---| "inOutSine"
---| "inQuad"
---| "outQuad"
---| "inOutQuad"
---| "inCubic"
---| "outCubic"
---| "inOutCubic"
---| "inQuart"
---| "outQuart"
---| "inQuint"
---| "outQuint"
---| "inOutQuint"
---| "inExpo"
---| "outExpo"
---| "inOutExpo"
---| "inCirc"
---| "outCirc"
---| "inOutCirc"

---@alias ease fun(a: multiple, b: multiple, t: number, s: validInterps)


local sin, cos, lerp, map, pi = math.sin, math.cos, math.lerp, math.map, math.pi

---@class easings: mathlib
---@field linear fun(a: multiple,b: multiple,t: number)
---@field inSine fun(a: multiple, b: multiple, t: number)
---@field outSine fun(a: multiple, b: multiple, t: number)
---@field inOutSine fun(a: multiple, b: multiple, t: number)
---@field inQuad fun(a: multiple, b: multiple, t: number)
---@field outQuad fun(a: multiple, b: multiple, t: number)
---@field inOutQuad fun(a: multiple, b: multiple, t: number)
---@field inCubic fun(a: multiple, b: multiple, t: number)
---@field outCubic fun(a: multiple, b: multiple, t: number)
---@field inOutCubic fun(a: multiple, b: multiple, t: number)
---@field inQuart fun(a: multiple, b: multiple, t: number)
---@field outQuart fun(a: multiple, b: multiple, t: number)
---@field inOutQuart fun(a: multiple, b: multiple, t: number)
---@field inQuint fun(a: multiple, b: multiple, t: number)
---@field outQuint fun(a: multiple, b: multiple, t: number)
---@field inOutQuint fun(a: multiple, b: multiple, t: number)
---@field inExpo fun(a: multiple, b: multiple, t: number)
---@field outExpo fun(a: multiple, b: multiple, t: number)
---@field inOutExpo fun(a: multiple, b: multiple, t: number)
---@field inCirc fun(a: multiple, b: multiple, t: number)
---@field outCirc fun(a: multiple, b: multiple, t: number)
---@field inOutCirc fun(a: multiple, b: multiple, t: number)
---@field setting fun(self?: self, x: string, y: boolean)
---@field __ease fun(self?: self, a: multiple, b: multiple, t: number, s: validInterps|string)
---@field exposeEase boolean
---@field exposeLib boolean
---@field test boolean
local easings = {}
easings.exposeEase = false --adds the local ease function to mathlib
easings.exposeLib = true --allows library to be used without require(), might still break some scripts due to load order.
easings.test = false

---@return multiple
function easings.linear(a,b,t)
    return lerp(a,b,t)
end

---@return multiple
function easings.inSine(a,b,t)
    local v = 1 - cos((t * pi) / 2)
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.outSine(a,b,t)
    local v = sin((t * pi) / 2)
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inOutSine(a,b,t)
    local v = -(cos(pi * t) - 1) / 2
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inQuad(a,b,t)
    local v = t ^ 2
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.outQuad(a,b,t)
    local v =  1 - (1 - t) * (1 - t)
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inOutQuad(a,b,t)
    local v = t < 0.5 and 2 * t * t or 1 - ((-2 * t + 2) ^ 2) / 2
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inCubic(a,b,t)
    local v = t ^ 3
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.outCubic(a,b,t)
    local v = 1 - ((1 - t)^3)
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inOutCubic(a,b,t)
    local v = t < 0.5 and 4 * t ^ 3 or 1 - ((-2 * t + 2) ^ 3) / 2
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inQuart(a,b,t)
    local v = t ^ 4
    return map(v, 0, 1, a, b)
end


---@return multiple
function easings.outQuart(a,b,t)
    local v = 1 - ((1 - t) ^ 4)
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inOutQuart(a,b,t)
    local v = t < 0.5 and 8 * (t^4) or 1 - ((-2 * t + 2)^4) / 2
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inQuint(a,b,t)
    local v = t ^ 5
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.outQuint(a,b,t)
    local v = 1 - ((1 - t) ^ 5)
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inOutQuint(a,b,t)
    local v = t < 0.5 and 16 * (t^5) or 1 - ((-2 * t + 2)^4) / 2;
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inExpo(a,b,t)
    local v = t == 0 and 0 or 2^(10 * t - 10)
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.outExpo(a,b,t)
    local v = t == 1 and 1 or 1 - 2^(-10 * t)
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inOutExpo(a,b,t)
    local v = t == 0 and 0 or t == 1 and 1 or t < 0.5 and (2^(20 * t - 10) / 2) or (2^(-20*t+10)) / 2
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inCirc(a,b,t)
    local v = 1 - math.sqrt(1 - (t^2))
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.outCirc(a,b,t)
    local v = math.sqrt(1 - ((t - 1)^2))
    return map(v, 0, 1, a, b)
end

---@return multiple
function easings.inOutCirc(a,b,t)
    local v = t < 0.5 and ((1 - math.sqrt(1 - (2 * t)^2)) / 2) or ((math.sqrt(1 - (-2 * t + 2)^2) + 1) / 2)
    return map(v, 0, 1, a, b)
end

---@return nil
function easings:setting(x, y)
    self[x] = y or not self[x]
end

---@return multiple
function easings:__ease(a,b,t,s)
    return self[s](a,b,t)
end


local function ease(a, b, t, s)
    easings:__ease(a,b,t,s)
end


function events.world_tick()
    if easings.exposeEase then
        math.ease = ease
    else
        math.ease = nil
    end
    if easings.exposeLib then
        _G.easings = easings
    else
        _G.easings = nil
    end
end

local _pos, pos = vec(0,0,0), vec(0,0,0)
local wrld = models:newPart("World", "WORLD")
local task = wrld:newItem("test"):setItem("stone")

function events.tick()
    task:setVisible(easings.test)
    if not easings.test then return end
    _pos:set(pos)
    pos:set(ease(pos, player:getPos()+(player:getLookDir():normalize()*2)+vec(0,player:getEyeHeight(),0), 0.7, "inQuint"))
end


function events.world_render(delta)
    if not easings.test then return end
    if delta == 1 then return end
    local fPos = lerp(_pos, pos, delta)
    task:setPos(fPos*16)
end

return easings
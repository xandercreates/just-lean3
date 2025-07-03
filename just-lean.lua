---@alias defaultInterpolation: string
---| "linear"

local assumed = "src.extras.ease" --change as expected
local easings
local exists = pcall(require(assumed))
---@class lean
local justlean = {}
justlean.active = {}
justlean.useEaseLib = false
---@class jl-extra
local jl_extras = {}
setmetatable(jl_extras, justlean)

function events.entity_init()
   exists = justlean.useEaseLib and pcall(require(assumed))
   if justlean.useEaseLib then
    if not exists then
        for _, k in ipairs(listFiles(nil, true)) do
            if k:find("ease$") then
                easings = require(k)
            end
        end
        else
            easings = require("src.extras.ease")
        end
    else
        easings = nil
    end
end
local function clamp(v, a, b)
    return math.min(math.max(v, a), b)
end

---@param self? self
---@param modelpart ModelPart
---@param modelHead? ModelPart
---@param changeHead boolean
---@param minLean table | Vector2
---@param maxLean table | Vector2
---@param speed number
---@param int defaultInterpolation | string
function justlean.init(self, modelpart, modelHead, changeHead, minLean, maxLean, speed, int)
    local self = setmetatable({}, justlean) --[[@as table]]
    self.enabled = true
    self.modelpart = modelpart
    self.modelHead = modelHead or vanilla_model.HEAD
    self.minLean = type(minLean) == "table" and vec(minLean.x or minLean[1] or -15, minLean.y or minLean[2] or -15, 0) or minLean.xy_
    self.maxLean = type(maxLean) == "table" and vec(maxLean.x or maxLean[1] or 15, maxLean.y or maxLean[2] or 15, 0) or maxLean.xy_
    self.speed = speed or 0.75
    self.int = int or "linear"
    self.rot = vectors.vec3()
    self._rot = self.rot:copy()
    self.changeHead = changeHead or changeHead == nil and changeHead ~= false and true
    self.doVanilla = type(self.modelHead) == "VanillaModelPart" or self.modelHead:getParentType():lower() == "head" or false

    function self:zero()
        self._rot = self.rot
        self.rot = vec(0,0,0)
    end

    function self:enable()
        self.enabled = true
        return self
    end

    function self:disable()
        self.enabled = false
        return self
    end

    function self:toggle()
        self.enabled = not self.enabled
        return self
    end

    function self:setState(x)
        if not x then
            self:toggle()
        else
            self.enabled = x
        end
    end


    self.tick = function(self) --MATH!!!
    if self.enabled then
            self._rot:set(self.rot)
            local vel = (math.log((player:getVelocity().x_z:length()*20) + 1 - 0.21585) * 0.06486 * 19 + 1)
            --log(player:getVelocity().x_z:length()*20)
            local t = math.sin(((client.getSystemTime() / 1000) * 20) / 16.0)
            local interp = exists and easings or math.lerp
            local base = ((((vanilla_model.HEAD:getOriginRot()+180)%360)-180):toRad() / vel) * 45.5
            local breathe = vec( t * 2.0, math.abs(t) / 2.0, (math.abs(math.cos(t)) / 16.0))
            local mth = vec(
                player:getPose() == "STANDING" and clamp(base.x, self.minLean.x, self.maxLean.x) or 0,
                player:getPose() == "STANDING" and clamp(base.y, self.minLean.y, self.maxLean.y) or 0,
                player:getPose() == "STANDING" and base.y * 0.075 or 0
            ):add(breathe)
            if exists then
                self.rot:set(interp:ease(self.rot, mth, self.speed or 0.75, self.int))
            else
                self.rot:set(interp(self.rot, mth, self.speed or 0.75))
            end
        else
            self:zero()
        end
    end

    self.render = function(self, delta, ctx)
        local inter = math.lerp(self._rot, self.rot, delta)
        --self.doVanilla = false
        self.modelpart:setRot(inter)
        if self.changeHead then
            if self.doVanilla then
                self.modelHead:setRot(self.modelHead:getOriginRot() + (inter*vec(-1,-1,-0.5)))
            else
                self.modelHead:setRot(self.modelHead:getRot() or vec(0,0,0) + (inter*vec(-1,-1,-0.5)))
            end
        else
            self.modelHead:setRot()
        end
    end
   
    table.insert(justlean.active, self)
    return self
end


function events.tick()
    for _, v in pairs(justlean.active) do
        v:tick()
    end
end

function events.render(delta, context)
    if delta == 1 then return end
    for _, v in pairs(justlean.active) do
        v:render(delta)
    end
end

return justlean
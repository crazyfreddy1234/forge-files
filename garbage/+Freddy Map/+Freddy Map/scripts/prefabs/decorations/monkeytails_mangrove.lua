
local prefabs =
{

}

local function SetFaceType(inst, type)
	if type == 8 then
		inst.Transform:SetEightFaced()
	elseif type == 6 then
		inst.Transform:SetSixFaced()
	elseif type == 4 then
		inst.Transform:SetFourFaced()
	else
		inst.Transform:SetNoFaced()
	end
end

local function UpdateSelf(inst) --mostly for data added via the map
    if inst.rotation then
        inst.Transform:SetRotation(inst.rotation)
    end
end

local function MakeMonkeytails(name, data)
    local assets =
    {
	    Asset("ANIM", "anim/reeds_monkeytails.zip"),
    }
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
		
		MakeObstaclePhysics(inst, 2.35)
        if data.facetype then
            SetFaceType(inst, data.facetype)
        end

        inst.AnimState:SetBank(data.bank or "grass")
        inst.AnimState:SetBuild(data.build or "reeds_monkeytails")
        inst.AnimState:PlayAnimation("idle", true)
		if data.scale then
			inst.AnimState:SetScale(data.scale, data.scale)
		end

        inst:AddTag("FX")
		inst:AddTag("NOCLICK")

		if data.bloom then
			inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		end

		if data.glow then
			inst.AnimState:SetLightOverride(data.glow)
		end
		
        if data.blockrad then
		    inst:SetGroundTargetBlockerRadius(data.blockrad)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:DoTaskInTime(0, UpdateSelf)

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeMonkeytails("monkeytails_mangrove", {scale = 1, blockrad = 1})
	
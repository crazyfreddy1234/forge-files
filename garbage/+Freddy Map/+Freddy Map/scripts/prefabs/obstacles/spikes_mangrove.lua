

local assets = {
    Asset("ANIM", "anim/spikes_mangrove.zip"),
}
local prefabs = {
    "collapse_small",
}

local function BreakTrap(inst)
	inst.state = "death"
	inst.AnimState:PlayAnimation("death")
end

------------------------------------------------------------------
--Spikes

local spike_values = TUNING.REFORGED_MAPS.SPIKES_MANGROVE

local SPIKES_EXCLUDE_TAGS = { "playerghost", "ghost", "INLIMBO", "notarget", "noattack", "camera", "invisible", "battlestandard", "mermguard" }

local spike_sounds = {
	activate	= "wintersfeast2019/winters_feast/oven/start",
	deactivate	= "dontstarve/quagmire/common/safe/open",
}

local function DeactivateSpikes(inst)
	inst.AnimState:PlayAnimation("deactivate")
	inst.state = "deactivated"
	inst.SoundEmitter:PlaySound("dontstarve/quagmire/common/safe/open")
	inst:DoTaskInTime(inst.activate_time or spike_values.ACTIVATE_TIME, inst.activate_fn)
end

local function ActivateSpikes(inst)
	inst.AnimState:PlayAnimation("activate")
	inst.state = "activated"
	inst.SoundEmitter:PlaySound("wintersfeast2019/winters_feast/oven/start")
	local pos = inst:GetPosition()
	local ents = TheSim:FindEntities(pos.x, 0, pos.z, spike_values.HIT_RANGE or 3, {"_combat", "_health"}, {"LA_mob", "notarget", "ghost", "shadow", "INLIMBO", "mermguard"})
	if #ents > 0 then
		for i, v in ipairs(ents) do
			if v ~= inst then
				v.components.combat:GetAttacked(inst, inst.components.combat.defaultdamage)		
				COMMON_FNS.KnockbackOnHit(inst, v, 2, nil, nil, true)
			end
		end
	end
	inst:DoTaskInTime(inst.deactivate_time or spike_values.DEACTIVATE_TIME, inst.deactivate_fn)
	local exclude_tags = inst.source and COMMON_FNS.GetAllyTags(inst.source) or {}
end

local function spike_fn()
    local inst = COMMON_FNS.BasicEntityInit("spikes_mangrove", "spikes_mangrove", "activate", {pristine_fn = function(inst)
	    inst.entity:AddSoundEmitter()
	    ------------------------------------------
	    COMMON_FNS.AddTags(inst, "trap", "spikes")
	end})
	------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    ------------------------------------------
	inst.Transform:SetNoFaced()
	inst.Transform:SetScale(6, 6, 6) 
	------------------------------------------
    inst.sounds				= spike_sounds
	inst.activate_time		= spike_values.ACTIVATE_TIME
	inst.deactivate_time	= spike_values.DEACTIVATE_TIME
	inst.activate_fn		= ActivateSpikes
	inst.deactivate_fn		= DeactivateSpikes
    ------------------------------------------
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(spike_values.DAMAGE)
    ------------------------------------------
	ActivateSpikes(inst)
    ------------------------------------------
    return inst
end

local function spike2_fn()
    local inst = COMMON_FNS.BasicEntityInit("spikes_mangrove", "spikes_mangrove", "activate", {pristine_fn = function(inst)
	    inst.entity:AddSoundEmitter()
	    ------------------------------------------
	    COMMON_FNS.AddTags(inst, "trap", "spikes")
	end})
	------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    ------------------------------------------
	inst.Transform:SetNoFaced()
	inst.Transform:SetScale(6, 6, 6) --TODO FIX THE ANIM SO I DON'T NEED TO DO THIS!
	------------------------------------------
    inst.sounds				= spike_sounds
	inst.activate_time		= spike_values.ACTIVATE2_TIME
	inst.deactivate_time	= spike_values.DEACTIVATE2_TIME
	inst.activate_fn		= ActivateSpikes
	inst.deactivate_fn		= DeactivateSpikes
    ------------------------------------------
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(spike_values.DAMAGE)
    ------------------------------------------
	ActivateSpikes(inst)
    ------------------------------------------
    return inst
end
--------------------------------------------------------


return Prefab("spikes_mangrove", spike_fn, assets, prefabs),
	Prefab("spikes2_mangrove", spike2_fn, assets, prefabs)
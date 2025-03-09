local assets = {
    Asset("ANIM", "anim/geyser_mangrove.zip"),
}
local prefabs = {
    "collapse_small",
}

local function BreakTrap(inst)
	inst.state = "death"
	inst.AnimState:PlayAnimation("death")
end

------------------------------------------------------------------
--Geyser

local geyser_values		= TUNING.REFORGED_MAPS.GEYSER_MANGROVE
local AURA_EXCLUDE_TAGS = { "playerghost", "ghost", "noauradamage", "INLIMBO", "notarget", "noattack", "camera", "invisible", "battlestandard", "mermguard" }

local geyser_sounds = {
	activate  = "turnoftides/common/together/water/hotspring/bathbomb",
	deactivate = "dontstarve/quagmire/common/safe/open",
}

local function DeactivateGeyser(inst)
	inst.AnimState:PlayAnimation("pst")
	inst.state = "deactivated"
	inst.components.aura:Enable(false)
	--inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
	inst:DoTaskInTime(inst.activate_time or geyser_values.ACTIVATE_TIME, inst.activate_fn)
end

local function ActivateGeyser(inst)
	inst.AnimState:PlayAnimation("loop", true)
	inst.state = "activated"
	inst.SoundEmitter:PlaySound("turnoftides/common/together/water/hotspring/bathbomb")
	local pos = inst:GetPosition()
	local ents = TheSim:FindEntities(pos.x, 0, pos.z, geyser_values.HIT_RANGE or 3, {"_combat", "_health"}, {"LA_mob", "notarget", "ghost", "shadow", "INLIMBO", "mermguard"})
	if #ents > 0 then
		for i, v in ipairs(ents) do
			if v ~= inst then
				v.components.combat:GetAttacked(inst, inst.components.combat.defaultdamage)		
				--COMMON_FNS.KnockbackOnHit(inst, v, 2)
				v.components.debuffable:AddDebuff("scorpeon_dot", "scorpeon_dot")
			end
		end
	end
	inst.components.aura:Enable(true)
	inst:DoTaskInTime(inst.deactivate_time or geyser_values.DEACTIVATE_TIME, inst.deactivate_fn)
	local exclude_tags = inst.source and COMMON_FNS.GetAllyTags(inst.source) or {}
end

local function geyser_fn()
    local inst = COMMON_FNS.BasicEntityInit("geyser_mangrove", "geyser_mangrove", "loop", {pristine_fn = function(inst)
	    inst.entity:AddSoundEmitter()
	    ------------------------------------------
	    COMMON_FNS.AddTags(inst, "trap", "geyser", "NOCLICK")
	end})
	------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    ------------------------------------------
	inst.Transform:SetNoFaced()
	inst.Transform:SetScale(1, 1, 1)
	------------------------------------------
    inst.sounds				= geyser_sounds
	inst.activate_time		= geyser_values.ACTIVATE_TIME
	inst.deactivate_time	= geyser_values.DEACTIVATE_TIME
	inst.activate_fn		= ActivateGeyser
	inst.deactivate_fn		= DeactivateGeyser
    ------------------------------------------
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(TUNING.TOADSTOOL_SPORECLOUD_DAMAGE)

	inst:AddComponent("aura")
    inst.components.aura.radius			 = geyser_values.RADIUS
    inst.components.aura.tickperiod		 = geyser_values.TICK
    inst.components.aura.auraexcludetags = AURA_EXCLUDE_TAGS
    inst.components.aura:Enable(true)
    ------------------------------------------
	ActivateGeyser(inst)
    ------------------------------------------
    return inst
end

local function geyser2_fn()
    local inst = COMMON_FNS.BasicEntityInit("geyser_mangrove", "geyser_mangrove", "loop", {pristine_fn = function(inst)
	    inst.entity:AddSoundEmitter()
	    ------------------------------------------
	    COMMON_FNS.AddTags(inst, "trap", "geyser", "NOCLICK")
	end})
	------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    ------------------------------------------
	inst.Transform:SetNoFaced()
	inst.Transform:SetScale(1, 1, 1)
	------------------------------------------
    inst.sounds				= geyser_sounds
	inst.activate_time		= geyser_values.ACTIVATE2_TIME
	inst.deactivate_time	= geyser_values.DEACTIVATE2_TIME
	inst.activate_fn		= ActivateGeyser
	inst.deactivate_fn		= DeactivateGeyser
    ------------------------------------------
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(geyser_values.DAMAGE)
	

	inst:AddComponent("aura")
    inst.components.aura.radius			 = geyser_values.RADIUS
    inst.components.aura.tickperiod		 = geyser_values.TICK
    inst.components.aura.auraexcludetags = AURA_EXCLUDE_TAGS
    inst.components.aura:Enable(true)

    ------------------------------------------
	ActivateGeyser(inst)
    ------------------------------------------
    return inst
end
--------------------------------------------------------

--------------------------------------------------------


return Prefab("geyser_mangrove", geyser_fn, assets, prefabs),
	Prefab("geyser2_mangrove", geyser2_fn, assets, prefabs)
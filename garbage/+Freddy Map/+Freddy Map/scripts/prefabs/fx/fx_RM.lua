local prefabs = {}

local assets = {
	
	Asset("ANIM", "anim/circus_portal_fx.zip"),
}

local function MakeFX(name, data)--bank, build, anim, animloop, isflat, glow, multc, bloom)
    local function fn()
        local inst = CreateEntity()
        ------------------------------------------
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        ------------------------------------------
        inst.AnimState:SetBank(data.bank)
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation(data.anim)
		if data.multc then
			local multc = data.multc
			inst.AnimState:SetMultColour(multc[1]/255, multc[2]/255, multc[3]/255, multc[4])
		end
		if data.addcolour then
			local addcolour = data.addcolour
			inst.AnimState:SetAddColour(addcolour[1]/255, addcolour[2]/255, addcolour[3]/255, addcolour[4])
		end
		if data.animloop then
			inst.AnimState:PushAnimation(data.animloop, true)
		end
		if data.foffset then
			inst.AnimState:SetFinalOffset(data.foffset)
		end
		if data.scale then
			inst.AnimState:SetScale(data.scale, data.scale)
		end
		if data.hidesymbols then
			for i, v in ipairs(data.hidesymbols) do
				inst.AnimState:HideSymbol(v)
			end
		end
		if data.facetype then
			SetFace(inst, data.facetype)
		end
		------------------------------------------
        inst:AddTag("FX")
		inst:AddTag("NOCLICK")
		------------------------------------------
		if data.isflat then
			--ideally we want them to just be under characters and above everything else
			inst.AnimState:SetRayTestOnBB(true)
			inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
			inst.AnimState:SetLayer(LAYER_BACKGROUND)
			inst.AnimState:SetSortOrder(3)
		end
		------------------------------------------
		if data.order then
			inst.AnimState:SetSortOrder(data.order)
		end
		------------------------------------------
		if data.bloom then
			inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		end
		------------------------------------------
		if data.glow then
			inst.AnimState:SetLightOverride(data.glow)
		end
		------------------------------------------
		if data.sound then
			inst.SoundEmitter:PlaySound(data.sound)
		end
		------------------------------------------
        inst.entity:SetPristine()
        ------------------------------------------
        if not TheWorld.ismastersim then
            return inst
        end
        ------------------------------------------
		inst.persists = false
		------------------------------------------
		if data.noloop then
			inst:ListenForEvent("animqueueover", inst.Remove)
		end
		------------------------------------------
		if data.fadein then
			inst:AddComponent("colourtweener")
			inst.AnimState:SetMultColour(0, 0, 0, 0)
			inst:DoTaskInTime(0, function(inst)
				inst.components.colourtweener:StartTween(data.multc and {data.multc[1]/255, data.multc[2]/255, data.multc[3]/255, data.multc[4]} or {1,1,1,1}, data.fadein)
			end)
		end
		------------------------------------------
		if data.fadeout then
			inst:AddComponent("colourtweener")
			inst:DoTaskInTime(0, function(inst)
				inst.components.colourtweener:StartTween({0,0,0,0}, data.fadeout, inst.Remove)
			end)
		end
		------------------------------------------
        return inst
    end

    return Prefab(name, fn, assets)
end

--TODO: Make these non-networked. Don't tell Glass.
return MakeFX("hf_passiveshield", {bank = "hf_passiveshield", build = "hf_passiveshield", anim = "front", isflat = true, glow = 1, multc = {255, 48, 183, 255}}),
	--General FX
	MakeFX("circus_portal_fx", {bank = "lavaportal_fx", build = "circus_portal_fx", anim = "portal_pre", animloop = "portal_loop", glow = 1, isflat = true, order = -1}),
	MakeFX("circus_player_teleport_fx", {bank = "lavaarena_player_teleport", build = "lavaarena_player_teleport_colorable", anim = "idle", glow = 1, order = 1, multc = {247, 178, 82, 255}, noloop = true, sound = "dontstarve/common/lava_arena/portal_player"})
	
	--Decor FX
	
	--Mob FX
	
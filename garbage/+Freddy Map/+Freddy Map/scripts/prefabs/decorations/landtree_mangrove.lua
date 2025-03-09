local decor = {}
local assets =
{
	Asset("ANIM", "anim/landtree_mangrove.zip"),
}

local function onload(inst, data, newents)
    if data then
		inst.Transform:SetRotation(data.rotation or 0)
    end
end

local anims = {
}
	
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("landtree_mangrove")
    inst.AnimState:SetBuild("oceantree_mangrove")
    inst.AnimState:PlayAnimation("sway1_loop", true)

    inst:AddTag("FX")
	inst:AddTag("NOCLICK")

    local color = .5 + math.random() * .5
    inst.AnimState:SetMultColour(color, color, color, 1)

    MakeSnowCoveredPristine(inst)
		
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false

    return inst
end
return Prefab("landtree_mangrove", fn, assets)
local assets =
{
    Asset("ANIM", "anim/mangrove_spawner.zip"),
}

local prefabs =
{
    "lavaarena_spawnerdecor_fx_1",
    "lavaarena_spawnerdecor_fx_2",
    "lavaarena_spawnerdecor_fx_3",
    "lavaarena_spawnerdecor_fx_small",
}

local DECOR_RADIUS = 3.3
local NUM_DECOR = 6

local function GetDecorPos(index)
    local angle = 240 * DEGREES
    local start_angle = -.5 * angle
    local delta_angle = angle / (NUM_DECOR - 1)
    return DECOR_RADIUS * math.sin(start_angle + index * delta_angle),
        0,
        -DECOR_RADIUS * math.cos(start_angle + index * delta_angle)
end

local function CreateScratches()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --[[Non-networked entity]]

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:SetBank("mangrove_spawner")
    inst.AnimState:SetBuild("lavaarena_spawner")
    inst.AnimState:PlayAnimation("idle_scratch")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    return inst
end

local function CreateSpawnTooth(variation)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --[[Non-networked entity]]

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:SetBank("mangrove_spawndecor")
    inst.AnimState:SetBuild("mangrove_spawndecor")
    inst.AnimState:PlayAnimation("idle")


    return inst
end

local function AddDecor(inst)
    CreateScratches().entity:SetParent(inst.entity)

    inst.highlightchildren = {}

    for i = 0, NUM_DECOR - 1 do
        local decor = CreateSpawnTooth(i % 4)
        decor.entity:SetParent(inst.entity)
        decor.Transform:SetPosition(GetDecorPos(i))
        table.insert(inst.highlightchildren, decor)
    end
end

local function mangrove_spawner()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("mangrove_spawner")
    inst.AnimState:SetBank("lavaarena_spawner")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(1)

    if not TheNet:IsDedicated() then
        AddDecor(inst)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    event_server_data("lavaarena", "prefabs/lavaarena_spawner").master_postinit(inst)

    return inst
end

return Prefab("mangrove_spawner", mangrove_spawner, assets, prefabs)

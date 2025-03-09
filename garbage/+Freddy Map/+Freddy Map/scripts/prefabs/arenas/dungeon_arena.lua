require("prefabs/world")
local TileManager = require "tilemanager"
local GroundTiles = require "worldtiledefs"
local assets = { -- TODO which assets are needed? add to common fns?
    Asset("SCRIPT", "scripts/prefabs/world.lua"),

    Asset("SOUND", "sound/lava_arena.fsb"),
    Asset("SOUND", "sound/forge2.fsb"),

    Asset("IMAGE", "images/lavaarena_wave.tex"),

    Asset("IMAGE", "images/wave.tex"),
    Asset("IMAGE", "images/wave_shadow.tex"),

    Asset("IMAGE", "images/colour_cubes/day05_cc.tex"), --default CC at startup

    Asset("ANIM", "anim/progressbar_tiny.zip"),
}
local prefabs = {
    "lavaarena_portal",
    "lavaarena_groundtargetblocker",
    "lavaarena_center",
    "lavaarena_spawner",

    "wave_shimmer",
    "wave_shore",
}
--------------------------------------------------------------------------
local function tile_physics_init(inst)
    inst.Map:AddTileCollisionSet(
        COLLISION.LAND_OCEAN_LIMITS,
        TileGroups.ImpassableTiles, true,
        TileGroups.ImpassableTiles, false,
        0.25, 64
    )
end
--------------------------------------------------------------------------
local map_values = {
    name = "dungeon_arena",
    colour_cube  = "images/colour_cubes/day05_cc.tex",
    sample_style = MAP_SAMPLE_STYLE.NINE_SAMPLE,
}
--------------------------------------------------------------------------
local function common_preinit(inst)
    COMMON_FNS.MapPreInit(inst, map_values)
end
--------------------------------------------------------------------------
local function common_postinit(inst)
    COMMON_FNS.MapPostInit(inst, map_values)
    mod_protect_TileManager = false
    inst:AddComponent("wavemanager")
    inst.Map:SetTransparentOcean(true)

    local map = TheWorld.Map 
        local tuning = TUNING.OCEAN_SHADER 
        map:SetOceanEnabled(true) 
        map:SetOceanTextureBlurParameters(tuning.TEXTURE_BLUR_PASS_SIZE, tuning.TEXTURE_BLUR_PASS_COUNT) 
        map:SetOceanNoiseParameters0(tuning.NOISE[1].ANGLE, tuning.NOISE[1].SPEED, tuning.NOISE[1].SCALE, tuning.NOISE[1].FREQUENCY) 
        map:SetOceanNoiseParameters1(tuning.NOISE[2].ANGLE, tuning.NOISE[2].SPEED, tuning.NOISE[2].SCALE, tuning.NOISE[2].FREQUENCY) 
        map:SetOceanNoiseParameters2(tuning.NOISE[3].ANGLE, tuning.NOISE[3].SPEED, tuning.NOISE[3].SCALE, tuning.NOISE[3].FREQUENCY)

    -- print(tostring(TheWorld.Map:GetTileAtPoint(ThePlayer:GetPosition():Get()))
    if not TheNet:IsDedicated() then
        --print("OCEAN COLOR UPDATING")
        --inst.components.oceancolor:Initialize(true)
        inst.Map:DoOceanRender(true)
    end
    mod_protect_TileManager = true
end
--------------------------------------------------------------------------
local function master_postinit(inst)
    COMMON_FNS.MapMasterPostInit(inst)
end
--------------------------------------------------------------------------
local function fn()
    local inst = COMMON_FNS.NetworkInit()
    ------------------------------------------
    inst._fog_density = net_int(inst.GUID, "lavaarena_network._fog_density", "updatefogdensity")
    inst._fog_density:set(4)
    ------------------------------------------
    inst.GetFogDensity = function(inst)
        return inst._fog_density:value()
    end
    ------------------------------------------
    inst._earthquake_intensity = net_float(inst.GUID, "lavaarena_network._earthquake_intensity")
    inst._earthquake_duration = net_float(inst.GUID, "lavaarena_network._earthquake_duration", "updateearthquakesound")
    ------------------------------------------
    if not TheNet:IsDedicated() then
        inst:ListenForEvent("updateearthquakesound", function()
            RemoveTask(inst.earthquake_sound_task)
            if TheWorld.SoundEmitter:PlayingSound("earthquake_sound") then
                TheWorld.SoundEmitter:KillSound("earthquake_sound")
            end
            local duration = inst._earthquake_duration:value()
            local intensity = inst._earthquake_intensity:value()
            if duration and duration > 0 and intensity and intensity > 0 then
                TheWorld.SoundEmitter:PlaySound("dontstarve/cave/earthquake", "earthquake_sound")
                TheWorld.SoundEmitter:SetParameter("earthquake_sound", "intensity", intensity)
                inst.earthquake_sound_task = inst:DoTaskInTime(duration, function()
                    if TheWorld.SoundEmitter:PlayingSound("earthquake_sound") then
                        TheWorld.SoundEmitter:KillSound("earthquake_sound")
                    end
                end)
            end
        end)
    end
    ------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    ------------------------------------------
    --[[inst:DoPeriodicTask(5, function()
        inst._fog_density:set(inst:GetFogDensity() + 1)
    end)--]]
    inst.SetEarthQuakeSound = function(inst, intensity, duration)
        inst._earthquake_intensity:set_local(0)
        inst._earthquake_intensity:set(intensity or 1)
        inst._earthquake_duration:set_local(0)
        inst._earthquake_duration:set(duration or 1)
    end
    ------------------------------------------
    return inst
end
--------------------------------------------------------------------------
return MakeWorld(map_values.name, prefabs, assets, common_postinit, master_postinit, { "lavaarena" }, {common_preinit = common_preinit}), Prefab(map_values.name .. "_network", fn)

------------
-- Spells --
------------
-- TODO is_random functionality (if not random then should return closest targets first)
--[[local function CommonSpellTargetCondition(inst, target)
	return target.components.health and not target.components.health:IsDead() and not target:HasTag("battlestandard") and not target:HasTag("structure")
end

local function GetTargetsForSpell(inst, range, max_targets, target_condition_fn, is_friendly, is_random)
    local range = range or 1
    local pos = inst:GetPosition()
    local ents = {}
	local target_cond = target_condition_fn or CommonSpellTargetCondition
    for _,target in pairs(TheSim:FindEntities(pos.x, 0, pos.z, range, {"_combat"}, {"battlestandard", "structure", "notarget"}, is_friendly and COMMON_FNS.GetAllyTags(inst) or COMMON_FNS.GetEnemyTags(inst))) do
        if target_cond(inst, target) then
            table.insert(ents, target)
        end
    end
    return max_targets and GetRandomValuesFromTable(ents, max_targets, true) or ents
end

local function MagicCircleTrackTargetPos(circle, caster, target)
    if circle and circle:IsValid() and target and target:IsValid() then
        circle:DoPeriodicTask(0, function(inst)
            if circle and circle:IsValid() and target and target:IsValid() then
                circle.Transform:SetPosition(target:GetPosition():Get())
            end
        end)
    end
end

local function HideMagicCircle(magic_circle)
    magic_circle:Hide()
end
-----------
-- Other --
-----------
local function SpawnFXInCircle(inst, opts) -- TODO move to main mod? there is a circle fx common fn already, but not like this at all
    local options = {
        prefab          = "hf_ground_lightning",
        max_angle_tests = 8,
        distance        = 3,
        max_spawn       = 3,
        min_angle       = 20,
        onspawn_fn      = nil,
        is_water_valid  = false,
        spawn_distance_from_edge = 3,
    }
    -- Load custom options
    MergeTable(options, opts or {}, true)
    -- Get valid angles
    local valid_angles = {}
    local angle_per_test = 360/options.max_angle_tests
    local owner_angle = -inst.Transform:GetRotation()
    local start_angle = owner_angle + angle_per_test
    local total_valid_angles = 0
    local pos = inst:GetPosition()
    for i=1,options.max_angle_tests do
        local angle       = owner_angle + angle_per_test*i
        local radian      = angle*DEGREES
        local offset      = Vector3(math.cos(radian),0,math.sin(radian)) * options.distance
        local current_pos = pos + offset
        -- Update valid angles if invalid point
        if not options.is_water_valid and TheWorld.Map:GetNearestPointOnWater(current_pos.x, current_pos.z, options.spawn_distance_from_edge, 1) then
            if start_angle ~= angle then
                table.insert(valid_angles, {start = start_angle - angle_per_test/2, final = angle - angle_per_test/2})
                valid_angles[#valid_angles].total = math.abs(valid_angles[#valid_angles].final - valid_angles[#valid_angles].start)
                total_valid_angles = total_valid_angles + valid_angles[#valid_angles].total
            end
            start_angle = angle_per_test * (i + 1)
        -- Update valid angles if the final point is valid
        elseif i == options.max_angle_tests then
            table.insert(valid_angles, {start = start_angle - angle_per_test/2, final = angle + angle_per_test/2})
            valid_angles[#valid_angles].total = math.abs(valid_angles[#valid_angles].final - valid_angles[#valid_angles].start)
            total_valid_angles = total_valid_angles + valid_angles[#valid_angles].total
        end
    end
    -- Only spawn fx if valid angles were found
    if #valid_angles > 0 then
        for _,angle_info in pairs(valid_angles) do
            -- Calculate the max amount that SHOULD spawn in this group
            local angle_ratio         = angle_info.total/total_valid_angles
            local current_total_spawn = math.ceil(angle_ratio * options.max_spawn) - (angle_ratio == 1 and 0 or 1)
            -- Calculate the max amount that CAN spawn in this group
            local angle_between_spawns = angle_info.total/(current_total_spawn - (angle_info.total >= 360 and 0 or 1))
            while current_total_spawn > 1 and angle_between_spawns < options.min_angle do
                current_total_spawn  = current_total_spawn - 1
                angle_between_spawns = angle_info.total/(current_total_spawn - (angle_info.total >= 360 and 0 or 1))
            end
            -- Spawn FX
            if current_total_spawn > 0 then
                local mid_angle = angle_info.start + angle_info.total/2
                for i=1,current_total_spawn do
                    local fx = COMMON_FNS.CreateFX(options.prefab)
                    -- Set Position
                    local radian      = (mid_angle + (i - (current_total_spawn + 1)/2) * angle_between_spawns) * DEGREES
                    local offset      = Vector3(math.cos(radian), 0, math.sin(radian)) * options.distance
                    local current_pos = pos + offset
                    fx.Transform:SetPosition(current_pos:Get())
                    if options.onspawn_fn then
                        options.onspawn_fn(inst, fx)
                    end
                end
            end
        end
    end
end

return {
    -- Spells
	CommonSpellTargetCondition = CommonSpellTargetCondition,
    GetTargetsForSpell        = GetTargetsForSpell,
    MagicCircleTrackTargetPos = MagicCircleTrackTargetPos,
    HideMagicCircle           = HideMagicCircle,
    -- Other
    SpawnFXInCircle = SpawnFXInCircle,
}]]

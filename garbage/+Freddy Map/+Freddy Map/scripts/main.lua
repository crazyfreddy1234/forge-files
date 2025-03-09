local _G				= GLOBAL
local AddPrefabPostInit = AddPrefabPostInit
local STRINGS			= _G.STRINGS

-- AddMap(name, level_id, spawners, targeting_range, icon, minimap, order_priority)
_G.AddMap("dungeon_arena", "DUNGEON_ARENA", 4, {atlas = "images/map_mangrove.xml", tex = "map_mangrove.tex"}, {atlas = "images/mangrove_arena_map.xml", tex = "mangrove_arena_map.tex"}, 5)
--_G.AddMap("mangrove_arena",	"MANGROVE_ARENA", 4, nil, {atlas = "images/reforged.xml", tex = "map_unknown.tex"}, {atlas = "images/maps.xml", tex = "map_unknown.tex"}, 1)

--local icon = {atlas = "images/reforged.xml", tex = "map_unknown.tex"}
--local minimap = {atlas = "images/reforged.xml", tex = "map_unknown.tex", atlas_preview = "images/reforged.xml", tex_preview = "map_unknown.tex"}
--_G.AddMap("circus_tent_arena", "CIRCUS_TENT_ARENA", 4, nil, icon, minimap, 0) -- TODO level id for default?
--_G.AddMap("mangrove_arena", "MANGROVE_ARENA", 4, nil, icon, minimap, 1) -- TODO level id for default?

-- Mod Imports 
--modimport("scripts/plus_achievements.lua")
--modimport("scripts/RM_tuning.lua")
--modimport("scripts/RM_assets.lua")
--modimport("scripts/RM_prefabs.lua")
modimport("scripts/infernal_strings.lua")
--modimport("scripts/plus_forge_lords.lua")
local _G      = GLOBAL
local STRINGS = _G.STRINGS
local NAMES   = STRINGS.NAMES
STRINGS.REFORGED_MAPS = {
    ENEMIES      = {},
    MAPS         = {},
    MODS         = {},
    PETS         = {},
    WEAPONS      = {},
    ARMOR        = {},
    HELMS        = {},
    STRUCTURES   = {},
    WAVESETS     = {},
    DEBUFFS      = {},
    ACHIEVEMENTS = {},
}
local REFORGED_STRINGS = STRINGS.REFORGED--STRINGS.CIRCUS_FORGE

local function SetItemsDescribeStrings(item_name, strings)
	for character,str in pairs(strings) do
		STRINGS.CHARACTERS[string.upper(character)].DESCRIBE[string.upper(item_name)] = str
	end
end
REFORGED_STRINGS.MODS.REFORGED_MAPS = "Reforged Maps"

----------------------------------------
-- Maps
----------------------------------------
local MAPS = REFORGED_STRINGS.MAPS
MAPS.mangrove_arena = {
    name = "Dungeon Arena",
    desc = "Get spanked!"
}
----------------------------------------
-- Mobs
----------------------------------------
local ENEMIES = REFORGED_STRINGS.ENEMIES

STRINGS.NAMES.GEYSER_MANGROVE   = "Mangrove Geyser"
STRINGS.NAMES.SPIKES_MANGROVE   = "Mangrove Spike"

local RM_str_info = {}

table.insert(RM_str_info, {
    str_loc = REFORGED_STRINGS,
    name = "STRINGS.REFORGED", -- TODO a way to get this as a string from the table itself?
    titles = reforged_titles,
})
--_G.GenerateStringPotFileForTables("hf_strings", hf_str_info)

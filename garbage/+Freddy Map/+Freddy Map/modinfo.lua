-- This information tells other players more about the mod
name = "Infernal Forge Maps"
author = "freddy"
version = "0.0.0"
description = "Additional maps for Reforged."
-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = ""

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = ""..name..""
end

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

forge_compatible			= true
dst_compatible				= true
dont_starve_compatible		= false
reign_of_giants_compatible	= false
all_clients_require_mod		= true

icon_atlas  = "modicon.xml"
icon        = "modicon.tex"

--priority = -2147483646

server_filter_tags = {"reforged", "reforged maps", "+"}

local function AddCustomConfig(name, label, hover, options, default)
    return {name = name, label = label, hover = hover or "", options = options, default = default}
end

local function AddSectionTitle(title)
    return AddCustomConfig(title, title, "", {{description = "", data = 0}}, 0)
end

local light_options = {
	{description = "Default",      data = false},
	{description = "Random",       data = "random"},
	{description = "Pink",         data = {255/255,  94/255, 250/255, 1}},
    {description = "Red",          data = {216/255,  31/255,  66/255, 1}},
	{description = "Orange",       data = {255/255, 125/255,  25/255, 1}},
	{description = "Yellow",       data = {255/255, 255/255,  25/255, 1}},
	{description = "Yellow Green", data = {204/255, 255/255,  52/255, 1}},
	{description = "Green",        data = { 39/255, 240/255,  56/255, 1}},
	{description = "Teal",         data = { 13/255, 237/255, 202/255, 1}},
	{description = "Sky Blue",     data = { 52/255, 228/255, 255/255, 1}},
	{description = "Blue",         data = { 46/255, 142/255, 255/255, 1}},
}

local maps = {
    {description = "None", data = "none", hover = "Do not attempt to override the default waveset."},
}

local wave_sets = {
    {description = "None", data = "none", hover = "Do not attempt to override the default waveset."},
}

configuration_options = {
    AddSectionTitle("Gameplay Settings"),
    AddCustomConfig("MAP", "Map", "Change The Default Map", maps, "none"),
    AddCustomConfig("WAVESET", "Wave Set", "Change The Default Waveset", wave_sets, "none"),

	AddSectionTitle("Other Settings"),
    AddCustomConfig("light_color_override", "Arena Light Color", "Change The Default Light Color", light_options, false),
}

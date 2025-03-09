local _G = GLOBAL
local require = _G.require

if _G.TheNet:GetServerGameMode() ~= "lavaarena" then -- TODO need to make sure this checks for the reforged mod
	print("ERROR: Forge mod was disabled because of not correct GameMode")
	return
end
--------------------------
-- Load Server Settings --
--------------------------
local session_settings = _G.GetSessionSettings()
local function UpdateSetting(type, setting, val)
	if (type == "gameplay" and session_settings[setting] == nil or type ~= "gameplay") and val ~= "none" and val ~=  nil then
		_G.REFORGED_SETTINGS[type][setting] = val
	end
end
if _G.REFORGED_SETTINGS then
	UpdateSetting("gameplay", "map",     GetModConfigData("MAP"))
	UpdateSetting("gameplay", "waveset", GetModConfigData("WAVESET"))
end
-----------------
-- Load Assets --
-----------------
modimport("scripts/infernal_tuning.lua")
modimport("scripts/infernal_strings.lua")
PrefabFiles = require("infernal_prefabs")
Assets		= require("infernal_assets")
---------------
-- Load Util --
---------------
_G.COMMON_FNS.REFORGED_MAPS = require "_common_functions_reforged_maps"
--------------
-- Load Mod --
--------------
modimport("scripts/main.lua")

-----------------
-- Config Data --
-----------------
_G.LIGHT_COLOR_OVERRIDE = GetModConfigData("light_color_override")
if _G.LIGHT_COLOR_OVERRIDE == "random" then
	_G.LIGHT_COLOR_OVERRIDE = {math.random(), math.random(), math.random(), 1}
end


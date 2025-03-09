local _G = GLOBAL
if _G.rawget(_G, "REFORGED_GROUND_TYPES") then
    local Layouts       = _G.require("map/layouts").Layouts
    local StaticLayout  = _G.require("map/static_layout")

    ---------Mangrove Arena------------
    Layouts["C_Layout"]   = StaticLayout.Get("map/static_layouts/dungeon_arena", {
        start_mask        = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
        fill_mask         = _G.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
        layout_position   = _G.LAYOUT_POSITION.CENTER,
        disable_transform = true,
    })
    Layouts["C_Layout"].ground_types = _G.REFORGED_GROUND_TYPES,    
    _G.AddStartLocation("dungeon_arena", {
        name           = _G.STRINGS.UI.SANDBOXMENU.DEFAULTSTART,
        location       = "dungeon_arena",
        start_setpeice = "C_Layout",
        start_node     = "Blank",
    })
    _G.AddLocation({
        location = "dungeon_arena",
        version = 3,
        overrides = {
            task_set = "lavaarena_taskset",--"(TODO)_arena_taskset",
            start_location  = "C_Layout",
            season_start    = "default",
            world_size      = "small",
            layout_mode     = "RestrictNodesByKey",
            wormhole_prefab = nil,
            roads           = "never",
            keep_disconnected_tiles             = true,
            no_wormholes_to_disconnected_tiles  = true,
            no_joining_islands                  = true,
        },
        required_prefabs = {
            "lavaarena_portal",
        },
    })
    
    _G.AddWorldGenLevel(_G.LEVELTYPE.LAVAARENA, {
        id       = "DUNGEON_ARENA",
        name     = "Dungeon",
        desc     = "TODO",
        location = "dungeon_arena", -- this is actually the prefab name
        version  = 3,
        overrides = {
            boons          = "never",
            touchstone     = "never",
            traps          = "never",
            poi            = "never",
            protected      = "never",
            task_set       = "lavaarena_taskset",--"(TODO)_arena_taskset",
            start_location = "dungeon_arena",
            season_start   = "default",
            world_size     = "small",
            layout_mode    = "RestrictNodesByKey",
            keep_disconnected_tiles = true,
            wormhole_prefab = nil,
            roads           = "never",
            has_ocean = true,
        },
        required_prefabs = {
            "lavaarena_portal",
        },
        background_node_range = {0,1},
    })
    _G.AddSettingsPreset(LEVELTYPE.LAVAARENA, {
        id        = "DUNGEON_ARENA",
        name      = "Dungeon",
        desc      = "TODO",
        location  = "dungeon_arena", -- this is actually the prefab name
        version   = 3,
        overrides = {},
    })
end
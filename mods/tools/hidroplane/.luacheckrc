unused_args = false
allow_defined_top = true

globals = {
    "minetest",
    "mobkit",
    "core",
    "player_api",
    "player_monoids",
    "math.sign",
}

read_globals = {
    string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

    -- Builtin
    "vector", "ItemStack",
    "dump", "DIR_DELIM", "VoxelArea", "Settings",

    -- MTG
    "default", "sfinv", "creative",
}

ignore = {"611"}

local pass = function(soundtable)
    return soundtable
end

local sound_api = {
    node_sound_default         = pass,
    node_sound_stone_defaults  = pass,
    node_sound_dirt_defaults   = pass,
    node_sound_grass_defaults  = pass,
    node_sound_sand_defaults   = pass,
    node_sound_gravel_defaults = pass,
    node_sound_wood_defaults   = pass,
    node_sound_leaves_defaults = pass,
    node_sound_glass_defaults  = pass,
    node_sound_ice_defaults    = pass,
    node_sound_metal_defaults  = pass,
    node_sound_water_defaults  = pass,
    node_sound_lava_defaults   = pass,
    node_sound_snow_defaults   = pass,
    node_sound_wool_defaults   = pass,
}

return sound_api

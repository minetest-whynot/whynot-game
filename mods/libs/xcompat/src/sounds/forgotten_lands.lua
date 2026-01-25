local pass = function(soundtable)
    return soundtable
end

local sound_api = {
    node_sound_default         = sounds.stone,
    node_sound_stone_defaults  = sounds.stone,
    node_sound_dirt_defaults   = sounds.dirt,
    node_sound_grass_defaults  = sounds.grass,
    node_sound_sand_defaults   = sounds.sand,
    node_sound_gravel_defaults = sounds.gravel,
    node_sound_wood_defaults   = sounds.wood,
    node_sound_leaves_defaults = sounds.grass,
    node_sound_glass_defaults  = sounds.glass,
    node_sound_ice_defaults    = sounds.stone,
    node_sound_metal_defaults  = sounds.stone,
    node_sound_water_defaults  = pass,
    node_sound_lava_defaults   = pass,
    node_sound_snow_defaults   = sounds.dirt,
    node_sound_wool_defaults   = sounds.stone,
}

return sound_api

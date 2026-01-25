local pass = function(soundtable)
    return soundtable
end

local sound_api = {
    node_sound_default         = fl_stone.sounds.stone,
    node_sound_stone_defaults  = fl_stone.sounds.stone,
    node_sound_dirt_defaults   = fl_topsoil.sounds.grass,
    node_sound_grass_defaults  = fl_topsoil.sounds.grass,
    node_sound_sand_defaults   = fl_stone.sounds.sand,
    node_sound_gravel_defaults = fl_topsoil.sounds.gravel,
    node_sound_wood_defaults   = fl_trees.sounds.wood,
    node_sound_leaves_defaults = fl_topsoil.sounds.grass,
    node_sound_glass_defaults  = fl_stone.sounds.stone,
    node_sound_ice_defaults    = fl_stone.sounds.stone,
    node_sound_metal_defaults  = fl_stone.sounds.stone,
    node_sound_water_defaults  = pass,
    node_sound_lava_defaults   = pass,
    node_sound_snow_defaults   = fl_topsoil.sounds.snow,
    node_sound_wool_defaults   = fl_stone.sounds.stone,
}

return sound_api

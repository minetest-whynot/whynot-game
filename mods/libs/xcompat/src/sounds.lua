local sound_api = {}

--convert some games for api usage

--ks_sounds conversion
--currently loggy and bedrock are ignored
local ks = {}

function ks.node_sound_defaults(soundtable)
	soundtable = soundtable or {}
	soundtable.footstep = soundtable.footstep or ks_sounds.generalnode_sounds.footstep
	soundtable.dug = soundtable.dug or ks_sounds.generalnode_sounds.dug
    soundtable.dig = soundtable.dig or ks_sounds.generalnode_sounds.dig
	soundtable.place = soundtable.place or ks_sounds.generalnode_sounds.place
	return soundtable
end

function ks.node_sound_wood_defaults(soundtable)
	soundtable = soundtable or {}
	soundtable.footstep = soundtable.footstep or ks_sounds.woodennode_sounds.footstep
	soundtable.dug = soundtable.dug or ks_sounds.woodennode_sounds.dug
    soundtable.dig = soundtable.dig or ks_sounds.woodennode_sounds.dig
	soundtable.place = soundtable.place or ks_sounds.woodennode_sounds.place
	ks.node_sound_defaults(soundtable)
	return soundtable
end

function ks.node_sound_leaves_defaults(soundtable)
	soundtable = soundtable or {}
	soundtable.footstep = soundtable.footstep or ks_sounds.leafynode_sounds.footstep
	soundtable.dug = soundtable.dug or ks_sounds.leafynode_sounds.dug
    soundtable.dig = soundtable.dig or ks_sounds.leafynode_sounds.dig
	soundtable.place = soundtable.place or ks_sounds.leafynode_sounds.place
	ks.node_sound_defaults(soundtable)
	return soundtable
end

function ks.node_sound_snow_defaults(soundtable)
	soundtable = soundtable or {}
	soundtable.footstep = soundtable.footstep or ks_sounds.snowynode_sounds.footstep
	soundtable.dug = soundtable.dug or ks_sounds.snowynode_sounds.dug
    soundtable.dig = soundtable.dig or ks_sounds.snowynode_sounds.dig
	soundtable.place = soundtable.place or ks_sounds.snowynode_sounds.place
	ks.node_sound_defaults(soundtable)
	return soundtable
end


--api
function sound_api.node_sound_default(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_defaults(soundtable)
    elseif minetest.get_modpath("ks_sounds") then
        return ks.node_sound_default(soundtable)
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_default(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_defaults(soundtable)
    elseif minetest.get_modpath("rp_sounds") then
        return rp_sounds.node_sound_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_stone_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_stone_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_stone_defaults(soundtable)
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_stone_defaults(soundtable)
    elseif minetest.get_modpath("fl_stone") then
        return fl_stone.sounds.stone(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_stone_defaults(soundtable)
    elseif minetest.get_modpath("rp_sounds") then
        return rp_sounds.node_sound_stone_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_dirt_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_dirt_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_dirt_defaults(soundtable)
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_dirt_defaults(soundtable)
    --s/dirt/grass
    elseif minetest.get_modpath("fl_topsoil") then
        return fl_topsoil.sounds.grass(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_dirt_defaults(soundtable)
    elseif minetest.get_modpath("rp_sounds") then
        return rp_sounds.node_sound_dirt_defaults(soundtable)
    else
        return soundtable
    end
end

--return dirt as some games use dirt vs grass
function sound_api.node_sound_grass_defaults(soundtable)
    if minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_grass_defaults(soundtable)
    else
        return sound_api.node_sound_dirt_defaults(soundtable)
    end
end

function sound_api.node_sound_sand_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_sand_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_sand_defaults(soundtable)
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_sand_defaults(soundtable)
    elseif minetest.get_modpath("fl_stone") then
        return fl_stone.sounds.sand(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_sand_defaults(soundtable)
    elseif minetest.get_modpath("rp_sounds") then
        return rp_sounds.node_sound_sand_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_gravel_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_gravel_defaults(soundtable)
    --s/gravel/sand
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_sand_defaults(soundtable)
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_gravel_defaults(soundtable)
    elseif minetest.get_modpath("fl_topsoil") then
        return fl_topsoil.sounds.gravel(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_gravel_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_wood_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_wood_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_wood_defaults(soundtable)
    elseif minetest.get_modpath("ks_sounds") then
        return ks.node_sound_wood_default(soundtable)
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_wood_defaults(soundtable)
    elseif minetest.get_modpath("fl_trees") then
        return fl_trees.sounds.wood(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_wood_defaults(soundtable)
    elseif minetest.get_modpath("rp_sounds") then
        return rp_sounds.node_sound_wood_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_leaves_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_leaves_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_leaves_defaults(soundtable)
    elseif minetest.get_modpath("ks_sounds") then
        return ks.node_sound_leaves_default(soundtable)
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_leaves_defaults(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_leaves_defaults(soundtable)
    elseif minetest.get_modpath("rp_sounds") then
        return rp_sounds.node_sound_leaves_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_glass_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_glass_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_glass_defaults(soundtable)
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_glass_defaults(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_glass_defaults(soundtable)
    elseif minetest.get_modpath("rp_sounds") then
        return rp_sounds.node_sound_glass_defaults(soundtable)
    else
        return soundtable
    end
end


function sound_api.node_sound_ice_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_ice_defaults(soundtable)
    --s/ice/glass
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_glass_defaults(soundtable)
    --s/ice/glass
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_glass_defaults(soundtable)
    --s/ice/glass
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_glass_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_metal_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_metal_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_metal_defaults(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_metal_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_water_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_water_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_water_defaults(soundtable)
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_water_defaults(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_water_defaults(soundtable)
    elseif minetest.get_modpath("rp_sounds") then
        return rp_sounds.node_sound_water_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_lava_defaults(soundtable)
    --s/lava/water
    if minetest.get_modpath("default") then
        return default.node_sound_water_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_lava_defaults(soundtable)
    --s/lava/water
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_water_defaults(soundtable)
    elseif minetest.get_modpath("hades_sounds") then
        return hades_sounds.node_sound_lava_defaults(soundtable)
    --s/lava/water
    elseif minetest.get_modpath("rp_sounds") then
        return rp_sounds.node_sound_water_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_snow_defaults(soundtable)
    if minetest.get_modpath("default") then
        return default.node_sound_snow_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_snow_defaults(soundtable)
    elseif minetest.get_modpath("ks_sounds") then
        return ks.node_sound_snow_default(soundtable)
    elseif minetest.get_modpath("nodes_nature") then
        return nodes_nature.node_sound_snow_defaults(soundtable)
    elseif minetest.get_modpath("fl_topsoil") then
        return fl_topsoil.sounds.snow(soundtable)
    elseif minetest.get_modpath("rp_sounds") then
        return rp_sounds.node_sound_snow_defaults(soundtable)
    else
        return soundtable
    end
end

function sound_api.node_sound_wool_defaults(soundtable)
    --s/wool/default
    if minetest.get_modpath("default") then
        return default.node_sound_defaults(soundtable)
    elseif minetest.get_modpath("mcl_sounds") then
        return mcl_sounds.node_sound_wool_defaults(soundtable)
    else
        return soundtable
    end
end

return sound_api
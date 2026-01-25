-- ks_sounds conversion
-- currently loggy and bedrock are ignored
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

local pass = function(soundtable)
    return soundtable
end

local sound_api = {
    node_sound_default         = ks.node_sound_default,
    node_sound_stone_defaults  = ks.node_sound_default,
    node_sound_dirt_defaults   = ks.node_sound_default,
    node_sound_grass_defaults  = ks.node_sound_leaves_defaults,
    node_sound_sand_defaults   = ks.node_sound_default,
    node_sound_gravel_defaults = ks.node_sound_default,
    node_sound_wood_defaults   = ks.node_sound_wood_defaults,
    node_sound_leaves_defaults = ks.node_sound_leaves_defaults,
    node_sound_glass_defaults  = ks.node_sound_default,
    node_sound_ice_defaults    = ks.node_sound_default,
    node_sound_metal_defaults  = ks.node_sound_default,
    node_sound_water_defaults  = pass,
    node_sound_lava_defaults   = pass,
    node_sound_snow_defaults   = ks.node_sound_snow_defaults,
    node_sound_wool_defaults   = ks.node_sound_default,
}

return sound_api

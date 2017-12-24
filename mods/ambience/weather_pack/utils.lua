---------------------------------------
-- Happy Weather: Utilities / Helpers

-- License: MIT

-- Credits: xeranas
---------------------------------------

if not minetest.global_exists("hw_utils") then
	hw_utils = {}
end

local mg_name = minetest.get_mapgen_setting("mg_name")

-- outdoor check based on node light level
hw_utils.is_outdoor = function(pos, offset_y)
	if offset_y == nil then
		offset_y = 0
	end

	if minetest.get_node_light({x=pos.x, y=pos.y + offset_y, z=pos.z}, 0.5) == 15 then
		return true
	end
	return false
end

-- checks if player is undewater. This is needed in order to
-- turn off weather particles generation.
hw_utils.is_underwater = function(player)
	local ppos = player:getpos()
	local offset = player:get_eye_offset()
	local player_eye_pos = {
		x = ppos.x + offset.x, 
		y = ppos.y + offset.y + 1.5, 
		z = ppos.z + offset.z}
	local node_level = minetest.get_node_level(player_eye_pos)
	if node_level == 8 or node_level == 7 then
		return true
	end
	return false
end

-- trying to locate position for particles by player look direction for performance reason.
-- it is costly to generate many particles around player so goal is focus mainly on front view.  
hw_utils.get_random_pos = function(player, offset)
	local look_dir = player:get_look_dir()
	local player_pos = player:getpos()

	local random_pos_x = 0
	local random_pos_y = 0
	local random_pos_z = 0

	if look_dir.x > 0 then
		if look_dir.z > 0 then
			random_pos_x = math.random(player_pos.x - offset.back, player_pos.x + offset.front) + math.random()
			random_pos_z = math.random(player_pos.z - offset.back, player_pos.z + offset.front) + math.random() 
		else
			random_pos_x = math.random(player_pos.x - offset.back, player_pos.x + offset.front) + math.random()
			random_pos_z = math.random(player_pos.z - offset.front, player_pos.z + offset.back) + math.random()
		end
	else
		if look_dir.z > 0 then
			random_pos_x = math.random(player_pos.x - offset.front, player_pos.x + offset.back) + math.random()
			random_pos_z = math.random(player_pos.z - offset.back, player_pos.z + offset.front) + math.random()
		else
			random_pos_x = math.random(player_pos.x - offset.front, player_pos.x + offset.back) + math.random()
			random_pos_z = math.random(player_pos.z - offset.front, player_pos.z + offset.back) + math.random()
		end
	end

	if offset.bottom ~= nil then
		random_pos_y = math.random(player_pos.y - offset.bottom, player_pos.y + offset.top)
	else
		random_pos_y = player_pos.y + offset.top
	end

	return {x=random_pos_x, y=random_pos_y, z=random_pos_z}
end

local np_temp = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 5349,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0
}

local np_humid = {
	offset = 50,
	scale = 50,
	spread = {x = 1000, y = 1000, z = 1000},
	seed = 842,
	octaves = 3,
	persist = 0.5,
	lacunarity = 2.0
}

local np_biome_v6 = {
	offset = 0, 
	scale = 1.0,
	spread = {x = 500.0, y = 500.0, z = 500.0},
	seed = 9130,
	octaves = 3,
	persist = 0.50,
	lacunarity = 2.0
}

local np_humidity_v6 = {
	offset = 0.5,
	scale = 0.5,
	spread = {x = 500.0, y = 500.0, z = 500.0},
	seed = 72384,
	octaves = 4,
	persist = 0.66,
	lacunarity = 2.0
}

local is_biome_frozen = function(position)
	local posx = math.floor(position.x)
	local posz = math.floor(position.z)
	local noise_obj = minetest.get_perlin(np_temp)
	local noise_temp = noise_obj:get2d({x = posx, y = posz})

	-- below 35 heat biome considered to be frozen type
	return noise_temp < 35
end

hw_utils.is_biome_frozen = function(position)
	if mg_name == "v6" then
		return false -- v6 not supported yet.
	end
	return is_biome_frozen(position)
end

local is_biome_dry_v6 = function(position)
	local posx = math.floor(position.x)
	local posz = math.floor(position.z)
	local noise_obj = minetest.get_perlin(np_biome_v6)
	local noise_biome = noise_obj:get2d({x = posx, y = posz})
	-- TODO futher investigation needed towards on biome check for v6 mapgen
	return noise_biome > 0.45
end

local is_biome_dry = function(position)
	local posx = math.floor(position.x)
	local posz = math.floor(position.z)
	local noise_obj = minetest.get_perlin(np_humid)
	local noise_humid = noise_obj:get2d({x = posx, y = posz})

	-- below 50 humid biome considered to be dry type (at least by this mod)
	return noise_humid < 50
end

hw_utils.is_biome_dry = function(position)
	if mg_name == "v6" then
		return false
	end
	return is_biome_dry(position)
end

local is_biome_tropic = function(position)
	local posx = math.floor(position.x)
	local posz = math.floor(position.z)
	local noise_obj = minetest.get_perlin(np_humid)
	local noise_humid = noise_obj:get2d({x = posx, y = posz})
	noise_obj = minetest.get_perlin(np_temp)
	local noise_temp = noise_obj:get2d({x = posx, y = posz})

	-- humid and temp values are taked by testing flying around world (not sure actually)
	return noise_humid > 55 and noise_temp > 80
end

hw_utils.is_biome_tropic = function(position)
	if mg_name == "v6" then
		return false -- v6 not supported yet.
	end
	return is_biome_tropic(position)
end

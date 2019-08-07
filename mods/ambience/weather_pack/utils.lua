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

local is_biome_frozen = function(position)
	if legacy_MT_version then
		return false;
	end
	local heat = minetest.get_heat(position)
	-- below 35 heat biome considered to be frozen type
	return heat < 35
end

hw_utils.is_biome_frozen = function(position)
	if mg_name == "v6" then
		return false -- v6 not supported.
	end
	return is_biome_frozen(position)
end

local is_biome_dry = function(position)
	if legacy_MT_version then
		return false;
	end
	local humidity = minetest.get_humidity(position)
	local heat = minetest.get_heat(position)
	return humidity < 50 and heat > 65
end

hw_utils.is_biome_dry = function(position)
	if mg_name == "v6" then
		return false
	end
	return is_biome_dry(position)
end

local is_biome_tropic = function(position)
	if legacy_MT_version then
		return false;
	end
	local humidity = minetest.get_humidity(position)
	local heat = minetest.get_heat(position)

	-- humid and temp values are taked by testing flying around world (not sure actually)
	return humidity > 55 and heat > 70
end

hw_utils.is_biome_tropic = function(position)
	if mg_name == "v6" then
		return false -- v6 not supported yet.
	end
	return is_biome_tropic(position)
end

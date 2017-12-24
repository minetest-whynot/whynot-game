-------------------------
-- Sky Layers: API

-- License: MIT
-- Credits: xeranas
-------------------------

skylayer = {}

-- flag for enable / disable skylayer temporally if needed
skylayer.enabled = true

-- supported skylayer types
skylayer.SKY_PLAIN = "plain"
skylayer.SKY_SOLID_COLOR = "solid_color"
skylayer.SKY_SKYBOX = "skybox"

-- helps track total dtime
local timer = 0

local gradient_default_min_value = 0
local gradient_default_max_value = 1000

-- how often sky will be updated in seconds
skylayer.update_interval = 4

-- keeps player related data such as player itself and own sky layers
local sky_players = {}

-- adds player to sky layer affected players list
local add_player = function(player)
	local data = {}
	data.id = player:get_player_name()
	data.player = player
	data.skylayers = {}
	table.insert(sky_players, data)
end

-- remove player from sky layer affected players list
local remove_player = function(player_name)
	if #sky_players == 0 then
		return
	end

	for k, player_data in ipairs(sky_players) do
		if player_data.id == player_name then
			set_default_sky(player_data.player)
			table.remove(sky_players, k)
			return
		end
	end
end

local get_player_by_name = function(player_name)
	if player_name == nil then
		return nil
	end

	if #minetest.get_connected_players() == 0 then
		return nil
	end

	for i, player in ipairs(minetest.get_connected_players()) do
		if player:get_player_name() == player_name then
			return player
		end
	end

	return nil
end

local get_player_data = function(player_name)
	if #sky_players == 0 then
		return nil
	end

	for k, player_data in ipairs(sky_players) do
		if player_data.id == player_name then
			return player_data
		end
	end	
end

local create_new_player_data = function(player_name)
	local player_data = get_player_data(player_name)
	if player_data == nil then
		local player = get_player_by_name(player_name)
		if player == nil then
			minetest.log("error", "Fail to resolve player '" .. player_name .. "'")
			return
		end
		add_player(player)
		return get_player_data(player_name)
	end
	return player_data
end

-- sets default / regular sky for player
local set_default_sky = function(player)
	player:set_sky(nil, "regular", nil)
end

-- resolves latest skylayer based on added layer time
local get_latest_layer = function(layers)
	if #layers == 0 then
		return nil
	end

	local latest_layer = nil
	for k, layer in ipairs(layers) do
		if latest_layer == nil then
			latest_layer = layer
		else
			if layer.added_time >= latest_layer.added_time then
				latest_layer = layer
			end
		end
	end

	return latest_layer
end

local convert_to_rgb = function(minval, maxval, current_val, colors)
	local max_index = #colors - 1
	local val = (current_val-minval) / (maxval-minval) * max_index + 1.0
	local index1 = math.floor(val)
	local index2 = math.min(math.floor(val)+1, max_index + 1)
	local f = val - index1
	local c1 = colors[index1]
	local c2 = colors[index2]
	
	return {
		r=math.floor(c1.r + f*(c2.r - c1.r)), 
		g=math.floor(c1.g + f*(c2.g-c1.g)), 
		b=math.floor(c1.b + f*(c2.b - c1.b))
	}
end

-- Returns current layer color in {r, g, b} format
local get_current_layer_color = function(layer_data)
	-- min timeofday value 0; max timeofday value 1. So sky color gradient range will be between 0 and 1 * skycolor.max_value.
	local timeofday = minetest.get_timeofday()
	local min_val = layer_data.gradient_data.min_value
	if min_val == nil then
		min_val = gradient_default_min_value
	end
	local max_val = layer_data.gradient_data.max_value
	if max_val == nil then
		max_val = gradient_default_max_value
	end
	local rounded_time = math.floor(timeofday * max_val)
	local gradient_colors = layer_data.gradient_data.colors
	local color = convert_to_rgb(min_val, max_val, rounded_time, gradient_colors)
	return color
end

local update_plain_sky = function(player, layer_data)
	local color = get_current_layer_color(layer_data)
	player:set_sky(color, "plain", nil, false)
end

local update_solid_color_sky = function(player, layer_data)
	player:set_sky(layer_data.color, "plain", nil, false)
end

local update_skybox_sky = function(player, layer_data)
	player:set_sky(layer_data.skybox[1], layer_data.skybox[2], layer_data.skybox[3])
end

local update_sky = function(player, timer)
	local player_data = get_player_data(player:get_player_name())
	if player_data == nil then return end

	local current_layer = get_latest_layer(player_data.skylayers)
	if current_layer == nil then
		return
	end

	if current_layer.updated == false or timer >= skylayer.update_interval then
		current_layer.updated = os.time()
		
		if current_layer.layer_type == skylayer.SKY_PLAIN then
			update_plain_sky(player, current_layer.data)
			return
		end

		if current_layer.layer_type == skylayer.SKY_SOLID_COLOR then
			update_solid_color_sky(player, current_layer.data)
			return
		end

		if current_layer.layer_type == skylayer.SKY_SKYBOX then
			update_skybox_sky(player, current_layer.data)
			return
		end
	end
end

skylayer.add_layer = function(player_name, layer)
	if layer == nil or layer.name == nil then
		minetest.log("error", "Incorrect skylayer definition")
		return
	end

	local player_data = get_player_data(player_name)
	if player_data == nil then
		player_data = create_new_player_data(player_name)
	end

	if player_data == nil then
		minetest.log("error", "Fail to add skylayer to player '" .. player_name .. "'")
		return
	end
	layer.added_time = os.time()
	layer.updated = false
	table.insert(player_data.skylayers, layer)
end

skylayer.remove_layer = function(player_name, layer_name)
	local player_data = get_player_data(player_name)
	if player_data == nil or player_data.skylayers == nil then
		return
	end

	if #player_data.skylayers == 0 then
		return
	end

	for k, layer in ipairs(player_data.skylayers) do
		if layer.name == layer_name then
			table.remove(player_data.skylayers, k)
			if #player_data.skylayers == 0 then
				local player = get_player_by_name(player_name)
				if player ~= nil then
					set_default_sky(player)
				end
			end
			return
		end
	end

end

minetest.register_globalstep(function(dtime)
	if skylayer.enabled == false then
		return
	end

	if #minetest.get_connected_players() == 0 then
		return
	end

	-- timer addition calculated outside of players loop 
	timer = timer + dtime;

	for k, player in ipairs(minetest.get_connected_players()) do
		update_sky(player, timer)
	end

	-- reset timer outside of loop to make sure that all players sky will be updated
	if timer >= skylayer.update_interval then
		timer = 0
	end
end)


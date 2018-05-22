

-------------------------
-- Sky Layers: Core

-- License: MIT
-- Credits: xeranas
-- Thanks: Perkovec for colorise utils (github.com/Perkovec/colorise-lua) 
-------------------------

local colorise = {}

colorise.rgb2hex = function (rgb)
	local hexadecimal = '#'

	for key = 1, #rgb do
	    local value = rgb[key] 
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'
		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end
		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end

local core = {}

core.settings = {}

-- flag to disable skylayer at global step
core.settings.enabled = true

-- default gradient interval values
core.settings.gradient_default_min_value = 0
core.settings.gradient_default_max_value = 1000

-- how often sky will be updated in seconds
core.settings.update_interval = 4

-- helps track total dtime
core.timer = 0

core.default_clouds = nil

-- keeps player related data such as player itself and own sky layers
core.sky_players = {}

-- adds player to sky layer affected players list
core.add_player = function(player)
	local data = {}
	data.id = player:get_player_name()
	data.player = player
	data.skylayers = {}
	table.insert(core.sky_players, data)
end

-- remove player from sky layer affected players list
core.remove_player = function(player_name)
	if #core.sky_players == 0 then
		return
	end
	for k, player_data in ipairs(core.sky_players) do
		if player_data.id == player_name then
			reset_sky(player_data.player)
			table.remove(core.sky_players, k)
			return
		end
	end
end

core.get_player_by_name = function(player_name)
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

core.get_player_data = function(player_name)
	if #core.sky_players == 0 then
		return nil
	end
	for k, player_data in ipairs(core.sky_players) do
		if player_data.id == player_name then
			return player_data
		end
	end	
end

core.create_new_player_data = function(player_name)
	local player_data = core.get_player_data(player_name)
	if player_data == nil then
		local player = core.get_player_by_name(player_name)
		if player == nil then
			minetest.log("error", "Fail to resolve player '" .. player_name .. "'")
			return
		end
		core.add_player(player)
		return core.get_player_data(player_name)
	end
	return player_data
end

-- sets default / regular sky for player
core.reset_sky = function(player)
	core.set_default_sky(player)
	core.set_default_clouds(player)
end

core.set_default_sky = function(player)
	player:set_sky(nil, "regular", nil)
end

core.set_default_clouds = function(player)
	player:set_clouds(core.default_clouds)
end

-- resolves latest skylayer based on added layer time
core.get_latest_layer = function(layers)
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

core.convert_to_rgb = function(minval, maxval, current_val, colors)
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

-- Returns current gradient color in {r, g, b} format
core.calculate_current_gradient_color = function(gradient_colors, min_val, max_val)
	if gradient_colors == nil then return nil end
	local timeofday = minetest.get_timeofday()
	if min_val == nil then
		min_val = core.settings.gradient_default_min_value
	end
	if max_val == nil then
		max_val = core.settings.gradient_default_max_value
	end
	local rounded_time = math.floor(timeofday * max_val)
	return core.convert_to_rgb(min_val, max_val, rounded_time, gradient_colors)
end

-- Returns current sky color in {r, g, b} format
core.get_current_layer_color = function(gradient_colors, min_val, max_val)
	return core.calculate_current_gradient_color(gradient_colors, min_val, max_val)
end

-- Returns current cloud color in hex format
core.get_current_cloud_color = function(gradient_colors, min_val, max_val)
	local rgb_color = core.calculate_current_gradient_color(gradient_colors, min_val, max_val)
	if rgb_color == nil then return nil end
	return colorise.rgb2hex({rgb_color.r, rgb_color.g, rgb_color.b}) 
end

core.update_sky_details = function(player, sky_layer)
	local sky_data = sky_layer.sky_data

	if sky_data == nil then 
		if sky_layer.reset_defaults == true then
			core.set_default_sky(player)
			sky_layer.reset_defaults = false
		end
		return
	end

	local sky_color = core.get_current_layer_color(
		sky_data.gradient_colors, 
		sky_data.gradient_min_value,
		sky_data.gradient_max_value)
	local bgcolor = sky_data.bgcolor
	if sky_color ~= nil then
		bgcolor = sky_color
	end
	local sky_type = "plain" -- default
	if sky_data.type ~= nil then
		sky_type = sky_data.type
	end
	local clouds = sky_layer.clouds_data ~= nil
	if sky_data.clouds ~= nil then
		clouds = sky_data.clouds
	end
	player:set_sky(bgcolor, sky_type, sky_data.textures, clouds)	
end

core.update_clouds_details = function(player, sky_layer)
	local clouds_data = sky_layer.clouds_data

	if clouds_data == nil then 
		if sky_layer.reset_defaults == true then
			core.set_default_clouds(player)
			sky_layer.reset_defaults = false
		end
		return
	end

	local cloud_color = core.get_current_cloud_color(
		clouds_data.gradient_colors, 
		clouds_data.gradient_min_value,
		clouds_data.gradient_max_value)
	if cloud_color == nil then
		cloud_color = clouds_data.color
	end
	player:set_clouds({
		color = cloud_color,
		density = clouds_data.density,
		ambient = clouds_data.ambient,
		height = clouds_data.height,
		thickness = clouds_data.thickness,
		speed = clouds_data.speed})
end

core.update_sky = function(player, timer)
	local player_data = core.get_player_data(player:get_player_name())
	if player_data == nil then return end

	local current_layer = core.get_latest_layer(player_data.skylayers)
	if current_layer == nil then
		return
	end

	if skylayer.update_interval == nil then
		skylayer.update_interval = core.settings.update_interval
	end

	if player_data.last_active_layer == nil or player_data.last_active_layer ~= current_layer.name then
		current_layer.reset_defaults = true
	end
	player_data.last_active_layer = current_layer.name

	if current_layer.updated == false or core.timer >= skylayer.update_interval then
		current_layer.updated = os.time()
		core.update_sky_details(player, current_layer)
		core.update_clouds_details(player, current_layer)
	end
end

minetest.register_on_joinplayer(function(player)
	if core.default_clouds == nil then
		core.default_clouds = player:get_clouds()
	end
end)

minetest.register_globalstep(function(dtime)
	if core.settings.enabled == false then
		return
	end

	if #minetest.get_connected_players() == 0 then
		return
	end

	-- timer addition calculated outside of players loop 
	core.timer = core.timer + dtime;

	for k, player in ipairs(minetest.get_connected_players()) do
		core.update_sky(player, core.timer)
	end

	-- reset timer outside of loop to make sure that all players sky will be updated
	if core.timer >= core.settings.update_interval then
		core.timer = 0
	end
end)

-------------------------
-- Sky Layers: API

-- License: MIT
-- Credits: xeranas
-------------------------

skylayer = {}

-- set flag for enable / disable skylayer
skylayer.is_enabled = function(enabled)
	core.settings.enabled = enabled
end

skylayer.add_layer = function(player_name, layer)
	if layer == nil or layer.name == nil then
		minetest.log("error", "Incorrect skylayer definition")
		return
	end

	local player_data = core.get_player_data(player_name)
	if player_data == nil then
		player_data = core.create_new_player_data(player_name)
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
	local player_data = core.get_player_data(player_name)
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
				local player = core.get_player_by_name(player_name)
				if player ~= nil then
					core.reset_sky(player)
				end
			end
			return
		end
	end
end

------------------------------
-- Happy Weather: Heavy Rain

-- License: MIT

-- Credits: xeranas
------------------------------

local heavy_rain = {}
heavy_rain.last_check = 0
heavy_rain.check_interval = 200

-- Weather identification code
heavy_rain.code = "heavy_rain"

-- Keeps sound handler references
local sound_handlers = {}

-- Manual triggers flags
local manual_trigger_start = false
local manual_trigger_end = false

-- Skycolor layer id
local SKYCOLOR_LAYER = "happy_weather_heavy_rain_sky"

heavy_rain.is_starting = function(dtime, position)
	if heavy_rain.last_check + heavy_rain.check_interval < os.time() then
		heavy_rain.last_check = os.time()
		local heavy_rain_chance = 0.06
		if hw_utils.is_biome_tropic(position) then
			heavy_rain_chance = 0.4
		end

		if math.random() < heavy_rain_chance then
			happy_weather.request_to_end("light_rain")
      		happy_weather.request_to_end("rain")
			return true
		end
	end

	if manual_trigger_start then
		manual_trigger_start = false
		return true
	end
	
	return false
end

heavy_rain.is_ending = function(dtime)
	if heavy_rain.last_check + heavy_rain.check_interval < os.time() then
		heavy_rain.last_check = os.time()
		if math.random() < 0.7 then
			if math.random() < 0.4 then
				happy_weather.request_to_start("rain")
			end
			return true
		end
	end

	if manual_trigger_end then
		manual_trigger_end = false
		return true
	end

	return false
end

local set_sky_box = function(player_name)
	local sl = {}
	sl.name = SKYCOLOR_LAYER
	sl.sky_data = {
		gradient_colors = {
			{r=0, g=0, b=0},
			{r=85, g=86, b=98},
			{r=142, g=140, b=149},
			{r=85, g=86, b=98},
			{r=0, g=0, b=0}
		},
	}
	sl.clouds_data = {
		gradient_colors = {
			{r=0, g=0, b=0},
			{r=65, g=66, b=78},
			{r=112, g=110, b=119},
			{r=65, g=66, b=78},
			{r=0, g=0, b=0}
		},
		speed = {z = 10, y = -40},
		density = 0.6
	}
	skylayer.add_layer(player_name, sl)
end

local set_rain_sound = function(player) 
	return minetest.sound_play("heavy_rain_drop", {
		object = player,
		max_hear_distance = 2,
		loop = true,
	})
end

local remove_rain_sound = function(player)
	local sound = sound_handlers[player:get_player_name()]
	if sound ~= nil then
		minetest.sound_stop(sound)
		sound_handlers[player:get_player_name()] = nil
	end
end

heavy_rain.add_player = function(player)
	sound_handlers[player:get_player_name()] = set_rain_sound(player)
	set_sky_box(player:get_player_name())
end

heavy_rain.remove_player = function(player)
	remove_rain_sound(player)
	skylayer.remove_layer(player:get_player_name(), SKYCOLOR_LAYER)
end

local rain_drop_texture = "happy_weather_heavy_rain_drops.png"

local add_close_range_rain_particle = function(player)
	local offset = {
		front = 1,
		back = 0,
		top = 6
	}

	local random_pos = hw_utils.get_random_pos(player, offset)
	local rain_texture_size_offset_y = -1

	if hw_utils.is_outdoor(random_pos, rain_texture_size_offset_y) then
		minetest.add_particle({
		  pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
		  velocity = {x=0, y=-10, z=0},
		  acceleration = {x=0, y=-10, z=0},
		  expirationtime = 5,
		  size = 30,
		  collisiondetection = true,
		  collision_removal = true,
		  vertical = true,
		  texture = rain_drop_texture,
		  playername = player:get_player_name()
		})
	end
end

local add_wide_range_rain_particle = function(player)
	local offset = {
		front = 10,
		back = 5,
		top = 8
	}

	local random_pos = hw_utils.get_random_pos(player, offset)

	if hw_utils.is_outdoor(random_pos) then
		minetest.add_particle({
		  pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
		  velocity = {x=0, y=-10, z=0},
		  acceleration = {x=0, y=-15, z=0},
		  expirationtime = 5,
		  size = 30,
		  collisiondetection = true,
		  collision_removal = true,
		  vertical = true,
		  
		  texture = rain_drop_texture,
		  playername = player:get_player_name()
		})
	end
end

local display_rain_particles = function(player)
	if hw_utils.is_underwater(player) then
		return
	end

	add_close_range_rain_particle(player)
  
	local particles_number_per_update = 5
	for i=particles_number_per_update, 1,-1 do
		add_wide_range_rain_particle(player)
	end
end

heavy_rain.render = function(dtime, player)
	display_rain_particles(player)
end

heavy_rain.start = function()
	manual_trigger_start = true
end

heavy_rain.stop = function()
	manual_trigger_end = true
end

heavy_rain.in_area = function(position)
	if hw_utils.is_biome_frozen(position) or 
		hw_utils.is_biome_dry(position) then
		return false
	end

	if position.y > -10 and position.y < 120 then
		return true
	end
	return false
end

happy_weather.register_weather(heavy_rain)

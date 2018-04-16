------------------------------ 
-- Happy Weather: Rain

-- License: MIT

-- Credits: xeranas
------------------------------

local rain = {}
rain.last_check = 0
rain.check_interval = 300
rain.chance = 0.1

-- Weather identification code
rain.code = "rain"

-- Keeps sound handler references 
local sound_handlers = {}

-- Manual triggers flags
local manual_trigger_start = false
local manual_trigger_end = false

-- Skycolor layer id
local SKYCOLOR_LAYER = "happy_weather_rain_sky"

rain.is_starting = function(dtime, position)
	if rain.last_check + rain.check_interval < os.time() then
		rain.last_check = os.time()
		if math.random() < rain.chance then
			happy_weather.request_to_end("light_rain")
			happy_weather.request_to_end("heavy_rain")
			return true
		end
	end

	if manual_trigger_start then
		manual_trigger_start = false
		return true
	end

	return false
end

rain.is_ending = function(dtime)
	if rain.last_check + rain.check_interval < os.time() then
		rain.last_check = os.time()
		if math.random() < 0.6 then
			happy_weather.request_to_start("light_rain")
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
	sl.layer_type = skylayer.SKY_PLAIN
	sl.name = SKYCOLOR_LAYER
	sl.sky_data = {
		gradient_colors = {
			{r=0, g=0, b=0},
			{r=65, g=66, b=78},
			{r=112, g=110, b=119},
			{r=65, g=66, b=78},
			{r=0, g=0, b=0}
		},
	}
	sl.clouds_data = {
		gradient_colors = {
			{r=10, g=10, b=10},
			{r=55, g=56, b=68},
			{r=102, g=100, b=109},
			{r=55, g=56, b=68},
			{r=10, g=10, b=10}
		},
		density = 0.5
	}
	skylayer.add_layer(player_name, sl)
end

local set_rain_sound = function(player) 
	return minetest.sound_play("rain_drop", {
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

rain.add_player = function(player)
	sound_handlers[player:get_player_name()] = set_rain_sound(player)
	set_sky_box(player:get_player_name())
end

rain.remove_player = function(player)
	remove_rain_sound(player)
	skylayer.remove_layer(player:get_player_name(), SKYCOLOR_LAYER)
end

-- Random texture getter
local choice_random_rain_drop_texture = function()
	local base_name = "happy_weather_light_rain_raindrop_"
	local number = math.random(1, 4)
	local extension = ".png"
	return base_name .. number .. extension
end

local add_rain_particle = function(player)
	local offset = {
		front = 5,
		back = 2,
		top = 6
	}

	local random_pos = hw_utils.get_random_pos(player, offset)

	if hw_utils.is_outdoor(random_pos) then
		minetest.add_particle({
			pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
			velocity = {x=0, y=-15, z=0},
			acceleration = {x=0, y=-35, z=0},
			expirationtime = 2,
			size = math.random(1, 4),
			collisiondetection = true,
			collision_removal = true,
			vertical = true,
			texture = choice_random_rain_drop_texture(),
			playername = player:get_player_name()
		})
	end
end

local display_rain_particles = function(player)
	if hw_utils.is_underwater(player) then
		return
	end

	add_rain_particle(player)
end

rain.in_area = function(position)
	if hw_utils.is_biome_frozen(position) or 
		hw_utils.is_biome_dry(position) then
		return false
	end

	if position.y > -10 and position.y < 120 then
		return true
	end
	return false
end

local particles_number_per_update = 10
rain.render = function(dtime, player)

	for i=particles_number_per_update, 1,-1 do
		display_rain_particles(player)
	end
end

rain.start = function()
	manual_trigger_start = true
end

rain.stop = function()
	manual_trigger_end = true
end

happy_weather.register_weather(rain)
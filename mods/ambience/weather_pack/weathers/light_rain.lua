------------------------------ 
-- Happy Weather: Light Rain

-- License: MIT

-- Credits: xeranas
------------------------------

local light_rain = {}
light_rain.last_check = 0
light_rain.check_interval = 200
light_rain.chance = 0.15

-- Weather identification code
light_rain.code = "light_rain"

-- Keeps sound handler references 
local sound_handlers = {}

-- Manual triggers flags
local manual_trigger_start = false
local manual_trigger_end = false

-- Skycolor layer id
local SKYCOLOR_LAYER = "happy_weather_light_rain_sky"

light_rain.is_starting = function(dtime, position)
	if light_rain.last_check + light_rain.check_interval < os.time() then
		light_rain.last_check = os.time()
		if math.random() < light_rain.chance then
			return true
		end
	end

	if manual_trigger_start then
		manual_trigger_start = false
		return true
	end

	return false
end

light_rain.is_ending = function(dtime)
	if light_rain.last_check + light_rain.check_interval < os.time() then
		light_rain.last_check = os.time()
		if math.random() < 0.5 then
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
	sl.clouds_data = {
		gradient_colors = {
			{r=50, g=50, b=50},
			{r=120, g=120, b=120},
			{r=200, g=200, b=200},
			{r=120, g=120, b=120},
			{r=50, g=50, b=50}
		},
		density = 0.6
	}
	skylayer.add_layer(player_name, sl)
end

local set_rain_sound = function(player) 
	return minetest.sound_play("light_rain_drop", {
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

light_rain.add_player = function(player)
	sound_handlers[player:get_player_name()] = set_rain_sound(player)
	set_sky_box(player:get_player_name())
end

light_rain.remove_player = function(player)
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
		top = 4
	}

	local random_pos = hw_utils.get_random_pos(player, offset)

	if hw_utils.is_outdoor(random_pos) then
		minetest.add_particle({
			pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
			velocity = {x=0, y=-10, z=0},
			acceleration = {x=0, y=-30, z=0},
			expirationtime = 2,
			size = math.random(0.5, 3),
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

light_rain.in_area = function(position)
	if hw_utils.is_biome_frozen(position) or 
		hw_utils.is_biome_dry(position) then
		return false
	end

	if position.y > -10 and position.y < 120 then
		return true
	end
	return false
end

light_rain.render = function(dtime, player)
	display_rain_particles(player)
end

light_rain.start = function()
	manual_trigger_start = true
end

light_rain.stop = function()
	manual_trigger_end = true
end

happy_weather.register_weather(light_rain)
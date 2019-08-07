----------------------------
-- Happy Weather: Snowfall

-- License: MIT

-- Credits: xeranas
----------------------------

local snowstorm = {}

-- Weather identification code
snowstorm.code = "snowstorm"
snowstorm.last_check = 0
snowstorm.check_interval = 300
snowstorm.chance = 0.05

-- Keeps sound handler references
local sound_handlers = {}

-- Manual triggers flags
local manual_trigger_start = false
local manual_trigger_end = false

-- Skycolor layer id
local SKYCOLOR_LAYER = "happy_weather_snowstorm_sky"

local set_weather_sound = function(player) 
	return minetest.sound_play("happy_weather_snowstorm", {
		object = player,
		max_hear_distance = 2,
		loop = true,
	})
end

local remove_weather_sound = function(player)
	local sound = sound_handlers[player:get_player_name()]
	if sound ~= nil then
		minetest.sound_stop(sound)
		sound_handlers[player:get_player_name()] = nil
	end
end

snowstorm.is_starting = function(dtime, position)
	if snowstorm.last_check + snowstorm.check_interval < os.time() then
		snowstorm.last_check = os.time()
		if math.random() < snowstorm.chance then
			return true
		end
	end

	if manual_trigger_start then
		manual_trigger_start = false
		return true
	end
	
	return false
end

snowstorm.is_ending = function(dtime)
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
			{r=231, g=234, b=239},
			{r=0, g=0, b=0}
		}
	}
	skylayer.add_layer(player_name, sl)
end

snowstorm.in_area = function(position)
	if hw_utils.is_biome_frozen(position) == false then
		return false
	end

	if position.y > 30 and position.y < 140 then
		return true
	end
	return false
end

snowstorm.add_player = function(player)
	sound_handlers[player:get_player_name()] = set_weather_sound(player)
	set_sky_box(player:get_player_name())
end

snowstorm.remove_player = function(player)
	remove_weather_sound(player)
	skylayer.remove_layer(player:get_player_name(), SKYCOLOR_LAYER)
end

local rain_drop_texture = "happy_weather_snowstorm.png"

local sign = function (number)
	if number >= 0 then
		return 1
	else
		return -1
	end
end

local add_wide_range_rain_particle = function(player)
	local offset = {
		front = 7,
		back = 4,
		top = 3,
		bottom = 0
	}

	local random_pos = hw_utils.get_random_pos(player, offset)
	local p_pos = player:getpos()

	local look_dir = player:get_look_dir()

	if hw_utils.is_outdoor(random_pos) then
		minetest.add_particle({
			pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
		  	velocity = {x = sign(look_dir.x) * -10, y = -1, z = sign(look_dir.z) * -10},
		  	acceleration = {x = sign(look_dir.x) * -10, y = -1, z = sign(look_dir.z) * -10},
		  	expirationtime = 0.3,
		  	size = 30,
		  	collisiondetection = true,
		  	texture = "happy_weather_snowstorm.png",
		  	playername = player:get_player_name()
		})
	end
end


-- Random texture getter
local choice_random_rain_drop_texture = function()
	local base_name = "happy_weather_light_snow_snowflake_"
	local number = math.random(1, 3)
	local extension = ".png"
	return base_name .. number .. extension
end

local add_snow_particle = function(player)
	local offset = {
		front = 5,
		back = 2,
		top = 4
	}

	local random_pos = hw_utils.get_random_pos(player, offset)

	if hw_utils.is_outdoor(random_pos) then
		minetest.add_particle({
			pos = {x=random_pos.x, y=random_pos.y, z=random_pos.z},
			velocity = {x = math.random(-5,-2.5), y = math.random(-10,-5), z = math.random(-5,-2.5)},
			acceleration = {x = math.random(-5,-2.5), y=-2.5, z = math.random(-5,-2.5)},
			expirationtime = 2.0,
			size = math.random(1, 3),
			collisiondetection = true,
			collision_removal = true,
			vertical = true,
			texture = choice_random_rain_drop_texture(),
			playername = player:get_player_name()
		})
	end
end

local display_particles = function(player)
	if hw_utils.is_underwater(player) then
		return
	end

	local particles_number_per_update = 3
	for i=particles_number_per_update, 1,-1 do
		add_wide_range_rain_particle(player)
	end

	local snow_particles_number_per_update = 10
	for i=snow_particles_number_per_update, 1,-1 do
		add_snow_particle(player)
	end
end

snowstorm.render = function(dtime, player)
	display_particles(player)
end

snowstorm.start = function()
	manual_trigger_start = true
end

snowstorm.stop = function()
	manual_trigger_end = true
end

happy_weather.register_weather(snowstorm)


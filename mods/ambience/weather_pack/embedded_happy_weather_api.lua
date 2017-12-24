---------------------------
-- Happy Weather API

-- License: MIT
-- Credits: xeranas
---------------------------

-- Main object which will be used in Weather API lifecycle
happy_weather = {}

-- Local variables which helps organize active and deactive weahers
local registered_weathers = {}
local active_weathers = {}

------------------------------------
-- Local helper / utility methods --
------------------------------------

-- Adds weather to active_weathers table
local add_active_weather = function(weather_obj)
	table.insert(active_weathers, weather_obj)
end

-- Remove weather from active_weathers table
local remove_active_weather = function(weather_code)
	if #active_weathers == 0 then
		return
	end

	for k, weather_ in ipairs(active_weathers) do
		if weather_.code == weather_code then
			table.remove(active_weathers, k)
			return
		end
	end
end

-- Returns active weather
local get_active_weather = function(weather_code)
	if #active_weathers == 0 then
		return nil
	end

	for k, weather_ in ipairs(active_weathers) do
		if weather_.code == weather_code then
			return weather_
		end
	end
end

-- adds player to affected_players table
local add_player = function(affected_players, player)
	table.insert(affected_players, player)
end

-- remove player from affected_players table
local remove_player = function(affected_players, player_name)
	if #affected_players == 0 then
		return
	end

	for k, player_ in ipairs(affected_players) do
		if player_:get_player_name() == player_name then
			table.remove(affected_players, k)
			return
		end
	end
end

local is_player_affected = function(affected_players, player_name)
	if #affected_players == 0 then
		return false
	end

	for k, player_ in ipairs(affected_players) do
		if player_:get_player_name() == player_name then
			return true
		end
	end
end

---------------------------
-- Weather API functions --
---------------------------

-- Adds weather to register_weathers table
happy_weather.register_weather = function(weather_obj)
	table.insert(registered_weathers, weather_obj)
end

-- Returns true if weather is active right now, false otherwise
happy_weather.is_weather_active = function(weather_code)
	if #active_weathers == 0 then
		return false
	end

	for k, weather_ in ipairs(active_weathers) do
		if weather_.code == weather_code then
			return true
		end
	end
	return false
end

-- Requests weaher to start
happy_weather.request_to_start = function(weather_code, position)
	if #registered_weathers == 0 then
		return
	end

	for k, weather_ in ipairs(registered_weathers) do
		if weather_.code == weather_code and weather_.start ~= nil then
			weather_.start(position)
			return
		end
	end
end

-- Requests weaher to end
happy_weather.request_to_end = function(weather_code)
	if #active_weathers == 0 then
		return
	end

	for k, weather_ in ipairs(active_weathers) do
		if weather_.code == weather_code and weather_.stop ~= nil then
			weather_.stop()
			return
		end
	end
end

happy_weather.is_player_in_weather_area = function(player_name, weather_code)
	if #active_weathers == 0 then
		return false
	end

	local active_weather = get_active_weather(weather_code)
	if active_weather == nil then
		return false
	end

	return is_player_affected(active_weather.affected_players, player_name)
end

-----------------------------------------------------------------------------
-- Weather object callback wrappers to avoid issues from undefined methods --
-----------------------------------------------------------------------------

-- Weather is_starting method nil-safe wrapper
local weather_is_starting = function(weather_obj, dtime, position)
	if weather_obj.is_starting == nil then
		return false
	end
	return weather_obj.is_starting(dtime, position)
end

-- Weather is_starting method nil-safe wrapper
local weather_is_ending = function(weather_obj, dtime)
	if weather_obj.is_ending == nil then
		return false
	end
	return weather_obj.is_ending(dtime)
end

-- Weather add_player method nil-safe wrapper
local weather_add_player = function(weather_obj, player)
	if weather_obj.add_player == nil then
		return
	end
	weather_obj.add_player(player)
end

-- Weather remove_player method nil-safe wrapper
local weather_remove_player = function(weather_obj, player)
	if weather_obj.remove_player == nil then
		return
	end
	weather_obj.remove_player(player)
end

-- Weather remove_player method nil-safe wrapper
local weather_in_area = function(weather_obj, position)
	if weather_obj.in_area == nil then
		return true
	end
	return weather_obj.in_area(position)
end

-- Weather render method nil-safe wrapper
local weather_render = function(weather_obj, dtime, player)
	if weather_obj.render == nil then
		return
	end
	weather_obj.render(dtime, player)
end

-- Weather start method nil-safe wrapper
local weather_start = function(weather_obj, player)
	if weather_obj.start == nil then
		return
	end
	weather_obj.start(player)
end

-- Weather stop method nil-safe wrapper
local weather_stop = function(weather_obj, player)
	if weather_obj.stop == nil then
		return
	end
	weather_obj.stop(player)
end

-- Perform clean-up callbacks calls sets flags upon weaher end
local prepare_ending = function(weather_obj)
	weather_obj.active = false
	remove_active_weather(weather_obj.code)
end

-- Perform weather setup for certain player
local prepare_starting = function(weather_obj)
	weather_obj.active = true
	weather_obj.affected_players = {}
	add_active_weather(weather_obj)
end

-- While still active weather can or can not affect players based on area they are
local render_if_in_area = function(weather_obj, dtime, player)
	if is_player_affected(weather_obj.affected_players, player:get_player_name()) then
		if weather_in_area(weather_obj, player:getpos()) then
			weather_render(weather_obj, dtime, player)
		else
			weather_remove_player(weather_obj, player)
			remove_player(weather_obj.affected_players, player:get_player_name())
		end
	else
		if weather_in_area(weather_obj, player:getpos()) then
			add_player(weather_obj.affected_players, player)
			weather_add_player(weather_obj, player)
		end
	end
end


--------------------------
-- Global step function --
--------------------------

minetest.register_globalstep(function(dtime)

	if #registered_weathers == 0 then
		-- no registered weathers, do nothing.
		return
	end

	if #minetest.get_connected_players() == 0 then
		-- no actual players, do nothing.
		return
	end

	-- Loop through registered weathers
	for i, weather_ in ipairs(registered_weathers) do
		local deactivate_weather = false
		local activate_weather = false

		-- Loop through connected players
		for ii, player in ipairs(minetest.get_connected_players()) do
			
			-- Weaher is active checking if it about to end
			if weather_.active then 
				if weather_is_ending(weather_, dtime) or deactivate_weather then
					weather_remove_player(weather_, player)
					remove_player(weather_.affected_players, player:get_player_name())
					deactivate_weather = true -- should remain true until all players will be removed from weather
				
				-- Weather still active updating it
				else
					render_if_in_area(weather_, dtime, player)
				end

			-- Weaher is not active checking if it about to start
			else
				if weather_.is_starting(dtime, player:getpos()) then
					activate_weather = true
				end
			end	
		end

		if deactivate_weather then
			prepare_ending(weather_)
		end

		if activate_weather then
			prepare_starting(weather_)
		end
	end
end)

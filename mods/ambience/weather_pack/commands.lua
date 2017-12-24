------------------------------------
-- Happy Weather API Chat Commands

-- License: MIT

-- Credits: xeranas
------------------------------------

minetest.register_privilege("weather_manager", {
	description = "Gives ability to control weather",
	give_to_singleplayer = false
})

minetest.register_chatcommand("start_weather", {
	params = "<weather_cd>",
	description = "Starts weather by given weather code.",
	privs = {weather_manager = true},
	func = function(name, param)
		if param ~= nil then
			happy_weather.request_to_start(param)
			minetest.log("action", name .. " requested weather '" .. param .. "' from chat command")
		end
	end
})

minetest.register_chatcommand("stop_weather", {
	params = "<weather_cd>",
	description = "Ends weather by given weather code.",
	privs = {weather_manager = true},
	func = function(name, param)
		if param ~= nil then
			happy_weather.request_to_end(param)
			minetest.log("action", name .. " requested weather '" .. param .. "' ending from chat command")
		end
	end
})
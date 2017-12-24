local modpath = minetest.get_modpath("weather_pack");

-- If skylayer mod not located then embeded version will be loaded.
if minetest.get_modpath("skylayer") == nil then
	dofile(modpath.."/embedded_sky_layer_api.lua")
end

-- If happy_weather_api mod not located then embeded version will be loaded.
if minetest.get_modpath("happy_weather_api") == nil then
	dofile(modpath.."/embedded_happy_weather_api.lua")
	dofile(modpath.."/commands.lua")
end

-- Happy Weather utilities
dofile(modpath.."/utils.lua")

dofile(modpath.."/light_rain.lua")
dofile(modpath.."/rain.lua")
dofile(modpath.."/heavy_rain.lua")
dofile(modpath.."/snow.lua")

if minetest.get_modpath("lightning") ~= nil then
	dofile(modpath.."/thunder.lua")

	-- Turn off lightning mod 'auto mode'
	lightning.auto = false
end

dofile(modpath.."/abm.lua")

local modpath = minetest.get_modpath("weather_pack");

-- If skylayer mod not located then embeded version will be loaded.
if minetest.get_modpath("skylayer") == nil then
	dofile(modpath.."/lib_sky_layer_api.lua")
end

-- If happy_weather_api mod not located then embeded version will be loaded.
if minetest.get_modpath("happy_weather_api") == nil then
	dofile(modpath.."/lib_happy_weather_api.lua")
	dofile(modpath.."/commands.lua")
end

legacy_MT_version = false
if minetest.get_humidity == nil then
	minetest.log("warning", "MOD [weather_pack]: Old Minetest version detected, some mod features will not work.")
	legacy_MT_version = true
end

-- Happy Weather utilities
dofile(modpath.."/utils.lua")

dofile(modpath.."/weathers/light_rain.lua")
dofile(modpath.."/weathers/rain.lua")
dofile(modpath.."/weathers/heavy_rain.lua")
dofile(modpath.."/weathers/snow.lua")
dofile(modpath.."/weathers/snowstorm.lua")

if minetest.get_modpath("lightning") ~= nil then
	dofile(modpath.."/weathers/thunder.lua")

	-- Turn off lightning mod 'auto mode'
	lightning.auto = false
end

dofile(modpath.."/abm.lua")

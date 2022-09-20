local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath .. "/api.lua")
dofile(modpath .. "/hunger_api.lua")
if minetest.get_modpath("3d_armor") ~= nil then
	dofile(modpath .. "/3d_armor.lua")
end

tac_nayn = {}
local modpath = minetest.get_modpath("tac_nayn")
if minetest.settings:get_bool("pbj_pup_generate") ~= false then
	dofile(modpath.."/generator.lua")
end
dofile(modpath.."/nodes.lua")
dofile(modpath.."/crafts.lua")

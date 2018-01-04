waffles  = {}

-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

waffles.intllib = S
dofile(minetest.get_modpath("waffles").."/nodes.lua")
dofile(minetest.get_modpath("waffles").."/batter.lua")
dofile(minetest.get_modpath("waffles").."/crafts.lua")

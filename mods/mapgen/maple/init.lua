minetest.log("verbose", "[MOD] Loading maple module...")

local S = minetest.get_translator(minetest.get_current_modname())
local modpath = minetest.get_modpath(minetest.get_current_modname())

maple = {
  get_translator = S,
  path = modpath
}

dofile(modpath .. "/trees.lua")
dofile(modpath .. "/nodes.lua")
dofile(modpath .. "/decorations.lua")
dofile(modpath .. "/crafts.lua")
dofile(modpath .. "/intermod.lua")

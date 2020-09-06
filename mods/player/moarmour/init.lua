local S = minetest.get_translator(minetest.get_current_modname())
local moarmour_path = minetest.get_modpath(minetest.get_current_modname())

moarmour = {
  path = moarmour_path,
  get_translator = S
}

-- Loading the files --
dofile(moarmour_path.."/nodes.lua")
dofile(moarmour_path.."/crafts.lua")
dofile(moarmour_path.."/armour.lua")

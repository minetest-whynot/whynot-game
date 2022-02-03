local modpath = minetest.get_modpath("home_vending_machines")
home_vending_machines = {}

dofile(modpath .. "/api.lua")
dofile(modpath .. "/machines.lua")
dofile(modpath .. "/items.lua")
dofile(modpath .. "/crafts.lua")

home_vending_machines.init = true
smart_inventory = {}
smart_inventory.modpath = minetest.get_modpath(minetest.get_current_modname())
local modpath = smart_inventory.modpath

-- load libs
smart_inventory.txt = dofile(modpath.."/libs/simple_po_reader.lua")
smart_inventory.smartfs = dofile(modpath.."/libs/smartfs.lua")
smart_inventory.smartfs_elements = dofile(modpath.."/libs/smartfs-elements.lua")

smart_inventory.doc_addon = dofile(modpath.."/doc_addon.lua")

smart_inventory.filter = dofile(modpath.."/libs/filter.lua")
smart_inventory.cache = dofile(modpath.."/libs/cache.lua")
smart_inventory.crecipes = dofile(modpath.."/libs/crecipes.lua")
smart_inventory.maininv = dofile(modpath.."/libs/maininv.lua")

smart_inventory.ui_tools = dofile(modpath.."/ui_tools.lua")
-- register pages
dofile(modpath.."/inventory_framework.lua")
dofile(modpath.."/pages/crafting.lua")
dofile(modpath.."/pages/creative.lua")
dofile(modpath.."/pages/player.lua")
dofile(modpath.."/pages/doc.lua")
dofile(modpath.."/pages/awards.lua")

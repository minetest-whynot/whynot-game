-- Loading the files --
armor_addon = {}
local armor_addon_path = minetest.get_modpath("armor_addon")
dofile(armor_addon_path.."/crafts.lua")
if minetest.get_modpath("3d_armor") then
dofile(armor_addon_path.."/armor.lua")
end

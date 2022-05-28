if minetest.get_modpath("waffles") then
	-- A waffle block is 9 waffles, 8 stamina each. This is huge.
	-- Let's just do 20 for all waffle armor peices.
	ediblestuff.make_armor_edible_while_wearing("moarmour","waffle",20,true)
end
if minetest.get_modpath("farming") and farming.mod == "redo" then
	ediblestuff.make_armor_edible_while_wearing("moarmour","chocolate",2.5)
end
if minetest.get_modpath("candycane") then
	ediblestuff.make_armor_edible_while_wearing("moarmour","cane",3.5)
end

--Crafting Recipes if the Waffles mod is enabled

if minetest.get_modpath("waffles") then

--Craft Tac Nayn
minetest.register_craft({
	output = 'tac_nayn:tacnayn',
	recipe = {
		{'dye:black', 'waffles:large_waffle', 'dye:black'},
		{'waffles:large_waffle', 'nyancat:nyancat', 'waffles:large_waffle'},
		{'dye:black', 'waffles:large_waffle', 'dye:black'},
	}
})

--Craft Tac Nayn Rainbow
minetest.register_craft({
	output = 'tac_nayn:tacnayn_rainbow',
	recipe = {
		{'dye:black', 'dye:dark_grey', 'dye:grey'},
		{'dye:dark_grey', 'nyancat:nyancat_rainbow', 'dye:dark_grey'},
		{'dye:grey', 'dye:dark_grey', 'dye:black'},
	}
})

--Reverse Rainbow Recipe
minetest.register_craft({
	output = 'tac_nayn:tacnayn_rainbow',
	recipe = {
		{'dye:grey', 'dye:dark_grey', 'dye:black'},
		{'dye:dark_grey', 'nyancat:nyancat_rainbow', 'dye:dark_grey'},
		{'dye:black', 'dye:dark_grey', 'dye:grey'},
	}
})
end

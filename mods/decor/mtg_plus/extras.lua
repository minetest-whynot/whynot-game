local S = minetest.get_translator("mtg_plus")

-- Add additional crafting recipes and nodes if particular mods were detected

-- moreblocks extras
if minetest.get_modpath("moreblocks") then
	minetest.register_craft({
		type = "shapeless",
		output = "default:glass",
		recipe = {"mtg_plus:dirty_glass", "moreblocks:sweeper"}
	})
	minetest.register_craft({
		type = "shapeless",
		output = "moreblocks:clean_glass",
		recipe = {"mtg_plus:dirty_glass", "moreblocks:sweeper", "moreblocks:sweeper"}
	})
	minetest.register_craft({
		output = "mtg_plus:dirty_glass",
		recipe = {
			{"default:dirt"},
			{"moreblocks:clean_glass"}
		}
	})
	minetest.register_craft({
		type = "shapeless",
		output = "mtg_plus:ice_window",
		recipe = { "mtg_plus:ice_tile4", "moreblocks:sweeper" },
	})
end

-- furniture extras
if minetest.get_modpath("furniture") then
	furniture.register_wooden("mtg_plus:goldwood", {
		description = S("Goldwood"),
		description_chair = S("Goldwood Chair"),
		description_stool = S("Goldwood Stool"),
		description_table = S("Goldwood Table"),
	})
	furniture.register_stone("mtg_plus:jungle_cobble", {
		description = S("Jungle Cobblestone"),
		description_stool = S("Jungle Cobblestone Stool"),
		description_table = S("Jungle Cobblestone Table"),
	})
	furniture.register_stone("mtg_plus:sandstone_cobble", {
		description = S("Cobbled Sandstone"),
		description_stool = S("Cobbled Sandstone Stool"),
		description_table = S("Cobbled Sandstone Table"),
	})
	furniture.register_stone("mtg_plus:desert_sandstone_cobble", {
		description = S("Cobbled Desert Sandstone"),
		description_stool = S("Cobbled Desert Sandstone Stool"),
		description_table = S("Cobbled Desert Sandstone Table"),
	})
	furniture.register_stone("mtg_plus:silver_sandstone_cobble", {
		description = S("Cobbled Silver Sandstone"),
		description_stool = S("Cobbled Silver Sandstone Stool"),
		description_table = S("Cobbled Silver Sandstone Table"),
	})
	furniture.register_stone("mtg_plus:gravel_cobble", {
		description = S("Cobbled Gravel"),
		description_stool = S("Cobbled Gravel Stool"),
		description_table = S("Cobbled Gravel Table"),
	})
end

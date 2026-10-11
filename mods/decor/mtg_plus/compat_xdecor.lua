if minetest.get_modpath("xdecor") then
	minetest.register_craft({
		output = "xpanes:papyrus 2",
		recipe = {
			{ "", "farming:string", "" },
			{ "farming:string", "xpanes:bamboo_frame", "farming:string" },
		}
	})

	minetest.register_craft({
		output = "xpanes:bamboo_frame",
		recipe = { { "xpanes:papyrus", "xpanes:papyrus", }, }
	})

	-- xdecor compability
	minetest.register_craft({
		output = "xdecor:packed_ice 2",
		recipe = { { "mtg_plus:ice_block", "mtg_plus:ice_block", "mtg_plus:ice_block" },
		{ "mtg_plus:ice_block", "", "mtg_plus:ice_block" },
		{ "mtg_plus:ice_block", "mtg_plus:ice_block", "mtg_plus:ice_block" }, },
	})

	minetest.register_craft({
		output = "mtg_plus:ice_tile16",
		recipe = { { "xdecor:packed_ice", "xdecor:packed_ice" },
		{ "xdecor:packed_ice", "xdecor:packed_ice" }, },
	})

	-- Alternate ice brick crafting recipe for xdecor compability
	minetest.register_craft({
		output = "mtg_plus:ice_brick 4",
		recipe = { { "", "default:ice", "default:ice" },
		{ "default:ice", "default:ice", "" } },
	})
	minetest.register_craft({
		output = "mtg_plus:ice_brick 4",
		recipe = { { "default:ice", "default:ice", "" },
		{ "", "default:ice", "default:ice" } },
	})
else
	-- Normal ice brick crafting recipe
	minetest.register_craft({
		output = "mtg_plus:ice_brick 4",
		recipe = { { "default:ice", "default:ice" },
		{ "default:ice", "default:ice" } },
	})
end
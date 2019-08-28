local S = minetest.get_translator("mtg_plus")

-- xpanes
xpanes.register_pane("paper", {
	description = S("Paper Barrier"),
	inventory_image = "mtg_plus_paperwall.png",
	wield_image = "mtg_plus_paperwall.png",
	textures = {"mtg_plus_paperwall.png", "mtg_plus_paperwall.png", "mtg_plus_paperwall.png"},
	groups = {snappy=3, flammable=4, pane=1},
	sounds = {
		footstep = {name="mtg_plus_paper_step", gain=0.1, max_hear_distance=7},
		place = {name="mtg_plus_paper_step", gain=0.3, max_hear_distance=13},
		dig = {name="mtg_plus_paper_dig", gain=0.1, max_hear_distance=11},
		dug = {name="mtg_plus_paper_dug", gain=0.2, max_hear_distance=13},
	},
	recipe = {
		{ "default:paper", "default:paper", "default:paper" },
		{ "default:paper", "default:paper", "default:paper" },
	}
})

local r
if minetest.registered_items["xpanes:paper_flat"] then
	r = "xpanes:paper_flat"
else
	r = "xpanes:paper"
end
minetest.register_craft({
	type = "fuel",
	recipe = r,
	burntime = 1,
})

xpanes.register_pane("wood", {
	description = S("Wooden Bars"),
	inventory_image = "mtg_plus_wooden_bar.png",
	wield_image = "mtg_plus_wooden_bar.png",
	textures = {"mtg_plus_wooden_bar.png", "mtg_plus_wooden_bar_side.png", "mtg_plus_wooden_bar_y.png"},
	groups = {choppy=3, oddly_breakable_by_hand=2, flammable=2, pane=1},
	sounds = default.node_sound_wood_defaults(),
	recipe = {
		{ "group:wood", "", "group:wood" },
		{ "group:wood", "", "group:wood" },
		{ "group:wood", "", "group:wood" },
	}
})

if minetest.registered_items["xpanes:wood_flat"] then
	r = "xpanes:wood_flat"
else
	r = "xpanes:wood"
end
minetest.register_craft({
	type = "fuel",
	recipe = r,
	burntime = 2,
})

xpanes.register_pane("goldglass", {
	description = S("Goldglass Pane"),
	inventory_image = "mtg_plus_goldglass.png",
	wield_image = "mtg_plus_goldglass.png",
	textures = {"mtg_plus_goldglass.png","mtg_plus_goldglass_pane_half.png","mtg_plus_goldglass_pane_top.png",},
	groups = {cracky=3,oddly_breakable_by_hand=2,pane=1},
	sounds = default.node_sound_glass_defaults(),
	recipe = {
		{ "mtg_plus:goldglass","mtg_plus:goldglass","mtg_plus:goldglass", },
		{ "mtg_plus:goldglass","mtg_plus:goldglass","mtg_plus:goldglass", },
	}
})

xpanes.register_pane("goldglass2", {
	description = S("Golden Window"),
	inventory_image = "mtg_plus_goldglass2.png",
	wield_image = "mtg_plus_goldglass2.png",
	textures = {"mtg_plus_goldglass2.png","mtg_plus_goldglass_pane_half.png","mtg_plus_goldglass_pane_top.png",},
	groups = {cracky=3,oddly_breakable_by_hand=3,pane=1},
	sounds = default.node_sound_glass_defaults(),
	recipe = {
		{ "default:gold_ingot","default:gold_ingot","default:gold_ingot", },
		{ "default:gold_ingot","default:glass","default:gold_ingot", },
		{ "default:gold_ingot","default:gold_ingot","default:gold_ingot", },
	}
})

xpanes.register_pane("papyrus", {
	description = S("Papyrus Lattice"),
	inventory_image = "mtg_plus_papyrus_lattice.png",
	wield_image = "mtg_plus_papyrus_lattice.png",
	textures = {"mtg_plus_papyrus_lattice.png","mtg_plus_papyrus_lattice.png","mtg_plus_papyrus_lattice.png"},
	groups = {snappy=2, choppy=1, flammable=2,pane=1},
	sounds = default.node_sound_leaves_defaults(),
	recipe = {
		{ "default:papyrus", "farming:string", "default:papyrus" },
		{ "default:papyrus", "farming:string", "default:papyrus" },
	}
})

if minetest.registered_items["xpanes:papyrus_flat"] then
	r = "xpanes:papyrus_flat"
else
	r = "xpanes:papyrus"
end
minetest.register_craft({
	type = "fuel",
	recipe = r,
	burntime = 1,
})


xpanes.register_pane("ice", {
	description = S("Ice Window Pane"),
	inventory_image = "mtg_plus_ice_window.png",
	wield_image = "mtg_plus_ice_window.png",
	textures = {"mtg_plus_ice_window.png", "mtg_plus_ice_window.png", "mtg_plus_ice_window.png"},
	groups = {cracky=3, slippery = 3, pane=1},
	sounds = default.node_sound_glass_defaults(),
	recipe = {
		{ "mtg_plus:ice_window", "mtg_plus:ice_window", "mtg_plus:ice_window", },
		{ "mtg_plus:ice_window", "mtg_plus:ice_window", "mtg_plus:ice_window", }
	}
})

local panes = {
	paper = S("Papier barriers are thin solid layers of paper which neatly connect to their neighbors as you build them. They could be useful to separate rooms."),
	wood = S("Wooden bars are barriers which neatly connect to their neighbors as you build them."),
	goldglass = S("Goldglass panes are thin layers of goldglass which neatly connect to their neighbors as you build them."),
	goldglass2 = S("Golden windows are decorative blocks which can be placed into holes for nice-looking windows. Golden windows automatically connect to their neighbors as you build them."),
	papyrus = S("Papyrus lattices are strong barriers which neatly connect to their neighbors as you build them."),
	ice = S("Ice window panes are thinner than the full ice windows and neatly connect to each other as you build them"),
}

for pane, longdesc in pairs(panes) do
	minetest.override_item("xpanes:"..pane.."_flat", {
		_doc_items_longdesc = longdesc,
	})
	minetest.override_item("xpanes:"..pane, {
		_doc_items_create_entry = false,
	})
	if minetest.get_modpath("doc") then
		doc.add_entry_alias("nodes", "xpanes:"..pane.."_flat", "nodes", "xpanes:"..pane)
	end
end


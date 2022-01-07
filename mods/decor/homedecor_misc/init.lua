-- Home Decor mod by VanessaE
--
-- Mostly my own code, with bits and pieces lifted from Minetest's default
-- lua files and from ironzorg's flowers mod.  Many thanks to GloopMaster
-- for helping me figure out the inventories used in the nightstands/dressers.
--
-- The code for ovens, nightstands, refrigerators are basically modified
-- copies of the code for chests and furnaces.

local S = minetest.get_translator("homedecor_misc")

homedecor_misc = {}

homedecor.register("ceiling_paint", {
	description = S("Textured Ceiling Paint"),
	drawtype = 'signlike',
	tiles = { 'homedecor_ceiling_paint.png' },
	inventory_image = 'homedecor_ceiling_paint_roller.png',
	wield_image = 'homedecor_ceiling_paint_roller.png',
	walkable = false,
	groups = { snappy = 3 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = { type = "wallmounted" },
})

homedecor.register("ceiling_tile", {
	description = S("Drop-Ceiling Tile"),
	drawtype = 'signlike',
	tiles = { 'homedecor_ceiling_tile.png' },
	wield_image = 'homedecor_ceiling_tile.png',
	inventory_image = 'homedecor_ceiling_tile.png',
	walkable = false,
	groups = { snappy = 3 },
	sounds = default.node_sound_leaves_defaults(),
	selection_box = { type = "wallmounted" },
})

local rug_types = {
	{ "small",   "homedecor_small_rug.obj"    },
	{ "large",   homedecor.box.slab_y(0.0625) },
	{ "persian", homedecor.box.slab_y(0.0625) },
}

for _, rt in ipairs(rug_types) do
	local s, m = unpack(rt)

	local mesh = m
	local nodebox = nil
	local tiles = { "homedecor_rug_"..s..".png", "wool_grey.png" }

	if type(m) == "table" then
		mesh = nil
		nodebox = {
			type = "fixed",
			fixed = m
		}
		tiles = {
			"homedecor_rug_"..s..".png",
			"wool_grey.png",
			"homedecor_rug_"..s..".png"
		}
	end

	homedecor.register("rug_"..s, {
		description = S("Rug (@1)", S(s)),
		mesh = mesh,
		tiles = tiles,
		node_box = nodebox,
		paramtype2 = "wallmounted",
		walkable = false,
		groups = {snappy = 3},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = { type = "wallmounted" },
	})
end

local pot_colors = { "black", "green", "terracotta" }

for _, p in ipairs(pot_colors) do
homedecor.register("flower_pot_"..p, {
	description = S("Flower Pot (@1)", S(p)),
	mesh = "homedecor_flowerpot.obj",
	tiles = {
		"homedecor_flower_pot_"..p..".png",
		{ name = "default_dirt.png", color = 0xff505050 },
	},
	groups = { snappy = 3, potting_soil=1 },
	sounds = default.node_sound_stone_defaults(),
})
end

local flowers_list = {
	{ S("Rose"),				"rose",				"flowers:rose" },
	{ S("Tulip"),				"tulip",			"flowers:tulip" },
	{ S("Yellow Dandelion"),	"dandelion_yellow",	"flowers:dandelion_yellow" },
	{ S("White Dandelion"), 	"dandelion_white",	"flowers:dandelion_white" },
	{ S("Blue Geranium"),		"geranium",			"flowers:geranium" },
	{ S("Viola"),				"viola",			"flowers:viola" },
	{ S("Cactus"),				"cactus",			"default:cactus" },
	{ S("Bonsai"),				"bonsai",			"default:sapling" }
}

for _, f in ipairs(flowers_list) do
	local flowerdesc, flower, craftwith = unpack(f)

	homedecor.register("potted_"..flower, {
		description = S("Potted flower (@1)", flowerdesc),
		mesh = "homedecor_potted_plant.obj",
		tiles = {
			"homedecor_flower_pot_terracotta.png",
			{ name = "default_dirt.png", color = 0xff303030 },
			"flowers_"..flower..".png"
		},
		walkable = false,
		groups = {snappy = 3},
		sounds = default.node_sound_glass_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.2, -0.5, -0.2, 0.2, 0.3, 0.2 }
		}
	})

	minetest.register_craft({
		type = "shapeless",
		output = "homedecor:potted_"..flower,
		recipe = { craftwith, "homedecor:flower_pot_small" }
	})

	minetest.register_alias("flowers:flower_"..flower.."_pot", "homedecor:potted_"..flower)
	minetest.register_alias("flowers:potted_"..flower, "homedecor:potted_"..flower)
	minetest.register_alias("flowers:flower_pot", "homedecor:flower_pot_small")
end

homedecor.register("pole_brass", {
	description = S("Brass Pole"),
	mesh = "homedecor_round_pole.obj",
	tiles = {"homedecor_generic_metal_brass.png^homedecor_generic_metal_lines_overlay.png",},
	inventory_image = "homedecor_pole_brass_inv.png",
	wield_image = "homedecor_pole_brass_inv.png",
	selection_box = {
		type = "fixed",
		fixed = { -0.125, -0.5, -0.125, 0.125, 0.5, 0.125 },
	},
	collision_box = {
		type = "fixed",
		fixed = { -0.125, -0.5, -0.125, 0.125, 0.5, 0.125 },
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	check_for_pole = true
})

homedecor.register("pole_wrought_iron", {
    description = S("Wrought Iron Pole"),
    tiles = { "homedecor_generic_metal_wrought_iron.png^homedecor_generic_metal_lines_overlay.png" },
    inventory_image = "homedecor_pole_wrought_iron_inv.png",
    wield_image = "homedecor_pole_wrought_iron_inv.png",
    selection_box = {
            type = "fixed",
            fixed = {-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625}
    },
	node_box = {
		type = "fixed",
                fixed = {-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625}
	},
    groups = {snappy=3},
    sounds = default.node_sound_wood_defaults(),
})

local ft_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.375, 0.5, 0.3125, 0.375 }
}

homedecor.register("fishtank", {
	description = S("Fishtank"),
	mesh = "homedecor_fishtank.obj",
	tiles = {
		{ name = "homedecor_generic_plastic.png", color = homedecor.color_black },
		"homedecor_fishtank_filter.png",
		"homedecor_fishtank_fishes.png",
		"homedecor_fishtank_gravel.png",
		"homedecor_fishtank_water_top.png",
		"homedecor_fishtank_sides.png",
	},
	use_texture_alpha = true,
	selection_box = ft_cbox,
	collision_box = ft_cbox,
	groups = {cracky=3,oddly_breakable_by_hand=3},
	sounds = default.node_sound_glass_defaults(),
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "homedecor:fishtank_lighted", param2 = node.param2})
		return itemstack
	end
})

homedecor.register("fishtank_lighted", {
	description = S("Fishtank (lighted)"),
	mesh = "homedecor_fishtank.obj",
	tiles = {
		{ name = "homedecor_generic_plastic.png", color = homedecor.color_black },
		"homedecor_fishtank_filter.png",
		"homedecor_fishtank_fishes_lighted.png",
		"homedecor_fishtank_gravel_lighted.png",
		"homedecor_fishtank_water_top_lighted.png",
		"homedecor_fishtank_sides_lighted.png",
	},
	light_source = default.LIGHT_MAX-4,
	use_texture_alpha = true,
	selection_box = ft_cbox,
	collision_box = ft_cbox,
	groups = {cracky=3,oddly_breakable_by_hand=3,not_in_creative_inventory=1},
	sounds = default.node_sound_glass_defaults(),
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "homedecor:fishtank", param2 = node.param2})
		return itemstack
	end,
	drop = "homedecor:fishtank",
})

homedecor.register("cardboard_box_big", {
	description = S("Cardboard box (big)"),
	tiles = {
		'homedecor_cardbox_big_tb.png',
		'homedecor_cardbox_big_tb.png',
		'homedecor_cardbox_big_sides.png',
	},
	groups = { snappy = 3 },
	infotext=S("Cardboard box"),
	inventory = {
		size=24,
	},
})

homedecor.register("cardboard_box", {
	description = S("Cardboard box"),
	tiles = {
		'homedecor_cardbox_tb.png',
		'homedecor_cardbox_tb.png',
		'homedecor_cardbox_sides.png',
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, -0.3125, 0.3125, 0, 0.3125},
		}
	},
	groups = { snappy = 3 },
	infotext=S("Cardboard box"),
	inventory = {
		size=8,
	},
})

homedecor.register("dvd_cd_cabinet", {
	description = S("DVD/CD cabinet"),
	mesh = "homedecor_dvd_cabinet.obj",
	tiles = {
		"default_wood.png",
		"homedecor_dvdcd_cabinet_front.png",
		"homedecor_dvdcd_cabinet_back.png"
	},
	selection_box = homedecor.nodebox.slab_z(-0.5),
	groups = {choppy=2,oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
})

local pooltable_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.5, 0.5, 0.3125, 1.5 }
}

homedecor.register("pool_table", {
	mesh = "homedecor_pool_table.obj",
	tiles = {
		"homedecor_pool_table_cue.png",
		"homedecor_pool_table_baize.png",
		"homedecor_pool_table_pockets.png",
		"homedecor_pool_table_balls.png",
		homedecor.lux_wood,
	},
	description = S("Pool Table"),
	inventory_image = "homedecor_pool_table_inv.png",
	groups = {snappy=3},
	selection_box = pooltable_cbox,
	collision_box = pooltable_cbox,
	expand = { forward="placeholder" },
	sounds = default.node_sound_wood_defaults(),
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
})

minetest.register_alias("homedecor:pool_table_2", "air")

local piano_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.125, 1.5, 0.5, 0.5 }
}

homedecor.register("piano", {
	mesh = "homedecor_piano.obj",
	tiles = {
		{ name = "homedecor_generic_wood_luxury.png", color = homedecor.color_black },
		"homedecor_piano_keys.png",
		"homedecor_generic_metal_brass.png",
	},
	inventory_image = "homedecor_piano_inv.png",
	description = S("Piano"),
	groups = { snappy = 3 },
	selection_box = piano_cbox,
	collision_box = piano_cbox,
	expand = { right="placeholder" },
	sounds = default.node_sound_wood_defaults(),
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
})

minetest.register_alias("homedecor:piano_left", "homedecor:piano")
minetest.register_alias("homedecor:piano_right", "air")

local tr_cbox = {
	type = "fixed",
	fixed = { -0.3125, -0.5, -0.1875, 0.3125, 0.125, 0.1875 }
}

homedecor.register("trophy", {
	description = S("Trophy"),
	mesh = "homedecor_trophy.obj",
	tiles = {
		"default_wood.png",
		"homedecor_generic_metal_gold.png"
	},
	inventory_image = "homedecor_trophy_inv.png",
	groups = { snappy=3 },
	walkable = false,
	selection_box = tr_cbox,
})

local sb_cbox = {
	type = "fixed",
	fixed = { -0.4, -0.5, -0.5, 0.4, 0.375, 0.5 }
}

homedecor.register("sportbench", {
	description = S("Sport bench"),
	mesh = "homedecor_sport_bench.obj",
	tiles = {
		"homedecor_generic_metal_wrought_iron.png",
		"homedecor_generic_metal_bright.png",
		{ name = "homedecor_generic_metal.png", color = homedecor.color_black },
		"wool_black.png"
	},
	inventory_image = "homedecor_sport_bench_inv.png",
	groups = { snappy=3 },
	selection_box = sb_cbox,
	walkable = false,
	sounds = default.node_sound_wood_defaults(),
})

local skate_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.15, 0.5, -0.3, 0.15 }
}

homedecor.register("skateboard", {
	drawtype = "mesh",
	mesh = "homedecor_skateboard.obj",
	tiles = { "homedecor_skateboard.png" },
	inventory_image = "homedecor_skateboard_inv.png",
	description = S("Skateboard"),
	groups = {snappy=3},
	selection_box = skate_cbox,
	walkable = false,
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

homedecor_misc.banister_materials = {
	{
		"wood",
		S("wood"),
		"default_wood.png",
		"default_wood.png",
		"group:wood",
		"group:stick",
		"",
		""
	},
	{
		"white_dark",
		S("dark topped"),
		homedecor.white_wood,
		homedecor.dark_wood,
		"group:wood",
		"group:stick",
		"dye:brown",
		"dye:white"
	},
	{
		"brass",
		S("brass"),
		homedecor.white_wood,
		"homedecor_generic_metal_brass.png",
		"technic:brass_ingot",
		"group:stick",
		"",
		"dye:white"
	},
	{
		"wrought_iron",
		S("wrought iron"),
		"homedecor_generic_metal_wrought_iron.png",
		"homedecor_generic_metal_wrought_iron.png",
		"homedecor:pole_wrought_iron",
		"homedecor:pole_wrought_iron",
		"",
		""
	}
}

for _, side in ipairs({"diagonal_left", "diagonal_right", "horizontal"}) do

	local sidedesc = side:match("^diagonal") and S("diagonal") or S("horizontal")

	for _, mat in ipairs(homedecor_misc.banister_materials) do

		local name, matdesc, tile1, tile2 = unpack(mat)
		local nodename = "banister_"..name.."_"..side

		local cbox = {
			type = "fixed",
			fixed = { -9/16, -3/16, 5/16, 9/16, 24/16, 8/16 }
		}

		if side == "horizontal" then
			cbox = {
				type = "fixed",
				fixed = { -8/16, -8/16, 5/16, 8/16, 8/16, 8/16 }
			}
		end

		local def = {
			description = S("Banister for Stairs (@1, @2)", matdesc, sidedesc),
			mesh = "homedecor_banister_"..side..".obj",
			tiles = {
				tile1,
				tile2,
			},
			inventory_image = "homedecor_banister_"..name.."_inv.png",
			selection_box = cbox,
			collision_box = cbox,
			groups = { snappy = 3},
			on_place = homedecor.place_banister,
			drop = "homedecor:banister_"..name.."_horizontal",
		}

		if side ~= "horizontal" then
			def.groups.not_in_creative_inventory = 1
		end

		if name == "wood" then
			def.palette = "unifieddyes_palette_greys.png"
			def.airbrush_replacement_node = "homedecor:banister_wood_"..side.."_grey"
			def.groups.ud_param2_colorable = 1
			def.paramtype2 = "colorfacedir"
			def.on_dig = unifieddyes.on_dig
		end
		homedecor.register(nodename, def)

		if name == "wood" then
			local nn = "homedecor:"..nodename
			local def2 = table.copy(minetest.registered_items[nn])
			def2.tiles = {
				homedecor.white_wood,
				homedecor.white_wood
			}
			def2.inventory_image = "homedecor_banister_wood_colored_inv.png"
			def2.groups.not_in_creative_inventory = 1

			unifieddyes.generate_split_palette_nodes(nn, def2, "homedecor:banister_"..name.."_horizontal")
		end
	end
end

homedecor.register("spiral_staircase", {
	description = "Spiral Staircase",
	mesh = "homedecor_spiral_staircase.obj",
	wield_scale = { x=0.4, y=0.4, z=0.4 },
	tiles = {
		"homedecor_generic_metal_wrought_iron.png",
	},
	selection_box = {
		type = "fixed",
		fixed = { -1.5, -0.5, -1.5, 0.5, 2.5, 0.5 }
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5625, -0.5, -0.5625, -0.4375, 2.5, -0.4375}, -- NodeBox9
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0}, -- NodeBox14
			{-0.5, -0.125, -0.5, -0.25, -0.0625, 0.5}, -- NodeBox15
			{-0.25, -0.125, -0.0625, 0, -0.0625, 0.5}, -- NodeBox16
			{-1, 0.25, -0.5, -0.5, 0.3125, 0.5}, -- NodeBox17
			{-1.5, 0.625, -0.5, -0.5, 0.6875, -0.25}, -- NodeBox18
			{-1.5, 0.625, -0.25, -0.9375, 0.6875, 0}, -- NodeBox19
			{-1.5, 1, -1, -0.5, 1.0625, -0.5}, -- NodeBox20
			{-0.75, 1.375, -1.5, -0.5, 1.4375, -0.5}, -- NodeBox21
			{-1, 1.375, -1.5, -0.75, 1.4375, -1}, -- NodeBox22
			{-0.5, 1.75, -1.5, 0.0625, 1.8125, -0.5}, -- NodeBox23
			{-0.5, 2.125, -0.8125, 0.5, 2.1875, -0.5}, -- NodeBox24
			{-0.0625, 2.125, -1.0625, 0.5, 2.1875, -0.75}, -- NodeBox25
			{-1.5, -0.125, 0.4375, 0.5, 1.625, 0.5}, -- NodeBox26
			{-1.5, 1.5625, -1.5, -1.4375, 2.875, 0.5}, -- NodeBox27
			{-1.5, 1.75, -1.5, 0.5, 3.3125, -1.4375}, -- NodeBox28
			{0.4375, -0.5, -0.5, 0.5, 0.875, 0.5}, -- NodeBox29
			{0.4375, 2.125, -1.5, 0.5, 3.3125, 0.5}, -- NodeBox30
		}
	},
	groups = {cracky = 1},
	sounds = default.node_sound_wood_defaults(),
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.rotate_simple or nil,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local fdir = minetest.dir_to_facedir(placer:get_look_dir())
		local leftx =  homedecor.fdir_to_left[fdir+1][1]
		local leftz =  homedecor.fdir_to_left[fdir+1][2]
		local revx  = -homedecor.fdir_to_fwd[fdir+1][1]
		local revz  = -homedecor.fdir_to_fwd[fdir+1][2]

		local corner1 = { x = pos.x + leftx + revx, y = pos.y, z = pos.z + leftz + revz}
		local corner2 = { x = pos.x, y = pos.y + 2, z = pos.z }

		local minp = { x = math.min(corner1.x, corner2.x),
		               y = math.min(corner1.y, corner2.y),
		               z = math.min(corner1.z, corner2.z) }

		local maxp = { x = math.max(corner1.x, corner2.x),
		               y = math.max(corner1.y, corner2.y),
		               z = math.max(corner1.z, corner2.z) }

		if #minetest.find_nodes_in_area(minp, maxp, "air") < 11 then
			minetest.set_node(pos, {name = "air"})
			minetest.chat_send_player(placer:get_player_name(), S("not enough space"))
			return true
		end

		local belownode = minetest.get_node({ x = pos.x, y = pos.y - 1, z = pos.z })

		if belownode and belownode.name == "homedecor:spiral_staircase" then
			local newpos = { x = pos.x, y = pos.y + 2, z = pos.z }
			minetest.set_node(pos, { name = "air" })
			minetest.set_node(newpos, { name = "homedecor:spiral_staircase", param2 = belownode.param2 })
		end
	end
})

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	local belownode = minetest.get_node({ x = pos.x, y = pos.y - 1, z = pos.z })

	if newnode.name ~= "homedecor:spiral_staircase"
	  and belownode
	  and belownode.name == "homedecor:spiral_staircase" then
		minetest.set_node(pos, { name = "air" })

		local newpos = { x = pos.x, y = pos.y + 2, z = pos.z }
		local checknode = minetest.get_node(newpos)

		if checknode and checknode.name == "air" then
			local fdir = minetest.dir_to_facedir(placer:get_look_dir())
			minetest.set_node(newpos, { name = newnode.name, param2 = fdir })
		else
			return true
		end
	end
end)

minetest.register_node(":homedecor:tatami_mat", {
	tiles = {
		"homedecor_tatami.png",
		"homedecor_tatami.png",
		"homedecor_tatami.png",
		"homedecor_tatami.png",
		"homedecor_tatami.png",
		"homedecor_tatami.png"
	},
	description = S("Japanese tatami"),
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy=3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
		}
	}
})

homedecor.register("dartboard", {
	description = S("Dartboard"),
	mesh = "homedecor_dartboard.obj",
	tiles = { "homedecor_dartboard.png" },
	inventory_image = "homedecor_dartboard_inv.png",
	wield_image = "homedecor_dartboard_inv.png",
	paramtype2 = "wallmounted",
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	groups = {choppy=2,dig_immediate=2,attached_node=1},
	legacy_wallmounted = true,
	sounds = default.node_sound_wood_defaults(),
})

-- crafting

-- Crafting for homedecor mod (includes folding) by Vanessa Ezekowitz
--
-- Mostly my own code; overall template borrowed from game default

minetest.register_craft( {
	output = "homedecor:flower_pot_terracotta",
	recipe = {
		{ "homedecor:roof_tile_terracotta", "default:dirt", "homedecor:roof_tile_terracotta" },
		{ "homedecor:roof_tile_terracotta", "homedecor:roof_tile_terracotta", "homedecor:roof_tile_terracotta" },
	},
})

minetest.register_craft( {
	output = "homedecor:flower_pot_green",
	recipe = {
		{ "", "dye:dark_green", "" },
		{ "basic_materials:plastic_sheet", "default:dirt", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
	},
})

minetest.register_craft( {
	output = "homedecor:flower_pot_black",
	recipe = {
		{ "dye:black", "dye:black", "dye:black" },
		{ "basic_materials:plastic_sheet", "default:dirt", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:ceiling_paint 20",
	recipe = {
		"dye:white",
		"dye:white",
		"default:sand",
		"bucket:bucket_water",
	},
	replacements = { { "bucket:bucket_water","bucket:bucket_empty" } }
})

minetest.register_craft( {
	output = "homedecor:ceiling_tile 10",
	recipe = {
		{ "", "dye:white", "" },
		{ "default:steel_ingot", "default:stone", "default:steel_ingot" },
	},
})

minetest.register_craft( {
	output = "homedecor:drawer_small",
	recipe = {
		{ "group:wood", "default:steel_ingot", "group:wood" },
	},
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:drawer_small",
	burntime = 30,
})

-- vertical poles/lampposts

minetest.register_craft( {
	output = "homedecor:pole_brass 4",
	recipe = {
		{ "", "basic_materials:brass_ingot", "" },
		{ "", "basic_materials:brass_ingot", "" },
		{ "", "basic_materials:brass_ingot", "" }
	},
})

minetest.register_craft( {
	output = "homedecor:pole_wrought_iron 4",
	recipe = {
		{ "default:iron_lump", },
		{ "default:iron_lump", },
		{ "default:iron_lump", },
	},
})

-- ===========================================================
-- Recipes that require materials from wool (cotton alternate)

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:rug_small 8",
	recipe = {
			"wool:red",
			"wool:yellow",
			"wool:blue",
			"wool:black"
	},
})

minetest.register_craft( {
	output = "homedecor:rug_persian 8",
	recipe = {
		{ "", "wool:yellow", "" },
		{ "wool:red", "wool:blue", "wool:red" },
		{ "", "wool:yellow", "" }
	},
})

-- cotton versions:

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:rug_small 8",
	recipe = {
		"cotton:red",
		"cotton:yellow",
		"cotton:blue",
		"cotton:black"
	},
})

minetest.register_craft( {
	output = "homedecor:rug_persian 8",
	recipe = {
		{ "", "cotton:yellow", "" },
		{ "cotton:red", "cotton:blue", "cotton:red" },
		{ "", "cotton:yellow", "" }
	},
})

-- fuel recipes for same

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:rug_small",
	burntime = 30,
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:rug_large 2",
	recipe = {
		"homedecor:rug_small",
		"homedecor:rug_small",
	},
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:rug_large",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:rug_persian",
	burntime = 30,
})

-- more misc stuff here

minetest.register_craft({
	output = "homedecor:fishtank",
	recipe = {
		{ "basic_materials:plastic_sheet", "homedecor:glowlight_small_cube", "basic_materials:plastic_sheet" },
		{ "default:glass", "bucket:bucket_water", "default:glass" },
		{ "default:glass", "building_blocks:gravel_spread", "default:glass" },
	},
	replacements = { {"bucket:bucket_water", "bucket:bucket_empty"} }
})

minetest.register_craft({
	output = "homedecor:cardboard_box 2",
	recipe = {
		{ "default:paper", "", "default:paper" },
		{ "default:paper", "default:paper", "default:paper" },
	},
})

minetest.register_craft({
	output = "homedecor:cardboard_box_big 2",
	recipe = {
		{ "default:paper", "", "default:paper" },
		{ "default:paper", "", "default:paper" },
		{ "default:paper", "default:paper", "default:paper" },
	},
})

minetest.register_craft( {
	output = "homedecor:openframe_bookshelf",
	recipe = {
		{"group:wood", "", "group:wood"},
		{"default:book", "default:book", "default:book"},
		{"group:wood", "", "group:wood"},
	},
})

-- japanese walls and mat

minetest.register_craft( {
	output = "homedecor:japanese_wall_top",
	recipe = {
		{"group:stick", "default:paper"},
		{"default:paper", "group:stick"},
		{"group:stick", "default:paper"}
	},
})

minetest.register_craft( {
	output = "homedecor:japanese_wall_top",
	recipe = {
		{"default:paper", "group:stick"},
		{"group:stick", "default:paper"},
		{"default:paper", "group:stick"}
	},
})

minetest.register_craft( {
	output = "homedecor:japanese_wall_middle",
	recipe = {
		{"homedecor:japanese_wall_top"}
	},
})

minetest.register_craft( {
	output = "homedecor:japanese_wall_bottom",
	recipe = {
		{"homedecor:japanese_wall_middle"}
	},
})

minetest.register_craft( {
	output = "homedecor:japanese_wall_top",
	recipe = {
		{"homedecor:japanese_wall_bottom"}
	},
})

minetest.register_craft( {
	output = "homedecor:tatami_mat",
	recipe = {
		{"farming:wheat", "farming:wheat", "farming:wheat"}
	},
})

minetest.register_craft( {
	output = "homedecor:pool_table",
	recipe = {
		{ "wool:dark_green", "wool:dark_green", "wool:dark_green" },
		{ "building_blocks:hardwood", "building_blocks:hardwood", "building_blocks:hardwood" },
		{ "building_blocks:slab_hardwood", "", "building_blocks:slab_hardwood" }
	},
})

minetest.register_craft({
	output = "homedecor:dartboard",
	recipe = {
		{"dye:black", "basic_materials:plastic_sheet", "dye:white"},
		{"basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet"},
		{"dye:dark_green", "basic_materials:plastic_sheet", "dye:red"}
	},
})

minetest.register_craft({
	output = "homedecor:piano",
	recipe = {
		{ "", "basic_materials:steel_wire", "building_blocks:hardwood" },
		{ "basic_materials:plastic_strip", "basic_materials:steel_wire", "building_blocks:hardwood" },
		{ "basic_materials:brass_ingot", "default:steelblock", "building_blocks:hardwood" }
	},
})

minetest.register_craft({
	output = "homedecor:wall_shelf 2",
	recipe = {
		{ "homedecor:wood_table_small_square", "homedecor:curtainrod_wood", "homedecor:curtainrod_wood" },
	},
})

minetest.register_craft({
	output = "homedecor:trophy 3",
	recipe = {
		{ "default:gold_ingot","","default:gold_ingot" },
		{ "","default:gold_ingot","" },
		{ "group:wood","default:gold_ingot","group:wood" }
	},
})

minetest.register_craft({
	output = "homedecor:sportbench",
	recipe = {
		{ "stairs:slab_steelblock","basic_materials:steel_bar","stairs:slab_steelblock" },
		{ "default:steel_ingot","wool:black","default:steel_ingot" },
		{ "default:steel_ingot","wool:black","default:steel_ingot" }
	},
})

minetest.register_craft({
	output = "homedecor:skateboard",
	recipe = {
		{ "dye:yellow","dye:green","dye:blue" },
		{ "homedecor:wood_table_small_square","homedecor:wood_table_small_square","homedecor:wood_table_small_square" },
		{ "default:steel_ingot","","default:steel_ingot" }
	},
})

minetest.register_craft({
	output = "homedecor:spiral_staircase",
	recipe = {
		{ "default:steelblock", "homedecor:pole_wrought_iron", "" },
		{ "", "homedecor:pole_wrought_iron", "default:steelblock" },
		{ "default:steelblock", "homedecor:pole_wrought_iron", "" }
	},
})

minetest.register_craftitem(":homedecor:flower_pot_small", {
	description = S("Small Flower Pot"),
	inventory_image = "homedecor_flowerpot_small_inv.png"
})

minetest.register_craft( {
	output = "homedecor:flower_pot_small",
	recipe = {
		{ "default:clay_brick", "", "default:clay_brick" },
		{ "", "default:clay_brick", "" }
	}
})

minetest.register_craft( {
	output = "homedecor:flower_pot_small 3",
	recipe = { { "homedecor:flower_pot_terracotta" } }
})

for i in ipairs(homedecor_misc.banister_materials) do

	local name    = homedecor_misc.banister_materials[i][1]
	local topmat  = homedecor_misc.banister_materials[i][5]
	local vertmat = homedecor_misc.banister_materials[i][6]
	local dye1    = homedecor_misc.banister_materials[i][7]
	local dye2    = homedecor_misc.banister_materials[i][8]

	minetest.register_craft({
		output = "homedecor:banister_"..name.."_horizontal 2",
		recipe = {
			{ topmat,  "",      dye1   },
			{ vertmat, topmat,  ""     },
			{ dye2,    vertmat, topmat }
		},
	})
end

unifieddyes.register_color_craft({
	output = "",
	palette = "split",
	neutral_node = "homedecor:banister_wood_horizontal",
	type = "shapeless",
	output_prefix = "homedecor:banister_wood_horizontal_",
	output_suffix = "",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE",
	}
})

-- Japanese-style wood/paper wall pieces and door

local jp_cbox = {
	type = "fixed",
	fixed = {-0.5, -0.5, 0, 0.5, 0.5, 0.0625},
}

minetest.register_node(":homedecor:japanese_wall_top", {
	description = S("Japanese wall (top)"),
	drawtype = "mesh",
	mesh = "homedecor_wall_japanese_top.obj",
	tiles = {
		homedecor.lux_wood,
		"homedecor_japanese_paper.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3},
	selection_box = jp_cbox,
	collision_box = jp_cbox,
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node(":homedecor:japanese_wall_middle", {
	description = S("Japanese wall"),
	drawtype = "mesh",
	mesh = "homedecor_wall_japanese_middle.obj",
	tiles = {
		homedecor.lux_wood,
		"homedecor_japanese_paper.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3},
	selection_box = jp_cbox,
	collision_box = jp_cbox,
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node(":homedecor:japanese_wall_bottom", {
	description = S("Japanese wall (bottom)"),
	drawtype = "mesh",
	mesh = "homedecor_wall_japanese_bottom.obj",
	tiles = {
		homedecor.lux_wood,
		"homedecor_japanese_paper.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3},
	selection_box = jp_cbox,
	collision_box = jp_cbox,
	sounds = default.node_sound_wood_defaults(),
})

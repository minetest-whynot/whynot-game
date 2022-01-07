-- This file supplies Kitchen stuff like refrigerators, sinks, etc.

local S = minetest.get_translator("homedecor_kitchen")

-- steel-textured fridge
homedecor.register("refrigerator_steel", {
	mesh = "homedecor_refrigerator.obj",
	tiles = { "homedecor_refrigerator_steel.png" },
	inventory_image = "homedecor_refrigerator_steel_inv.png",
	description = S("Refrigerator (stainless steel)"),
	groups = {snappy=3},
	sounds = default.node_sound_stone_defaults(),
	selection_box = homedecor.nodebox.slab_y(2),
	collision_box = homedecor.nodebox.slab_y(2),
	expand = { top="placeholder" },
	infotext=S("Refrigerator"),
	inventory = {
		size=50,
		lockable=true,
	},
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.rotate_simple or nil,
})

-- white, enameled fridge
homedecor.register("refrigerator_white", {
	mesh = "homedecor_refrigerator.obj",
	tiles = { "homedecor_refrigerator_white.png" },
	inventory_image = "homedecor_refrigerator_white_inv.png",
	description = S("Refrigerator"),
	groups = {snappy=3},
	selection_box = homedecor.nodebox.slab_y(2),
	collision_box = homedecor.nodebox.slab_y(2),
	sounds = default.node_sound_stone_defaults(),
	expand = { top="placeholder" },
	infotext=S("Refrigerator"),
	inventory = {
		size=50,
		lockable=true,
	},
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.rotate_simple or nil,
})

minetest.register_alias("homedecor:refrigerator_white_bottom", "homedecor:refrigerator_white")
minetest.register_alias("homedecor:refrigerator_white_top", "air")

minetest.register_alias("homedecor:refrigerator_steel_bottom", "homedecor:refrigerator_steel")
minetest.register_alias("homedecor:refrigerator_steel_top", "air")

minetest.register_alias("homedecor:refrigerator_white_bottom_locked", "homedecor:refrigerator_white_locked")
minetest.register_alias("homedecor:refrigerator_white_top_locked", "air")
minetest.register_alias("homedecor:refrigerator_locked", "homedecor:refrigerator_white_locked")

minetest.register_alias("homedecor:refrigerator_steel_bottom_locked", "homedecor:refrigerator_steel_locked")
minetest.register_alias("homedecor:refrigerator_steel_top_locked", "air")

-- kitchen "furnaces"
homedecor.register_furnace("oven", {
	description = S("Oven"),
	tile_format = "homedecor_oven_%s%s.png",
	output_slots = 4,
	output_width = 2,
	cook_speed = 1.25,
})

homedecor.register_furnace("oven_steel", {
	description = S("Oven (stainless steel)"),
	tile_format = "homedecor_oven_steel_%s%s.png",
	output_slots = 4,
	output_width = 2,
	cook_speed = 1.25,
})

homedecor.register_furnace("microwave_oven", {
	description = S("Microwave Oven"),
	tiles = {
		"homedecor_microwave_top.png", "homedecor_microwave_top.png^[transformR180",
		"homedecor_microwave_top.png^[transformR270", "homedecor_microwave_top.png^[transformR90",
		"homedecor_microwave_top.png^[transformR180", "homedecor_microwave_front.png"
	},
	tiles_active = {
		"homedecor_microwave_top.png", "homedecor_microwave_top.png^[transformR180",
		"homedecor_microwave_top.png^[transformR270", "homedecor_microwave_top.png^[transformR90",
		"homedecor_microwave_top.png^[transformR180", "homedecor_microwave_front_active.png"
	},
	output_slots = 2,
	output_width = 2,
	cook_speed = 1.5,
	extra_nodedef_fields = {
		node_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, -0.125, 0.5, 0.125, 0.5 },
		},
	},
})

homedecor.register("dishwasher", {
	description = S("Dishwasher"),
	drawtype = "nodebox",
	tiles = {
		"homedecor_dishwasher_top.png",
		"homedecor_dishwasher_bottom.png",
		"homedecor_dishwasher_sides.png",
		"homedecor_dishwasher_sides.png^[transformFX",
		"homedecor_dishwasher_back.png",
		"homedecor_dishwasher_front.png"
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
			{-0.5, -0.5, -0.5, 0.5, 0.5, -0.4375},
			{-0.5, -0.5, -0.5, 0.5, 0.1875, 0.1875},
			{-0.4375, -0.5, -0.5, 0.4375, 0.4375, 0.4375},
		}
	},
	selection_box = { type = "regular" },
	sounds = default.node_sound_stone_defaults(),
	groups = { snappy = 3 },
})

local materials = { ["granite"] = S("granite"), ["marble"] = S("marble"), ["steel"] = S("steel"), ["wood"] = S("wood") }

for m, m_loc in pairs(materials) do
homedecor.register("dishwasher_"..m, {
	description = S("Dishwasher (@1)", m_loc),
	tiles = {
		"homedecor_kitchen_cabinet_top_"..m..".png",
		"homedecor_dishwasher_bottom.png",
		"homedecor_dishwasher_sides.png",
		"homedecor_dishwasher_sides.png^[transformFX",
		"homedecor_dishwasher_back.png",
		"homedecor_dishwasher_front.png"
	},
	groups = { snappy = 3 },
	sounds = default.node_sound_stone_defaults(),
})
end

local cabinet_sides = "(default_wood.png^[transformR90)^homedecor_kitchen_cabinet_bevel.png"
local cabinet_sides_colored = "(homedecor_generic_wood_plain.png^[transformR90)^homedecor_kitchen_cabinet_bevel.png"

local ic_cabinet_sides = string.gsub(cabinet_sides, "%^", "&")
local ic_cabinet_sides_colored = string.gsub(cabinet_sides_colored, "%^", "&")

local cabinet_bottom = "(default_wood.png^[colorize:#000000:100)^homedecor_kitchen_cabinet_bevel.png"
local cabinet_bottom_colored = "homedecor_generic_wood_plain.png^homedecor_kitchen_cabinet_bevel.png"

local function N_(x) return x end

local counter_materials = { "", N_("granite"), N_("marble"), N_("steel") }

homedecor.kitchen_convert_nodes = {}

for _, mat in ipairs(counter_materials) do

	local desc = S("Kitchen Cabinet")
	local desc2 = S("Kitchen Cabinet with drawers")
	local material = ""

	if mat ~= "" then
		desc = S("Kitchen Cabinet (@1 top)", S(mat))
		desc2 = S("Kitchen Cabinet with drawers (@1 top)", S(mat))
		material = "_"..mat
	end

	homedecor.register("kitchen_cabinet_colorable"..material, {
		description = desc,
		tiles = {
			'homedecor_kitchen_cabinet_top'..material..'.png',
			cabinet_bottom,
			cabinet_sides,
			cabinet_sides,
			cabinet_sides,
			'homedecor_kitchen_cabinet_front.png^homedecor_kitchen_cabinet_bevel.png'
		},
		inventory_image = "[inventorycube"
			.."{homedecor_kitchen_cabinet_top"..material..".png"
			.."{homedecor_kitchen_cabinet_front.png"
			.."{"..ic_cabinet_sides,
		mesh = "homedecor_kitchen_cabinet.obj",
		paramtype2 = "wallmounted",
		palette = "unifieddyes_palette_colorwallmounted.png",
		airbrush_replacement_node = "homedecor:kitchen_cabinet_colored"..material,
		place_param2 = 0,
		groups = { snappy = 3, ud_param2_colorable = 1},
		sounds = default.node_sound_wood_defaults(),
		infotext=S("Kitchen Cabinet"),
		inventory = {
			size=24,
			lockable=true,
		},
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
		end
	})

	homedecor.register("kitchen_cabinet_colored"..material, {
		description = desc,
		tiles = {
			{name = 'homedecor_kitchen_cabinet_top'..material..'.png', color = 0xFFFFFFFF},
			{name = cabinet_bottom, color = 0xFFFFFFFF },
			cabinet_sides_colored,
			cabinet_sides_colored,
			cabinet_sides_colored,
			'homedecor_kitchen_cabinet_colored_front.png^homedecor_kitchen_cabinet_bevel.png'
		},
		inventory_image = "[inventorycube"
			.."{homedecor_kitchen_cabinet_top"..material..".png"
			.."{homedecor_kitchen_cabinet_front.png"
			.."{"..ic_cabinet_sides_colored,
		mesh = "homedecor_kitchen_cabinet.obj",
		paramtype2 = "colorwallmounted",
		palette = "unifieddyes_palette_colorwallmounted.png",
		groups = { snappy = 3, ud_param2_colorable = 1, not_in_creative_inventory = 1 },
		sounds = default.node_sound_wood_defaults(),
		infotext=S("Kitchen Cabinet"),
		inventory = {
			size=24,
			lockable=true,
		},
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
		end
	})

	homedecor.register("kitchen_cabinet_colorable_with_drawers"..material, {
		description = desc2,
		tiles = {
			'homedecor_kitchen_cabinet_top'..material..'.png',
			cabinet_bottom,
			cabinet_sides,
			cabinet_sides,
			cabinet_sides,
			'homedecor_kitchen_cabinet_front_with_drawers.png^homedecor_kitchen_cabinet_bevel.png'
		},
		inventory_image = "[inventorycube"
			.."{homedecor_kitchen_cabinet_top"..material..".png"
			.."{homedecor_kitchen_cabinet_front_with_drawers.png"
			.."{"..ic_cabinet_sides,
		mesh = "homedecor_kitchen_cabinet.obj",
		paramtype2 = "wallmounted",
		palette = "unifieddyes_palette_colorwallmounted.png",
		airbrush_replacement_node = "homedecor:kitchen_cabinet_colored_with_drawers"..material,
		groups = { snappy = 3, ud_param2_colorable = 1},
		sounds = default.node_sound_wood_defaults(),
		infotext=S("Kitchen Cabinet with drawers"),
		inventory = {
			size=24,
			lockable=true,
		},
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
		end
	})

	homedecor.register("kitchen_cabinet_colored_with_drawers"..material, {
		description = desc2,
		tiles = {
			{name = 'homedecor_kitchen_cabinet_top'..material..'.png', color = 0xFFFFFFFF},
			{name = cabinet_bottom, color = 0xFFFFFFFF },
			cabinet_sides_colored,
			cabinet_sides_colored,
			cabinet_sides_colored,
			'homedecor_kitchen_cabinet_colored_front_with_drawers.png^homedecor_kitchen_cabinet_bevel.png'
		},
		inventory_image = "[inventorycube"
			.."{homedecor_kitchen_cabinet_top"..material..".png"
			.."{homedecor_kitchen_cabinet_colored_front_with_drawers.png"
			.."{"..ic_cabinet_sides_colored,
		mesh = "homedecor_kitchen_cabinet.obj",
		paramtype2 = "colorwallmounted",
		palette = "unifieddyes_palette_colorwallmounted.png",
		groups = { snappy = 3, ud_param2_colorable = 1, not_in_creative_inventory = 1 },
		sounds = default.node_sound_wood_defaults(),
		infotext=S("Kitchen Cabinet with drawers"),
		inventory = {
			size=24,
			lockable=true,
		},
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
		end
	})

	homedecor.kitchen_convert_nodes[#homedecor.kitchen_convert_nodes + 1] = "homedecor:kitchen_cabinet"..material
	homedecor.kitchen_convert_nodes[#homedecor.kitchen_convert_nodes + 1] = "homedecor:kitchen_cabinet"..material.."_locked"

end

local kitchen_cabinet_half_box = homedecor.nodebox.slab_z(0.5, 0.5)

homedecor.register("kitchen_cabinet_colorable_half", {
	description = S('Half-height Kitchen Cabinet (on ceiling)'),
	tiles = {
		cabinet_sides,
		cabinet_bottom,
		cabinet_sides,
		cabinet_sides,
		cabinet_sides,
		'homedecor_kitchen_cabinet_front_half.png^homedecor_kitchen_cabinet_half_bevel.png'
	},
	mesh = "homedecor_kitchen_cabinet_half.obj",
	paramtype2 = "wallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	airbrush_replacement_node = "homedecor:kitchen_cabinet_colored_half",
	place_param2 = 0,
	selection_box = kitchen_cabinet_half_box,
	node_box = kitchen_cabinet_half_box,
	groups = { snappy = 3, ud_param2_colorable = 1 },
	sounds = default.node_sound_wood_defaults(),
	infotext=S("Kitchen Cabinet"),
	inventory = {
		size=12,
		lockable=true,
	},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end
})

homedecor.kitchen_convert_nodes[#homedecor.kitchen_convert_nodes + 1] = "homedecor:kitchen_cabinet_half"
homedecor.kitchen_convert_nodes[#homedecor.kitchen_convert_nodes + 1] = "homedecor:kitchen_cabinet_half_locked"

homedecor.register("kitchen_cabinet_colored_half", {
	description = S('Half-height Kitchen Cabinet (on ceiling)'),
	tiles = {
		{ name = cabinet_sides, color = 0xFFFFFFFF },
		cabinet_bottom_colored,
		cabinet_sides_colored,
		cabinet_sides_colored,
		cabinet_sides_colored,
		'homedecor_kitchen_cabinet_colored_front_half.png^homedecor_kitchen_cabinet_half_bevel.png'
	},
	mesh = "homedecor_kitchen_cabinet_half.obj",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	selection_box = kitchen_cabinet_half_box,
	node_box = kitchen_cabinet_half_box,
	groups = { snappy = 3, ud_param2_colorable = 1, not_in_creative_inventory = 1  },
	sounds = default.node_sound_wood_defaults(),
	infotext=S("Kitchen Cabinet"),
	inventory = {
		size=12,
		lockable=true,
	},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end
})

homedecor.register("kitchen_cabinet_colorable_with_sink", {
	description = S("Kitchen Cabinet with sink"),
	mesh = "homedecor_kitchen_sink.obj",
	tiles = {
		"homedecor_kitchen_sink_top.png",
		cabinet_bottom,
		cabinet_sides,
		cabinet_sides,
		cabinet_sides,
		"homedecor_kitchen_cabinet_front.png^homedecor_kitchen_cabinet_bevel.png"
	},
		inventory_image = "[inventorycube"
			.."{homedecor_kitchen_sink_top.png"
			.."{homedecor_kitchen_cabinet_front.png"
			.."{"..ic_cabinet_sides,
	paramtype2 = "wallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	airbrush_replacement_node = "homedecor:kitchen_cabinet_colored_with_sink",
	place_param2 = 0,
	groups = { snappy = 3, ud_param2_colorable = 1 },
	sounds = default.node_sound_wood_defaults(),
	infotext=S("Under-sink cabinet"),
	inventory = {
		size=16,
		lockable=true,
	},
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, -8/16, -8/16,  8/16, 6/16,  8/16 },
			{ -8/16,  6/16, -8/16, -6/16, 8/16,  8/16 },
			{  6/16,  6/16, -8/16,  8/16, 8/16,  8/16 },
			{ -8/16,  6/16, -8/16,  8/16, 8/16, -6/16 },
			{ -8/16,  6/16,  6/16,  8/16, 8/16,  8/16 },
		}
	},
	on_destruct = function(pos)
		homedecor.stop_particle_spawner({x=pos.x, y=pos.y+1, z=pos.z})
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end
})

homedecor.kitchen_convert_nodes[#homedecor.kitchen_convert_nodes + 1] = "homedecor:kitchen_cabinet_with_sink"
homedecor.kitchen_convert_nodes[#homedecor.kitchen_convert_nodes + 1] = "homedecor:kitchen_cabinet_with_sink_locked"

homedecor.register("kitchen_cabinet_colored_with_sink", {
	description = S("Kitchen Cabinet with sink"),
	mesh = "homedecor_kitchen_sink.obj",
	tiles = {
		{ name = "homedecor_kitchen_sink_top.png", color = 0xFFFFFFFF },
		{ name = cabinet_bottom, color = 0xFFFFFFFF},
		cabinet_sides_colored,
		cabinet_sides_colored,
		cabinet_sides_colored,
		"homedecor_kitchen_cabinet_colored_front.png^homedecor_kitchen_cabinet_bevel.png",
	},
		inventory_image = "[inventorycube"
			.."{homedecor_kitchen_sink_top.png"
			.."{homedecor_kitchen_cabinet_front.png"
			.."{"..ic_cabinet_sides_colored,
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	groups = { snappy = 3, ud_param2_colorable = 1,  not_in_creative_inventory = 1 },
	sounds = default.node_sound_wood_defaults(),
	infotext=S("Under-sink cabinet"),
	inventory = {
		size=16,
		lockable=true,
	},
	node_box = {
		type = "fixed",
		fixed = {
			{ -8/16, -8/16, -8/16,  8/16, 6/16,  8/16 },
			{ -8/16,  6/16, -8/16, -6/16, 8/16,  8/16 },
			{  6/16,  6/16, -8/16,  8/16, 8/16,  8/16 },
			{ -8/16,  6/16, -8/16,  8/16, 8/16, -6/16 },
			{ -8/16,  6/16,  6/16,  8/16, 8/16,  8/16 },
		}
	},
	on_destruct = function(pos)
		homedecor.stop_particle_spawner({x=pos.x, y=pos.y+1, z=pos.z})
	end,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end
})

local cp_cbox = {
	type = "fixed",
	fixed = { -0.375, -0.5, -0.5, 0.375, -0.3125, 0.3125 }
}

homedecor.register("copper_pans", {
	description = S("Copper pans"),
	mesh = "homedecor_copper_pans.obj",
	tiles = { "homedecor_polished_copper.png" },
	inventory_image = "homedecor_copper_pans_inv.png",
	groups = { snappy=3 },
	selection_box = cp_cbox,
	walkable = false,
	on_place = minetest.rotate_node
})

local kf_cbox = {
	type = "fixed",
	fixed = { -2/16, -8/16, 1/16, 2/16, -1/16, 8/16 }
}

homedecor.register("kitchen_faucet", {
	mesh = "homedecor_kitchen_faucet.obj",
	tiles = { "homedecor_generic_metal_bright.png" },
	inventory_image = "homedecor_kitchen_faucet_inv.png",
	description = S("Kitchen Faucet"),
	groups = {snappy=3},
	selection_box = kf_cbox,
	walkable = false,
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local below = minetest.get_node_or_nil({x=pos.x, y=pos.y-1, z=pos.z})
		if below and string.find(below.name, "homedecor:.*sink") then
			local particledef = {
				outlet      = { x = 0, y = -0.19, z = 0.13 },
				velocity_x  = { min = -0.05, max = 0.05 },
				velocity_y  = -0.3,
				velocity_z  = { min = -0.1,  max = 0 },
				spread      = 0
			}
			homedecor.start_particle_spawner(pos, node, particledef, "homedecor_faucet")
		end
		return itemstack
	end,
	on_destruct = homedecor.stop_particle_spawner
})

homedecor.register("paper_towel", {
	mesh = "homedecor_paper_towel.obj",
	tiles = {
		"homedecor_generic_quilted_paper.png",
		"default_wood.png"
	},
	inventory_image = "homedecor_paper_towel_inv.png",
	description = S("Paper towels"),
	groups = { snappy=3 },
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = { -0.4375, 0.125, 0.0625, 0.4375, 0.4375, 0.5 }
	},
})

-- crafting


minetest.register_craft({
        output = "homedecor:oven_steel",
        recipe = {
		{"basic_materials:heating_element", "default:steel_ingot", "basic_materials:heating_element", },
		{"default:steel_ingot", "moreblocks:iron_glass", "default:steel_ingot", },
		{"default:steel_ingot", "basic_materials:heating_element", "default:steel_ingot", },
	}
})

minetest.register_craft({
        output = "homedecor:oven_steel",
        recipe = {
		{"basic_materials:heating_element", "default:steel_ingot", "basic_materials:heating_element", },
		{"default:steel_ingot", "default:glass", "default:steel_ingot", },
		{"default:steel_ingot", "basic_materials:heating_element", "default:steel_ingot", },
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:oven",
	recipe = {
		"homedecor:oven_steel",
		"dye:white",
		"dye:white",
	}
})

minetest.register_craft({
        output = "homedecor:microwave_oven 2",
        recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot", },
		{"default:steel_ingot", "moreblocks:iron_glass", "basic_materials:ic", },
		{"default:steel_ingot", "default:copper_ingot", "basic_materials:energy_crystal_simple", },
	}
})

minetest.register_craft({
        output = "homedecor:microwave_oven 2",
        recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot", },
		{"default:steel_ingot", "default:glass", "basic_materials:ic", },
		{"default:steel_ingot", "default:copper_ingot", "basic_materials:energy_crystal_simple", },
	}
})

minetest.register_craft({
	output = "homedecor:refrigerator_steel",
	recipe = {
		{"default:steel_ingot", "homedecor:glowlight_small_cube", "default:steel_ingot", },
		{"default:steel_ingot", "default:copperblock", "default:steel_ingot", },
		{"default:steel_ingot", "default:clay", "default:steel_ingot", },
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:refrigerator_white",
	recipe = {
		"homedecor:refrigerator_steel",
		"dye:white",
		"dye:white",
		"dye:white",
	}
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_colorable",
        recipe = {
		{"group:wood", "group:stick", "group:wood", },
		{"group:wood", "group:stick", "group:wood", },
		{"group:wood", "group:stick", "group:wood", },
	}
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_colorable_steel",
        recipe = {
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
			{"", "homedecor:kitchen_cabinet_colorable", ""},
	}
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_colorable_steel",
        recipe = {
			{"moreblocks:slab_steelblock_1"},
			{ "homedecor:kitchen_cabinet_colorable" },
	}
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_colorable_marble",
        recipe = {
			{"building_blocks:slab_marble"},
			{"homedecor:kitchen_cabinet_colorable"},
	}
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_colorable_marble",
        recipe = {
			{"technic:slab_marble_1"},
			{"homedecor:kitchen_cabinet_colorable"},
	}
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_colorable_granite",
        recipe = {
			{"technic:slab_granite_1"},
			{"homedecor:kitchen_cabinet_colorable"},
	}
})

minetest.register_craft({
	type = "shapeless",
        output = "homedecor:kitchen_cabinet_colorable_half 2",
        recipe = { "homedecor:kitchen_cabinet_colorable" }
})

minetest.register_craft({
        output = "homedecor:kitchen_cabinet_colorable_with_sink",
        recipe = {
		{"group:wood", "default:steel_ingot", "group:wood", },
		{"group:wood", "default:steel_ingot", "group:wood", },
		{"group:wood", "group:stick", "group:wood", },
	}
})

minetest.register_craft( {
    output = "homedecor:dishwasher",
    recipe = {
		{ "basic_materials:ic",  "building_blocks:slab_grate_1",    "default:steel_ingot",  },
		{ "default:steel_ingot", "homedecor:shower_head",           "basic_materials:motor" },
		{ "default:steel_ingot", "basic_materials:heating_element", "bucket:bucket_water"   }
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher",
    recipe = {
		{ "basic_materials:ic", "homedecor:fence_chainlink", "default:steel_ingot",  },
		{ "default:steel_ingot", "homedecor:shower_head", "basic_materials:motor" },
		{ "default:steel_ingot", "basic_materials:heating_element", "bucket:bucket_water" }
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_wood",
    recipe = {
		{ "stairs:slab_wood" },
		{ "homedecor:dishwasher" },
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_wood",
    recipe = {
		{ "moreblocks:slab_wood" },
		{ "homedecor:dishwasher" },
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_wood",
    recipe = {
		{ "moreblocks:slab_wood_1" },
		{ "homedecor:dishwasher" },
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_steel",
    recipe = {
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
		{ "", "homedecor:dishwasher", "" },
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_steel",
    recipe = {
		{ "moreblocks:slab_steelblock_1" },
		{ "homedecor:dishwasher" },
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_marble",
    recipe = {
		{ "building_blocks:slab_marble" },
		{ "homedecor:dishwasher" },
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_marble",
    recipe = {
		{ "technic:slab_marble_1" },
		{ "homedecor:dishwasher" },
    },
})

minetest.register_craft( {
    output = "homedecor:dishwasher_granite",
    recipe = {
		{ "technic:slab_granite_1" },
		{ "homedecor:dishwasher" },
    },
})

minetest.register_craft( {
        output = "homedecor:kitchen_faucet",
        recipe = {
			{ "", "default:steel_ingot" },
			{ "default:steel_ingot", "" },
			{ "homedecor:taps", "" }
        },
})

minetest.register_craft( {
        output = "homedecor:kitchen_faucet",
        recipe = {
			{ "default:steel_ingot","" },
			{ "", "default:steel_ingot" },
			{ "", "homedecor:taps" }
        },
})

minetest.register_craft( {
        output = "homedecor:cutlery_set",
        recipe = {
			{ "", "vessels:drinking_glass", "" },
			{ "basic_materials:steel_strip", "building_blocks:slab_marble", "basic_materials:steel_strip" },
        },
})

minetest.register_craft( {
        output = "homedecor:cutlery_set",
        recipe = {
			{ "", "vessels:drinking_glass", "" },
			{ "basic_materials:steel_strip", "building_blocks:micro_marble_1", "basic_materials:steel_strip" },
        },
})

minetest.register_craft({
	output = "homedecor:copper_pans",
	recipe = {
		{ "basic_materials:copper_strip","","basic_materials:copper_strip" },
		{ "default:copper_ingot","","default:copper_ingot" },
		{ "default:copper_ingot","","default:copper_ingot" }
	},
})

minetest.register_craft({
    output = "homedecor:paper_towel",
    recipe = {
		{ "homedecor:toilet_paper", "homedecor:toilet_paper" }
    },
})

minetest.register_lbm({
	name = ":homedecor:convert_kitchen_cabinets",
	label = "Convert homedecor kitchen cabinets to use [color]wallmounted",
	run_at_every_load = false,
	nodenames = homedecor.kitchen_convert_nodes,
	action = function(pos, node)
		local name = node.name
		local newname = string.gsub(name, "_cabinet", "_cabinet_colorable")

		local old_fdir = math.floor(node.param2 % 32)
		local new_fdir = 3

		if old_fdir == 0 then
			new_fdir = 3
		elseif old_fdir == 1 then
			new_fdir = 4
		elseif old_fdir == 2 then
			new_fdir = 2
		elseif old_fdir == 3 then
			new_fdir = 5
		end

		minetest.swap_node(pos, { name = newname, param2 = new_fdir })
	end
})

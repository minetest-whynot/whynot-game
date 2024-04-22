local S = minetest.get_translator("building_blocks")

local function building_blocks_stairs(nodename, def)

	if def.groups and (def.groups.crumbly or def.groups.oddly_breakable_by_hand) then
		def.groups["handy"]=1
		def._mcl_hardness=0.6
	elseif def.groups and (def.groups.snappy or def.groups.choppy) then
		def.groups["axey"]=5
		def._mcl_hardness=1.6
	elseif def.groups and (def.groups.cracky or def.groups.crumbly) then
		def.groups["pickaxey"]=5
		def._mcl_hardness=1.6
	end

	def.is_ground_content = def.is_ground_content == true

	minetest.register_node(nodename, def)
	if minetest.get_modpath("moreblocks") then
		local mod, name = nodename:match("(.*):(.*)")
		stairsplus:register_all(mod, name, nodename, def)

		minetest.register_alias("stairs:slab_" .. name, mod .. ":slab_" .. name)
		minetest.register_alias("stairs:stair_" .. name, mod .. ":stair_" .. name)
		minetest.register_alias("stairs:stair_inner_" .. name, mod .. ":stair_" .. name .. "_inner")
		minetest.register_alias("stairs:stair_outer_" .. name, mod .. ":stair_" .. name .. "_outer")
	end
end

building_blocks_stairs("building_blocks:grate", {
	drawtype = "glasslike",
	description = S("Grate"),
	tiles = {"building_blocks_grate.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	use_texture_alpha = "clip",
	groups = {cracky=1, dig_generic=3},
	_sound_def = {
		key = "node_sound_metal_defaults",
	},
})
building_blocks_stairs("building_blocks:smoothglass", {
	drawtype = "glasslike",
	description = S("Streak Free Glass"),
	tiles = {"building_blocks_sglass.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	use_texture_alpha = "clip",
	groups = {snappy=3,cracky=3,oddly_breakable_by_hand=3},
	_sound_def = {
		key = "node_sound_glass_defaults",
	},
})
building_blocks_stairs("building_blocks:woodglass", {
	drawtype = "glasslike",
	description = S("Wood Framed Glass"),
	tiles = {"building_blocks_wglass.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	use_texture_alpha = "clip",
	groups = {snappy=3,cracky=3,oddly_breakable_by_hand=3},
	_sound_def = {
		key = "node_sound_glass_defaults",
	},
})

building_blocks_stairs("building_blocks:Adobe", {
	tiles = {"building_blocks_Adobe.png"},
	description = S("Adobe"),
	is_ground_content = false,
	groups = {crumbly=3, dig_stone=2},
	_sound_def = {
		key = "node_sound_stone_defaults",
	},
})
local grasstex = {
	homedecor.textures.grass.top,
	homedecor.textures.grass.dirt,
	homedecor.textures.grass.side
}
building_blocks_stairs("building_blocks:fakegrass", {
	tiles = grasstex,
	description = S("Fake Grass"),
	is_ground_content = false,
	groups = {crumbly=3, dig_sand=3},
	_sound_def = {
		key = "node_sound_dirt_defaults",
	},
})
building_blocks_stairs("building_blocks:hardwood", {
	tiles = {"building_blocks_hardwood.png"},
	is_ground_content = false,
	description = S("Hardwood"),
	groups = {choppy=1,flammable=1, dig_tree=1},
	_sound_def = {
		key = "node_sound_wood_defaults",
	},
})
building_blocks_stairs("building_blocks:Roofing", {
	tiles = {"building_blocks_Roofing.png"},
	is_ground_content = false,
	description = S("Roof block"),
	groups = {snappy=3, dig_generic=4},
	_sound_def = {
		key = "node_sound_stone_defaults",
	},
})
building_blocks_stairs("building_blocks:Tar", {
	description = S("Tar"),
	tiles = {"building_blocks_tar.png"},
	is_ground_content = false,
	groups = {crumbly=1, tar_block = 1, dig_generic=4},
	_sound_def = {
		key = "node_sound_stone_defaults",
	},
})
building_blocks_stairs("building_blocks:Marble", {
	description = S("Marble"),
	tiles = {"building_blocks_marble.png"},
	is_ground_content = false,
	groups = {cracky=3, marble = 1, dig_stone=2},
	_sound_def = {
		key = "node_sound_stone_defaults",
	},
})

minetest.register_node("building_blocks:brobble_spread", {
	drawtype = "raillike",
	-- Translators: "Brobble" is a portmanteau of "Brick" and "Cobble".
	-- Translate however you see fit.
	description = S("Brobble Spread"),
	tiles = {"building_blocks_brobble.png"},
	inventory_image = "building_blocks_brobble_spread_inv.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
        -- but how to specify the dimensions for curved and sideways rails?
        fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {crumbly=3, dig_generic=4, handy=1},
	_mcl_hardness=0.6
})

if not minetest.get_modpath("moreblocks") or not minetest.get_modpath("gloopblocks") then
	local graveltex = homedecor.textures.gravel
	minetest.register_node("building_blocks:gravel_spread", {
		drawtype = "raillike",
		description = S("Gravel Spread"),
		tiles = {graveltex},
		inventory_image = "building_blocks_gravel_spread_inv.png",
		paramtype = "light",
		walkable = false,
		selection_box = {
			type = "fixed",
			-- but how to specify the dimensions for curved and sideways rails?
			fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
		},
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {crumbly=2, dig_generic=4, handy=1},
		_mcl_hardness=0.6,
		_sound_def = {
			key = "node_sound_dirt_defaults",
		},
	})
end

minetest.register_node("building_blocks:Tarmac_spread", {
	drawtype = "raillike",
	description = S("Tarmac Spread"),
	tiles = {"building_blocks_tar.png"},
	inventory_image = "building_blocks_tar_spread_inv.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
        -- but how to specify the dimensions for curved and sideways rails?
        fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky=3, dig_generic=4, pickaxey=5},
	_mcl_hardness=1.6,
	_sound_def = {
		key = "node_sound_dirt_defaults",
	},
})
minetest.register_node("building_blocks:terrycloth_towel", {
	drawtype = "raillike",
	description = S("Terrycloth towel"),
	tiles = {"building_blocks_towel.png"},
	inventory_image = "building_blocks_towel_inv.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
        -- but how to specify the dimensions for curved and sideways rails?
        fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {crumbly=3, dig_generic=4, handy=1},
	_mcl_hardness=0.6
})

minetest.register_node("building_blocks:BWtile", {
	drawtype = "nodebox",
	description = S("Chess board tiling"),
	tiles = {
		"building_blocks_BWtile.png",
		"building_blocks_BWtile.png^[transformR90",
		"building_blocks_BWtile.png^[transformR90",
		"building_blocks_BWtile.png^[transformR90",
		"building_blocks_BWtile.png",
		"building_blocks_BWtile.png"
	},
	inventory_image = "building_blocks_bwtile_inv.png",
	paramtype = "light",
	walkable = false,
	node_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {crumbly=3, dig_generic=4, handy=1},
	_mcl_hardness=0.6
})

minetest.register_node("building_blocks:Fireplace", {
	description = S("Fireplace"),
	tiles = {
		"building_blocks_cast_iron.png",
		"building_blocks_cast_iron.png",
		"building_blocks_cast_iron.png",
		"building_blocks_cast_iron_fireplace.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = minetest.LIGHT_MAX,
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky=2, dig_generic=4, pickaxey=5},
	_mcl_hardness=1.6,
	_sound_def = {
		key = "node_sound_stone_defaults",
	},
})

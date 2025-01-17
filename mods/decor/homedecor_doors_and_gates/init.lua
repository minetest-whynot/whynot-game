-- Node definitions for Homedecor doors

if not minetest.get_modpath("doors") or not minetest.get_modpath("default") then
	minetest.log(
		"action",
		"[homedecor_doors_and_gates]: minetest game not detected, disabling as this mod is minetest game only at this time"
	)
	return
end

local S = minetest.get_translator("homedecor_doors_and_gates")
local mesecons_mp = minetest.get_modpath("mesecons")
homedecor_doors_and_gates = {}

local door_list = {
	{
		name = "wood_plain",
		description = S("Plain Wooden Door"),
		sounds = default.node_sound_wood_defaults(),
		sound_open = "homedecor_door_open",
		sound_close = "homedecor_door_close",
		use_texture_alpha = "opaque",
	},
	{
		name = "exterior_fancy",
		description = S("Fancy Wood/Glass Door"),
		sounds = default.node_sound_wood_defaults(),
		sound_open = "homedecor_door_open",
		sound_close = "homedecor_door_close",
		mesh = "homedecor_door_fancy",
		use_texture_alpha = "blend",
	},
	{
		name = "french_oak",
		description = S("French door, Oak-colored"),
		sounds = default.node_sound_glass_defaults(),
		mesh = "homedecor_door_french",
		use_texture_alpha = "blend",
	},
	{
		name = "french_mahogany",
		description = S("French door, Mahogany-colored"),
		sounds = default.node_sound_glass_defaults(),
		mesh = "homedecor_door_french",
		use_texture_alpha = "blend",
	},
	{
		name = "french_white",
		description = S("French door, White"),
		sounds = default.node_sound_glass_defaults(),
		mesh = "homedecor_door_french",
		use_texture_alpha = "blend",
	},
	{
		name = "basic_panel",
		description = S("Basic white panel Door"),
		sounds = default.node_sound_wood_defaults(),
		sound_open = "homedecor_door_open",
		sound_close = "homedecor_door_close",
		use_texture_alpha = "opaque",
	},
	{
		name = "wrought_iron",
		description = S("Wrought Iron Gate/Door"),
		sounds = default.node_sound_metal_defaults(),
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
		mesh = "homedecor_door_wrought_iron",
		use_texture_alpha = "clip",
	},
	{
		name = "carolina",
		description = S("Wooden Carolina door"),
		sounds = default.node_sound_wood_defaults(),
		sound_open = "homedecor_door_open",
		sound_close = "homedecor_door_close",
		use_texture_alpha = "blend",
	},
	{
		name = "woodglass",
		description = S("Wooden door with glass insert, type 3"),
		sounds = default.node_sound_wood_defaults(),
		sound_open = "homedecor_door_open",
		sound_close = "homedecor_door_close",
		mesh = "homedecor_door_wood_glass_3",
		use_texture_alpha = "clip",
	},
	{
		name = "closet_mahogany",
		description = S("Mahogany Closet Door"),
		sounds = default.node_sound_wood_defaults(),
		mesh = "homedecor_door_closet",
		use_texture_alpha = "clip",
	},
	{
		name = "closet_oak",
		description = S("Oak Closet Door"),
		sounds = default.node_sound_wood_defaults(),
		mesh = "homedecor_door_closet",
		use_texture_alpha = "clip",
	},
}

local old_doors = {}

local door_types = {"_a", "_b", "_c", "_d"}
local door_conversion = {["_c"]="_a", ["_d"]="_b"}

local function generate_door(def)
	local default_settings = {
		tiles = {{ name = "homedecor_door_" .. def.name .. ".png", backface_culling = true }},
		inventory_image = "homedecor_door_" .. def.name .. "_inv.png",
		use_texture_alpha = def.use_texture_alpha or "blend",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		mesecons = {
			effector = {
				action_on = function(pos, node)
					local door = doors.get(pos)
					if door then door:open() end
				end,
				action_off = function(pos, node)
					local door = doors.get(pos)
					if door then door:close() end
				end,
				rules = minetest.global_exists("mesecon") and mesecon.rules.pplate or nil
			}
		},
	}

	for k, v in pairs(default_settings) do
		if not def[k] then def[k] = v end
	end

	def.name = nil

	return def
end

for _, door in ipairs(door_list) do
	local name, mesh = door.name, door.mesh
	doors.register("homedecor_" .. name, generate_door(door))

	--hack to get around doors not allowing custom meshes
	if mesh then
		for _, v in pairs(door_types) do
			if door_conversion[v] then v=door_conversion[v] end
			minetest.override_item("doors:homedecor_" .. name .. v, {
				mesh = mesh .. v .. ".obj"
			})
		end
	end

	--compatibility
	old_doors[#old_doors + 1] = "homedecor:door_"..name.."_left"
	old_doors[#old_doors + 1] = "homedecor:door_"..name.."_right"

	minetest.register_alias("doors:"..name.."_a", "doors:homedecor_"..name.."_a")
	minetest.register_alias("doors:"..name.."_b", "doors:homedecor_"..name.."_b")
end

-- Gates

local gate_list = {
	{ "picket",          S("Unpainted Picket Fence Gate") },
	{ "picket_white",    S("White Picket Fence Gate")     },
	{ "barbed_wire",     S("Barbed Wire Fence Gate")      },
	{ "chainlink",       S("Chainlink Fence Gate")        },
	{ "half_door",       S("\"Half\" Door")               },
	{ "half_door_white", S("\"Half\" Door (white)")       }
}

local gate_models_closed = {
	{{ -0.5, -0.5, 0.498, 0.5, 0.5, 0.498 }},

	{{ -0.5, -0.5, 0.498, 0.5, 0.5, 0.498 }},

	{{ -8/16, -8/16, 6/16, -6/16,  8/16,  8/16 },	-- left post
	 {  6/16, -8/16, 6/16,  8/16,  8/16,  8/16 },	-- right post
	 { -8/16,  7/16, 13/32, 8/16,  8/16, 15/32 },	-- top piece
	 { -8/16, -8/16, 13/32, 8/16, -7/16, 15/32 },	-- bottom piece
	 { -6/16, -8/16,  7/16, 6/16,  8/16,  7/16 }},	-- the wire

	{{ -8/16, -8/16,  6/16, -7/16,  8/16,  8/16 },	-- left post
	 {  6/16, -8/16,  6/16,  8/16,  8/16,  8/16 },	-- right post
	 { -8/16,  7/16, 13/32,  8/16,  8/16, 15/32 },	-- top piece
	 { -8/16, -8/16, 13/32,  8/16, -7/16, 15/32 },	-- bottom piece
	 { -8/16, -8/16,  7/16,  8/16,  8/16,  7/16 },	-- the chainlink itself
	 { -8/16, -3/16,  6/16, -6/16,  3/16,  8/16 }},	-- the lump representing the lock

	{{ -8/16, -8/16, 6/16, 8/16, 8/16, 8/16 }}, -- the whole door :P

	{{ -8/16, -8/16, 6/16, 8/16, 8/16, 8/16 }}, -- the whole door :P

}

local gate_models_open = {
	{{ 0.498, -0.5, -0.5, 0.498, 0.5, 0.5 }},

	{{ 0.498, -0.5, -0.5, 0.498, 0.5, 0.5 }},

	{{  6/16, -8/16, -8/16,  8/16,  8/16, -6/16 },	-- left post
	 {  6/16, -8/16,  6/16,  8/16,  8/16,  8/16 },	-- right post
	 { 13/32,  7/16, -8/16, 15/32,  8/16,  8/16 },	-- top piece
	 { 13/32, -8/16, -8/16, 15/32, -7/16,  8/16 },	-- bottom piece
	 {  7/16, -8/16, -6/16,  7/16,  8/16,  6/16 }},	-- the wire

	{{  6/16, -8/16, -8/16,  8/16,  8/16, -7/16 },	-- left post
	 {  6/16, -8/16,  6/16,  8/16,  8/16,  8/16 },	-- right post
	 { 13/32,  7/16, -8/16, 15/32,  8/16,  8/16 },	-- top piece
	 { 13/32, -8/16, -8/16, 15/32, -7/16,  8/16 },	-- bottom piece
	 {  7/16, -8/16, -8/16,  7/16,  8/16,  8/16 },	-- the chainlink itself
	 {  6/16, -3/16, -8/16,  8/16,  3/16, -6/16 }},	-- the lump representing the lock

	{{ 6/16, -8/16, -8/16, 8/16, 8/16, 8/16 }}, -- the whole door :P

	{{ 6/16, -8/16, -8/16, 8/16, 8/16, 8/16 }}, -- the whole door :P
}

for i, g in ipairs(gate_list) do

	local gate, gatedesc = unpack(g)

	local tiles = {
		"homedecor_gate_"..gate.."_tb.png",
		"homedecor_gate_"..gate.."_tb.png",
		"homedecor_gate_"..gate.."_lr.png",
		"homedecor_gate_"..gate.."_lr.png",
		"homedecor_gate_"..gate.."_fb.png^[transformFX",
		"homedecor_gate_"..gate.."_fb.png"
	}

	if gate == "barbed_wire" then
		tiles = {
			"homedecor_gate_barbed_wire_edges.png",
			"homedecor_gate_barbed_wire_edges.png",
			"homedecor_gate_barbed_wire_edges.png",
			"homedecor_gate_barbed_wire_edges.png",
			"homedecor_gate_barbed_wire_fb.png^[transformFX",
			"homedecor_gate_barbed_wire_fb.png"
		}
	end

	if gate == "picket" or gate == "picket_white" then
		tiles = {
			"blank.png",
			"blank.png",
			"blank.png",
			"blank.png",
			"homedecor_gate_"..gate.."_back.png",
			"homedecor_gate_"..gate.."_front.png"
		}
	end

    local def = {
		drawtype = "nodebox",
		description = gatedesc,
		tiles = tiles,
		paramtype = "light",
		use_texture_alpha = "clip",
		groups = {snappy=3, axey=5},
		is_ground_content = false,
		_mcl_hardness=1.6,
		sounds = default.node_sound_wood_defaults(),
		paramtype2 = "facedir",
		selection_box = {
			type = "fixed",
			fixed = { -0.5, -0.5, 0.4, 0.5, 0.5, 0.5 }
		},
		node_box = {
			type = "fixed",
			fixed = gate_models_closed[i]
		},
		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			homedecor_doors_and_gates.flip_gate(pos, node, clicker, gate, "closed")
			return itemstack
		end,
	}

	if mesecons_mp then
        def.mesecons = {
            effector = {
				rules = mesecon.rules.pplate,
                action_on = function(pos,node) homedecor_doors_and_gates.flip_gate(pos,node,nil,gate, "closed") end
            }
        }
	end

    -- gates when placed default to closed, closed.

	minetest.register_node(":homedecor:gate_"..gate.."_closed", def)

    -- this is either a terrible idea or a great one
    def = table.copy(def)
    def.groups.not_in_creative_inventory = 1
    def.selection_box.fixed = { 0.4, -0.5, -0.5, 0.5, 0.5, 0.5 }
    def.node_box.fixed = gate_models_open[i]
	def.tiles = {
		tiles[1].."^[transformR90",
		tiles[2].."^[transformR270",
		tiles[6],
		tiles[5],
		tiles[4],
		tiles[3]
	}
    def.drop = "homedecor:gate_"..gate.."_closed"
	def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        homedecor_doors_and_gates.flip_gate(pos, node, clicker, gate, "open")
        return itemstack
	end

	if mesecons_mp then
		def.mesecons.effector = {
			rules = mesecon.rules.pplate,
			action_off = function(pos,node) homedecor_doors_and_gates.flip_gate(pos,node,nil,gate, "open") end
		}
	end

	minetest.register_node(":homedecor:gate_"..gate.."_open", def)
end

minetest.register_alias("homedecor:fence_barbed_wire_gate_open",    "homedecor:gate_barbed_wire_open")
minetest.register_alias("homedecor:fence_barbed_wire_gate_closed",  "homedecor:gate_barbed_wire_closed")
minetest.register_alias("homedecor:fence_chainlink_gate_open",      "homedecor:gate_chainlink_open")
minetest.register_alias("homedecor:fence_chainlink_gate_closed",    "homedecor:gate_chainlink_closed")
minetest.register_alias("homedecor:fence_picket_gate_open",         "homedecor:gate_picket_open")
minetest.register_alias("homedecor:fence_picket_gate_closed",       "homedecor:gate_picket_closed")
minetest.register_alias("homedecor:fence_picket_gate_white_open",   "homedecor:gate_picket_white_open")
minetest.register_alias("homedecor:fence_picket_gate_white_closed", "homedecor:gate_picket_white_closed")

function homedecor_doors_and_gates.flip_gate(pos, node, player, gate, oc)


	local fdir = node.param2 or 0

	local gateresult
	if oc == "closed" then
		gateresult = "homedecor:gate_"..gate.."_open"
	else
		gateresult = "homedecor:gate_"..gate.."_closed"
	end

	minetest.set_node(pos, {name = gateresult, param2 = fdir})
    minetest.sound_play("homedecor_gate_open_close", {
		pos=pos,
		max_hear_distance = 5,
		gain = 2,
	})

    -- the following opens and closes gates below and above in sync with this one

    local above = {x=pos.x, y=pos.y+1, z=pos.z}
    local below = {x=pos.x, y=pos.y-1, z=pos.z}
    local nodeabove = minetest.get_node(above)
    local nodebelow = minetest.get_node(below)

	if string.find(nodeabove.name, "homedecor:gate_"..gate) then
        minetest.set_node(above, {name = gateresult, param2 = fdir})
	end

	if string.find(nodebelow.name, "homedecor:gate_"..gate) then
        minetest.set_node(below, {name = gateresult, param2 = fdir})
	end
end

-- Japanese-style wood/paper door
homedecor.register("door_japanese_closed", {
	description = S("Japanese-style door"),
	inventory_image = "homedecor_door_japanese_inv.png",
	tiles = {
		homedecor.lux_wood,
		"homedecor_japanese_paper.png"
	},
	mesh = "homedecor_door_japanese_closed.obj",
	groups = { snappy = 3 },
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, 0.5, 1.5, 0.0625},
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.0625, 0.5, 1.5, 0},
	},
	expand = { top = "placeholder" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "homedecor:door_japanese_open", param2 = node.param2})
		return itemstack
	end
})

homedecor.register("door_japanese_open", {
	tiles = {
		homedecor.lux_wood,
		"homedecor_japanese_paper.png"
	},
	mesh = "homedecor_door_japanese_open.obj",
	groups = { snappy = 3, not_in_creative_inventory = 1 },
	sounds = default.node_sound_wood_defaults(),
	on_rotate = minetest.get_modpath("screwdriver") and screwdriver.disallow or nil,
	selection_box = {
		type = "fixed",
		fixed = {-1.5, -0.5, -0.0625, 0.5, 1.5, 0},
	},
	collision_box = {
		type = "fixed",
		fixed = {-1.5, -0.5, -0.0625, -0.5, 1.5, 0},
	},
	expand = { top = "placeholder" },
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		minetest.set_node(pos, {name = "homedecor:door_japanese_closed", param2 = node.param2})
		return itemstack
	end,
	drop = "homedecor:door_japanese_closed",
})

-- crafting

-- half-doors

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:gate_half_door_closed 4",
	recipe = {
		"doors:homedecor_wood_plain",
		"doors:homedecor_wood_plain"
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:gate_half_door_white_closed 4",
	recipe = {
		"doors:homedecor_basic_panel",
		"doors:homedecor_basic_panel"
	},
})

-- Gates

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:gate_picket_white_closed",
        recipe = {
			"homedecor:fence_picket_white"
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:fence_picket_white",
        recipe = {
			"homedecor:gate_picket_white_closed"
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:gate_picket_closed",
        recipe = {
			"homedecor:fence_picket"
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:fence_picket",
        recipe = {
			"homedecor:gate_picket_closed"
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:gate_barbed_wire_closed",
        recipe = {
			"homedecor:fence_barbed_wire"
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:fence_barbed_wire",
        recipe = {
			"homedecor:gate_barbed_wire_closed"
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:gate_chainlink_closed",
        recipe = {
			"homedecor:fence_chainlink"
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:fence_chainlink",
        recipe = {
			"homedecor:gate_chainlink_closed"
        },
})

------ Doors

-- plain wood, non-windowed

minetest.register_craft( {
        output = "doors:homedecor_wood_plain 2",
        recipe = {
			{ "group:wood", "group:wood", "" },
			{ "group:wood", "group:wood", "default:steel_ingot" },
			{ "group:wood", "group:wood", "" },
        },
})

-- fancy exterior

minetest.register_craft( {
        output = "doors:homedecor_exterior_fancy 2",
        recipe = {
			{ "group:wood", "default:glass" },
			{ "group:wood", "group:wood" },
			{ "group:wood", "group:wood" },
        },
})

-- French style wood/glass

minetest.register_craft( {
        output = "doors:homedecor_french_oak 2",
        recipe = {
			{ "default:glass", "group:wood" },
			{ "group:wood", "default:glass" },
			{ "default:glass", "group:wood" },
        },
})

minetest.register_craft( {
        output = "doors:homedecor_french_oak 2",
        recipe = {
			{ "group:wood", "default:glass" },
			{ "default:glass", "group:wood" },
			{ "group:wood", "default:glass" },
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "doors:homedecor_french_mahogany 2",
        recipe = {
			"dye:brown",
			"doors:homedecor_french_oak",
			"doors:homedecor_french_oak"
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "doors:homedecor_french_white 2",
        recipe = {
			"dye:white",
			"doors:homedecor_french_oak",
			"doors:homedecor_french_oak"
        },
})

-- Closet doors

-- oak

minetest.register_craft( {
        output = "doors:homedecor_closet_oak 2",
        recipe = {
			{ "", "group:stick", "group:stick" },
			{ "default:steel_ingot", "group:stick", "group:stick" },
			{ "", "group:stick", "group:stick" },
        },
})

-- mahogany

minetest.register_craft( {
	type = "shapeless",
        output = "doors:homedecor_closet_mahogany 2",
        recipe = {
			"doors:homedecor_closet_oak",
			"doors:homedecor_closet_oak",
			"dye:brown"
        },
})

-- wrought iron fence-like door

minetest.register_craft( {
        output = "doors:homedecor_wrought_iron 2",
        recipe = {
			{ "homedecor:pole_wrought_iron", "default:iron_lump" },
			{ "homedecor:pole_wrought_iron", "default:iron_lump" },
			{ "homedecor:pole_wrought_iron", "default:iron_lump" }
        },
})

-- bedroom/panel door

minetest.register_craft( {
	output = "doors:homedecor_basic_panel",
	recipe = {
		{ "dye:white", "dye:white", "" },
		{ "doors:homedecor_wood_plain", "basic_materials:brass_ingot", "" },
		{ "", "", "" },
	},
})

-- basic wood/glass single-lite door

minetest.register_craft( {
	output = "doors:homedecor_woodglass",
	recipe = {
		{ "group:wood", "default:glass", "" },
		{ "group:wood", "default:glass", "basic_materials:brass_ingot" },
		{ "group:wood", "group:wood", "" },
	},
})

-- "Carolina" door

minetest.register_craft( {
	output = "doors:homedecor_carolina",
	recipe = {
		{ "default:glass", "default:glass", "" },
		{ "group:wood", "group:wood", "default:iron_lump" },
		{ "group:wood", "group:wood", "" },
	},
})


minetest.register_craft({
	output = "homedecor:door_japanese_closed",
	recipe = {
		{ "homedecor:japanese_wall_top" },
		{ "homedecor:japanese_wall_bottom" }
	},
})

-- aliases

minetest.register_alias("homedecor:jpn_door_top",               "air")
minetest.register_alias("homedecor:jpn_door_top_open",          "air")

minetest.register_alias("homedecor:jpn_door_bottom",            "homedecor:door_japanese_closed")
minetest.register_alias("homedecor:jpn_door_bottom_open",       "homedecor:door_japanese_open")

minetest.register_alias("homedecor:door_glass_right",           "doors:door_glass_b")
minetest.register_alias("homedecor:door_glass_left",            "doors:door_glass_a")

minetest.register_alias("doors:wood_glass_oak_a",               "doors:homedecor_french_oak_a")
minetest.register_alias("doors:wood_glass_oak_b",               "doors:homedecor_french_oak_b")

minetest.register_alias("doors:wood_glass_white_a",             "doors:homedecor_french_white_a")
minetest.register_alias("doors:wood_glass_white_b",             "doors:homedecor_french_white_b")

minetest.register_alias("doors:wood_glass_mahogany_a",          "doors:homedecor_french_mahogany_a")
minetest.register_alias("doors:wood_glass_mahogany_b",          "doors:homedecor_french_mahogany_b")

minetest.register_alias("doors:homedecor_wood_glass_oak_a",     "doors:homedecor_french_oak_a")
minetest.register_alias("doors:homedecor_wood_glass_oak_b",     "doors:homedecor_french_oak_b")

minetest.register_alias("doors:homedecor_wood_glass_white_a",   "doors:homedecor_french_white_a")
minetest.register_alias("doors:homedecor_wood_glass_white_b",   "doors:homedecor_french_white_b")

minetest.register_alias("doors:homedecor_wood_glass_mahogany_a", "doors:homedecor_french_mahogany_a")
minetest.register_alias("doors:homedecor_wood_glass_mahogany_b", "doors:homedecor_french_mahogany_b")

minetest.register_alias("doors:homedecor_woodglass2_a",         "doors:homedecor_carolina_a")
minetest.register_alias("doors:homedecor_woodglass2_b",         "doors:homedecor_carolina_b")

minetest.register_alias("doors:woodglass2_a",                   "doors:homedecor_carolina_a")
minetest.register_alias("doors:woodglass2_b",                   "doors:homedecor_carolina_b")

minetest.register_alias("doors:homedecor_bedroom_a",            "doors:homedecor_basic_panel_a")
minetest.register_alias("doors:homedecor_bedroom_b",            "doors:homedecor_basic_panel_b")

minetest.register_alias("doors:bedroom_a",                      "doors:homedecor_basic_panel_a")
minetest.register_alias("doors:bedroom_b",                      "doors:homedecor_basic_panel_b")

-- flip old homedecor doors around, since they use minetest_game doors API now

old_doors[#old_doors + 1] = "homedecor:door_wood_glass_oak_left"
old_doors[#old_doors + 1] = "homedecor:door_wood_glass_oak_right"

old_doors[#old_doors + 1] = "homedecor:door_wood_glass_white_left"
old_doors[#old_doors + 1] = "homedecor:door_wood_glass_white_right"

old_doors[#old_doors + 1] = "homedecor:door_wood_glass_mahogany_left"
old_doors[#old_doors + 1] = "homedecor:door_wood_glass_mahogany_right"

old_doors[#old_doors + 1] = "homedecor:door_woodglass2_left"
old_doors[#old_doors + 1] = "homedecor:door_woodglass2_right"

old_doors[#old_doors + 1] = "homedecor:door_bedroom_left"
old_doors[#old_doors + 1] = "homedecor:door_bedroom_right"

minetest.register_lbm({
	name = ":homedecor:convert_doors_3",
	label = "Convert Homedecor doors to mtg doors API",
	nodenames = old_doors,
	run_at_every_load = false,
	action = function(pos, node)
		-- old doors param2:  N=0, E=1, S=2, W=3
		local newparam2 = (node.param2 + 2) % 4
		local e = string.find(node.name, "_", -7)
		local dir = string.sub(node.name, e+1)
		local newname = "doors:homedecor_"..string.sub(node.name, 16, e-1)
		if dir == "right" then
			print("Want to replace "..node.name.." with "..newname.."_a")
			minetest.set_node(pos, {name = newname.."_a", param2 = newparam2 })
		else
			print("Want to replace "..node.name.." with "..newname.."_b")
			minetest.set_node(pos, {name = newname.."_b", param2 = newparam2 })
		end
		minetest.set_node({x=pos.x, y=pos.y+1, z=pos.z}, {name = "doors:hidden"})
	end
})

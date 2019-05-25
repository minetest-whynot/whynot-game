-- Node definitions for Homedecor doors

local S = homedecor.gettext

-- new doors using minetest_game doors API

local door_list = {
	{	name = "wood_plain",
		description = "Plain Wooden Door",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_wood_defaults(),
			open = "homedecor_door_open",
			close = "homedecor_door_close",
		}
	},

	{	name = "exterior_fancy",
		description = "Fancy Wood/Glass Door",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_wood_defaults(),
			open = "homedecor_door_open",
			close = "homedecor_door_close",
		},
		backface = true,
		alpha = true
	},

	{	name = "wood_glass_oak",
		description = "Glass and Wood, Oak-colored",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_glass_defaults(),
		},
	},

	{	name = "wood_glass_mahogany",
		description = "Glass and Wood, Mahogany-colored",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_glass_defaults(),
		},
	},

	{	name = "wood_glass_white",
		description = "Glass and Wood, White",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_glass_defaults(),
		},
	},

	{	name = "bedroom",
		description = "White Bedroom Door",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_wood_defaults(),
			open = "homedecor_door_open",
			close = "homedecor_door_close",
		}
	},

	{	name = "wrought_iron",
		description = "Wrought Iron Gate/Door",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_metal_defaults(),
			open = "doors_steel_door_open",
			close = "doors_steel_door_close",
		},
		backface = true,
	},

	{	name = "woodglass",
		description = "Wooden door with glass insert",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_wood_defaults(),
			open = "homedecor_door_open",
			close = "homedecor_door_close",
		},
		backface = true,
		alpha = true
	},

	{	name = "woodglass2",
		description = "Wooden door with glass insert, type 2",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_wood_defaults(),
			open = "homedecor_door_open",
			close = "homedecor_door_close",
		},
		backface = true,
		alpha = true
	},

	{	name = "closet_mahogany",
		description = "Mahogany Closet Door",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_wood_defaults(),
		}
	},

	{	name = "closet_oak",
		description = "Oak Closet Door",
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = {
			main = default.node_sound_wood_defaults(),
		}
	},
}

local old_doors = {}

for _, door in ipairs(door_list) do
	doors.register(door.name, {
			tiles = {{ name = "homedecor_door_"..door.name..".png", backface_culling = door.backface }},
			description = door.description,
			inventory_image = "homedecor_door_"..door.name.."_inv.png",
			groups = table.copy(door.groups),
			sounds = door.sounds.main,
			sound_open = door.sounds.open,
			sound_close = door.sounds.close
	})
	if door.alpha then
		minetest.override_item("doors:"..door.name.."_a", {
			use_texture_apha = true
		})
		minetest.override_item("doors:"..door.name.."_b", {
			use_texture_apha = true
		})
	end			
	old_doors[#old_doors + 1] = "homedecor:door_"..door.name.."_left"
	old_doors[#old_doors + 1] = "homedecor:door_"..door.name.."_right"
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
			"homedecor_blanktile.png",
			"homedecor_blanktile.png",
			"homedecor_blanktile.png",
			"homedecor_blanktile.png",
			"homedecor_gate_"..gate.."_back.png",
			"homedecor_gate_"..gate.."_front.png"
		}
	end

    local def = {
		drawtype = "nodebox",
		description = gatedesc,
		tiles = tiles,
		paramtype = "light",
		groups = {snappy=3},
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
			homedecor.flip_gate(pos, node, clicker, gate, "closed")
			return itemstack
		end,
        mesecons = {
            effector = {
				rules = m_rules,
                action_on = function(pos,node) homedecor.flip_gate(pos,node,nil,gate, "closed") end
            }
        }
	}

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
        homedecor.flip_gate(pos, node, clicker, gate, "open")
        return itemstack
	end
    def.mesecons.effector = {
		rules = m_rules,
        action_off = function(pos,node) homedecor.flip_gate(pos,node,nil,gate, "open") end
    }

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

function homedecor.flip_gate(pos, node, player, gate, oc)


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
	on_rotate = screwdriver.disallow,
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
		"homedecor:door_wood_plain_left",
		"homedecor:door_wood_plain_left"
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:gate_half_door_closed 4",
	recipe = {
		"homedecor:door_wood_plain_right",
		"homedecor:door_wood_plain_right"
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:gate_half_door_white_closed 4",
	recipe = {
		"homedecor:door_bedroom_left",
		"homedecor:door_bedroom_left"
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "homedecor:gate_half_door_white_closed 4",
	recipe = {
		"homedecor:door_bedroom_right",
		"homedecor:door_bedroom_right"
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
        output = "homedecor:door_wood_plain_left 2",
        recipe = {
			{ "group:wood", "group:wood", "" },
			{ "group:wood", "group:wood", "default:steel_ingot" },
			{ "group:wood", "group:wood", "" },
        },
})

-- fancy exterior

minetest.register_craft( {
        output = "homedecor:door_exterior_fancy_left 2",
        recipe = {
			{ "group:wood", "default:glass" },
			{ "group:wood", "group:wood" },
			{ "group:wood", "group:wood" },
        },
})

-- wood and glass (grid style)

-- bare

minetest.register_craft( {
        output = "homedecor:door_wood_glass_oak_left 2",
        recipe = {
			{ "default:glass", "group:wood" },
			{ "group:wood", "default:glass" },
			{ "default:glass", "group:wood" },
        },
})

minetest.register_craft( {
        output = "homedecor:door_wood_glass_oak_left 2",
        recipe = {
			{ "group:wood", "default:glass" },
			{ "default:glass", "group:wood" },
			{ "group:wood", "default:glass" },
        },
})

-- mahogany

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:door_wood_glass_mahogany_left 2",
        recipe = {
			"default:dirt",
			"default:coal_lump",
			"homedecor:door_wood_glass_oak_left",
			"homedecor:door_wood_glass_oak_left"
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:door_wood_glass_mahogany_left 2",
        recipe = {
			"dye:brown",
			"homedecor:door_wood_glass_oak_left",
			"homedecor:door_wood_glass_oak_left"
        },
})

-- white

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:door_wood_glass_white_left 2",
        recipe = {
			"dye:white",
			"homedecor:door_wood_glass_oak_left",
			"homedecor:door_wood_glass_oak_left"
        },
})

-- Closet doors

-- oak

minetest.register_craft( {
        output = "homedecor:door_closet_oak_left 2",
        recipe = {
			{ "", "group:stick", "group:stick" },
			{ "default:steel_ingot", "group:stick", "group:stick" },
			{ "", "group:stick", "group:stick" },
        },
})

-- mahogany

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:door_closet_mahogany_left 2",
        recipe = {
			"homedecor:door_closet_oak_left",
			"homedecor:door_closet_oak_left",
			"default:dirt",
			"default:coal_lump",
        },
})

minetest.register_craft( {
	type = "shapeless",
        output = "homedecor:door_closet_mahogany_left 2",
        recipe = {
			"homedecor:door_closet_oak_left",
			"homedecor:door_closet_oak_left",
			"dye:brown"
        },
})

-- wrought fence-like door

minetest.register_craft( {
        output = "homedecor:door_wrought_iron_left 2",
        recipe = {
			{ "homedecor:pole_wrought_iron", "default:iron_lump" },
			{ "homedecor:pole_wrought_iron", "default:iron_lump" },
			{ "homedecor:pole_wrought_iron", "default:iron_lump" }
        },
})

-- bedroom door

minetest.register_craft( {
	output = "homedecor:door_bedroom_left",
	recipe = {
		{ "dye:white", "dye:white", "" },
		{ "homedecor:door_wood_plain_left", "basic_materials:brass_ingot", "" },
		{ "", "", "" },
	},
})

-- woodglass door

minetest.register_craft( {
	output = "homedecor:door_woodglass_left",
	recipe = {
		{ "group:wood", "default:glass", "" },
		{ "group:wood", "default:glass", "basic_materials:brass_ingot" },
		{ "group:wood", "group:wood", "" },
	},
})

-- woodglass door type 2

minetest.register_craft( {
	output = "homedecor:door_woodglass2_left",
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

minetest.register_alias("homedecor:jpn_door_top", "air")
minetest.register_alias("homedecor:jpn_door_bottom", "homedecor:door_japanese_closed")

minetest.register_alias("homedecor:jpn_door_top_open", "air")
minetest.register_alias("homedecor:jpn_door_bottom_open", "homedecor:door_japanese_open")

minetest.register_alias("homedecor:door_glass_right", "doors:door_glass_b")
minetest.register_alias("homedecor:door_glass_left", "doors:door_glass_a")

-- flip old homedecor doors around, since they use minetest_game doors API now

minetest.register_lbm({
	name = ":homedecor:convert_doors",
	label = "Convert Homedecor doors to mtg doors API",
	nodenames = old_doors,
	run_at_every_load = false,
	action = function(pos, node)
		-- old doors param2:  N=0, E=1, S=2, W=3
		local newparam2 = (node.param2 + 2) % 4
		local e = string.find(node.name, "_", -7)
		local dir = string.sub(node.name, e+1)
		local newname = "doors:"..string.sub(node.name, 16, e-1)
		if dir == "right" then
			minetest.set_node(pos, {name = newname.."_a", param2 = newparam2 })
		else
			minetest.set_node(pos, {name = newname.."_b", param2 = newparam2 })
		end
		minetest.set_node({x=pos.x, y=pos.y+1, z=pos.z}, {name = "doors:hidden"})
	end
})

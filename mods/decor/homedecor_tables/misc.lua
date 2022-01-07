-- formerly homedecor's misc tables component

local S = minetest.get_translator("homedecor_tables")

-- Various kinds of table legs

local table_shapes = {"large_square", "small_square", "small_round"}

local tabletop_materials = {
	{ "glass",
		S("Small square glass tabletop"),
		S("Small round glass tabletop"),
		S("Large glass tabletop piece"),
	},
	{ "wood",
		S("Small square wooden tabletop"),
		S("Small round wooden tabletop"),
		S("Large wooden tabletop piece"),
	}
}

leg_materials = {
	{ "brass",          S("brass") },
	{ "wrought_iron",   S("wrought iron") },
	{ "wood",           S("wood") }
}

for _, t in ipairs(leg_materials) do
	local name, desc = unpack(t)
	homedecor.register("table_legs_"..name, {
		description = S("Table Legs (@1)", desc),
		drawtype = "plantlike",
		tiles = {"homedecor_table_legs_"..name..".png"},
		inventory_image = "homedecor_table_legs_"..name..".png",
		wield_image = "homedecor_table_legs_"..name..".png",
		walkable = false,
		groups = {snappy=3},
		sounds = default.node_sound_wood_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.37, -0.5, -0.37, 0.37, 0.5, 0.37 }
		},
	})
end

minetest.register_alias("homedecor:utility_table_legs", "homedecor:table_legs_wood")
minetest.register_alias("homedecor:utility_table_top",  "homedecor:wood_table_small_square")

-- table tops and combined tables

local tables_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5,    -0.5,  0.5,    -0.4375, 0.5 },
}

for i, mat in ipairs(tabletop_materials) do
	local m, small_s, small_r, large = unpack(mat)
	local s

	if m == "glass" then
		s = default.node_sound_glass_defaults()
	else
		s = default.node_sound_wood_defaults()
	end

	for _, shape in ipairs(table_shapes) do

		homedecor.register(m.."_table_"..shape, {
			description = shape.." "..m.." tabletop",
			mesh = "homedecor_table_"..shape..".obj",
			tiles = {
				'homedecor_'..m..'_table_'..shape..'.png',
				'homedecor_'..m..'_table_edges.png',
				'homedecor_blanktile.png',
				'homedecor_blanktile.png',
				'homedecor_blanktile.png',
			},
			wield_image = 'homedecor_'..m..'_table_'..shape..'_inv.png',
			groups = { snappy = 3 },
			sounds = s,
			selection_box = tables_cbox,
			collision_box = tables_cbox,
			on_place = function(itemstack, placer, pointed_thing)
				local player_name = placer:get_player_name()
				if minetest.is_protected(pointed_thing.under, player_name) then return end
				local node = minetest.get_node(pointed_thing.under)
				if string.find(node.name, "homedecor:table_legs") then
					local newname = string.format("homedecor:%s_table_%s_with_%s_legs",
						m, shape, string.sub(node.name, 22))
					minetest.set_node(pointed_thing.under, {name = newname})
					if not creative.is_enabled_for(player_name) then
						itemstack:take_item()
						return itemstack
					end
				else
					return minetest.rotate_node(itemstack, placer, pointed_thing)
				end
			end
		})

		for _, l in ipairs(leg_materials) do
			local leg_mat, desc = unpack(l)

			homedecor.register(string.format("%s_table_%s_with_%s_legs", m, shape, leg_mat), {
				description = string.format("%s %s table with %s legs", shape, m, leg_mat),
				mesh = "homedecor_table_"..shape..".obj",
				tiles = {
					'homedecor_blanktile.png',
					'homedecor_blanktile.png',
					'homedecor_'..m..'_table_'..shape..'.png',
					'homedecor_'..m..'_table_edges.png',
					"homedecor_table_legs_"..leg_mat..".png",
				},
				groups = { snappy = 3 },
				sounds = s,
			})
		end
	end

	minetest.register_alias('homedecor:'..m..'_table_large_b', 'homedecor:'..m..'_table_large')
	minetest.register_alias('homedecor:'..m..'_table_small_square_b', 'homedecor:'..m..'_table_small_square')
	minetest.register_alias('homedecor:'..m..'_table_small_round_b', 'homedecor:'..m..'_table_small_round')
	minetest.register_alias('homedecor:'..m..'_table_large', 'homedecor:'..m..'_table_large_square')

end

-- old-style tables that used to be from 3dforniture.

local table_colors = {
	{ "",           S("Table"),           homedecor.plain_wood },
	{ "_mahogany",  S("Mahogany Table"),  homedecor.mahogany_wood },
	{ "_white",     S("White Table"),     homedecor.white_wood }
}

for _, t in ipairs(table_colors) do
	local suffix, desc, texture = unpack(t)

	homedecor.register("table"..suffix, {
		description = desc,
		tiles = { texture },
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.4, -0.5, -0.4, -0.3,  0.4, -0.3 },
				{  0.3, -0.5, -0.4,  0.4,  0.4, -0.3 },
				{ -0.4, -0.5,  0.3, -0.3,  0.4,  0.4 },
				{  0.3, -0.5,  0.3,  0.4,  0.4,  0.4 },
				{ -0.5,  0.4, -0.5,  0.5,  0.5,  0.5 },
				{ -0.4, -0.2, -0.3, -0.3, -0.1,  0.3 },
				{  0.3, -0.2, -0.4,  0.4, -0.1,  0.3 },
				{ -0.3, -0.2, -0.4,  0.4, -0.1, -0.3 },
				{ -0.3, -0.2,  0.3,  0.3, -0.1,  0.4 },
			},
		},
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		sounds = default.node_sound_wood_defaults(),
	})
end

-- crafting

minetest.register_craft( {
        output = "homedecor:glass_table_small_round_b 15",
        recipe = {
                { "", "default:glass", "" },
                { "default:glass", "default:glass", "default:glass" },
                { "", "default:glass", "" },
        },
})

minetest.register_craft( {
        output = "homedecor:glass_table_small_square_b 2",
        recipe = {
		{"homedecor:glass_table_small_round", "homedecor:glass_table_small_round" },
	}
})

minetest.register_craft( {
        output = "homedecor:glass_table_large_b 2",
        recipe = {
		{ "homedecor:glass_table_small_square", "homedecor:glass_table_small_square" },
	}
})

minetest.register_craft( {
        output = "homedecor:wood_table_small_round_b 15",
        recipe = {
                { "", "group:wood", "" },
                { "group:wood", "group:wood", "group:wood" },
                { "", "group:wood", "" },
        },
})

minetest.register_craft( {
        output = "homedecor:wood_table_small_square_b 2",
        recipe = {
		{ "homedecor:wood_table_small_round","homedecor:wood_table_small_round" },
	}
})

minetest.register_craft( {
        output = "homedecor:wood_table_large_b 2",
        recipe = {
		{ "homedecor:wood_table_small_square", "homedecor:wood_table_small_square" },
	}
})

--

minetest.register_craft({
        type = "fuel",
        recipe = "homedecor:wood_table_small_round_b",
        burntime = 30,
})

minetest.register_craft({
        type = "fuel",
        recipe = "homedecor:wood_table_small_square_b",
        burntime = 30,
})

minetest.register_craft({
        type = "fuel",
        recipe = "homedecor:wood_table_large_b",
        burntime = 30,
})


minetest.register_craft( {
        output = "homedecor:table_legs_wrought_iron 3",
        recipe = {
                { "", "default:iron_lump", "" },
                { "", "default:iron_lump", "" },
                { "default:iron_lump", "default:iron_lump", "default:iron_lump" },
        },
})

minetest.register_craft( {
        output = "homedecor:table_legs_brass 3",
	recipe = {
		{ "", "basic_materials:brass_ingot", "" },
		{ "", "basic_materials:brass_ingot", "" },
		{ "basic_materials:brass_ingot", "basic_materials:brass_ingot", "basic_materials:brass_ingot" }
	},
})

minetest.register_craft( {
        output = "homedecor:utility_table_legs",
        recipe = {
                { "group:stick", "group:stick", "group:stick" },
                { "group:stick", "", "group:stick" },
                { "group:stick", "", "group:stick" },
        },
})

minetest.register_craft({
        type = "fuel",
        recipe = "homedecor:utility_table_legs",
        burntime = 30,
})

for _, shape in ipairs (table_shapes) do
	for _, leg in ipairs(leg_materials) do
		for _, mat in ipairs(tabletop_materials) do
			minetest.register_craft({
				output = "homedecor:"..mat[1].."_table_"..shape.."_with_"..leg[1].."_legs",
				type = "shapeless",
				recipe = {
					"homedecor:"..mat[1].."_table_"..shape,
					"homedecor:table_legs_"..leg[1]
				},
			})
		end
	end
end

minetest.register_craft({
	output = "homedecor:table",
	recipe = {
		{ "group:wood","group:wood", "group:wood" },
		{ "group:stick", "", "group:stick" },
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:table_mahogany",
	recipe = {
		"homedecor:table",
		"dye:brown",
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:table_mahogany",
	recipe = {
		"homedecor:table",
		"unifieddyes:dark_orange",
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "homedecor:table_white",
	recipe = {
		"homedecor:table",
		"dye:white",
	},
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:table",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:table_mahogany",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:table_white",
	burntime = 30,
})

-- recycling

minetest.register_craft({
        type = "shapeless",
        output = "vessels:glass_fragments",
        recipe = {
		"homedecor:glass_table_small_round",
		"homedecor:glass_table_small_round",
		"homedecor:glass_table_small_round"
	}
})

minetest.register_craft({
        type = "shapeless",
        output = "vessels:glass_fragments",
        recipe = {
		"homedecor:glass_table_small_square",
		"homedecor:glass_table_small_square",
		"homedecor:glass_table_small_square"
	}
})

minetest.register_craft({
        type = "shapeless",
        output = "vessels:glass_fragments",
        recipe = {
		"homedecor:glass_table_large",
		"homedecor:glass_table_large",
		"homedecor:glass_table_large"
	}
})

minetest.register_craft({
        type = "shapeless",
        output = "default:stick 4",
        recipe = {
		"homedecor:wood_table_small_round",
		"homedecor:wood_table_small_round",
		"homedecor:wood_table_small_round"
	}
})

minetest.register_craft({
        type = "shapeless",
        output = "default:stick 4",
        recipe = {
		"homedecor:wood_table_small_square",
		"homedecor:wood_table_small_square",
		"homedecor:wood_table_small_square"
	}
})

minetest.register_craft({
        type = "shapeless",
        output = "default:stick 4",
        recipe = {
		"homedecor:wood_table_large",
		"homedecor:wood_table_large",
		"homedecor:wood_table_large"
	}
})

-- Aliases for the above 3dforniture-like tables

minetest.register_alias("3dforniture:table", "homedecor:table")
minetest.register_alias('table', 'homedecor:table')

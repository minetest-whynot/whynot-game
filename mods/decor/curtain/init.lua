local color_table = {
	{"white", "White"},
	{"grey", "Grey"},
	{"black", "Black"},
	{"red", "Red"},
	{"yellow", "Yellow"},
	{"green", "Green"},
	{"cyan", "Cyan"},
	{"blue", "Blue"},
	{"magenta", "Magenta"},
	{"orange", "Orange"},
	{"violet", "Violet"},
	{"brown", "Brown"},
	{"pink", "Pink"},
	{"dark_grey", "Dark Grey"},
	{"dark_green", "Dark Green"}
}

for _,v in ipairs(color_table) do
	minetest.register_node("curtain:"..v[1].."_curtain_closed", {
		description = v[2].." Curtain",
		tiles = {"wool_"..v[1]..".png"},
		paramtype = "light",
		paramtype2 = "facedir",
		walkable = false,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, 0.3125, 0.5, 0.5, 0.5},
		},
		sounds = default.node_sound_defaults(),
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3},
		on_rightclick = function(pos, node, puncher)
			minetest.swap_node(pos, {name = "curtain:"..v[1].."_curtain_open", param2 = node.param2})
		end,
	})

	minetest.register_node("curtain:"..v[1].."_curtain_open", {
		description = v[2].." Curtain open",
		tiles = {"wool_"..v[1]..".png"},
		paramtype = "light",
		paramtype2 = "facedir",
		walkable = false,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0.3125, 0.3125, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, 0, 0.3125, 0.5, 0.5, 0.5},
		},
		sounds = default.node_sound_defaults(),
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3,not_in_creative_inventory=1},
		on_rightclick = function(pos, node, puncher)
			minetest.swap_node(pos, {name = "curtain:"..v[1].."_curtain_closed", param2 = node.param2})
		end,
		drop = "curtain:"..v[1].."_curtain_closed",
	})

	minetest.register_node("curtain:large_"..v[1].."_curtain_closed", {
		description = "Large "..v[2].." Curtain",
		tiles = {"wool_"..v[1]..".png"},
		paramtype = "light",
		paramtype2 = "facedir",
		walkable = false,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -1.5, 0.4375, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -1.5, 0.3125, 0.5, 0.5, 0.5},
		},
		sounds = default.node_sound_defaults(),
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3},
		on_rightclick = function(pos, node, puncher)
			minetest.swap_node(pos, {name = "curtain:large_"..v[1].."_curtain_open", param2 = node.param2})
		end,
	})

	minetest.register_node("curtain:large_"..v[1].."_curtain_open", {
		description = "Large "..v[2].." Curtain open",
		tiles = {"wool_"..v[1]..".png"},
		paramtype = "light",
		paramtype2 = "facedir",
		walkable = false,
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0.3125, 0.3125, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.5, 0, 0.3125, 0.5, 0.5, 0.5},
		},
		sounds = default.node_sound_defaults(),
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=3,flammable=3,not_in_creative_inventory=1},
		on_rightclick = function(pos, node, puncher)
			minetest.swap_node(pos, {name = "curtain:large_"..v[1].."_curtain_closed", param2 = node.param2})
		end,
		drop = "curtain:large_"..v[1].."_curtain_closed",
	})

	if minetest.registered_nodes["default:wool_"..v[1]] then
		minetest.register_craft({
			output = "curtain:"..v[1].."_curtain_closed",
			recipe = {
				{"group:stick"},
				{"default:carpet_"..v[1]},
			}
		})
	elseif (minetest.get_modpath("carpet_api")) then
		minetest.register_craft({
			output = "curtain:"..v[1].."_curtain_closed",
			recipe = {
				{"group:stick"},
				{"carpet:wool_"..v[1]},
			}
		})
	else
		minetest.register_craft({
			output = "curtain:"..v[1].."_curtain_closed 12",
			recipe = {
				{"group:stick", "group:stick", "group:stick"},
				{"wool:"..v[1], "wool:"..v[1], "wool:"..v[1]},
				{"wool:"..v[1], "wool:"..v[1], "wool:"..v[1]},
			}
		})
	end

	minetest.register_craft({
		output = "curtain:large_"..v[1].."_curtain_closed",
		recipe = {
			{"curtain:"..v[1].."_curtain_closed"},
			{"curtain:"..v[1].."_curtain_closed"},
		}
	})

	minetest.register_craft({
		output = "curtain:"..v[1].."_curtain_closed 2",
		recipe = {
			{"curtain:large_"..v[1].."_curtain_closed"},
		}
	})
end

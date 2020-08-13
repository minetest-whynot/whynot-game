-- formerly lrfurn coffee table component

local S = minetest.get_translator("homedecor_tables")

local fdir_to_right = {
	{  1,  0 },
	{  0, -1 },
	{ -1,  0 },
	{  0,  1 },
}

local function check_right(pos, fdir, long, placer)
	if not fdir or fdir > 3 then fdir = 0 end

	local pos2 = { x = pos.x + fdir_to_right[fdir+1][1],     y=pos.y, z = pos.z + fdir_to_right[fdir+1][2]     }
	local pos3 = { x = pos.x + fdir_to_right[fdir+1][1] * 2, y=pos.y, z = pos.z + fdir_to_right[fdir+1][2] * 2 }

	local node2 = minetest.get_node(pos2)
	if node2 and node2.name ~= "air" then
		return false
	elseif minetest.is_protected(pos2, placer:get_player_name()) then
		if not long then
			minetest.chat_send_player(placer:get_player_name(), S("Someone else owns the spot where the other end goes!"))
		else
			minetest.chat_send_player(placer:get_player_name(),
				S("Someone else owns the spot where the middle or far end goes!"))
		end
		return false
	end

	if long then
		local node3 = minetest.get_node(pos3)
		if node3 and node3.name ~= "air" then
			return false
		elseif minetest.is_protected(pos3, placer:get_player_name()) then
			minetest.chat_send_player(placer:get_player_name(), S("Someone else owns the spot where the other end goes!"))
			return false
		end
	end

	return true
end

minetest.register_alias("lrfurn:coffeetable_back", "lrfurn:coffeetable")
minetest.register_alias("lrfurn:coffeetable_front", "air")

minetest.register_node(":lrfurn:coffeetable", {
	description = S("Coffee Table"),
	drawtype = "nodebox",
	tiles = {
		"lrfurn_coffeetable_back.png",
		"lrfurn_coffeetable_back.png",
		"lrfurn_coffeetable_back.png",
		"lrfurn_coffeetable_back.png",
		"lrfurn_coffeetable_back.png",
		"lrfurn_coffeetable_back.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
	sounds = default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
					--legs
					{ -0.375,  -0.5, -0.375,  -0.3125, -0.0625, -0.3125 },
					{  0.3125, -0.5, -0.375,   0.375,  -0.0625, -0.3125 },
					{ -0.375,  -0.5,  1.3125, -0.3125, -0.0625,  1.375  },
					{ 0.3125,  -0.5,  1.3125,  0.375,  -0.0625,  1.375  },
					--tabletop
					{-0.4375, -0.0625, -0.4375, 0.4375, 0, 1.4375},
				}
	},
	selection_box = {
		type = "fixed",
		fixed = {
					{-0.4375, -0.5, -0.4375, 0.4375, 0.0, 1.4375},
				}
	},

	after_place_node = function(pos, placer, itemstack, pointed_thing)
		if minetest.is_protected(pos, placer:get_player_name()) then return true end
		local node = minetest.get_node(pos)
		local fdir = node.param2

		if check_right(pos, fdir, false, placer) then
			minetest.set_node(pos, { name = node.name, param2 = (fdir + 1) % 4 })
		else
			minetest.chat_send_player(placer:get_player_name(),
			  S("No room to place the coffee table!"))
			minetest.set_node(pos, {name = "air"})
			return true
		end
	end,
})

minetest.register_craft({
	output = "lrfurn:coffeetable",
	type = "shapeless",
	recipe = {
		"lrfurn:endtable",
		"lrfurn:endtable"
	}
})

minetest.register_craft({
	output = "lrfurn:coffeetable",
	recipe = {
		{"", "", "", },
		{"stairs:slab_wood", "stairs:slab_wood", "stairs:slab_wood", },
		{"group:stick", "", "group:stick", }
	}
})

minetest.register_craft({
	output = "lrfurn:coffeetable",
	recipe = {
		{"", "", "", },
		{"moreblocks:slab_wood", "moreblocks:slab_wood", "moreblocks:slab_wood", },
		{"group:stick", "", "group:stick", }
	}
})

if minetest.settings:get("log_mods") then
	minetest.log("action", "[lrfurn/coffeetable] Loaded!")
end

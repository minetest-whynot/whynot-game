local S = minetest.get_translator("homedecor_seating")
local armchair_cbox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, 0, 0.5 },
		{-0.5, -0.5, 0.4, 0.5, 0.5, 0.5 }
	}
}

minetest.register_node(":lrfurn:armchair", {
	description = S("Armchair"),
	drawtype = "mesh",
	mesh = "lrfurn_armchair.obj",
	tiles = {
		"lrfurn_upholstery.png",
		{ name = "lrfurn_sofa_bottom.png", color = 0xffffffff }
	},
	paramtype = "light",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	inventory_image = "lrfurn_armchair_inv.png",
	groups = {snappy=3, ud_param2_colorable = 1},
	sounds = default.node_sound_wood_defaults(),
	node_box = armchair_cbox,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end,
	on_dig = unifieddyes.on_dig,
	on_rotate = unifieddyes.fix_after_screwdriver_nsew,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		if not clicker:is_player() then
			return itemstack
		end
		pos.y = pos.y-0.5
		clicker:setpos(pos)
		clicker:set_hp(20)
		return itemstack
	end
})

homedecor.register("armchair", {
	description = S("Armchair"),
	mesh = "forniture_armchair.obj",
	tiles = {
		"wool_white.png",
		{ name = "wool_dark_grey.png", color = 0xffffffff },
		{ name = "default_wood.png", color = 0xffffffff }
	},
	inventory_image = "homedecor_armchair_inv.png",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	groups = {snappy=3, ud_param2_colorable = 1},
	sounds = default.node_sound_wood_defaults(),
	node_box = armchair_cbox,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end,
	on_dig = unifieddyes.on_dig,
	on_rotate = unifieddyes.fix_after_screwdriver_nsew,
})

-- crafts

minetest.register_craft({
	output = "lrfurn:armchair",
	recipe = {
		{"wool:white", "", "", },
		{"stairs:slab_wood", "", "", },
		{"group:stick", "", "", }
	}
})

minetest.register_craft({
	output = "lrfurn:armchair",
	recipe = {
		{"wool:white", "", "", },
		{"moreblocks:slab_wood", "", "", },
		{"group:stick", "", "", }
	}
})

unifieddyes.register_color_craft({
	output = "lrfurn:armchair",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "lrfurn:armchair",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
	output = "homedecor:armchair 2",
	recipe = {
	{ "wool:white",""},
	{ "group:wood","group:wood" },
	{ "wool:white","wool:white" },
	},
})

unifieddyes.register_color_craft({
	output = "homedecor:armchair",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "homedecor:armchair",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:armchair",
	burntime = 30,
})

minetest.register_alias('armchair', 'homedecor:armchair')

-- convert old static nodes to param2 color

lrfurn.old_static_armchairs = {}

for _, color in ipairs(lrfurn.colors) do
	table.insert(lrfurn.old_static_armchairs, "lrfurn:armchair_"..color)
end

minetest.register_lbm({
	name = ":lrfurn:convert_armchairs",
	label = "Convert lrfurn armchairs to use param2 color",
	run_at_every_load = false,
	nodenames = lrfurn.old_static_armchairs,
	action = function(pos, node)
		local name = node.name
		local color = string.sub(name, string.find(name, "_")+1)

		if color == "red" then
			color = "medium_red"
		elseif color == "dark_green" then
			color = "medium_green"
		elseif color == "magenta" then
			color = "medium_magenta"
		elseif color == "cyan" then
			color = "medium_cyan"
		end

		local paletteidx, _ = unifieddyes.getpaletteidx("unifieddyes:"..color, "wallmounted")
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

		local param2 = paletteidx + new_fdir

		minetest.set_node(pos, { name = "lrfurn:armchair", param2 = param2 })
		local meta = minetest.get_meta(pos)
		meta:set_string("dye", "unifieddyes:"..color)
	end
})

if minetest.settings:get("log_mods") then
	minetest.log("action", "[lrfurn/armchairs] Loaded!")
end

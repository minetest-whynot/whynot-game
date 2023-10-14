pie = {}

-- check for available hunger mods
local hmod = minetest.get_modpath("hunger")
local hbmod = minetest.global_exists("hbhunger")
local stmod = minetest.global_exists("stamina")
local defmod = minetest.get_modpath("default")
local mclhunger = minetest.get_modpath("mcl_hunger")
local screwdriver_exists = minetest.get_modpath("screwdriver")
local quarters = minetest.settings:get_bool("pie.quarters")

-- sound support
local cake_sound = defmod and default.node_sound_dirt_defaults()

if minetest.get_modpath("mcl_sounds") then
	cake_sound = mcl_sounds.node_sound_dirt_defaults()
end


-- eat pie slice function
local function replace_pie(node, puncher, pos)

	-- is this my pie?
	if minetest.is_protected(pos, puncher:get_player_name()) then
		return
	end

	-- which size of pie did we hit?
	local pie = node.name:sub(1,-3)
	local num = tonumber(node.name:sub(-1))

	-- are we using crystal shovel to pick up full pie using soft touch?
	local tool = puncher:get_wielded_item():get_name()
	if num == 0 and tool == "ethereal:shovel_crystal" then

		local inv = puncher:get_inventory()

		minetest.remove_node(pos)

		if inv:room_for_item("main", {name = pie .. "_0"}) then
			inv:add_item("main", pie .. "_0")
		else
			pos.y = pos.y + 0.5
			minetest.add_item(pos, {name = pie .. "_0"})
		end

		return
	end

	-- eat slice or remove whole pie
	if num == 3 then
		node.name = "air"
	elseif num < 3 then
		node.name = pie .. "_" .. (num + 1)
	end

	minetest.swap_node(pos, node)

	if num == 3 then
		minetest.check_for_falling(pos)
	end

	-- default eat sound
	local sound = "default_dig_crumbly"

	-- Blockmen's hud_hunger mod
	if hmod then

		local h = hunger.read(puncher)

		h = math.min(h + 4, 30)

		local ok = hunger.update_hunger(puncher, h)

		sound = "hunger_eat"

	-- Wuzzy's hbhunger mod
	elseif hbmod then

		local h = tonumber(hbhunger.hunger[puncher:get_player_name()])

		h = math.min(h + 4, 30)

		hbhunger.hunger[puncher:get_player_name()] = h

		sound = "hbhunger_eat_generic"

	-- Sofar's stamina mod
	elseif stmod then

		stamina.change(puncher, 4)

		sound = "stamina_eat"

	-- mineclone2 mcl_hunger mod
	elseif mclhunger then

		local h = mcl_hunger.get_hunger(puncher)

		h = math.min(h + 4, 20)

		mcl_hunger.set_hunger(puncher, h)

		sound = "mcl_hunger_bite"

	-- none of the above found? add to health instead
	else

		local h = puncher:get_hp()

		h = math.min(h + 4, 20)

		puncher:set_hp(h)
	end

	minetest.sound_play(sound, {pos = pos, gain = 0.7, max_hear_distance = 5}, true)
end


-- register pie bits
pie.register_pie = function(pie, desc)

	-- full pie

	local nodebox = {
		type = "fixed",
		fixed = {-0.45, -0.5, -0.45, 0.45, 0, 0.45}
	}
	local tiles = {
		pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
		pie .. "_side.png", pie .. "_side.png", pie .. "_side.png"
	}

	minetest.register_node(":pie:" .. pie .. "_0", {
		description = desc,
		paramtype = "light",
		paramtype2 = "facedir",
		use_texture_alpha = "clip",
		sunlight_propagates = false,
		tiles = tiles,
		inventory_image = pie .. "_inv.png",
		wield_image = pie .. "_inv.png",
		drawtype = "nodebox",
		node_box = nodebox,
		sounds = cake_sound,

		on_rotate = screwdriver_exists and screwdriver.rotate_simple,

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end
	})

	-- 3/4 pie

	nodebox = {
		type = "fixed",
		fixed = {-0.45, -0.5, -0.25, 0.45, 0, 0.45}
	}
	tiles = {
		pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
		pie .. "_side.png", pie .. "_side.png", pie .. "_inside.png"
	}

	if quarters then
		nodebox.fixed = {
			{-0.45, -0.5, -0.45, 0, 0, 0.45},
			{-0.45, -0.5, 0, 0.45, 0, 0.45}
		}
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_side_inside.png^[transformFX",
			pie .. "_side.png", pie .. "_side.png", pie .. "_side_inside.png"
		}
	end

	minetest.register_node(":pie:" .. pie .. "_1", {
		description = "3/4 " .. desc,
		paramtype = "light",
		paramtype2 = "facedir",
		use_texture_alpha = "clip",
		sunlight_propagates = true,
		tiles = tiles,
		groups = {not_in_creative_inventory = 1},
		drop = {},
		drawtype = "nodebox",
		node_box = nodebox,
		sounds = cake_sound,

		on_rotate = screwdriver_exists and screwdriver.rotate_simple,

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end
	})

	-- 1/2 pie

	nodebox = {
		type = "fixed",
		fixed = {-0.45, -0.5, 0.0, 0.45, 0, 0.45}
	}
	tiles = {
		pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
		pie .. "_side.png", pie .. "_side.png", pie .. "_inside.png"
	}

	if quarters then
		nodebox.fixed = {-0.45, -0.5, -.45, 0, 0, 0.45}
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_inside.png",
			pie .. "_side.png", pie .. "_side.png", pie .. "_side.png"
		}
	end

	minetest.register_node(":pie:" .. pie .. "_2", {
		description = "Half " .. desc,
		paramtype = "light",
		paramtype2 = "facedir",
		use_texture_alpha = "clip",
		sunlight_propagates = true,
		tiles = tiles,
		groups = {not_in_creative_inventory = 1},
		drop = {},
		drawtype = "nodebox",
		node_box = nodebox,
		sounds = cake_sound,

		on_rotate = screwdriver_exists and screwdriver.rotate_simple,

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end
	})

	-- 1/4 pie

	tiles = {
		pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
		pie .. "_side.png", pie .. "_side.png", pie .. "_inside.png"
	}
	nodebox = {
		type = "fixed",
		fixed = {-0.45, -0.5, 0.25, 0.45, 0, 0.45}
	}

	if quarters then
		nodebox.fixed = {-0.45, -0.5, 0.0, 0.0, 0, 0.45}
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_inside.png",
			pie .. "_side.png", pie .. "_side.png", pie .. "_inside.png"
		}
	end

	minetest.register_node(":pie:" .. pie .. "_3", {
		description = "Piece of " .. desc,
		paramtype = "light",
		paramtype2 = "facedir",
		use_texture_alpha = "clip",
		sunlight_propagates = true,
		tiles = tiles,
		groups = {not_in_creative_inventory = 1},
		drop = {},
		drawtype = "nodebox",
		node_box = nodebox,
		sounds = cake_sound,

		on_rotate = screwdriver_exists and screwdriver.rotate_simple,

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end
	})
end


-- register cakes
pie.register_pie("pie", "Cake")
pie.register_pie("choc", "Chocolate Cake")
pie.register_pie("scsk", "Strawberry Cheesecake")
pie.register_pie("coff", "Coffee Cake")
pie.register_pie("rvel", "Red Velvet Cake")
pie.register_pie("meat", "Meat Cake")
pie.register_pie("bana", "Banana Cake")
pie.register_pie("brpd", "Bread Pudding")
pie.register_pie("orange", "Orange Pie")


-- ingredient variables
local mcl = minetest.get_modpath("mcl_dye")
local i_sugar = mcl and "mcl_core:sugar" or "group:food_sugar"
local i_wheat = mcl and "mcl_farming:wheat_item" or "group:food_wheat"
local i_flour = mcl and "mcl_farming:bread" or "group:food_flour"
local i_egg = mcl and "mcl_throwing:egg" or "group:food_egg"
local i_milk = mcl and "mcl_mobitems:milk_bucket" or "group:food_milk"
local i_cocoa = mcl and "mcl_dye:brown" or "group:food_cocoa"
local i_strawberry = mcl and "mcl_dye:red" or "group:food_strawberry"
local i_coffee = mcl and "mcl_dye:black" or "group:food_coffee"
local i_cheese = mcl and "mcl_dye:yellow" or "group:food_cheese"
local i_red = mcl and "mcl_dye:red" or "dye:red"
local i_meat = mcl and "mcl_mobitems:beef" or "group:food_meat_raw"
local i_banana = mcl and "mcl_dye:yellow" or "group:food_banana"
local i_bread = mcl and "mcl_farming:bread" or "group:food_bread"
local i_orange = mcl and "mcl_dye:orange" or "group:food_orange"
local i_bucket = mcl and "mcl_buckets:bucket_empty" or "bucket:bucket_empty"
local i_bottle = mcl and "mcl_potions:glass_bottle" or "vessels:glass_bottle"

-- replacement items
local replace_these = {
	{"mobs:bucket_milk", i_bucket},
	{"mobs:wooden_bucket_milk", "wooden_bucket:bucket_wood_empty"},
	{"mcl_mobitems:milk_bucket", i_bucket},
	{"petz:bucket_milk", i_bucket},
	{"cucina_vegana:soy_milk", i_bottle}
}

-- normal cake recipe
minetest.register_craft({
	output = "pie:pie_0",
	recipe = {
		{i_sugar, i_milk, i_sugar},
		{i_sugar, i_egg, i_sugar},
		{i_wheat, i_flour, i_wheat}
	},
	replacements = replace_these
})

-- chocolate cake recipe
minetest.register_craft({
	output = "pie:choc_0",
	recipe = {
		{i_cocoa, i_milk, i_cocoa},
		{i_sugar, i_egg, i_sugar},
		{i_wheat, i_flour, i_wheat}
	},
	replacements = replace_these
})

-- strawberry cheesecake recipe
minetest.register_craft({
	output = "pie:scsk_0",
	recipe = {
		{i_strawberry, i_milk, i_strawberry},
		{i_sugar, i_egg, i_sugar},
		{i_wheat, i_flour, i_wheat}
	},
	replacements = replace_these
})

-- coffee cake recipe
minetest.register_craft({
	output = "pie:coff_0",
	recipe = {
		{i_coffee, i_milk, i_coffee},
		{i_sugar, i_egg, i_sugar},
		{i_wheat, i_flour, i_wheat}
	},
	replacements = replace_these
})

-- red velvet cake recipe
minetest.register_craft({
	output = "pie:rvel_0",
	recipe = {
		{i_cocoa, i_milk, i_red},
		{i_sugar, i_egg, i_sugar},
		{i_flour, i_cheese, i_flour}
	},
	replacements = replace_these
})

-- meat cake recipe
minetest.register_craft({
	output = "pie:meat_0",
	recipe = {
		{i_meat, i_egg, i_meat},
		{i_wheat, i_wheat, i_wheat}
	}
})

-- banana cake recipe
minetest.register_craft({
	output = "pie:bana_0",
	recipe = {
		{i_banana, i_milk, i_banana},
		{i_sugar, i_egg, i_sugar},
		{i_wheat, i_flour, i_wheat}
	},
	replacements = replace_these
})

-- bread pudding recipe
minetest.register_craft({
	output = "pie:brpd_0",
	recipe = {
		{i_bread, i_milk, i_bread},
		{i_sugar, i_egg, i_sugar},
		{i_wheat, i_flour, i_wheat}
	},
	replacements = replace_these
})

-- orange pie
minetest.register_craft({
	output = "pie:orange_0",
	recipe = {
		{i_orange, i_milk, i_orange},
		{i_sugar, i_egg, i_sugar},
		{i_wheat, i_flour, i_wheat}
	},
	replacements = replace_these
})


-- add lucky blocks
if minetest.get_modpath("lucky_block") then

	lucky_block:add_blocks({
		{"nod", "pie:pie_0", 0},
		{"nod", "pie:choc_0", 0},
		{"nod", "pie:coff_0", 0},
		{"tro", "pie:pie_0"},
		{"nod", "pie:rvel_0", 0},
		{"nod", "pie:scsk_0", 0},
		{"nod", "pie:bana_0", 0},
		{"nod", "pie:orange_0", 0},
		{"tro", "pie:orange_0", "default_place_node_hard", true},
		{"nod", "pie:brpd_0", 0},
		{"nod", "pie:meat_0", 0},
		{"lig"}
	})
end


-- some aliases for older pie mod by Mitroman
minetest.register_alias("pie:apie_0", "pie:pie_0")
minetest.register_alias("pie:apie_1", "pie:pie_1")
minetest.register_alias("pie:apie_2", "pie:pie_2")
minetest.register_alias("pie:apie_3", "pie:pie_3")
minetest.register_alias("pie:piebatter", "pie:pie_0")
minetest.register_alias("pie:apiebatter", "pie:pie_0")
minetest.register_alias("pie:amuffinbatter", "pie:pie_0")
minetest.register_alias("pie:applemuffin", "pie:pie_0")
minetest.register_alias("pie:sugar", "farming:sugar")
minetest.register_alias("pie:knife", "default:sword_steel")


print("[MOD] Pie loaded")

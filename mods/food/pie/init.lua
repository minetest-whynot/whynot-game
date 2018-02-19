
-- check for available hunger mods
local hmod = minetest.get_modpath("hunger")
local hbmod = minetest.get_modpath("hbhunger")
local stmod = minetest.get_modpath("stamina")
local foodmod = minetest.get_modpath("food")

-- eat pie slice function
local replace_pie = function(node, puncher, pos)

	-- is this my pie?
	if minetest.is_protected(pos, puncher:get_player_name()) then
		return
	end

	-- which size of pie did we hit?
	local pie = node.name:split("_")[1]
	local num = tonumber(node.name:split("_")[2])

	-- eat slice or remove whole pie
	if num == 3 then
		node.name = "air"
	elseif num < 3 then
		node.name = pie .. "_" .. (num + 1)
	end

	minetest.swap_node(pos, {name = node.name})

	-- Blockmen's hud_hunger mod
	if hmod then

		local h = hunger.read(puncher)
--		print ("hunger is "..h)

		h = math.min(h + 4, 30)

		local ok = hunger.update_hunger(puncher, h)

		minetest.sound_play("hunger_eat", {
			pos = pos, gain = 0.7, max_hear_distance = 5})

	-- Wuzzy's hbhunger mod
	elseif hbmod then

		local h = tonumber(hbhunger.hunger[puncher:get_player_name()])
--		print ("hbhunger is "..h)

		h = math.min(h + 4, 30)

		hbhunger.hunger[puncher:get_player_name()] = h

		minetest.sound_play("hbhunger_eat_generic", {
			pos = pos, gain = 0.7, max_hear_distance = 5})

	-- Sofar's stamina mod
	elseif stmod then

		stamina.change(puncher, 4)

		minetest.sound_play("stamina_eat", {
			pos = pos, gain = 0.7, max_hear_distance = 5})

	-- none of the above found? add to health instead
	else

		local h = puncher:get_hp()
--		print ("health is "..h)

		h = math.min(h + 4, 20)

		puncher:set_hp(h)
	end
end

-- register pie bits
local register_pie = function(pie, desc)

	-- full pie
	minetest.register_node("pie:" .. pie .. "_0", {
		description = desc,
		paramtype = "light",
		sunlight_propagates = false,
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
			pie .. "_side.png", pie .. "_side.png", pie .. "_side.png"
		},
		inventory_image = pie .. "_inv.png",
		wield_image = pie .. "_inv.png",
		groups = {crumbly = 1, level = 2},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {{-0.45, -0.5, -0.45, 0.45, 0, 0.45}},
		},

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end,
	})

	-- 3/4 pie
	minetest.register_node("pie:" .. pie .. "_1", {
		description = "3/4" .. desc,
		paramtype = "light",
		sunlight_propagates = true,
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
			pie .. "_side.png", pie .. "_side.png", pie .. "_inside.png"
		},
		groups = {not_in_creative_inventory = 1},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {{-0.45, -0.5, -0.25, 0.45, 0, 0.45}},
		},

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end,
	})

	-- 1/2 pie
	minetest.register_node("pie:" .. pie .. "_2", {
		description = "Half " .. desc,
		paramtype = "light",
		sunlight_propagates = true,
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
			pie .. "_side.png", pie .. "_side.png", pie .. "_inside.png"
		},
		groups = {not_in_creative_inventory = 1},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {{-0.45, -0.5, 0.0, 0.45, 0, 0.45}},
		},

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end,
	})

	-- 1/4 pie
	minetest.register_node("pie:" .. pie .. "_3", {
		description = "Piece of " .. desc,
		paramtype = "light",
		sunlight_propagates = true,
		tiles = {
			pie .. "_top.png", pie .. "_bottom.png", pie .. "_side.png",
			pie .. "_side.png", pie .. "_side.png", pie .. "_inside.png"
		},
		groups = {not_in_creative_inventory = 1},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {{-0.45, -0.5, 0.25, 0.45, 0, 0.45}},
		},

		on_punch = function(pos, node, puncher, pointed_thing)
			replace_pie(node, puncher, pos)
		end,
	})

end

local ingredients = {}

if foodmod then
	ingredients.sugar = "group:food_sugar"
	ingredients.milk = "group:food_milk"
	ingredients.egg = "group:food_egg"
	ingredients.wheat = "group:food_wheat"
	ingredients.flour = "group:food_flour"
	ingredients.cocoa = "group:food_cocoa"
	ingredients.coffee = "group:food_coffee"
	ingredients.strawberry = "group:food_strawberry"
	ingredients.cheese = "group:food_cheese"
	ingredients.meat_raw = "group:food_meat_raw"
	ingredients.banana = "group:food_banana"
	ingredients.orange = "group:food_orange"
else
	ingredients.sugar = "farming:sugar"
	ingredients.milk = "mobs:bucket_milk"
	ingredients.egg = "mobs:egg"
	ingredients.wheat = "farming:wheat"
	ingredients.flour = "farming:flour"
	ingredients.cocoa = "farming:cocoa_beans"
	ingredients.coffee = "farming:coffee_beans"
	ingredients.strawberry = "ethereal:strawberry"
	ingredients.cheese = "mobs:cheese"
	ingredients.meat_raw = "mobs:meat_raw"
	ingredients.banana = "ethereal:banana"
	ingredients.orange = "ethereal:orange"
end

-- normal cake
register_pie("pie", "Cake")

minetest.register_craft({
	output = "pie:pie_0",
	recipe = {
		{ingredients.sugar, ingredients.milk, ingredients.sugar},
		{ingredients.sugar, ingredients.egg, ingredients.sugar},
		{ingredients.wheat, ingredients.flour, ingredients.wheat},
	},
	replacements = {{ "mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- chocolate cake
register_pie("choc", "Chocolate Cake")

minetest.register_craft({
	output = "pie:choc_0",
	recipe = {
		{ingredients.cocoa, ingredients.milk, ingredients.cocoa},
		{ingredients.sugar, ingredients.egg, ingredients.sugar},
		{ingredients.wheat, ingredients.flour, ingredients.wheat},
	},
	replacements = {{ "mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- strawberry cheesecake
register_pie("scsk", "Strawberry Cheesecake")

minetest.register_craft({
	output = "pie:scsk_0",
	recipe = {
		{ingredients.strawberry, ingredients.milk, ingredients.strawberry},
		{ingredients.sugar, ingredients.egg, ingredients.sugar},
		{ingredients.wheat, ingredients.flour, ingredients.wheat},
	},
	replacements = {{ "mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- coffee cake
register_pie("coff", "Coffee Cake")

minetest.register_craft({
	output = "pie:coff_0",
	recipe = {
		{ingredients.coffee, ingredients.milk, ingredients.coffee},
		{ingredients.sugar, ingredients.egg, ingredients.sugar},
		{ingredients.wheat, ingredients.flour, ingredients.wheat},
	},
	replacements = {{ "mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- red velvet cake
register_pie("rvel", "Red Velvet Cake")

minetest.register_craft({
	output = "pie:rvel_0",
	recipe = {
		{ingredients.cocoa, ingredients.milk, "dye:red"},
		{ingredients.sugar, ingredients.egg, ingredients.sugar},
		{ingredients.flour, ingredients.cheese, ingredients.flour},
	},
	replacements = {{ "mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- meat cake
register_pie("meat", "Meat Cake")

minetest.register_craft({
	output = "pie:meat_0",
	recipe = {
		{ingredients.meat_raw, ingredients.egg, ingredients.meat_raw},
		{ingredients.wheat, ingredients.wheat, ingredients.wheat},
		{"", "", ""}
	},
})

-- banana cake
register_pie("bana", "Banana Cake")

minetest.register_craft({
	output = "pie:bana_0",
	recipe = {
		{ingredients.banana, ingredients.milk, ingredients.banana},
		{ingredients.sugar, ingredients.egg, ingredients.sugar},
		{ingredients.wheat, ingredients.flour, ingredients.wheat},
	},
	replacements = {{ "mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- bread pudding
register_pie("brpd","Bread Pudding")

minetest.register_craft({
	output = "pie:brpd_0",
	recipe = {
		{"farming:bread", ingredients.milk, "farming:bread"},
		{ingredients.sugar, ingredients.egg, ingredients.sugar},
		{ingredients.wheat, ingredients.flour, ingredients.wheat},
	},
	replacements = {{ "mobs:bucket_milk", "bucket:bucket_empty"}}
})

-- orange pie
register_pie("orange","Orange Pie")

minetest.register_craft({
	output = "pie:orange_0",
	recipe = {
		{ingredients.orange, ingredients.milk, ingredients.orange},
		{ingredients.sugar, ingredients.egg, ingredients.sugar},
		{ingredients.wheat, ingredients.flour, ingredients.wheat},
	},
	replacements = {{ "mobs:bucket_milk", "bucket:bucket_empty"}}
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
	{"lig"},
})
end

print ("[MOD] Pie loaded")

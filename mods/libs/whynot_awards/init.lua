local S = minetest.get_translator(minetest.get_current_modname())
local awards_modpath = minetest.get_modpath(minetest.get_current_modname())

Whynot_awards = {
	get_translator = S,
	modpath = awards_modpath,
}

dofile(awards_modpath.."/custom_triggers.lua")


-- Set builtin awards to hidden
for name, award in pairs(awards.registered_awards) do
	award.secret = true
end

-- 4 awards are registered with minetest.after(0) so hide them later
minetest.after(2, function()
	if (awards.registered_awards["awards_builder1"]) then
		awards.registered_awards["awards_builder1"].secret = true
		awards.registered_awards["awards_builder2"].secret = true
		awards.registered_awards["awards_builder3"].secret = true
		awards.registered_awards["awards_builder4"].secret = true
	end
end)



awards.register_award("whynot_welcome", {
	title = S("Welcome to the WhyNot? game"),
	description = S("You are embarking on a Minetest journey. Whether it's for the thrill of survival, the satisfaction of exploration, or the arts of crafting and creative designs, we hope you will find it enjoyable.\n\nMake sure to check your recipe book, awards or the help button in your inventory for more information and guidance."),
	--icon = "",
	requires = {},
	trigger = {
		type   = "join",
		target = 1,
	},
})


awards.register_award("whynot_gatherfood",{
	title = S("Gather and eat wild foodstuff"),
	description = S("You need to eat to survive. The easiest food to find are wild mushrooms, blueberries and apples. Find and eat one of each to help secure your survival."),
	icon = "whynot_awards_gatherer.png",
	requires = {},
	trigger = {
		type = "eatwildfood",
		target = 3,
	},
})


awards.register_award("whynot_gatherwildseeds",{
	title = S("Gather wild seeds"),
	description = S("Harvesting various types of grass can sometimes give you seeds. These seeds can the be planted and farmed for food and materials."),
	icon = "whynot_awards_wildseeds.png",
	requires = {},
	trigger = {
		type = "gatherwildseeds",
		target = 3,
	},
})


awards.register_award("whynot_gatherfruitvegetable",{
	title = S("Gather wild fruits and vegetables"),
	description = S("More common in temperate regions, but also found in various climates, wild fruits and vegetables can be harvested. Use them for food, or re-plant them as crops for agriculture."),
	icon = "whynot_awards_carrot.png",
	requires = {},
	trigger = {
		type = "gatherfruitvegetable",
		target = 3,
	},
})


awards.register_award("whynot_tree",{
	title = S("Cut a tree"),
	description = S("Cut down a tree, karate-style,"),
	icon = "whynot_awards_tree.png",
	requires = {},
	trigger = {
		type = "dig",
		node = "group:tree",
		target = 1,
	},
})


awards.register_award("whynot_planks",{
	title = S("Craft planks"),
	description = S("Chop some wood to make planks."),
	icon = "whynot_awards_wood.png",
	requires = {"whynot_tree"},
	trigger = {
		type = "craft",
		item = "group:wood",
		target = 1,
	},
})

awards.register_award("whynot_simple_boat",{
	title = S("Craft a raft"),
	description = S("A simple boat will let you travel on water faster than walking on ground."),
	icon = "whynot_awards_boat.png",
	requires = {"whynot_planks"},
	trigger = {
		type = "craft",
		item = "boats:boat",
		target = 1,
	},
})


awards.register_award("whynot_chest",{
	title = S("Craft a chest"),
	description = S("Chests are the most basic form of storage. They are very useful to gather more items than can fit in your character's inventory."),
	icon = "whynot_awards_chest.png",
	requires = {"whynot_planks"},
	trigger = {
		type = "craft",
		item = "default:chest",
		target = 1,
	},
})


awards.register_award("whynot_sticks",{
	title = S("Craft sticks"),
	description = S("Split planks to make sticks."),
	icon = "whynot_awards_stick.png",
	requires = {"whynot_planks"},
	trigger = {
		type = "craft",
		item = "group:stick",
		target = 1,
	},
})


awards.register_award("whynot_tools",{
	title = S("Craft wood tools"),
	description = S("The first tools you can craft are made of wood. They are not very strong or durable, but will enable you to start mining rock and minerals to move up to better ones."),
	icon = "whynot_awards_pick_wood.png",
	requires = {"whynot_sticks"},
	trigger = {
		type = "craft",
		item = "default:pick_wood",
		target = 1,
	},
})


awards.register_award("whynot_plow_soil",{
	title = S("Plow soil"),
	description = S("To grow your own food, you must first plow soil. Make sure to be close to water so that the crops can grow."),
	icon = "whynot_awards_hoe.png",
	requires = {"whynot_tools", "whynot_gatherfruitvegetable"},
	trigger = {
		type = "plow_soil",
		target = 1,
	},
})


awards.register_award("whynot_plant_crops",{
	title = S("Plant crops"),
	description = S("After your garden is prepared and plowed, it is time to plant. Find different crops and seeds and plant them in your garden to become self sufficient."),
	icon = "whynot_awards_hoe.png",
	requires = {"whynot_plow_soil"},
	trigger = {
		type = "plant_crops",
		target = 3,
	},
})


awards.register_award("whynot_bones",{
	title = S("Grave digger"),
	description = S("Dig dirt to find bones."),
	icon = "whynot_awards_bone.png",
	trigger = {
		type = "collect",
		item = "bonemeal:bone",
		target = 1,
	},
})


awards.register_award("whynot_cotton", {
	title = S("Collect cotton"),
	description = S("Wild cotton can be found the savanna. Alternatively you can plant, grow and harvest seeds found in the jungle.)"),
	icon = "whynot_awards_cotton_flower.png",
	trigger = {
		type = "collect",
		item = "farming:cotton",
		target = 1
	}
})


awards.register_award("whynot_wool", {
	title = S("Craft wool"),
	description = S("Wool is a very useful material for crafting garments, beds, and many other items."),
	icon = "whynot_awards_wool.png",
	requires = {"whynot_cotton"},
	trigger = {
		type = "craft",
		item = "group:wool",
		target = 1
	}
})


awards.register_award("whynot_backpack", {
	title = S("Craft a backpack"),
	description = S("Backpacks are very useful to help carry more stuff than the basic inventory lets you. It allows you keep mining longer and carry extra tools and food everywhere you go. Use dyed wools to create different coloured ones."),
	icon = "whynot_awards_wool.png",
	requires = {"whynot_wool"},
	trigger = {
		type = "craft",
		item = "group:backpack",
		target = 1
	}
})


awards.register_award("whynot_spawnpoint", {
	title = S("Find your new home"),
	description = S("Your home is the place with your bed. If you sleep once in bed, you always respawn at this position in case of death."),
	icon = "beds_bed.png",
	requires = {"whynot_planks",  "whynot_wool"},
--	prices = { }, -- Price is a new home ;-)
--	on_unlock = function(name, def) end
})

local orig_beds_on_rightclick = beds.on_rightclick
function beds.on_rightclick(pos, player)
	orig_beds_on_rightclick(pos, player)
	local player_name = player:get_player_name()
	if beds.player[player_name] then
		awards.unlock(player_name, "whynot_spawnpoint")
	end
end
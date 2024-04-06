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


local function escape_argument(texture_modifier)
	return texture_modifier:gsub(".", {["\\"] = "\\\\", ["^"] = "\\^", [":"] = "\\:"})
end

local function awards_combine_with_frame(...)
	local arg={...}
	if #arg == 1 then
		return "([combine:88x88:0,0=whynot_awards_frame.png:3,3="..escape_argument(arg[1].."^[resize:82x82")..")"
	else
		local composition = "([combine:88x88:0,0=whynot_awards_frame.png"
		for i=1, #arg do
			composition = composition..":"..escape_argument(arg[i])
		end
		return composition..")"
	end
end



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
	icon = awards_combine_with_frame("farming_carrot.png"),
	requires = {},
	trigger = {
		type = "gatherfruitvegetable",
		target = 3,
	},
})


awards.register_award("whynot_tree",{
	title = S("Cut a tree"),
	description = S("Cut down a tree, karate-style."),
	icon = awards_combine_with_frame(minetest.inventorycube("default_tree_top.png", "default_tree.png", "default_tree.png")),
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
	icon = awards_combine_with_frame(minetest.inventorycube("default_wood.png")),
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
	icon = awards_combine_with_frame("boats_inventory.png"),
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
	icon = awards_combine_with_frame(minetest.inventorycube("default_chest_top.png", "default_chest_front.png", "default_chest_side.png")),
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
	icon = awards_combine_with_frame("default_stick.png"),
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
	icon = awards_combine_with_frame("default_tool_woodpick.png"),
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
	icon = awards_combine_with_frame("farming_tool_stonehoe.png"),
	requires = {"whynot_tools", "whynot_gatherfruitvegetable"},
	trigger = {
		type = "plow_soil",
		target = 1,
	},
})


awards.register_award("whynot_plant_crops",{
	title = S("Plant crops"),
	description = S("After your garden is prepared and plowed, it is time to plant. Find different crops and seeds and plant them in your garden to become self sufficient."),
	icon = awards_combine_with_frame("farming_tool_stonehoe.png"),
	requires = {"whynot_plow_soil"},
	trigger = {
		type = "plant_crops",
		target = 3,
	},
})


awards.register_award("whynot_bones",{
	title = S("Grave digger"),
	description = S("Dig dirt to find bones."),
	icon = awards_combine_with_frame("bonemeal_bone.png"),
	trigger = {
		type = "collect",
		item = "bonemeal:bone",
		target = 1,
	},
})


awards.register_award("whynot_cotton", {
	title = S("Collect cotton"),
	description = S("Wild cotton can be found the savanna. Alternatively you can plant, grow and harvest seeds found in the jungle."),
	icon = awards_combine_with_frame("farming_cotton.png"),
	trigger = {
		type = "collect",
		item = "farming:cotton",
		target = 1
	}
})


awards.register_award("whynot_wool", {
	title = S("Craft wool"),
	description = S("Wool is a very useful material for crafting garments, beds, and many other items."),
	icon = awards_combine_with_frame(minetest.inventorycube("wool_white.png")),
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
	icon = awards_combine_with_frame(minetest.inventorycube("wool_white.png", "wool_white.png^backpacks_backpack_front.png", "wool_white.png")),
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
	icon = awards_combine_with_frame("beds_bed.png"),
	requires = {"whynot_planks",  "whynot_wool"},
--	prices = { }, -- Price is a new home ;-)
--	on_unlock = function(name, def) end
})

if minetest.get_modpath("beds") and minetest.global_exists("beds") then
	local orig_beds_on_rightclick = beds.on_rightclick
	function beds.on_rightclick(pos, player)
		orig_beds_on_rightclick(pos, player)
		local player_name = player:get_player_name()
		if beds.player[player_name] then
			awards.unlock(player_name, "whynot_spawnpoint")
		end
	end
end


awards.register_award("whynot_stone",{
	title = S("Mine stone"),
	description = S("Using a wood pick axe, start digging through stone. The cobblestone obtained from digging stone can then be used to craft sturdier tools."),
	icon = awards_combine_with_frame(minetest.inventorycube("default_cobble.png")),
	requires = {"whynot_tools"},
	trigger = {
		type = "dig",
		node = "group:stone",
		target = 1,
	},
})


awards.register_award("whynot_coal",{
	title = S("Mine coal"),
	description = S("Coal is a common mineral found underground. Among other things, it can be used to craft torches for lighting your way, or as combustible in furnaces."),
	icon = awards_combine_with_frame(minetest.inventorycube("default_stone.png^default_mineral_coal.png")),
	requires = {"whynot_tools"},
	trigger = {
		type = "dig",
		node = "default:stone_with_coal",
		target = 1,
	},
})


awards.register_award("whynot_campfire", {
	title = S("Craft a campfire"),
	description = S("If night falls and you have not found coal, build a campfire to make some light."),
	icon = awards_combine_with_frame("campfire:campfire"),
	requires = {"whynot_stone"},
	trigger = {
		type = "craft",
		item = "campfire:campfire",
		target = 1
	}
})


awards.register_award("whynot_furnace", {
	title = S("Craft a furnace"),
	description = S("Furnaces are central to advancing in this game. Use them to smelt ores, cook food, or both!"),
	icon = "whynot_awards_oven.png",
	requires = {"whynot_stone"},
	trigger = {
		type = "craft",
		item = "default:furnace",
		target = 1
	}
})


awards.register_award("whynot_max_depth", {
	title = S("Dig deeper"),
	description = S("Keep digging until you reach these depths."),
	--icon = "whynot_awards_hoe.png",
	requires = {"whynot_stone"},
	trigger = {
		type = "max",
		max_param = "depth",
		target = 2000,
	},
})


awards.register_award("whynot_max_altitude", {
	title = S("Fly higher"),
	description = S("Fly higher and soar to new heights"),
	--icon = "whynot_awards_hoe.png",
	requires = {},
	trigger = {
		type = "max",
		max_param = "altitude",
		target = 2000,
	},
})


awards.register_award("whynot_max_distance", {
	title = S("Travel further"),
	description = S("Sail the high seas and and explore lands far far away."),
	--icon = "whynot_awards_hoe.png",
	requires = {"whynot_simple_boat"},
	trigger = {
		type = "max",
		max_param = "distance",
		target = 2000,
	},
})


awards.register_award("whynot_chocolate", {
	title = S("Craft chocolate"),
	description = S("Make some delicious chocolate. It can be eaten or incorporated in various recipes to make succulent treats. You can even build an edible armour from it!"),
	icon = "whynot_awards_chocolate.png",
	requires = {"whynot_furnace"},
	trigger = {
		type = "craft",
		item = "farming:chocolate_dark",
		target = 1
	}
})


awards.register_award("whynot_well", {
	title = S("Craft a well"),
	description = S("Wells are not just pretty! They are very useful as an infinite source of water."),
	icon = "whynot_awards_well.png",
	requires = {"whynot_stone"},
	trigger = {
		type = "craft",
		item = "homedecor:well",
		target = 1
	}
})


awards.register_award("whynot_mine_tin", {
	title = S("Mine tin"),
	description = S("Tin is one of the first metal you'll encounter when digging down. Smelt it in a furnace to form ingots. Then combine it with copper to make bronze."),
	icon = "whynot_awards_tin.png",
	requires = {"whynot_stone"},
	trigger = {
		type = "dig",
		item = "default:stone_with_tin",
		target = 1
	}
})


awards.register_award("whynot_mine_copper", {
	title = S("Mine copper"),
	description = S("Copper is one of the first metal you'll encounter when digging down. Smelt it in a furnace to form ingots. Then combine it with tin to make bronze."),
	icon = "whynot_awards_copper.png",
	requires = {"whynot_stone"},
	trigger = {
		type = "dig",
		item = "default:stone_with_copper",
		target = 1
	}
})


awards.register_award("whynot_bronze", {
	title = S("Craft bronze"),
	description = S("Bronze is the first versatile metal you'll be able to use to craft better tools, armor and other items."),
	icon = "whynot_awards_bronze.png",
	requires = {"whynot_mine_copper", "whynot_mine_tin", "whynot_furnace"},
	trigger = {
		type = "craft",
		item = "default:bronze_ingot",
		target = 1
	}
})


awards.register_award("whynot_steel", {
	title = S("Craft steel"),
	description = S("Steel is stronger than bronze. Use it to upgrade your tools and armor."),
	icon = "whynot_awards_steel.png",
	requires = {"whynot_furnace"},
	trigger = {
		type = "craft",
		item = "default:steel_ingot",
		target = 1
	}
})


awards.register_award("whynot_supercub", {
	title = S("Craft an airplane"),
	description = S("Why not have airplanes? Build a Supercub and travel at high speeds and soar to new heights!"),
	icon = "whynot_awards_steel.png",
	requires = {"whynot_bronze", "whynot_steel", "awards_diamond_ore"},
	trigger = {
		type = "craft",
		item = "supercub:supercub",
		target = 1
	}
})
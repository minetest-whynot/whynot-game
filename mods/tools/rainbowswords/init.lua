-- Minetest 0.4.14+ mod: rainbowswords
-- namespace: rainbowswords
-- (c) 2016 by d.kartaschew

local load_start = os.clock()

local namespace = "rainbowswords"

local items = { 
{ "kahki_steel_sword", 	"Kahki Steel Sword", 	"rainbowswords_kahki_sword.png", {"default:sword_steel", "dye:green", "dye:grey"}, 1 },
{ "blue_steel_sword", 	"Blue Steel Sword", 	"rainbowswords_blue_sword.png", {"default:sword_steel", "dye:blue"}, 1 },
{ "red_steel_sword", 	"Red Steel Sword", 	"rainbowswords_red_sword.png", {"default:sword_steel", "dye:red"}, 1 },
{ "white_steel_sword", 	"White Steel Sword", 	"rainbowswords_white_sword.png", {"default:sword_steel", "dye:white"}, 1 },
{ "grey_steel_sword", 	"Grey Steel Sword", 	"rainbowswords_grey_sword.png", {"default:sword_steel", "dye:grey"}, 1 } ,
{ "dkgrey_steel_sword", "Dark Grey Steel Block", "rainbowswords_dark_grey_sword.png", {"default:sword_steel", "dye:dark_grey"}, 1 },
{ "black_steel_sword", 	"Black Steel Sword", 	"rainbowswords_black_sword.png", {"default:sword_steel", "dye:black"} , 1 },
{ "cyan_steel_sword", 	"Cyan Steel Sword", 	"rainbowswords_cyan_sword.png", {"default:sword_steel", "dye:cyan"} , 1 },
{ "dkgreen_steel_sword", "Dark Green Steel Sword", "rainbowswords_dark_green_sword.png", {"default:sword_steel", "dye:dark_green"} , 1 },
{ "green_steel_sword", 	"Green Steel Sword", 	"rainbowswords_green_sword.png", {"default:sword_steel", "dye:green"} , 1 },
{ "yellow_steel_sword", "Yellow Steel Sword", 	"rainbowswords_yellow_sword.png", {"default:sword_steel", "dye:yellow"} , 1 },
{ "brown_steel_sword", 	"Brown Steel Sword", 	"rainbowswords_brown_sword.png", {"default:sword_steel", "dye:brown"} , 1 },
{ "orange_steel_sword", "Orange Steel Sword", 	"rainbowswords_orange_sword.png", {"default:sword_steel", "dye:orange"} , 1 },
{ "magenta_steel_sword", "Magenta Steel Sword", "rainbowswords_magenta_sword.png", {"default:sword_steel", "dye:magenta"} , 1 },
{ "flowerpower_steel_sword", "FlowerPower Steel Sword", "rainbowswords_flowerpower_blade.png", {"default:sword_steel", "dye:red", "dye:white"} , 1 },
{ "rainbow_steel_sword", "Rainbow Steel Sword", "rainbowswords_rainbow_blade.png", 
	{"default:sword_steel", "dye:red", "dye:orange" , "dye:yellow" , "dye:green" , "dye:blue"} , 1 },
}


-- loop over all items and register
for i = 1, #items do

  -- register tool
	minetest.register_tool(":" .. namespace .. ":" .. items[i][1], {
		description = items[i][2],
		inventory_image = items[i][3] ,
		tool_capabilities = {
			full_punch_interval = 0.8,
			max_drop_level=1,
			groupcaps={
				snappy={times={[1]=2.5, [2]=1.20, [3]=0.35}, uses=30, maxlevel=2},
			},
			damage_groups = {fleshy=6},
		},
		sound = {breaks = "default_tool_breaks"},
	})

  -- register crafting
	minetest.register_craft({
		type = "shapeless",
		output = namespace .. ":" .. items[i][1] .. " " .. items[i][5],
		recipe = items[i][4]
	})



-- End item loop.
end

-- Special swords

-- register Ghost Blade
	minetest.register_tool(":" .. namespace .. ":ghostblade", {
		description = "Ghost Blade",
		inventory_image = "rainbowswords_ghosts_blade.png" ,
		tool_capabilities = {
			full_punch_interval = 0.4,
			max_drop_level=1,
			groupcaps={
				snappy={times={[1]=1.0, [2]=0.45, [3]=0.15}, uses=50, maxlevel=5},
			},
			damage_groups = {fleshy=10},
		},
		sound = {breaks = "default_tool_breaks"},
	})

  -- register crafting
	minetest.register_craft({
		type = "shapeless",
		output = namespace .. ":ghostblade 1",
		recipe = {"default:sword_diamond", "dye:black", "dye:blue"}
	})

if minetest.setting_getbool("log_mods") then
print(("[RainbowSwords] Loaded in %f seconds"):format(os.clock() - load_start))
end


--+--Crafting Recipes--+--

--Check for Homedecor before craft recipe is defined
if minetest.get_modpath("homedecor") then

	--Use alternate recipe if Homedecor is enabled
	--Waffle Maker (with Homedecor enabled)
	minetest.register_craft({
		output = 'waffles:wafflemaker',
		recipe = {
			{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
			{'', '', 'homedecor:power_crystal'},
			{'homedecor:plastic_sheeting', 'homedecor:heating_element', 'homedecor:copper_strip'},
		}
	})
	
	--Reverse Recipe for Waffle Maker (with Homedecor enabled)
	minetest.register_craft({
		output = 'waffles:wafflemaker',
		recipe = {
			{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
			{'homedecor:power_crystal', '', ''},
			{'homedecor:copper_strip', 'homedecor:heating_element', 'homedecor:plastic_sheeting'},
		}
	})
	
else

	--When Homedecor is not enabled, use these recipes
	--Waffle Maker
	minetest.register_craft({
		output = 'waffles:wafflemaker',
		recipe = {
			{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
			{'', 'default:furnace', 'default:copper_ingot'},
			{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		}
	})
	
	--Reverse Recipe for Waffle Maker
	minetest.register_craft({
		output = 'waffles:wafflemaker',
		recipe = {
			{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
			{'default:copper_ingot', 'default:furnace', ''},
			{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
		}
	})
	
	--Toaster (Only Available if Homedecor is Not Enabled, Uses Homedecor Toaster Craft Instead if Homedecor is Enabled)
	minetest.register_craft({
		output = 'waffles:toaster',
		recipe = {
			{'default:steel_ingot', 'default:copper_ingot', 'default:steel_ingot'},
			{'default:steel_ingot', 'bucket:bucket_lava', 'default:steel_ingot'},
		}
	})
	
end

--Recipes that should appear regardless Homedecor is installed or not goes here
--Waffle Batter
minetest.register_craft({
	output = 'waffles:waffle_batter_1',
	recipe = {
		{'farming:flour'},
		{'farming:flour'},
		{'bucket:bucket_water'},
	}
})

--Small Waffles
minetest.register_craft({
	output = 'waffles:small_waffle 4',
	recipe = {
		{'waffles:large_waffle'},
	}
})

--Slice of Bread (only if not farming one used)
if not minetest.registered_items["farming:bread_slice"] then
	minetest.register_craft({
		output = 'waffles:breadslice 2',
		type = "shapeless",
		recipe = {"farming:bread"}
	})
end

--Package of Toaster Waffles
minetest.register_craft({
	output = 'waffles:toaster_waffle_pack',
	recipe = {
		{'', 'default:paper', ''},
		{'default:paper', 'waffles:waffle_batter_1', 'default:paper'},
		{'', 'default:paper', ''},
	}
})

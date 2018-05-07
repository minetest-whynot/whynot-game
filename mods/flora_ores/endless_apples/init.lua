
-- override default apple
minetest.register_node(":default:apple", {
	description = "Apple",
	drawtype = "plantlike",
	tiles = {"default_apple.png"},
	inventory_image = "default_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-3 / 16, -7 / 16, -3 / 16, 3 / 16, 4 / 16, 3 / 16}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
		leafdecay = 3, leafdecay_drop = 1, food_apple = 1},
	on_use = minetest.item_eat(2),
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		minetest.set_node(pos, {name = "default:apple", param2 = 1})
	end,

	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		if oldnode.param2 == 0 then
			minetest.set_node(pos, {name = "endless_apples:apple_mark"})
			minetest.get_node_timer(pos):start(math.random(2400, 4800))
		end
	end,
})

-- air node to mark apple pos
minetest.register_node("endless_apples:apple_mark", {
	description = "Air!",
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	groups = {not_in_creative_inventory = 1},
	on_timer = function(pos, elapsed)
		if not minetest.find_node_near(pos, 1, "default:leaves") then
			minetest.remove_node(pos)
		elseif minetest.get_node_light(pos) < 13 then
			minetest.get_node_timer(pos):start(300)
		else 
			minetest.set_node(pos, {name = "default:apple"})
		end
	end
})

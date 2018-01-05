dofile(minetest.get_modpath("hovercraft").."/hover.lua")

hover:register_hovercraft("hovercraft:hover_red" ,{
	description = "Red Hovercraft",
	textures = {"hovercraft_red.png"},
	inventory_image = "hovercraft_red_inv.png",
	max_speed = 10,
	acceleration = 0.25,
	deceleration = 0.05,
	jump_velocity = 4.0,
	fall_velocity = 1.0,
	bounce = 0.5,
})

hover:register_hovercraft("hovercraft:hover_blue" ,{
	description = "Blue Hovercraft",
	textures = {"hovercraft_blue.png"},
	inventory_image = "hovercraft_blue_inv.png",
	max_speed = 12,
	acceleration = 0.25,
	deceleration = 0.1,
	jump_velocity = 4.0,
	fall_velocity = 1.0,
	bounce = 0.8,
})

hover:register_hovercraft("hovercraft:hover_green" ,{
	description = "Green Hovercraft",
	textures = {"hovercraft_green.png"},
	inventory_image = "hovercraft_green_inv.png",
	max_speed = 8,
	acceleration = 0.25,
	deceleration = 0.15,
	jump_velocity = 5.5,
	fall_velocity = 1.5,
	bounce = 0.5,
})

hover:register_hovercraft("hovercraft:hover_yellow" ,{
	description = "Yellow Hovercraft",
	textures = {"hovercraft_yellow.png"},
	inventory_image = "hovercraft_yellow_inv.png",
	max_speed = 8,
	acceleration = 0.25,
	deceleration = 0.05,
	jump_velocity = 3.0,
	fall_velocity = 0.5,
	bounce = 0.25,
})

minetest.register_craft({
	output = 'hovercraft:hover_red',
	recipe = {
		{'', '', 'default:steelblock'},
		{'wool:red', 'wool:red', 'wool:red'},
		{'wool:black', 'wool:black', 'wool:black'},
	}
})

minetest.register_craft({
	output = 'hovercraft:hover_blue',
	recipe = {
		{'', '', 'default:steelblock'},
		{'wool:blue', 'wool:blue', 'wool:blue'},
		{'wool:black', 'wool:black', 'wool:black'},
	}
})

minetest.register_craft({
	output = 'hovercraft:hover_green',
	recipe = {
		{'', '', 'default:steelblock'},
		{'wool:green', 'wool:green', 'wool:green'},
		{'wool:black', 'wool:black', 'wool:black'},
	}
})

minetest.register_craft({
	output = 'hovercraft:hover_yellow',
	recipe = {
		{'', '', 'default:steelblock'},
		{'wool:yellow', 'wool:yellow', 'wool:yellow'},
		{'wool:black', 'wool:black', 'wool:black'},
	}
})

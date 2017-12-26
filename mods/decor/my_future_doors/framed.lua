local doorcolors = {"white","red","black"}
for i = 1,#doorcolors do
local col = doorcolors[i]

minetest.register_node("my_future_doors:door1a_"..col, {
	description = "Door 1a",
	tiles = {
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col.."b.png",
		"myndoors_door1_"..col.."b.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.1875, 0.4375, 0.5, -0.0625},
			{-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
			{0.4375, -0.5, -0.5, 0.5, 0.5, 0.5},
			{0.4375, -0.5, 0.5, 0.625, 0.5, 0.5625},
			{0.4375, -0.5, -0.5625, 0.625, 0.5, -0.5},
			{-0.625, -0.5, -0.5625, -0.4375, 0.5, -0.5},
			{-0.625, -0.5, 0.5, -0.4375, 0.5, 0.5625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.4375,	-0.5,	-0.1875,	0.4375, 1.5,	-0.0625}, --door
			{0.4375,	-0.5,	-0.5625,	0.625,	1.4375, 0.5625}, --right
			{-0.625,	-0.5,	-0.5625,	-0.4375, 1.4375, 0.5625}, --left
			{-0.625,	1.4375,	 -0.5625,	0.625,	1.625,	0.5625}, --top
		}
	},

on_place = function(itemstack, placer, pointed_thing)
	local pos1 = pointed_thing.above
	local pos2 = {x=pos1.x, y=pos1.y, z=pos1.z}
	      pos2.y = pos2.y+1
	if
	not minetest.registered_nodes[minetest.get_node(pos1).name].buildable_to or
	not minetest.registered_nodes[minetest.get_node(pos2).name].buildable_to or
	not placer or
	not placer:is_player() then
	return
	end
        return minetest.item_place(itemstack, placer, pointed_thing)
end,
after_place_node = function(pos, placer, itemstack, pointed_thing)
	local node = minetest.get_node(pos)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="my_future_doors:door1b_"..col,param2=node.param2})
end,
after_destruct = function(pos, oldnode)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="air"})
end,
on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local timer = minetest.get_node_timer(pos)
	if node.name == "my_future_doors:door1a_"..col then
	   minetest.set_node(pos,{name="my_future_doors:door1c_"..col,param2=node.param2})
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="my_future_doors:door1d_"..col,param2=node.param2})
	   timer:start(3)
	end
end,
})
minetest.register_node("my_future_doors:door1b_"..col, {
	tiles = {
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col.."b.png",
		"myndoors_door1_"..col.."b.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.1875, 0.4375, 0.5, -0.0625},
			{-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
			{0.4375, -0.5, -0.5, 0.5, 0.5, 0.5},
			{0.4375, -0.5, 0.5, 0.625, 0.5, 0.5625},
			{0.4375, -0.5, -0.5625, 0.625, 0.5, -0.5},
			{-0.625, -0.5, -0.5625, -0.4375, 0.5, -0.5},
			{-0.625, -0.5, 0.5, -0.4375, 0.5, 0.5625},
			{-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
			{-0.625, 0.4375, -0.5625, 0.625, 0.625, -0.5},
			{-0.625, 0.4375, 0.5, 0.625, 0.625, 0.5625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.5, -0.5, -0.5},
		}
	},
})minetest.register_node("my_future_doors:door1c_"..col, {
	tiles = {
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col.."b.png",
		"myndoors_door1_"..col.."b.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
			{0.4375, -0.5, -0.5, 0.5, 0.5, 0.5},
			{0.4375, -0.5, 0.5, 0.625, 0.5, 0.5625},
			{0.4375, -0.5, -0.5625, 0.625, 0.5, -0.5},
			{-0.625, -0.5, -0.5625, -0.4375, 0.5, -0.5},
			{-0.625, -0.5, 0.5, -0.4375, 0.5, 0.5625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0.4375,	-0.5,	-0.5625,	0.625,	1.4375, 0.5625}, --right
			{-0.625,	-0.5,	-0.5625,	-0.4375, 1.4375, 0.5625}, --left
			{-0.625,	1.4375,	 -0.5625,	0.625,	1.625,	0.5625}, --top
		}
	},
after_place_node = function(pos, placer, itemstack, pointed_thing)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="my_future_doors:door1d_"..col,param2=nodeu.param2})
end,
after_destruct = function(pos, oldnode)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="air"})
end,
on_timer = function(pos, elapsed)
	local node = minetest.get_node(pos)
	   minetest.set_node(pos,{name="my_future_doors:door1a_"..col,param2=node.param2})
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="my_future_doors:door1b_"..col,param2=node.param2})
end,
})
minetest.register_node("my_future_doors:door1d_"..col, {
	tiles = {
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col..".png",
		"myndoors_door1_"..col.."b.png",
		"myndoors_door1_"..col.."b.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
			{0.4375, -0.5, -0.5, 0.5, 0.5, 0.5},
			{0.4375, -0.5, 0.5, 0.625, 0.5, 0.5625},
			{0.4375, -0.5, -0.5625, 0.625, 0.5, -0.5},
			{-0.625, -0.5, -0.5625, -0.4375, 0.5, -0.5},
			{-0.625, -0.5, 0.5, -0.4375, 0.4375, 0.5625},
			{-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
			{-0.625, 0.4375, -0.5625, 0.625, 0.625, -0.5},
			{-0.625, 0.4375, 0.5, 0.625, 0.625, 0.5625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, -0.5, -0.5, -0.5},
		}
	},
})
minetest.register_craft({
	output = "my_future_doors:door1a_"..col.." 1",
	recipe = {
		{"my_door_wood:wood_"..col, "wool:"..col, "my_door_wood:wood_"..col},
		{"wool:"..col, "my_door_wood:wood_"..col, "wool:"..col},
		{"my_door_wood:wood_"..col, "wool:"..col, "my_door_wood:wood_"..col}
	}
})
end

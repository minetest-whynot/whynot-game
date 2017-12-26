minetest.register_node("my_misc_doors:door2a", {
	description = "Sliding Door",
	inventory_image = "mydoors_bars.png",
	tiles = {
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.0625, -0.3125, 0.5, 0.0625},
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
			{0.3125, -0.5, -0.0625, 0.4375, 0.5, 0.0625},
			{0.125, -0.5, -0.0625, 0.25, 0.5, 0.0625},
			{-0.25, -0.5, -0.0625, -0.125, 0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.0625, 0.4375, 1.5, 0.0625},
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
			local pt = pointed_thing.above
			local pt2 = {x=pt.x, y=pt.y, z=pt.z}
			pt2.y = pt2.y+1
			local p2 = minetest.dir_to_facedir(placer:get_look_dir())
			local pt3 = {x=pt.x, y=pt.y, z=pt.z}
			local p4 = 0
			if p2 == 0 then
				pt3.x = pt3.x-1
				p4 = 2
			elseif p2 == 1 then
				pt3.z = pt3.z+1
				p4 = 3
			elseif p2 == 2 then
				pt3.x = pt3.x+1
				p4 = 0
			elseif p2 == 3 then
				pt3.z = pt3.z-1
				p4 = 1
			end
			if minetest.get_node(pt3).name == "my_misc_doors:door2a" then
				minetest.set_node(pt, {name="my_misc_doors:door2a", param2=p4})
				minetest.set_node(pt2, {name="my_misc_doors:door2b", param2=p4})
			else
				minetest.set_node(pt, {name="my_misc_doors:door2a", param2=p2})
				minetest.set_node(pt2, {name="my_misc_doors:door2b", param2=p2})
			end
end,
after_destruct = function(pos, oldnode)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="air"})
end,
on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local timer = minetest.get_node_timer(pos)
	local a = minetest.get_node({x=pos.x, y=pos.y, z=pos.z-1})
	local b = minetest.get_node({x=pos.x, y=pos.y, z=pos.z+1})
	local c = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z})
	local d = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z})
		minetest.set_node(pos, {name="my_misc_doors:door2c", param2=node.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name="my_misc_doors:door2d", param2=node.param2})

	     if a.name == "my_misc_doors:door2a" then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name="my_misc_doors:door2c", param2=a.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z-1}, {name="my_misc_doors:door2d", param2=a.param2})
		end
	     if b.name == "my_misc_doors:door2a" then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name="my_misc_doors:door2c", param2=b.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z+1}, {name="my_misc_doors:door2d", param2=b.param2})
		end
	     if c.name == "my_misc_doors:door2a" then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name="my_misc_doors:door2c", param2=c.param2})
		minetest.set_node({x=pos.x+1,y=pos.y+1,z=pos.z}, {name="my_misc_doors:door2d", param2=c.param2})
		end
	     if d.name == "my_misc_doors:door2a" then
		minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name="my_misc_doors:door2c", param2=d.param2})
		minetest.set_node({x=pos.x-1,y=pos.y+1,z=pos.z}, {name="my_misc_doors:door2d", param2=d.param2})
		end

	   timer:start(3)

end,
})
minetest.register_node("my_misc_doors:door2b", {
	tiles = {
		"mydoors_bars.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.5, -0.0625, -0.3125, 0.5, 0.0625},
			{-0.0625, -0.5, -0.0625, 0.0625, 0.5, 0.0625},
			{0.3125, -0.5, -0.0625, 0.4375, 0.5, 0.0625},
			{0.125, -0.5, -0.0625, 0.25, 0.5, 0.0625},
			{-0.25, -0.5, -0.0625, -0.125, 0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0},
		}
	},
})
minetest.register_node("my_misc_doors:door2c", {
	tiles = {
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png^[transformFX",
		"mydoors_bars.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, -0.375, -0.0625, -0.3125, -0.5, 0.0625},
			{-0.0625, -0.375, -0.0625, 0.0625, -0.5, 0.0625},
			{0.3125, -0.375, -0.0625, 0.4375, -0.5, 0.0625},
			{0.125, -0.375, -0.0625, 0.25, -0.5, 0.0625},
			{-0.25, -0.375, -0.0625, -0.125, -0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0},
		}
	},
after_place_node = function(pos, placer, itemstack, pointed_thing)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="my_misc_doors:door2d",param2=nodeu.param2})
end,
after_destruct = function(pos, oldnode)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="air"})
end,
on_timer = function(pos, elapsed)
	local node = minetest.get_node(pos)
	local a = minetest.get_node({x=pos.x, y=pos.y, z=pos.z-1})
	local b = minetest.get_node({x=pos.x, y=pos.y, z=pos.z+1})
	local c = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z})
	local d = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z})
		minetest.set_node(pos, {name="my_misc_doors:door2a", param2=node.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name="my_misc_doors:door2b", param2=node.param2})

	     if a.name == "my_misc_doors:door2c" then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name="my_misc_doors:door2a", param2=a.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z-1}, {name="my_misc_doors:door2b", param2=a.param2})
		end
	     if b.name == "my_misc_doors:door2c" then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name="my_misc_doors:door2a", param2=b.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z+1}, {name="my_misc_doors:door2b", param2=b.param2})
		end
	     if c.name == "my_misc_doors:door2c" then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name="my_misc_doors:door2a", param2=c.param2})
		minetest.set_node({x=pos.x+1,y=pos.y+1,z=pos.z}, {name="my_misc_doors:door2b", param2=c.param2})
		end
	     if d.name == "my_misc_doors:door2c" then
		minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name="my_misc_doors:door2a", param2=d.param2})
		minetest.set_node({x=pos.x-1,y=pos.y+1,z=pos.z}, {name="my_misc_doors:door2b", param2=d.param2})
		end

end,
})
minetest.register_node("my_misc_doors:door2d", {
	tiles = {
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png",
		"mydoors_bars.png^[transformFX",
		"mydoors_bars.png",
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.4375, 0.375, -0.0625, -0.3125, 0.5, 0.0625},
			{-0.0625, 0.375, -0.0625, 0.0625, 0.5, 0.0625},
			{0.3125, 0.375, -0.0625, 0.4375, 0.5, 0.0625},
			{0.125, 0.375, -0.0625, 0.25, 0.5, 0.0625},
			{-0.25, 0.375, -0.0625, -0.125, 0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0},
		}
	},
})
minetest.register_craft({
	output = "my_misc_doors:door2a 1",
	recipe = {
		{"default:steel_ingot", "default:steelblock", ""},
		{"default:steel_ingot", "default:steel_ingot", ""},
		{"default:steelblock", "default:steel_ingot", ""}
	}
})

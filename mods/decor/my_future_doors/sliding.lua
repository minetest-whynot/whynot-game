local doors = {
	{"my_future_doors:door2a","my_future_doors:door2b","my_future_doors:door2c","my_future_doors:door2d","2","Steel"},
	{"my_future_doors:door3a","my_future_doors:door3b","my_future_doors:door3c","my_future_doors:door3d","3","Squared"},
	{"my_future_doors:door4a","my_future_doors:door4b","my_future_doors:door4c","my_future_doors:door4d","4","Dark"},
	{"my_future_doors:door6a","my_future_doors:door6b","my_future_doors:door6c","my_future_doors:door6d","6","Points"},
	{"my_future_doors:door7a","my_future_doors:door7b","my_future_doors:door7c","my_future_doors:door7d","7","Snow Flake"},
	{"my_future_doors:door8a","my_future_doors:door8b","my_future_doors:door8c","my_future_doors:door8d","8","Blue Steel"},
	{"my_future_doors:door9a","my_future_doors:door9b","my_future_doors:door9c","my_future_doors:door9d","9","Tan Steel"},
	}

local recipes = {
	{{"default:steel_ingot", "default:steelblock", ""},
		{"default:steel_ingot", "default:steel_ingot", ""},
		{"default:steelblock", "default:steel_ingot", ""}},
	{{"default:steel_ingot","default:steel_ingot", ""},
		{"default:steel_ingot", "default:steel_ingot", ""},
		{"default:steelblock", "default:steelblock", ""}},
	{{"default:steel_ingot","default:steel_ingot", ""},
		{"default:steel_ingot", "default:steel_ingot", "dye:black"},
		{"default:steelblock", "default:steelblock", ""}},
	{{"default:steel_ingot","default:steel_ingot", ""},
		{"default:steelblock", "default:steelblock", ""},
		{"default:steel_ingot", "default:steel_ingot", ""}},
	{{"default:steel_ingot", "default:steelblock", ""},
		{"default:steel_ingot", "default:steel_ingot", ""},
		{ "default:steel_ingot", "default:steelblock",""}},
	{{"default:steel_ingot", "default:steelblock", ""},
		{"default:steel_ingot", "default:steel_ingot", "dye:blue"},
		{ "default:steel_ingot", "default:steelblock",""}},
	{{"default:steel_ingot", "default:steelblock", ""},
		{"default:steel_ingot", "default:steel_ingot", "dye:brown"},
		{ "default:steel_ingot", "default:steelblock",""}},
}
for i in ipairs (doors) do
local doora = doors[i][1]
local doorb = doors[i][2]
local doorc = doors[i][3]
local doord = doors[i][4]
local num = doors[i][5]
local des = doors[i][6]
local recipe = recipes[i]

local function onplace(itemstack, placer, pointed_thing)
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
			if minetest.get_node(pt3).name == doora then
				minetest.set_node(pt, {name=doora, param2=p4})
				minetest.set_node(pt2, {name=doorb, param2=p4})
			else
				minetest.set_node(pt, {name=doora, param2=p2})
				minetest.set_node(pt2, {name=doorb, param2=p2})
			end
		itemstack: take_item()
		return itemstack
end

local function afterdestruct(pos, oldnode)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="air"})
end

local function rightclick(pos, node, player, itemstack, pointed_thing)
	local timer = minetest.get_node_timer(pos)
	local a = minetest.get_node({x=pos.x, y=pos.y, z=pos.z-1})
	local b = minetest.get_node({x=pos.x, y=pos.y, z=pos.z+1})
	local c = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z})
	local d = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z})
		minetest.set_node(pos, {name=doorc, param2=node.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name=doord, param2=node.param2})

	     if a.name == doora then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name=doorc, param2=a.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z-1}, {name=doord, param2=a.param2})
		end
	     if b.name == doora then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name=doorc, param2=b.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z+1}, {name=doord, param2=b.param2})
		end
	     if c.name == doora then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name=doorc, param2=c.param2})
		minetest.set_node({x=pos.x+1,y=pos.y+1,z=pos.z}, {name=doord, param2=c.param2})
		end
	     if d.name == doora then
		minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name=doorc, param2=d.param2})
		minetest.set_node({x=pos.x-1,y=pos.y+1,z=pos.z}, {name=doord, param2=d.param2})
		end

	   timer:start(3)

end

local function afterplace(pos, placer, itemstack, pointed_thing)
	   minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name=doord,param2=nodeu.param2})
end

local function ontimer(pos, elapsed)
	local node = minetest.get_node(pos)
	local a = minetest.get_node({x=pos.x, y=pos.y, z=pos.z-1})
	local b = minetest.get_node({x=pos.x, y=pos.y, z=pos.z+1})
	local c = minetest.get_node({x=pos.x+1, y=pos.y, z=pos.z})
	local d = minetest.get_node({x=pos.x-1, y=pos.y, z=pos.z})
		minetest.set_node(pos, {name=doora, param2=node.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z}, {name=doorb, param2=node.param2})

	     if a.name == doorc then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name=doora, param2=a.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z-1}, {name=doorb, param2=a.param2})
		end
	     if b.name == doorc then
		minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name=doora, param2=b.param2})
		minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z+1}, {name=doorb, param2=b.param2})
		end
	     if c.name == doorc then
		minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name=doora, param2=c.param2})
		minetest.set_node({x=pos.x+1,y=pos.y+1,z=pos.z}, {name=doorb, param2=c.param2})
		end
	     if d.name == doorc then
		minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name=doora, param2=d.param2})
		minetest.set_node({x=pos.x-1,y=pos.y+1,z=pos.z}, {name=doorb, param2=d.param2})
		end

end

minetest.register_node(doora, {
	description = des.." Sliding Door",
	inventory_image = "myndoors_door"..num.."a_inv.png",
	wield_image = "myndoors_door"..num.."a_inv.png",
	tiles = {
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_bottom.png",
		"myndoors_door"..num.."a_bottom.png^[transformFX"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 3},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 1.5, 0.0625}
		}
	},

on_place = onplace,

after_destruct = afterdestruct,

on_rightclick = rightclick,
})
minetest.register_node(doorb, {
	tiles = {
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_bottom.png^[transformFY",
		"myndoors_door"..num.."a_bottom.png^[transformFX^[transformFY"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.0625}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{0, 0, 0, 0, 0, 0},
		}
	},
})minetest.register_node(doorc, {
	tiles = {
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_bottomo.png",
		"myndoors_door"..num.."a_bottomo.png^[transformFX"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	drop = doora,
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, -0.25, 0.5, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, -0.25, 1.5, 0.0625},
		}
	},
after_place_node = afterplace,
after_destruct = afterdestruct,
on_timer = ontimer,
})
minetest.register_node(doord, {
	tiles = {
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_edge.png",
		"myndoors_door"..num.."a_bottomo.png^[transformFY",
		"myndoors_door"..num.."a_bottomo.png^[transformFX^[transformFY"
	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, -0.25, 0.5, 0.0625},
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
	output = "my_future_doors:door"..num.."a 2",
	recipe = recipe
})
end

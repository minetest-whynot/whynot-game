
-- suck in items on top of hopper
minetest.register_abm({
	label = "Hopper suction",
	nodenames = {"hopper:hopper", "hopper:hopper_side"},
	interval = 1.0,
	chance = 1,
	action = function(pos, _, _, active_object_count_wider)
		if active_object_count_wider == 0 then
			return
		end

		local inv = minetest.get_meta(pos):get_inventory()
		if not inv then
			return
		end

		for _,object in pairs(minetest.get_objects_inside_radius(pos, 1)) do
			local entity = not object:is_player() and object:get_luaentity()

			if entity
			and entity.name == "__builtin:item"
			and inv:room_for_item("main", ItemStack(entity.itemstring)) then

				local posob = object:get_pos()

				if math.abs(posob.x - pos.x) <= 0.5
				and posob.y - pos.y <= 0.85
				and posob.y - pos.y >= 0.3 then

					inv:add_item("main", ItemStack(entity.itemstring))

					entity.itemstring = ""
					object:remove()
				end
			end
		end
	end,
})

-- Used to convert side hopper facing into source and destination relative coordinates
-- This was tedious to populate and test
local directions = {
	[0]={["src"]={x=0, y=1, z=0},["dst"]={x=-1, y=0, z=0}},
	[1]={["src"]={x=0, y=1, z=0},["dst"]={x=0, y=0, z=1}},
	[2]={["src"]={x=0, y=1, z=0},["dst"]={x=1, y=0, z=0}},
	[3]={["src"]={x=0, y=1, z=0},["dst"]={x=0, y=0, z=-1}},
	[4]={["src"]={x=0, y=0, z=1},["dst"]={x=-1, y=0, z=0}},
	[5]={["src"]={x=0, y=0, z=1},["dst"]={x=0, y=-1, z=0}},
	[6]={["src"]={x=0, y=0, z=1},["dst"]={x=1, y=0, z=0}},
	[7]={["src"]={x=0, y=0, z=1},["dst"]={x=0, y=1, z=0}},
	[8]={["src"]={x=0, y=0, z=-1},["dst"]={x=-1, y=0, z=0}},
	[9]={["src"]={x=0, y=0, z=-1},["dst"]={x=0, y=1, z=0}},
	[10]={["src"]={x=0, y=0, z=-1},["dst"]={x=1, y=0, z=0}},
	[11]={["src"]={x=0, y=0, z=-1},["dst"]={x=0, y=-1, z=0}},
	[12]={["src"]={x=1, y=0, z=0},["dst"]={x=0, y=1, z=0}},
	[13]={["src"]={x=1, y=0, z=0},["dst"]={x=0, y=0, z=1}},
	[14]={["src"]={x=1, y=0, z=0},["dst"]={x=0, y=-1, z=0}},
	[15]={["src"]={x=1, y=0, z=0},["dst"]={x=0, y=0, z=-1}},
	[16]={["src"]={x=-1, y=0, z=0},["dst"]={x=0, y=-1, z=0}},
	[17]={["src"]={x=-1, y=0, z=0},["dst"]={x=0, y=0, z=1}},
	[18]={["src"]={x=-1, y=0, z=0},["dst"]={x=0, y=1, z=0}},
	[19]={["src"]={x=-1, y=0, z=0},["dst"]={x=0, y=0, z=-1}},
	[20]={["src"]={x=0, y=-1, z=0},["dst"]={x=1, y=0, z=0}},
	[21]={["src"]={x=0, y=-1, z=0},["dst"]={x=0, y=0, z=1}},
	[22]={["src"]={x=0, y=-1, z=0},["dst"]={x=-1, y=0, z=0}},
	[23]={["src"]={x=0, y=-1, z=0},["dst"]={x=0, y=0, z=-1}},
}

local bottomdir = function(facedir)
	return ({[0]={x=0, y=-1, z=0},
		{x=0, y=0, z=-1},
		{x=0, y=0, z=1},
		{x=-1, y=0, z=0},
		{x=1, y=0, z=0},
		{x=0, y=1, z=0}})[math.floor(facedir/4)]
end

-- hopper workings
minetest.register_abm({
	label = "Hopper transfer",
	nodenames = {"hopper:hopper", "hopper:hopper_side"},
	neighbors = hopper.neighbors,
	interval = 1.0,
	chance = 1,
	catch_up = false,

	action = function(pos, node, _, _)
		local source_pos, destination_pos, destination_dir
		if node.name == "hopper:hopper_side" then
			source_pos = vector.add(pos, directions[node.param2].src)
			destination_dir = directions[node.param2].dst
			destination_pos = vector.add(pos, destination_dir)
		else
			destination_dir = bottomdir(node.param2)
			source_pos = vector.subtract(pos, destination_dir)
			destination_pos = vector.add(pos, destination_dir)
		end

		local output_direction = "bottom"
		if destination_dir.y == 0 then
			output_direction = "side"
		end

		local source_node = minetest.get_node(source_pos)
		local destination_node = minetest.get_node(destination_pos)

		local registered_source_inventories = hopper.get_registered(source_node.name)
		if registered_source_inventories ~= nil then
			hopper.take_item_from(pos, source_pos, source_node, registered_source_inventories["top"])
		end

		local registered_destination_inventories = hopper.get_registered(destination_node.name)
		if registered_destination_inventories ~= nil then
			if not hopper.send_item_to(pos, destination_pos, destination_node, registered_destination_inventories[output_direction]) then
				hopper.try_eject_item(pos, destination_pos)
			end
		else
			hopper.try_eject_item(pos, destination_pos)
		end
	end,
})

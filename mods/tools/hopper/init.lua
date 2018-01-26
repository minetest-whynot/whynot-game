
-- define global
hopper = {}


-- Intllib
local S

if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s, a, ...) a = {a, ...}
		return s:gsub("@(%d+)", function(n)
			return a[tonumber(n)]
		end)
	end

end

-- creative check
local creative_mode_cache = minetest.settings:get_bool("creative_mode")
function check_creative(name)
	return creative_mode_cache or minetest.check_player_privs(name, {creative = true})
end


-- default containers
local containers = {

	{"top", "hopper:hopper", "main"},
	{"bottom", "hopper:hopper", "main"},
	{"side", "hopper:hopper", "main"},
	{"side", "hopper:hopper_side", "main"},

	{"top", "default:chest", "main"},
	{"bottom", "default:chest", "main"},
	{"side", "default:chest", "main"},

	{"top", "default:furnace", "dst"},
	{"bottom", "default:furnace", "src"},
	{"side", "default:furnace", "fuel"},

	{"top", "default:furnace_active", "dst"},
	{"bottom", "default:furnace_active", "src"},
	{"side", "default:furnace_active", "fuel"},

	{"bottom", "default:chest_locked", "main"},
	{"side", "default:chest_locked", "main"},

	{"top", "default:chest", "default:chest"}, --  new animated chests
	{"bottom", "default:chest", "default:chest"},
	{"side", "default:chest", "default:chest"},

	{"bottom", "default:chest_locked", "default:chest"},
	{"side", "default:chest_locked", "default:chest"},
}

-- global function to add new containers
function hopper:add_container(list)

	for n = 1, #list do
		table.insert(containers, list[n])
	end
end


-- protector redo mod support
if minetest.get_modpath("protector") then

	hopper:add_container({
		{"top", "protector:chest", "main"},
		{"bottom", "protector:chest", "main"},
		{"side", "protector:chest", "main"},
	})
end


-- wine mod support
if minetest.get_modpath("wine") then

	hopper:add_container({
		{"top", "wine:wine_barrel", "dst"},
		{"bottom", "wine:wine_barrel", "src"},
		{"side", "wine:wine_barrel", "src"},
	})
end


-- formspec
local function get_hopper_formspec(pos)

	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"size[8,9]"
		.. default.gui_bg
		.. default.gui_bg_img
		.. default.gui_slots
		.. "list[nodemeta:" .. spos .. ";main;0,0.3;8,4;]"
		.. "list[current_player;main;0,4.85;8,1;]"
		.. "list[current_player;main;0,6.08;8,3;8]"
		.. "listring[nodemeta:" .. spos .. ";main]"
		.. "listring[current_player;main]"

	return formspec
end


-- check where pointing and set normal or side-hopper
local hopper_place = function(itemstack, placer, pointed_thing)

	local pos = pointed_thing.above
	local x = pointed_thing.under.x - pos.x
	local z = pointed_thing.under.z - pos.z
	local name = placer:get_player_name() or ""

	if minetest.is_protected(pos, name) then
		minetest.record_protection_violation(pos, name)
		return itemstack
	end

	if x == -1 then
		minetest.set_node(pos, {name = "hopper:hopper_side", param2 = 0})

	elseif x == 1 then
		minetest.set_node(pos, {name = "hopper:hopper_side", param2 = 2})

	elseif z == -1 then
		minetest.set_node(pos, {name = "hopper:hopper_side", param2 = 3})

	elseif z == 1 then
		minetest.set_node(pos, {name = "hopper:hopper_side", param2 = 1})

	else
		minetest.set_node(pos, {name = "hopper:hopper"})
	end

	if not check_creative(placer:get_player_name()) then
		itemstack:take_item()
	end

	-- set metadata
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	inv:set_size("main", 4*4)

	meta:set_string("owner", name)

	return itemstack
end


-- hopper
minetest.register_node("hopper:hopper", {
	description = S("Hopper (Place onto sides for side-hopper)"),
	groups = {cracky = 3},
	drawtype = "nodebox",
	paramtype = "light",
	tiles = {"hopper_top.png", "hopper_top.png", "hopper_front.png"},
	inventory_image = "hopper_inv.png",
	node_box = {
		type = "fixed",
		fixed = {
			--funnel walls
			{-0.5, 0.0, 0.4, 0.5, 0.5, 0.5},
			{0.4, 0.0, -0.5, 0.5, 0.5, 0.5},
			{-0.5, 0.0, -0.5, -0.4, 0.5, 0.5},
			{-0.5, 0.0, -0.5, 0.5, 0.5, -0.4},
			--funnel base
			{-0.5, 0.0, -0.5, 0.5, 0.1, 0.5},
			--spout
			{-0.3, -0.3, -0.3, 0.3, 0.0, 0.3},
			{-0.15, -0.3, -0.15, 0.15, -0.5, 0.15},
		},
	},

	on_place = hopper_place,

	can_dig = function(pos, player)

		local inv = minetest.get_meta(pos):get_inventory()

		return inv:is_empty("main")
	end,

	on_rightclick = function(pos, node, clicker, itemstack)

		if not minetest.get_meta(pos)
		or minetest.is_protected(pos, clicker:get_player_name()) then
			return itemstack
		end

		minetest.show_formspec(clicker:get_player_name(),
			"hopper:hopper", get_hopper_formspec(pos))
	end,

	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)

		minetest.log("action", S("@1 moves stuff in hopper at @2",
			player:get_player_name(), minetest.pos_to_string(pos)))
	end,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)

		minetest.log("action", S("@1 moves stuff to hopper at @2",
			player:get_player_name(), minetest.pos_to_string(pos)))
	end,

	on_metadata_inventory_take = function(pos, listname, index, stack, player)

		minetest.log("action", S("@1 moves stuff from hopper at @2",
			player:get_player_name(), minetest.pos_to_string(pos)))
	end,

	on_rotate = screwdriver.disallow,
	on_blast = function() end,
})


-- side hopper
minetest.register_node("hopper:hopper_side", {
	description = S("Side Hopper (Place into crafting to return normal Hopper)"),
	groups = {cracky = 3, not_in_creative_inventory = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {
		"hopper_top.png", "hopper_top.png", "hopper_back.png",
		"hopper_side.png", "hopper_back.png", "hopper_back.png"
	},
	inventory_image = "hopper_side_inv.png",
	drop = "hopper:hopper",
	node_box = {
		type = "fixed",
		fixed = {
			--funnel walls
			{-0.5, 0.0, 0.4, 0.5, 0.5, 0.5},
			{0.4, 0.0, -0.5, 0.5, 0.5, 0.5},
			{-0.5, 0.0, -0.5, -0.4, 0.5, 0.5},
			{-0.5, 0.0, -0.5, 0.5, 0.5, -0.4},
			--funnel base
			{-0.5, 0.0, -0.5, 0.5, 0.1, 0.5},
			--spout
			{-0.3, -0.3, -0.3, 0.3, 0.0, 0.3},
			{-0.7, -0.3, -0.15, 0.15, 0.0, 0.15},
		},
	},

	on_place = hopper_place,

	can_dig = function(pos, player)

		local inv = minetest.get_meta(pos):get_inventory()

		return inv:is_empty("main")
	end,

	on_rightclick = function(pos, node, clicker, itemstack)

		if not minetest.get_meta(pos)
		or minetest.is_protected(pos, clicker:get_player_name()) then
			return itemstack
		end

		minetest.show_formspec(clicker:get_player_name(),
			"hopper:hopper_side", get_hopper_formspec(pos))
	end,

	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)

		minetest.log("action", S("@1 moves stuff in hopper at @2",
			player:get_player_name(), minetest.pos_to_string(pos)))
	end,

	on_metadata_inventory_put = function(pos, listname, index, stack, player)

		minetest.log("action", S("@1 moves stuff to hopper at @2",
			player:get_player_name(), minetest.pos_to_string(pos)))
	end,

	on_metadata_inventory_take = function(pos, listname, index, stack, player)

		minetest.log("action", S("@1 moves stuff from hopper at @2",
			player:get_player_name(), minetest.pos_to_string(pos)))
	end,

	on_rotate = screwdriver.rotate_simple,
	on_blast = function() end,
})


-- transfer function
local transfer = function(src, srcpos, dst, dstpos)

	-- source inventory
	local inv = minetest.get_meta(srcpos):get_inventory()

	-- destination inventory
	local inv2 = minetest.get_meta(dstpos):get_inventory()

	-- check for empty source or no inventory
	if not inv or not inv2 or inv:is_empty(src) == true then
		return
	end

	local stack, item

	-- transfer item
	for i = 1, inv:get_size(src) do

		stack = inv:get_stack(src, i)
		item = stack:get_name()

		-- if slot not empty and room for item in destination
		if item ~= ""
		and inv2:room_for_item(dst, item) then

			-- is item a tool
			if stack:get_wear() > 0 then
				inv2:add_item(dst, stack:take_item(stack:get_count()))
				inv:set_stack(src, i, nil)
			else -- not a tool
				stack:take_item(1)
				inv2:add_item(dst, item)
				inv:set_stack(src, i, stack)
			end

			return
		end
	end
end


-- hopper workings
minetest.register_abm({

	label = "Hopper suction and transfer",
	nodenames = {"hopper:hopper", "hopper:hopper_side"},
	interval = 1.0,
	chance = 1,
	catch_up = false,

	action = function(pos, node, active_object_count, active_object_count_wider)

		local inv = minetest.get_meta(pos):get_inventory()

		for _,object in pairs(minetest.get_objects_inside_radius(pos, 1)) do

			if not object:is_player()
			and object:get_luaentity()
			and object:get_luaentity().name == "__builtin:item"
			and inv
			and inv:room_for_item("main",
				ItemStack(object:get_luaentity().itemstring)) then

				if object:get_pos().y - pos.y >= 0.3 then

					inv:add_item("main",
						ItemStack(object:get_luaentity().itemstring))

					object:get_luaentity().itemstring = ""
					object:remove()
				end
			end
		end


		local front

		-- if side hopper check which way spout is facing
		if node.name == "hopper:hopper_side" then

			local face = minetest.get_node(pos).param2

			if face == 0 then
				front = {x = pos.x - 1, y = pos.y, z = pos.z}

			elseif face == 1 then
				front = {x = pos.x, y = pos.y, z = pos.z + 1}

			elseif face == 2 then
				front = {x = pos.x + 1, y = pos.y, z = pos.z}

			elseif face == 3 then
				front = {x = pos.x, y = pos.y, z = pos.z - 1}
			else
				return
			end
		else
			-- otherwise normal hopper, output downwards
			front = {x = pos.x, y = pos.y - 1, z = pos.z}
		end

		-- get node above hopper
		local top = minetest.get_node({x = pos.x, y = pos.y + 1, z = pos.z}).name

		-- get node at other end of spout
		local out = minetest.get_node(front).name

		local where, nod, inv, def

		-- do for loop here for api check
		for n = 1, #containers do

			where = containers[n][1]
			nod = containers[n][2]
			inv = containers[n][3]

			-- from top node into hopper below
			if where == "top" and top == nod
			and (node.name == "hopper:hopper" or node.name == "hopper:hopper_side") then

				transfer(inv, {x = pos.x, y = pos.y + 1, z = pos.z}, "main", pos)
				minetest.get_node_timer(
					{x = pos.x, y = pos.y + 1, z = pos.z}):start(0.5)

			-- from top hopper into node below
			elseif where == "bottom" and out == nod
			and node.name == "hopper:hopper" then

				transfer("main", pos, inv, front)
				minetest.get_node_timer(front):start(0.5)

			-- side hopper into container beside
			elseif where == "side" and out == nod
			and node.name == "hopper:hopper_side" then

				transfer("main", pos, inv, front)
				minetest.get_node_timer(front):start(0.5)

			end
		end
	end,
})


-- hopper recipe
minetest.register_craft({
	output = "hopper:hopper",
	recipe = {
		{"default:steel_ingot", "default:chest", "default:steel_ingot"},
		{"", "default:steel_ingot", ""},
	},
})

-- side hopper to hopper recipe
minetest.register_craft({
	type = "shapeless",
	output = "hopper:hopper",
	recipe = {"hopper:hopper_side"},
})

-- add lucky blocks
if minetest.get_modpath("lucky_block") then

	lucky_block:add_blocks({
		{"dro", {"hopper:hopper"}, 3},
		{"nod", "default:lava_source", 1},
	})
end


print (S("[MOD] Hopper loaded"))

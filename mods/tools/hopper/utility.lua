local FS = hopper.translator_escaped
-- Target inventory retrieval

-- looks first for a registration matching the specific node name, then for a registration
-- matching group and value, then for a registration matching a group and *any* value
hopper.get_registered = function(target_node_name)
	local output = hopper.containers[target_node_name]
	if output ~= nil then return output end

	local target_def = minetest.registered_nodes[target_node_name]
	if target_def == nil or target_def.groups == nil then return nil end

	for group, value in pairs(target_def.groups) do
		local registered_group = hopper.groups[group]
		if registered_group ~= nil then
			output = registered_group[value]
			if output ~= nil then return output end
			output = registered_group["all"]
			if output ~= nil then return output end
		end
	end

	return nil
end

hopper.get_eject_button_texts = function(pos, loc_X, loc_Y)
	if not hopper.config.eject_button_enabled then return "" end

	local texture, eject_button_tooltip
	if minetest.get_meta(pos):get_string("eject") == "true" then
		texture = "hopper_mode_eject.png"
		eject_button_tooltip = FS("This hopper is currently set to eject items from its output\neven if there isn't a compatible block positioned to receive it.\nClick this button to disable this feature.")
	else
		texture = "hopper_mode_hold.png"
		eject_button_tooltip = FS("This hopper is currently set to hold on to item if there\nisn't a compatible block positioned to receive it.\nClick this button to have it eject items instead.")
	end
	return ("image_button_exit[%g,%g;1,1;%s;eject;]"):format(loc_X, loc_Y, texture) ..
		"tooltip[eject;"..eject_button_tooltip.."]"
end

hopper.get_string_pos = function(pos)
	return pos.x .. "," .. pos.y .. "," ..pos.z
end

-- Apparently node_sound_metal_defaults is a newer thing, I ran into games using an older version of the default mod without it.
if default.node_sound_metal_defaults ~= nil then
	hopper.metal_sounds = default.node_sound_metal_defaults()
else
	hopper.metal_sounds = default.node_sound_stone_defaults()
end

-------------------------------------------------------------------------------------------
-- Inventory transfer functions

local delay = function(x)
	return (function() return x end)
end

local get_placer = function(player_name)
	if player_name ~= "" then
		return minetest.get_player_by_name(player_name) or {
			is_player = delay(true),
			get_player_name = delay(player_name),
			is_fake_player = ":hopper",
			get_wielded_item = delay(ItemStack(nil))
		}
	end
	return nil
end

local function get_container_inventory(node_pos, inv_info)
	local get_inventory_fn = inv_info.get_inventory

	local inventory
	if get_inventory_fn then
		inventory = get_inventory_fn(node_pos)
		if not inventory then
			local target_node = minetest.get_node(node_pos)
			minetest.log("error","No inventory from api get_inventory function: " ..
				target_node.name .. " on " .. vector.to_string(node_pos))
		end
	else
		inventory = minetest.get_meta(node_pos):get_inventory()
	end
	return inventory
end

--- @param Removes items from the target node and puts them into the hopper's inventory
--- @param target_inv_info : Inventory information where to take the ItemStacks
hopper.take_item_from = function(hopper_pos, target_pos, target_node, target_inv_info)
	if not target_inv_info then
		return false -- Cannot move take from this direction
	end

	local target_def = minetest.registered_nodes[target_node.name]
	if not target_def then
		return
	end

	--hopper inventory
	local hopper_meta = minetest.get_meta(hopper_pos)
	local hopper_inv = hopper_meta:get_inventory()
	local placer = get_placer(hopper_meta:get_string("placer"))

	--source inventory
	local target_inv_name = target_inv_info.inventory_name
	local target_inv = get_container_inventory(target_pos, target_inv_info)
	if not target_inv then
		return false
	end

	local target_inv_size = target_inv:get_size(target_inv_name)
	if target_inv:is_empty(target_inv_name) == false then
		for i = 1,target_inv_size do
			local stack = target_inv:get_stack(target_inv_name, i)

			if not stack:is_empty() and hopper_inv:room_for_item("main", stack:get_name()) then
				local stack_to_take = stack:take_item(1)

				if target_def.allow_metadata_inventory_take == nil
					or placer == nil -- backwards compatibility, older versions of this mod didn't record who placed the hopper
					or target_def.allow_metadata_inventory_take(target_pos, target_inv_name, i, stack_to_take, placer) > 0 then

					target_inv:set_stack(target_inv_name, i, stack)
					--add to hopper
					hopper_inv:add_item("main", stack_to_take)
					if target_def.on_metadata_inventory_take ~= nil and placer ~= nil then
						target_def.on_metadata_inventory_take(target_pos, target_inv_name, i, stack_to_take, placer)
					end
					break
				end
			end

		end -- for
	end
end

local function try_send_item_to_air(hopper_inv, target_pos)
	local stack
	local stack_num
	for i = 1, hopper_inv:get_size("main") do
		stack = hopper_inv:get_stack("main", i)
		if not stack:is_empty() then
			stack_num = i
			break
		end
	end

	local eject_node = minetest.get_node(target_pos)
	local ndef = minetest.registered_nodes[eject_node.name]
	if not ndef or not ndef.buildable_to then
		minetest.log("verbose", "hopper.try_send_item_to_air: eject direction not buildable ("
			..eject_node.name.." at "..target_pos:to_string().."). Looking for alternate.")
		local air_pos = minetest.find_node_near(target_pos, 2, {"air"})
		if not air_pos then
			minetest.log("warning", "hopper.try_send_item_to_air: could not find an air node nearby")
			return false
		end
		target_pos = air_pos
	end

	local stack_to_put = stack:take_item(1)
	minetest.add_item(target_pos, stack_to_put)
	hopper_inv:set_stack("main", stack_num, stack)
	hopper.log_inventory("hopper ejecting "..stack:get_name().." as object to "..target_pos:to_string())
	return true
end

--- @brief Moves items from the hopper's inventory to the destination and triggers inventory actions
--- @param placer          : (optional) PlayerRef
--- @param target_def      : Target nodedef
local function send_item_to_inv(hopper_inv, target_pos, filtered_items, placer, target_inv_info, target_def)
	local target_inv_name = target_inv_info.inventory_name
	local target_inv = get_container_inventory(target_pos, target_inv_info)
	if not target_inv then
		return false
	end

	local stack
	local stack_num
	for i = 1, hopper_inv:get_size("main") do
		stack = hopper_inv:get_stack("main", i)
		local item = stack:get_name()
		if item ~= "" and (filtered_items == nil or filtered_items[item])
				and target_inv:room_for_item(target_inv_name, item) then
			stack_num = i
			break
		end
	end
	if not stack_num then
		return false
	end

	local stack_to_put = stack:take_item(1)
	if target_def.allow_metadata_inventory_put and placer -- backwards compatibility, older versions of this mod didn't record who placed the hopper
			and target_def.allow_metadata_inventory_put(target_pos, target_inv_name, stack_num, stack_to_put, placer) < 0 then
		return false
	end

	hopper_inv:set_stack("main", stack_num, stack)
	target_inv:add_item(target_inv_name, stack_to_put)
	if target_def.on_metadata_inventory_put ~= nil and placer ~= nil then
		target_def.on_metadata_inventory_put(target_pos, target_inv_name, stack_num, stack_to_put, placer)
	end
	return true
end

--- @brief Used to put items from the hopper inventory into the target block
--- @param target_inv_info : Inventory information where to put the ItemStacks
--- @param filtered_items  : (optional) whitelist of item names { ["modname:itemname"] = true, ... }
hopper.send_item_to = function(hopper_pos, target_pos, target_node, target_inv_info, filtered_items)
	if not target_inv_info then
		return false -- Cannot move item into this direction
	end

	local target_def = minetest.registered_nodes[target_node.name]
	if not target_def then
		return false
	end

	local hopper_meta = minetest.get_meta(hopper_pos)
	local hopper_inv = hopper_meta:get_inventory()
	if hopper_inv:is_empty("main") == true then
		return false
	end

	local placer = get_placer(hopper_meta:get_string("placer"))
	return send_item_to_inv(hopper_inv, target_pos, filtered_items, placer, target_inv_info, target_def)
end

hopper.try_eject_item = function(hopper_pos, target_pos)
	if not hopper.config.eject_button_enabled then
		return false
	end

	local hopper_meta = minetest.get_meta(hopper_pos)
	if hopper_meta:get_string("eject") ~= "true" then
		return false
	end

	local hopper_inv = hopper_meta:get_inventory()
	if hopper_inv:is_empty("main") then
		return false
	end

	return try_send_item_to_air(hopper_inv, target_pos)
end


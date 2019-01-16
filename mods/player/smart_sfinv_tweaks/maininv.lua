-- Enhanced main inventory methods
local maininvClass = {}
local maininvClass_mt = {__index = maininvClass}

-- Clear the inventory
function maininvClass:remove_all()
	for idx = 1, self.inventory:get_size("main") do
		self.inventory:set_stack("main", idx, "")
	end
end

-- Save inventory content to a slot (file)
function maininvClass:save_to_slot(slot)
	local savedata = {}
	for idx, stack in ipairs(self.inventory:get_list("main")) do
		if not stack:is_empty() then
			savedata[idx] = stack:to_string()
		end
	end

	local player = minetest.get_player_by_name(self.playername)
	player:set_attribute("inv_save_slot_"..tostring(slot), minetest.serialize(savedata))
end

-- Get restore the inventory content from a slot (file)
function maininvClass:restore_from_slot(slot)
	local player = minetest.get_player_by_name(self.playername)
	local savedata = minetest.deserialize(player:get_attribute("inv_save_slot_"..tostring(slot)))
	if savedata then
		for idx = 1, self.inventory:get_size("main") do
			self.inventory:set_stack("main", idx, savedata[idx])
		end
	end
end

-- Add a item to inventory
function maininvClass:add_item(item)
	return self.inventory:add_item("main", item)
end

function maininvClass:add_sepearate_stack(item)
	for idx, stack in ipairs(self.inventory:get_list("main")) do
		if stack:is_empty() then
			self.inventory:set_stack("main", idx, item)
			item = ""
			break
		end
	end
	return item
end

-- Get inventory content as consolidated table
function maininvClass:get_items()
	local items_in_inventory = {}

	for _, stack in ipairs(self.inventory:get_list("main")) do
		local itemname = stack:get_name()
		if itemname and itemname ~= "" then
			if not items_in_inventory[itemname] then
				items_in_inventory[itemname] = stack:get_count()
			else
				items_in_inventory[itemname] = items_in_inventory[itemname] + stack:get_count()
			end
		end
	end

-- add items in crafting field to the available items in inventory
	for _, stack in ipairs(self.inventory:get_list("craft")) do
		local itemname = stack:get_name()
		if itemname and itemname ~= "" then
			if not items_in_inventory[itemname] then
				items_in_inventory[itemname] = stack:get_count()
			else
				items_in_inventory[itemname] = items_in_inventory[itemname] + stack:get_count()
			end
		end
	end

	return items_in_inventory
end

-- try to get empty stacks by move items to other stacky up to max_size
function maininvClass:compress()
	for idx1 = self.inventory:get_size("main"), 1, -1 do
		local stack1 = self.inventory:get_stack("main", idx1)
		if not stack1:is_empty() then
			for idx2 = 1, idx1 do
				local stack2 = self.inventory:get_stack("main", idx2)
				if idx1 ~= idx2  and stack1:get_name() == stack2:get_name() then
					stack1 = stack2:add_item(stack1)
					self.inventory:set_stack("main", idx1, stack1)
					self.inventory:set_stack("main", idx2, stack2)
					if stack1:is_empty() then
						break
					end
				end
			end
		end
	end
end

-- move items to crafting grid to craft item
function maininvClass:craft_item(grid)
	for idx_main, stack_main in ipairs(self.inventory:get_list("main")) do
		for x, col in pairs(grid) do
			for y, item in pairs(col) do
				local idx_craft = (y-1)*3+x
				local stack_craft = self.inventory:get_stack("craft", idx_craft )
				if not stack_main:is_empty() and stack_main:get_name() == item then --right item
					local left = stack_craft:add_item(stack_main:take_item(1))
					stack_main:add_item(left)
					self.inventory:set_stack("craft", idx_craft, stack_craft)
					self.inventory:set_stack("main", idx_main, stack_main)
				end
			end
		end
	end
end


-- move all items from crafting inventory back to main inventory
function maininvClass:sweep_crafting_inventory()
	for idx = 1, self.inventory:get_size("craft") do
		local stack = self.inventory:get_stack("craft", idx)
		if not stack:is_empty() then
			local left = self.inventory:add_item("main", stack)
			self.inventory:set_stack("craft", idx, left)
		end
	end
end

-- Swap row to the top. Asumption the inventory is 8x4, the row number should be 2, 3 or 4
function maininvClass:swap_row_to_top(row)
	local width = 8
	for idx1 = 1, width do
		local idx2 = (row -1) * width + idx1
		local stack1 = self.inventory:get_stack("main", idx1)
		local stack2 = self.inventory:get_stack("main", idx2)
		self.inventory:set_stack("main", idx2, stack1)
		self.inventory:set_stack("main", idx1, stack2)
	end
end

-- Swap row to the top. Asumption the inventory is 8x4, the row number should be 2, 3 or 4
function maininvClass:rotate_rows()
	local width = 8
	local inv_list = self.inventory:get_list("main")
	local new_list = {}
	for idx1 = 1, width do
		table.insert(inv_list, inv_list[1])
		table.remove(inv_list, 1)
		self.inventory:set_list("main", inv_list)
	end
end


-- player inventory class
local maininv = {}
function maininv.get(player)
	local self = setmetatable({}, maininvClass_mt)
	self.playername = player:get_player_name()
	self.inventory = player:get_inventory()
	return self
end

return maininv

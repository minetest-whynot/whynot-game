woodcutting = {}

local mod_storage = minetest.get_mod_storage()
local disabled_by_player = {}

woodcutting.settings = {
	tree_distance = tonumber(minetest.settings:get("woodcutting_tree_distance")) or 1,
	leaves_distance = tonumber(minetest.settings:get("woodcutting_leaves_distance")) or 2,
	player_distance = tonumber(minetest.settings:get("woodcutting_player_distance")) or 80,
	dig_leaves = minetest.settings:get_bool("woodcutting_dig_leaves", true),
	wear_limit = tonumber(minetest.settings:get("woodcutting_wear_limit")) or 65535,

	on_new_process_hook = function(process) return true end,             -- do not start the process if set to nil or return false
	on_step_hook = function(process) return true end,                    -- if false is returned finish the process
	on_before_dig_hook = function(process, pos) return true end,         -- if false is returned the node is not digged
	on_after_dig_hook = function(process, pos, oldnode) return true end, -- if false is returned do nothing after digging node
}

woodcutting.tree_content_ids = {}
woodcutting.leaves_content_ids = {}
woodcutting.process_runtime = {}

local woodcutting_class = {}
woodcutting_class.__index = woodcutting_class

----------------------------
--- Constructor. Create a new process with template
----------------------------
function woodcutting.new_process(playername, template)
	local process = setmetatable(template, woodcutting_class)
	process.__index = woodcutting_class
	process.treenodes_sorted = {} -- simple sortable list
	process.treenodes_hashed = {} -- With minetest.hash_node_position() as key for deduplication
	process.playername = playername
	process.tree_distance = process.tree_distance or woodcutting.settings.tree_distance
	process.leaves_distance = process.leaves_distance or woodcutting.settings.leaves_distance
	process.player_distance = process.player_distance or woodcutting.settings.player_distance
	process.wear_limit = process.wear_limit or woodcutting.settings.wear_limit

	if process.dig_leaves == nil then --bool value with default value true
		if woodcutting.settings.dig_leaves == nil then
			process.dig_leaves = false
		else
			process.dig_leaves = woodcutting.settings.dig_leaves
		end
	end

	local hook = woodcutting.settings.on_new_process_hook(process)
	if hook == false then
		return
	end

	woodcutting.process_runtime[playername] = process
	process = woodcutting.get_process(playername) -- note: self is stored in inporcess table, but get_process function does additional data enrichments
	process:show_hud()
	process:process_woodcut_step()
	return process
end

----------------------------
-- Getter - get running process for player
----------------------------
function woodcutting.get_process(playername)
	local process = woodcutting.process_runtime[playername]
	if process then
		process._player = minetest.get_player_by_name(playername)
		if not process._player then
			-- stop process if player leaved the game
			process:stop_process()
			return
		end
	end
	return process
end

----------------------------------
--- Stop the woodcutting process
----------------------------------
function woodcutting_class:stop_process()
	if self._hud and self._player then
		self._player:hud_remove(self._hud)
	end
	woodcutting.process_runtime[self.playername] = nil
end

----------------------------------
--- Add neighbors tree nodes to the list for further processing
----------------------------------
function woodcutting_class:add_tree_neighbors(pos)
	-- read map around the node
	local vm = minetest.get_voxel_manip()
	local r_min = vector.subtract(pos, self.tree_distance)
	local r_max = vector.add(pos, self.tree_distance)
	local minp, maxp = vm:read_from_map(r_min, r_max)
	local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	-- collect tree nodes to the lists
	for i in area:iterp(r_min, r_max) do
		local tree_nodename = woodcutting.tree_content_ids[data[i]]
		if tree_nodename then
			local pos = area:position(i)
			local poshash = minetest.hash_node_position(pos)
			if not self.treenodes_hashed[poshash] then
				table.insert(self.treenodes_sorted, pos)
				self.treenodes_hashed[poshash] = tree_nodename
			end
		end
	end
end

----------------------------------
--- Get the delay time before processing the node at pos
----------------------------------
function woodcutting_class:get_delay_time(pos)
	local poshash = minetest.hash_node_position(pos)
	local nodedef = minetest.registered_nodes[self.treenodes_hashed[poshash]]
	local capabilities = self._player:get_wielded_item():get_tool_capabilities()
	local dig_params = minetest.get_dig_params(nodedef.groups, capabilities)
	if dig_params.diggable then
		return dig_params.time
	else
		-- try hand if the tool is not able to dig
		local dig_params = minetest.get_dig_params(nodedef.groups, minetest.registered_items[""].tool_capabilities)
		if dig_params.diggable then
			return dig_params.time
		end
	end
end

----------------------------------
--- Check node removal allowed
----------------------------------
function woodcutting_class:check_processing_allowed(pos)
	return vector.distance(pos, self._player:get_pos()) < self.player_distance
		and self._player:get_wielded_item():get_wear() <= self.wear_limit
end

----------------------------------
--- Select the next tree node for cutting
----------------------------------
function woodcutting_class:select_next_tree_node()
	local playerpos = self._player:get_pos()
	-- sort the table for priorization higher nodes, select the first one and process them
	table.sort(self.treenodes_sorted, function(a,b)
		local aval = math.abs(playerpos.x-a.x) + math.abs(playerpos.z-a.z)
		local bval = math.abs(playerpos.x-b.x) + math.abs(playerpos.z-b.z)
		if aval == bval then -- if same horizontal distance, prever higher node
			aval = -a.z
			bval = -b.z
		end
		return aval < bval
	end)
	return self.treenodes_sorted[1]
end

----------------------------------
--- Process a woodcut step in minetest.after chain. Select a tree node and trigger processing for them
----------------------------------
function woodcutting_class:process_woodcut_step()
	local function run_process_woodcut_step(playername)
		local process = woodcutting.get_process(playername)
		if not process then
			return
		end

		local hook = woodcutting.settings.on_step_hook(process)
		if hook == false then
			process:stop_process()
			return
		end

		local pos = process:select_next_tree_node()
		process:show_hud(pos)
		if pos then
			if process:check_processing_allowed(pos) then
				-- dig the node
				local delaytime = process:get_delay_time(pos)
				if delaytime then
					table.remove(process.treenodes_sorted, 1)
					process:woodcut_node(pos, delaytime)
				else
					-- wait for right tool is used, try again
					process:process_woodcut_step()
				end
			else
				-- just remove from hashed table and trigger the next step
				local poshash = minetest.hash_node_position(pos)
				table.remove(process.treenodes_sorted, 1)
				process.treenodes_hashed[poshash] = nil
				process:process_woodcut_step()
			end
		elseif next(process.treenodes_hashed) then
			-- nothing selected but still running. Trigger next step
			process:process_woodcut_step()
		else
			process:stop_process()
		end
	end
	minetest.after(0.1, run_process_woodcut_step, self.playername)
end

----------------------------
-- Process single node async
----------------------------
function woodcutting_class:woodcut_node(pos, delay)
	local function run_woodcut_node(playername, pos)
		-- get current process object (async start)
		local process = woodcutting.get_process(playername)
		if not process then
			return
		end

		-- Check it is async chain, trigger the next step in this case
		local poshash = minetest.hash_node_position(pos)
		if process.treenodes_hashed[poshash] then
			process:process_woodcut_step()
			process.treenodes_hashed[poshash] = nil
		end

		-- Check right node at the place before removal
		local node = minetest.get_node(pos)
		local id = minetest.get_content_id(node.name)
		if not (woodcutting.tree_content_ids[id] or woodcutting.leaves_content_ids[id]) then
			return
		end

		local hook = woodcutting.settings.on_before_dig_hook(process, pos)
		if hook == false then
			return
		end

		-- dig the node
		minetest.node_dig(pos, node, process._player)
	end
	minetest.after(delay, run_woodcut_node, self.playername, pos)
end

----------------------------
-- Process leaves around the tree node
----------------------------
function woodcutting_class:process_leaves(pos)
	local vm = minetest.get_voxel_manip()
	local r_min = vector.subtract(pos, self.leaves_distance * 2 + 3)
	local r_max = vector.add(pos, self.leaves_distance * 2 + 3)
	local minp, maxp = vm:read_from_map(r_min, r_max)
	local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
	local data = vm:get_data()

	for i in area:iterp(vector.add(r_min, (self.leaves_distance+1)), vector.subtract(r_max, (self.leaves_distance+1))) do
		if woodcutting.leaves_content_ids[data[i]] then
			local leavespos = area:position(i)
			-- search if no other tree node near the leaves
			local tree_found = false
			for i2 in area:iterp(vector.subtract(leavespos,self.leaves_distance), vector.add(leavespos,self.leaves_distance)) do
				if woodcutting.tree_content_ids[data[i2] ] then
					tree_found = true
					break
				end
			end
			if not tree_found then
				self:woodcut_node(leavespos, 0)
			end
		end
	end
end

----------------------------------
--- Create hud message
----------------------------------
function woodcutting_class:get_hud_message(pos)
	local message = "Woodcutting active. Hold sneak key to disable it"
	if pos then
		message = '['..#self.treenodes_sorted..'] '..minetest.pos_to_string(pos).." | "..message
	end
	return message

end

----------------------------------
--- Enable players hud message
----------------------------------
function woodcutting_class:show_hud(pos)
	if not self._player then
		return
	end

	local message = self:get_hud_message(pos)

	if self._hud then
		self._player:hud_change(self._hud, "text", message)
	else
		self._hud = self._player:hud_add({
				hud_elem_type = "text",
				position = {x=0.3,y=0.3},
				alignment = {x=0,y=0},
				size = "",
				text = message,
				number = 0xFFFFFF,
				offset = {x=0, y=0},
			})
	end
end

----------------------------
-- dig node - check if woodcutting and initialize the work
----------------------------
minetest.register_on_dignode(function(pos, oldnode, digger)
	-- check removed node is tree / check the digger is still online
	local id = minetest.get_content_id(oldnode.name)
	if not woodcutting.tree_content_ids[id] or not digger then
		return
	end

	local playername = digger:get_player_name()
	if disabled_by_player[playername] then
		return
	end

	-- Get the process or create new one
	local sneak = digger:get_player_control().sneak
	local process = woodcutting.get_process(playername)
	if not process and sneak then
		process = woodcutting.new_process(playername, {
			sneak_pressed = true, -- to control sneak toggle
		})
	end
	if not process then
		return
	end

	local hook = woodcutting.settings.on_after_dig_hook(process, pos, oldnode)
	if hook == false then
		return
	end


	-- process the sneak toggle
	if sneak then
		if not process.sneak_pressed then
			-- sneak pressed second time - stop the work
			process:stop_process()
			return
		end
	else
		if process.sneak_pressed then
			process.sneak_pressed = false
		end
	end

	-- add the neighbors to the list.
	-- Note: The processing is started in new_process() using minetest.after() functionlity
	process:add_tree_neighbors(pos)

	-- process leaves for cutted node
	if process.dig_leaves then
		process:process_leaves(pos)
	end
end)

----------------------------
-- start collecting infos about trees and leaves after all mods loaded
----------------------------
minetest.after(0, function ()
	for k, v in pairs(minetest.registered_nodes) do
		if v.groups.tree then
			local id = minetest.get_content_id(k)
			woodcutting.tree_content_ids[id] = k
		elseif v.groups.leafdecay then
			local id = minetest.get_content_id(k)
			woodcutting.leaves_content_ids[id] = k
		end
	end
end)

----------------------------
-- Stop work if the player dies
----------------------------
minetest.register_on_dieplayer(function(player)
	local process = woodcutting.get_process(player:get_player_name())
	if process then
		process:stop_process()
	end
end)

----------------------------
-- Command to toggle whether cutting is enabled, per-player
----------------------------
minetest.register_chatcommand("toggle_woodcutting", {
	description = "Toggle whether woodcutting is enabled",
	func = function(player_name)
		local is_currently_disabled = disabled_by_player[player_name]
		if is_currently_disabled then
			disabled_by_player[player_name] = nil
			mod_storage:set_string(player_name .. "_disabled", "")
			return true, "Woodcutting is now enabled."
		else
			disabled_by_player[player_name] = true
			mod_storage:set_string(player_name .. "_disabled", "true")
			local process = woodcutting.get_process(player_name)
			if process then
				process:stop_process()
			end
			return true, "Woodcutting is now disabled."
		end
	end
})

minetest.register_on_joinplayer(function(player)
	-- load player settings
	local player_name = player:get_player_name()
	if mod_storage:get_string(player_name .. "_disabled") == "true" then
		disabled_by_player[player_name] = true
	end
end)

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	disabled_by_player[player_name] = nil
	local process = woodcutting.get_process(player_name)
	if process then
		process:stop_process()
	end
end)

-- constant subspace size
local c_subspacesize = 8

-- chance for node restoral per second (No worries, all nodes will be restored, but not immediately)
local c_randomize_restore = 5

-- transform compatible nodes only
local c_restricted_mode = true

local compatible_nodes = {
	"default:stone",
	"default:dirt"
}

-- Check if the subspace still enabled for user (or can be disabled)
local function ssw_get_wielded(playername)
	local user = minetest.get_player_by_name(playername)
	-- if user leave the game, disable them
	if not user then
		return false
	end
	-- user does not hold the walker in the hand
	local item = user:get_wielded_item()
	if not item or item:get_name() ~= "subspacewalker:walker" then
		return false
	end
	-- all ok, still active
	return item
end

-- subspacewalker runtime data
local subspacewalker = {
	users_in_subspace = {},
}

-- tool definition
minetest.register_tool("subspacewalker:walker", {
	description = "Subspace Walker",
	inventory_image = "subspace_walker.png",
	wield_image = "subspace_walker.png",
	tool_capabilities = {},
	range = 0,
	on_use = function(itemstack, user, pointed_thing)
		subspacewalker.users_in_subspace[user:get_player_name()] = {timer = 1}
	end,
	on_place = function(itemstack, user, pointed_thing)
		subspacewalker.users_in_subspace[user:get_player_name()] = nil
	end,
	on_secondary_use = function(itemstack, user, pointed_thing)
		subspacewalker.users_in_subspace[user:get_player_name()] = nil
	end
})

-- Globalstep check for nodes to hide
minetest.register_globalstep(function(dtime)
	-- check each player with walker active
	for playername, ssw in pairs(subspacewalker.users_in_subspace) do
		ssw.timer = ssw.timer + dtime
		local ssw_stack = ssw_get_wielded(playername)
		if not ssw_stack then
			subspacewalker.users_in_subspace[playername] = nil
		else
			local user = minetest.get_player_by_name(playername)
			local control = user:get_player_control()
			local userpos = user:getpos()

			--regular step, once each second
			if ssw.timer > 0.2 or --0.5
					--sneaking but not in air
					(control.sneak and userpos.y - 0.5 == math.floor(userpos.y)) then
				ssw.timer = 0

				-- set offset for jump or sneak
				userpos.y = math.floor(userpos.y+0.5)
				if control.jump then
					userpos.y = userpos.y + 1
				elseif control.sneak then
					userpos.y = userpos.y -1
				end
				userpos = vector.round(userpos)

				--voxel_manip magic
				local pos1 = {x=userpos.x-c_subspacesize, y=userpos.y, z=userpos.z-c_subspacesize}
				local pos2 = {x=userpos.x+c_subspacesize, y=userpos.y+c_subspacesize, z=userpos.z+c_subspacesize}

				local manip = minetest.get_voxel_manip()
				local min_c, max_c = manip:read_from_map(pos1, pos2)
				local area = VoxelArea:new({MinEdge=min_c, MaxEdge=max_c})

				local data = manip:get_data()
				local changed = false

				local ssw_id = minetest.get_content_id("subspacewalker:subspace")
				local air_id = minetest.get_content_id("air")

				local transform_count = 0

				-- check each node in the area
				for i in area:iterp(pos1, pos2) do
					local nodepos = area:position(i)
--					if math.random(0, vector.distance(userpos, nodepos)) < 2 then
						local cur_id = data[i]
						if cur_id and cur_id ~= ssw_id and cur_id ~= air_id then
							local cur_name = minetest.get_name_from_content_id(cur_id)
							if c_restricted_mode then
								for _, compat in ipairs(compatible_nodes) do
									if compat == cur_name then
										data[i] = ssw_id
										minetest.get_meta(area:position(i)):set_string("subspacewalker", cur_name)
										changed = true
										transform_count = transform_count + 1
									end
								end
							else
								data[i] = ssw_id
								minetest.get_meta(area:position(i)):set_string("subspacewalker", cur_name)
								changed = true
								transform_count = transform_count + 1
							end
						end
--					end
				end
				-- save changes if needed
				if changed then
					manip:set_data(data)
					manip:write_to_map()
					local wear = ssw_stack:get_wear()
					ssw_stack:add_wear(transform_count)
					user:set_wielded_item(ssw_stack)
				end
			end

			-- jump special handling. Restore node under the player
			if control.jump then
				local userpos = user:getpos()
				userpos.y = math.floor(userpos.y-0.5)
				local node = minetest.get_node(userpos)
				local meta = minetest.get_meta(userpos)
				local data = meta:to_table()
				if data.fields.subspacewalker then
					node.name = data.fields.subspacewalker
					data.fields.subspacewalker = nil
					meta:from_table(data)
					minetest.swap_node(userpos, node)
				end
			end
		end
	end
end)

-- node to hide the original one
minetest.register_node("subspacewalker:subspace", {
	drawtype = "airlike",
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 5,
	diggable = false,
	walkable = false,
	groups = {not_in_creative_inventory=1},
	pointable = false,
	drop = ""
})

-- ABM on hidden blocks checks if there can be restored again
minetest.register_abm({
	nodenames = { "subspacewalker:subspace" },
	interval = 0.5,
	chance = c_randomize_restore,
	action = function(pos, node)
		if node.name == 'ignore' then 
			return 
		end

		local can_be_restored = true
		-- check if the node can be restored
		for playername, _ in pairs(subspacewalker.users_in_subspace) do
			local ssw_stack = ssw_get_wielded(playername)
			if not ssw_stack then
				subspacewalker.users_in_subspace[playername] = nil
			else
				local user = minetest.get_player_by_name(playername)
				local userpos = user:getpos()
				userpos.y = math.floor(userpos.y+0.5)
				if ( pos.x >= userpos.x-c_subspacesize-1 and pos.x <= userpos.x+c_subspacesize+1) and  -- "+1" is to avoid flickering of nodes. restoring range is higher then the effect range
						( pos.y >= userpos.y and pos.y <= userpos.y+c_subspacesize+1 ) and
						( pos.z >= userpos.z-c_subspacesize-1 and pos.z <= userpos.z+c_subspacesize+1) then
					can_be_restored = false --active user in range
				end
			end
		end

		--restore them
		if can_be_restored then
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			local data = meta:to_table()
			node.name = data.fields.subspacewalker
			data.fields.subspacewalker = nil
			meta:from_table(data)
			minetest.swap_node(pos, node)
		end
	end
})

minetest.register_craft({
	output = "subspacewalker:walker",
	width = 1,
	recipe = {
			{"default:diamond"},
			{"default:mese_crystal"},
			{"group:stick"}
	}
})

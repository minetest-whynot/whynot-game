
local orig_update_creative_inventory = creative.update_creative_inventory
function creative.update_creative_inventory(player_name, tab_content)
	-- do original stuff
	orig_update_creative_inventory(player_name, tab_content)

	-- Set all stacks to maximum count
	local player_inv = minetest.get_inventory({type = "detached", name = "creative_" .. player_name})
	local list = player_inv:get_list("main")
	for _, stack in ipairs(list) do
		stack:set_count(stack:get_stack_max())
	end

	player_inv:set_list("main", list)
end

local S = waffles.intllib

-- Waffle Batter
local batter = {}

local function remove_empty_can(player)
	local inv = player:get_inventory()
	local ret = inv:remove_item("main", ItemStack("waffles:waffle_batter_3"))
	local itemstack = inv:get_stack("main", player:get_wield_index())
	local was_success = ret:get_count() == 1
	return itemstack, was_success
end


function batter.register(filled, original_def)
	local group
	if filled == 1 then
		group = 0
	else
		group = 1
	end
	minetest.register_tool("waffles:waffle_batter_"..filled, {
		description = S("Waffle Batter"),
		inventory_image = "waffle_batter_"..filled..".png",
		wield_image = "waffle_batter_"..filled..".png",
		stack_max = 1,
		groups = {not_in_creative_inventory = group},
		on_use = function(itemstack, user, pointed_thing)

			if pointed_thing.type ~= "node" then
				return
			end

			local pos = pointed_thing.under
			local pname = user:get_player_name()

			if minetest.is_protected(pos, pname) then
				minetest.record_protection_violation(pos, pname)
				return
			end

			local node = minetest.get_node(pos)

			if node.name == "waffles:wafflemaker_open_empty" then

				minetest.set_node(pos, {name = "waffles:wafflemaker_open_full", param2 = node.param2})
				if filled == 3 then
					itemstack, was_success = remove_empty_can(user)
					return itemstack
				else
					return ItemStack("waffles:waffle_batter_"..filled + 1)
				end
			end

		end,
	})
end

batter.register(1)
batter.register(2)
batter.register(3)

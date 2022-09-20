--[[
This file is only loaded if the `3d_armor` mod is present
]]

local S = minetest.get_translator(minetest.get_current_modname())

-- check if they have the armor equipped.
local function armor_search(elms)
	local eww = ediblestuff.edible_while_wearing
	for _,elm in pairs(elms) do
		if eww[elm] then
			return true
		end
	end
	return false
end
local function delayed_armor_check(pname)
	return function ()
		local player=minetest.get_player_by_name(pname)
		-- this can fail inside register_on_joinplayer.
		local elms=armor:get_weared_armor_elements(player)
		if elms == nil then
			-- Prevent log flooding
			if ediblestuff.logcount > ediblestuff.logdelay then
				-- If it does fail, wait another second (it's possible to get into an infinite loop here...)
				minetest.log("info", "ediblestuff: armor check was delayed...")
				ediblestuff.logcount = 0
			end
			ediblestuff.logcount = ediblestuff.logcount + 1
			minetest.after(1, delayed_armor_check(pname))
			return
		end
		if armor_search(elms) then
			ediblestuff.equipped[pname] = true
		else
			ediblestuff.equipped[pname] = nil
		end
	end
end
local function armor_check_event(player)
	-- We don't know if the reference to player is still valid after the delay(s). Just pass the name.
	minetest.after(0, delayed_armor_check(player:get_player_name()))
end
minetest.register_on_joinplayer(armor_check_event)
armor:register_on_equip(armor_check_event)
armor:register_on_unequip(armor_check_event)
armor:register_on_destroy(armor_check_event)
minetest.register_on_leaveplayer(function(player)
	ediblestuff.equipped[player:get_player_name()] = nil
end)
minetest.register_globalstep(function()
	-- Instead of iterating over every player, only iterate over players we know have ediblestuff equipped
	local satiates = ediblestuff.satiates
	for pname,_ in pairs(ediblestuff.equipped) do
		local player=minetest.get_player_by_name(pname)
		local n, armor_inv = armor:get_valid_player(player,"[ediblestuff register_globalstep]")
		if not n then
			ediblestuff.equipped[pname]=nil
		else
			local hunger_max = ediblestuff.get_max_hunger(player)
			local hunger_availabile = hunger_max - ediblestuff.get_hunger(player)
			local hunger_ratio = hunger_availabile/hunger_max
			if hunger_ratio >= ediblestuff.hunger_threshold then
				local inv_list = armor_inv:get_list("armor")
				local list = {}
				for i,slot in ipairs(inv_list) do
					-- Ensure that the armor can actually be eaten before we try to eat it.
					if slot:get_count() > 0 and satiates[slot:get_name()] then
						list[#list+1] = {slot, i}
					end
				end
				local victim_armor_tuple = list[math.random(#list)]
				local victim_armor, index = victim_armor_tuple[1], victim_armor_tuple[2]
				local armor_max = 65535 -- largest possible tool durability
				local durability_ratio = (armor_max - victim_armor:get_wear())/armor_max
				local item_satiates = ediblestuff.satiates[victim_armor:get_name()]
				local item_ratio = 1
				if item_satiates > hunger_availabile then
					-- They can't eat it all even if they wanted to. Scale it so they can eat just a part of it.
					item_ratio = hunger_availabile/item_satiates
				end
				local possible_satiation = math.min(hunger_ratio,durability_ratio*item_ratio)
				ediblestuff.alter_hunger(player,possible_satiation*item_satiates)
				armor:damage(player,index,victim_armor,possible_satiation*armor_max)
				minetest.chat_send_player(pname,S("You ate @1% of your equipped @2", math.ceil(possible_satiation*100), victim_armor:get_short_description()))
				if hunger_ratio >= durability_ratio then
					local old_armor=ItemStack(victim_armor)
					victim_armor:take_item()
					armor:set_inventory_stack(player,index,victim_armor)
					armor:run_callbacks("on_unequip",player,index,old_armor)
					armor:run_callbacks("on_destroy",player,index,old_armor)
					armor:set_player_armor(player)
				end
			end
		end
	end
end)

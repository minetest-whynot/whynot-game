local S = minetest.get_translator(minetest.get_current_modname())

ediblestuff = {}
ediblestuff.logcount = 0
ediblestuff.logdelay = 5
ediblestuff.hunger_threshold = minetest.settings:get("ediblestuff_api.hunger_threshold") or 0.5

-- How much does an arbirary item satiate when equipped?
-- This is only needed because calling on_use is much more expensive and might have side effects
ediblestuff.satiates = {}

ediblestuff.make_thing_edible = function(item,amount)
	minetest.override_item(item, {
		on_use=minetest.item_eat(amount)
	})
	ediblestuff.satiates[item] = amount
	if minetest.get_modpath("hunger_ng") ~= nil then
		hunger_ng.add_hunger_data(item, {
			satiates = amount,
		})
	elseif minetest.get_modpath("hunger") and hunger.register_food then
		hunger.register_food(item,amount)
	end
end
ediblestuff.make_things_edible = function(mod,name,scale,items)
	local result = {}
	for typ,amount in pairs(items) do
		local scaled = scale*amount
		result[typ]=scaled
		ediblestuff.make_thing_edible(mod..":"..typ.."_"..name,scaled)
	end
	return result
end
ediblestuff.make_tools_edible = function (mod,name,scale,is_flat_rate)
	local numbers={
		pick=3,
		shovel=1,
		axe=3,
		sword=2,
	}
	if minetest.get_modpath("farming") ~= nil then numbers.hoe=2 end
	if is_flat_rate == true then
		for typ,_ in pairs(numbers) do
			numbers[typ] = 1
		end
	end
	return ediblestuff.make_things_edible(mod,name,scale,numbers)
end
ediblestuff.make_armor_edible = function(mod,name,scale,is_flat_rate)
	if minetest.get_modpath("3d_armor") == nil then return {} end
	local numbers = {
		helmet=5,
		chestplate=8,
		leggings=7,
		boots=4,
	}
	if minetest.get_modpath("shields") ~= nil then
		numbers.shield=7
	end
	if is_flat_rate == true then
		for typ,_ in pairs(numbers) do
			numbers[typ] = 1
		end
	end
	return ediblestuff.make_things_edible(mod,name,scale,numbers)
end
ediblestuff.make_armor_edible_while_wearing = function (mod,name,scale,is_flat_rate)
	local result = ediblestuff.make_armor_edible(mod,name,scale,is_flat_rate)
	for typ,_ in pairs(result) do
		ediblestuff.edible_while_wearing[mod..":"..typ.."_"..name] = true
	end
	return result
end
-- These functions all make calls to `minetest.override_item`, which should only
-- be used at load-time, according to the MT API doc
minetest.register_on_mods_loaded(function()
	ediblestuff.make_thing_edible = nil
	ediblestuff.make_things_edible = nil
	ediblestuff.make_tools_edible = nil
	ediblestuff.make_armor_edible = nil
	ediblestuff.make_armor_edible_while_wearing = nil
end)
if minetest.get_modpath("stamina") then
	if stamina.settings ~= nil then
		-- For minetest-mods/stamina
		ediblestuff.get_max_hunger = function ()
			return stamina.settings.visual_max
		end
	else
	    -- works for TenPlus1 and sofar
		ediblestuff.get_max_hunger = function ()
			return STAMINA_VISUAL_MAX
		end
	end
	ediblestuff.get_hunger = function (player)
		local meta = player:get_meta()
		local amount = meta:get_string("stamina:level")
		if not amount then return end
		return tonumber(amount)
	end
	ediblestuff.alter_hunger = stamina.change
elseif minetest.get_modpath("hunger") then
	ediblestuff.get_max_hunger = function ()
		return HUNGER_MAX
	end
	ediblestuff.get_hunger = hunger.read
	ediblestuff.alter_hunger = function (player,amount)
		hunger.update_hunger(player,ediblestuff.get_hunger(player)+amount)
	end
elseif minetest.get_modpath("hbhunger") then
	ediblestuff.get_max_hunger = function ()
		return hbhunger.SAT_MAX
	end
	ediblestuff.get_hunger = hbhunger.get_hunger_raw
	--[[or function (player)
		local name = player:get_player_name()
		return hbhunger.hunger[name]
	end]]
	ediblestuff.alter_hunger = function (player, amount)
		local name = player:get_player_name()
		hbhunger.hunger[name] = math.min(ediblestuff.get_hunger(player)+amount,hbhunger.SAT_MAX)
		hbhunger.set_hunger_raw(player)
	end
elseif minetest.get_modpath("mcl_hunger") then
	ediblestuff.get_max_hunger = function ()
		return 20
	end
	ediblestuff.get_hunger = mcl_hunger.get_hunger
	ediblestuff.alter_hunger = function (player, amount)
		mcl_hunger.set_hunger(player,ediblestuff.get_hunger(player)+amount)
	end
elseif minetest.get_modpath("hunger_ng") then
	ediblestuff.get_max_hunger = function (player)
		local info = hunger_ng.get_hunger_information(player:get_player_name())
		if info.invalid then return end
		return info.maximum.hunger
	end
	ediblestuff.get_hunger = function (player)
		local info = hunger_ng.get_hunger_information(player:get_player_name())
		if info.invalid then return end
		return info.hunger.exact
	end
	ediblestuff.alter_hunger = function (player, amount)
		hunger_ng.alter_hunger(player:get_player_name(),amount)
	end
elseif minetest.get_modpath("hud") then -- Must come after `hunger`
	ediblestuff.get_max_hunger = function ()
		return 30  -- Before `hunger` was a thing this was hardcoded
	end
	ediblestuff.get_hunger = hud.get_hunger
	--[[or function (player)
		return tonumber(hud.hunger[player:get_player_name()])
	end]]
	if hud.change_item then
		ediblestuff.alter_hunger = function (player,amount)
			hud.change_item(player,"hunger",{
				number=math.min(ediblestuff.get_hunger(player)+amount,30)
			})
			hud.set_hunger(user)
		end
	else
		ediblestuff.alter_hunger = function (player,amount)
			hud.hunger[name] = math.min(ediblestuff.get_hunger(player)+amount,30)
			hud.set_hunger(user)
		end
	end
else
	-- No known hunger mod. Use hp instead.
	minetest.log("info","ediblestuff: no known hunger mod. using hp as hunger instead")
	ediblestuff.get_max_hunger = function (player)
		return player:get_properties().hp_max
	end
	ediblestuff.get_hunger = function (player)
		return player:get_hp()
	end
	ediblestuff.alter_hunger = function (player, amount)
		player:set_hp(player:get_hp()+amount)
	end
end
ediblestuff.equipped = {}
ediblestuff.edible_while_wearing = {}
if minetest.get_modpath("3d_armor") == nil then return end
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

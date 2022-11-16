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
elseif minetest.get_modpath("hbhunger") and minetest.settings:get_bool("enable_damage") then
	-- The `hbhunger` mod doesn't define these globals if `enable_damage` is falsy
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

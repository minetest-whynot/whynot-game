-- Keep these for backwards compatibility
function hbhunger.save_hunger(player)
	hbhunger.set_hunger_raw(player)
end
function hbhunger.load_hunger(player)
	hbhunger.get_hunger_raw(player)
end

-- wrapper for minetest.item_eat (this way we make sure other mods can't break this one)
local org_eat = minetest.do_item_eat
minetest.do_item_eat = function(hp_change, replace_with_item, itemstack, user, pointed_thing)
	local old_itemstack = itemstack
	itemstack = hbhunger.eat(hp_change, replace_with_item, itemstack, user, pointed_thing)
	for _, callback in pairs(minetest.registered_on_item_eats) do
		local result = callback(hp_change, replace_with_item, itemstack, user, pointed_thing, old_itemstack)
		if result then
			return result
		end
	end
	return itemstack
end

-- food functions
local food = hbhunger.food

function hbhunger.register_food(name, hunger_change, replace_with_item, poisen, heal, sound)
	food[name] = {}
	food[name].saturation = hunger_change	-- hunger points added
	food[name].replace = replace_with_item	-- what item is given back after eating
	food[name].poisen = poisen				-- time its poisening
	food[name].healing = heal				-- amount of HP
	food[name].sound = sound				-- special sound that is played when eating
end

function hbhunger.eat(hp_change, replace_with_item, itemstack, user, pointed_thing)
	local item = itemstack:get_name()
	local def = food[item]
	if not def then
		def = {}
		if type(hp_change) ~= "number" then
			hp_change = 1
			minetest.log("error", "Wrong on_use() definition for item '" .. item .. "'")
		end
		def.saturation = hp_change * 1.3
		def.replace = replace_with_item
	end
	local func = hbhunger.item_eat(def.saturation, def.replace, def.poisen, def.healing, def.sound)
	return func(itemstack, user, pointed_thing)
end

-- Poison player
local function poisenp(tick, time, time_left, player)
	-- First check if player is still there
	if not player:is_player() then
		return
	end
	time_left = time_left + tick
	if time_left < time then
		minetest.after(tick, poisenp, tick, time, time_left, player)
	else
		hbhunger.poisonings[player:get_player_name()] = hbhunger.poisonings[player:get_player_name()] - 1
		if hbhunger.poisonings[player:get_player_name()] <= 0 then
			-- Reset HUD bar color
			hb.change_hudbar(player, "health", nil, nil, "hudbars_icon_health.png", nil, "hudbars_bar_health.png")
		end
	end
	if player:get_hp()-1 > 0 then
		player:set_hp(player:get_hp()-1)
	end
	
end

function hbhunger.item_eat(hunger_change, replace_with_item, poisen, heal, sound)
	return function(itemstack, user, pointed_thing)
		if itemstack:take_item() ~= nil and user ~= nil then
			local name = user:get_player_name()
			local h = tonumber(hbhunger.hunger[name])
			local hp = user:get_hp()
			if h == nil or hp == nil then
				return
			end
			if user:is_player() then
				local object, object_pos
				-- Check if user is a "fake player" (unofficial imitation of a the player data structure)
				if type(user) == "userdata" then
					object = user
				else
					object_pos = user:get_pos()
				end
				minetest.sound_play(
					{name = sound or "hbhunger_eat_generic",
					gain = 1},
					{object=object,
					pos=object_pos,
					max_hear_distance = 16,
					pitch = 1 + math.random(-10, 10)*0.005,},
					true
				)
			end

			-- Saturation
			if h < hbhunger.SAT_MAX and hunger_change then
				h = h + hunger_change
				if h > hbhunger.SAT_MAX then h = hbhunger.SAT_MAX end
				hbhunger.hunger[name] = h
				hbhunger.set_hunger_raw(user)
			end
			-- Healing
			if hp < 20 and heal then
				hp = hp + heal
				if hp > 20 then hp = 20 end
				user:set_hp(hp)
			end
			-- Poison
			if poisen then
				-- Set poison bar
				hb.change_hudbar(user, "health", nil, nil, "hbhunger_icon_health_poison.png", nil, "hbhunger_bar_health_poison.png")
				hbhunger.poisonings[name] = hbhunger.poisonings[name] + 1
				poisenp(1, poisen, 0, user)
			end

			if itemstack:get_count() == 0 then
				itemstack:add_item(replace_with_item)
			else
				local inv = user:get_inventory()
				if inv:room_for_item("main", replace_with_item) then
					inv:add_item("main", replace_with_item)
				else
					minetest.add_item(user:get_pos(), replace_with_item)
				end
			end
		end
		return itemstack
	end
end

-- player-action based hunger changes
function hbhunger.handle_node_actions(pos, oldnode, player, ext)
	-- is_fake_player comes from the pipeworks, we are not interested in those
	if not player or not player:is_player() or player.is_fake_player == true then
		return
	end
	local name = player:get_player_name()
	local exhaus = hbhunger.exhaustion[name]
	if exhaus == nil then return end
	local new = hbhunger.EXHAUST_PLACE
	-- placenode event
	if not ext then
		new = hbhunger.EXHAUST_DIG
	end
	-- assume its send by main timer when movement detected
	if not pos and not oldnode then
		new = hbhunger.EXHAUST_MOVE
	end
	exhaus = exhaus + new
	if exhaus > hbhunger.EXHAUST_LVL then
		exhaus = 0
		local h = tonumber(hbhunger.hunger[name])
		h = h - 1
		if h < 0 then h = 0 end
		hbhunger.hunger[name] = h
		hbhunger.set_hunger_raw(player)
	end
	hbhunger.exhaustion[name] = exhaus
end

minetest.register_on_placenode(hbhunger.handle_node_actions)
minetest.register_on_dignode(hbhunger.handle_node_actions)

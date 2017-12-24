
local sky_start = tonumber(minetest.setting_get("sky_start") or -100)

local player_list = {} 

local timer = 0

local function node_ok(pos, fallback)
	fallback = fallback or "air"
	local node = minetest.get_node_or_nil(pos)

	if not node then
		return fallback
	end

	if minetest.registered_nodes[node.name] then
		return node.name
	end

	return fallback
end


minetest.register_globalstep(function(dtime)

	timer = timer + dtime

	if timer < 2 then
		return
	end

	timer = 0

	for _, player in pairs(minetest.get_connected_players()) do

		local name = player:get_player_name()
		local pos = player:getpos()

		pos.y = pos.y + 1.5 -- head level
		local head_node = node_ok(pos)

		pos.y = pos.y - 1.5 -- reset pos

		local ndef = minetest.registered_nodes[head_node]

		if (ndef.walkable == nil or ndef.walkable == true)
		and (ndef.drowning == nil or ndef.drowning == 0)
		and (ndef.damage_per_second == nil or ndef.damage_per_second <= 0)
		and (ndef.collision_box == nil or ndef.collision_box.type == "regular")
		and (ndef.node_box == nil or ndef.node_box.type == "regular") then
			player:set_sky({}, "regular", {})
			player_list[name] = "surface" 
			return
		end

		local current = player_list[name] or ""

		-- Surface
		if pos.y > sky_start and current ~= "surface" then
			player:set_sky({}, "regular", {})
			player:set_clouds({density = 0.4})
			player_list[name] = "surface"

		-- Everything else (blackness)
		elseif pos.y < sky_start and current ~= "blackness" then
			player:set_sky(000000, "plain", {})
			player:set_clouds({density = 0})
			player_list[name] = "blackness"
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	player_list[name] = nil
end)

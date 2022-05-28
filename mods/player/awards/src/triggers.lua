-- AWARDS
--
-- Copyright (C) 2013-2015 rubenwardy
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published by
-- the Free Software Foundation; either version 2.1 of the License, or
-- (at your option) any later version.
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Lesser General Public License for more details.
-- You should have received a copy of the GNU Lesser General Public License along
-- with this program; if not, write to the Free Software Foundation, Inc.,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
--

-- Don't actually use translator here. We define empty S() to fool the update_translations script
-- into extracting those strings for the templates. Actual translation is done in api_triggers.lua.
local S = function (str)
	return str
end

-- Check if a player object is valid for awards.
local function player_ok(player)
	return player and player.is_player and player:is_player() and not player.is_fake_player
end

awards.register_trigger("chat", {
	type = "counted",
	progress = S("@1/@2 chat messages"),
	auto_description = { S("Send a chat message"), S("Chat @1 times") },
})
minetest.register_on_chat_message(function(name, message)
	local player = minetest.get_player_by_name(name)
	if not player_ok(player) or string.find(message, "/")  then
		return
	end

	awards.notify_chat(player)
end)


awards.register_trigger("join", {
	type = "counted",
	progress = S("@1/@2 joins"),
	auto_description = { S("Join once"), S("Join @1 times") },
})
minetest.register_on_joinplayer(awards.notify_join)


awards.register_trigger("death", {
	type = "counted_key",
	progress = S("@1/@2 deaths"),
	auto_description = { S("Die once of @2"), S("Die @1 times of @2") },
	auto_description_total = { S("Die @1 times."), S("Mine @1 times") },
	get_key = function(self, def)
		return def.trigger.reason
	end,
})
minetest.register_on_dieplayer(function(player, reason)
	if reason then
		reason = reason.type
	else
		reason = "unknown"
	end
	awards.notify_death(player, reason)
end)


awards.register_trigger("dig", {
	type = "counted_key",
	progress = S("@1/@2 dug"),
	auto_description = { S("Mine: @2"), S("Mine: @1×@2") },
	auto_description_total = { S("Mine @1 block."), S("Mine @1 blocks.") },
	get_key = function(self, def)
		return minetest.registered_aliases[def.trigger.node] or def.trigger.node
	end,
	key_is_item = true,
})
minetest.register_on_dignode(function(pos, node, player)
	if not player_ok(player) or not pos or not node then
		return
	end

	local node_name = node.name
	node_name = minetest.registered_aliases[node_name] or node_name
	awards.notify_dig(player, node_name)
end)


awards.register_trigger("place", {
	type = "counted_key",
	progress = S("@1/@2 placed"),
	auto_description = { S("Place: @2"), S("Place: @1×@2") },
	auto_description_total = { S("Place @1 block."), S("Place @1 blocks.") },
	get_key = function(self, def)
		return minetest.registered_aliases[def.trigger.node] or def.trigger.node
	end,
	key_is_item = true,
})
minetest.register_on_placenode(function(pos, node, player)
	if not player_ok(player) or not pos or not node then
		return
	end

	local node_name = node.name
	node_name = minetest.registered_aliases[node_name] or node_name
	awards.notify_place(player, node_name)
end)


awards.register_trigger("craft", {
	type = "counted_key",
	progress = S("@1/@2 crafted"),
	auto_description = { S("Craft: @2"), S("Craft: @1×@2") },
	auto_description_total = { S("Craft @1 item"), S("Craft @1 items.") },
	get_key = function(self, def)
		return minetest.registered_aliases[def.trigger.item] or def.trigger.item
	end,
	key_is_item = true,
})
minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	if not player_ok(player) or itemstack:is_empty() then
		return
	end

	local itemname = itemstack:get_name()
	itemname = minetest.registered_aliases[itemname] or itemname
	awards.notify_craft(player, itemname, itemstack:get_count())
end)


awards.register_trigger("eat", {
	type = "counted_key",
	progress = S("@1/@2 eaten"),
	auto_description = { S("Eat @2"), S("Eat @1×@2") },
	auto_description_total = { S("Eat @1 item"), S("Eat @1 items.") },
	get_key = function(self, def)
		return minetest.registered_aliases[def.trigger.item] or def.trigger.item
	end,
	key_is_item = true,
})
minetest.register_on_item_eat(function(_, _, itemstack, player, _)
	if not player_ok(player) or itemstack:is_empty() then
		return
	end

	local itemname = itemstack:get_name()
	itemname = minetest.registered_aliases[itemname] or itemname
	awards.notify_eat(player, itemname)
end)

if (minetest.get_modpath("cmi")) then
	-- trigger for killing mobs
	awards.register_trigger("kill_mob", {
		type = "counted_key",
		progress = "@1/@2 killed",
		auto_description = { "Kill @2", "Kill @1×@2" },
		auto_description_total = { "Kill @1 mob", "Kill @1 mob." },
		get_key = function(self, def)
			return minetest.registered_aliases[def.trigger.mob] or def.trigger.mob
		end
	})

	-- trigger for punching (attacking) a mob
	awards.register_trigger("punch_mob", {
		type = "counted_key",
		progress = "@1/@2 punched",
		auto_description = { "Punch @2", "Punch @1×@2" },
		auto_description_total = { "Punch @1 mob", "Punch @1 mobs." },
		get_key = function(self, def)
			return minetest.registered_aliases[def.trigger.mob] or def.trigger.mob
		end
	})

	--
	-- There doesn't appear to be global callbacks to notify when an entity is punched or killed in minetest or mobs_redo
	--
	-- The Common Mob Interface (cmi), which is supported by mobs_redo, provides callback registration for punching
	-- and killing mobs. Those can then be used to trigger awards.
	if minetest.global_exists("cmi") then

		cmi.register_on_punchmob(function(mob, hitter, time_from_last_punch, tool_capabilities, dir, damage, attacker)
			if (player_ok(hitter)) then
				awards.notify_punch_mob(hitter, cmi.get_mob_description(mob))
			end
		end)

		cmi.register_on_diemob(function(mob, cause_of_death)
			if (player_ok(cause_of_death.puncher)) then
				awards.notify_kill_mob(cause_of_death.puncher, cmi.get_mob_description(mob))
			end
		end)

	end
end
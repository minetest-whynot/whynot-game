-- Check if a player object is valid for awards.
local function player_ok(player)
	return player and player.is_player and player:is_player() and not player.is_fake_player
end

-- Don't actually use translator here. We define empty S() to fool the update_translations script
-- into extracting those strings for the templates. Actual translation is done in api_triggers.lua.
local S = function (str)
	return str
end


awards.register_trigger("collect", {
    type = "counted_key",
    progress = S("@1/@2 collected"),
    auto_description = { S("Collect: @2"), S("Collect: @1×@2") },
    auto_description_total = { S("Collect @1 items."), S("Collect @1 items.") },
    get_key = function(self, def)
        return minetest.registered_aliases[def.trigger.item] or def.trigger.item
    end,
    key_is_item = true,
})



local base_minetest_handle_node_drops = minetest.handle_node_drops
function minetest.handle_node_drops(pos, drops, digger)
    if (not player_ok(digger)) then
        return
    end

    -- Uncomment to debug with qa_block
    local awards_data = awards.player(digger:get_player_name())
    Whynot_awards.playerawardsdata = awards_data

    for _, itemstr in ipairs(drops) do
        local itemstack = ItemStack(itemstr)
        for i = 1, itemstack:get_count(), 1 do
            awards.notify_collect(digger, itemstack:get_name())
        end
    end

    return base_minetest_handle_node_drops(pos, drops, digger)
end


local foodstuff_to_gather = {}
foodstuff_to_gather["default:apple"] = 1
foodstuff_to_gather["flowers:mushroom_brown"] = 1
foodstuff_to_gather["default:blueberries"] = 1

awards.register_trigger("eatwildfood", {
	type = "counted",
	progress = S("@1/@2 eaten"),
	auto_description = { S("Eat @2 different wild foods"), S("Eat @1×@2 different wild foods") },
})

minetest.register_on_item_eat(function(_, _, itemstack, player, _)
	if not player_ok(player) then
		return
	end

    local awards_data = awards.player(player:get_player_name())
    if (awards_data) then
        local itemname = itemstack:get_name()
        itemname = minetest.registered_aliases[itemname] or itemname

        -- Uncomment to debug with qa_block
        Whynot_awards.playerawardsdata = awards_data

        awards_data["eat"] = awards_data["eat"] or {}
        if (foodstuff_to_gather[itemname] ~= nil and awards_data["eat"][itemname] ~= nil and awards_data["eat"][itemname] <= 1) then
            awards.notify_eatwildfood(player)
        end
    end
end)


local grains_to_gather = {"farming:seed_wheat", "farming:seed_oat", "farming:seed_barley", "farming:seed_rye", "farming:seed_cotton", "farming:rice", "farming:seed_hemp"}

awards.register_trigger("gatherwildseeds",{
    type = "counted",
    progress = S("@1/@2 grains found"),
    auto_description = { S("Find @2 different wild seeds"), S("Find @1×@2 different wild seeds") },
})

local function check_wildseeds(_, _, _, digger)
    -- minetest.log("warning", "derp check_wildseeds")
    if (not player_ok(digger)) then
        return
    end

    -- minetest.log("warning", "derp player_ok")

    local awards_data = awards.player(digger:get_player_name())
    if (awards_data) then
        -- Uncomment to debug with qa_block
        Whynot_awards.playerawardsdata = awards_data

        -- minetest.log("warning", "derp awards_data")

        awards_data["collect"] = awards_data["collect"] or {}
        awards_data["prev_collect"] = awards_data["prev_collect"] or {}
        local collected = awards_data["collect"]
        local prev_collected = awards_data["prev_collect"]

        for _, itemname in pairs(grains_to_gather) do
            local items_collected = collected[itemname]
            if (prev_collected[itemname] ~= items_collected and (items_collected == nil or items_collected <= 1)) then
                -- minetest.log("warning", "derp "..itemname.." "..awards_data["collect"][itemname])
                awards.notify_gatherwildseeds(digger)
                prev_collected[itemname] = items_collected
            end
        end
    end
end

for i = 4, 5 do
	minetest.override_item("default:grass_" .. i, {
        after_dig_node = check_wildseeds
	})

	if minetest.registered_nodes["default:dry_grass_1"] then
		minetest.override_item("default:dry_grass_" .. i, {
			after_dig_node = check_wildseeds
		})
	end

end

minetest.override_item("default:junglegrass", {
    after_dig_node = check_wildseeds
})
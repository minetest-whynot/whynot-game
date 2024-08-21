-- Check if a player object is valid for awards.
local function player_ok(player)
	return minetest.is_player(player) and minetest.player_exists(player:get_player_name())
end

-- Don't actually use translator here. We define empty S() to fool the update_translations script
-- into extracting those strings for the templates. Actual translation is done in api_triggers.lua.
local S = function (str)
	return str
end


minetest.register_on_joinplayer(function(player, _)
    if (player_ok(player)) then
        local awards_data = awards.player(player:get_player_name())
        if (awards_data) then
            awards_data["max"] = awards_data["max"] or {}
            awards_data["max"]["depth"] = awards_data["max"]["depth"] or 0
            awards_data["max"]["altitude"] = awards_data["max"]["altitude"] or 0
            awards_data["max"]["distance"] = awards_data["max"]["distance"] or 0

            awards_data["prev_eatwildfood_eat"] = awards_data["prev_eatwildfood_eat"] or {}
            awards_data["prev_gatherfruitvegetable_collect"] = awards_data["prev_gatherfruitvegetable_collect"] or {}
            awards_data["prev_plant_crops_place"] = awards_data["prev_plant_crops_place"] or {}
            awards_data["prev_gatherwildseeds_collect"] = awards_data["prev_gatherwildseeds_collect"] or {}
        end
    end
end)


local function check_action_with_item_in_collection(trigger_name, award_action, itemname, collection, player)
    if (not (player_ok(player) and collection[itemname])) then
		return
	end

    local awards_data = awards.player(player:get_player_name())
    if (awards_data) then
        itemname = minetest.registered_aliases[itemname] or itemname

        -- Uncomment to debug with qa_block
        Whynot_awards.playerawardsdata = awards_data

        local prev_action = "prev_"..trigger_name.."_"..award_action
        local award_action_counts = awards_data[award_action]
        local prev_action_counts = awards_data[prev_action]

        local items_collected = award_action_counts[itemname]
        if (prev_action_counts[itemname] ~= items_collected and (items_collected <= 1 or prev_action_counts[itemname] == nil)) then
            awards["notify_"..trigger_name](player)
            prev_action_counts[itemname] = items_collected
        end
    end
end


local function check_action_with_collection(trigger_name, award_action, collection, player)
    if (not player_ok(player)) then
        return
    end

    local awards_data = awards.player(player:get_player_name())
    if (awards_data) then
        -- Uncomment to debug with qa_block
        Whynot_awards.playerawardsdata = awards_data

        local prev_action = "prev_"..trigger_name.."_"..award_action
        local award_action_counts = awards_data[award_action]
        local prev_action_counts = awards_data[prev_action]

        local notify_award_trigger = awards["notify_"..trigger_name]

        for _, itemname in pairs(collection) do
            local items_collected = award_action_counts[itemname]
            if (prev_action_counts[itemname] ~= items_collected and (items_collected <= 1 or prev_action_counts[itemname] == nil)) then
                notify_award_trigger(player)
                prev_action_counts[itemname] = items_collected
            end
        end
    end
end


------------------------------------
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
        if (not itemstack:is_empty()) then
            awards.notify_collect(digger, itemstack:get_name(), itemstack:get_count())
        end
    end

    return base_minetest_handle_node_drops(pos, drops, digger)
end


----------------------------------------
awards.register_trigger("eatwildfood", {
	type = "counted",
	progress = S("@1/@2 eaten"),
	auto_description = { S("Eat @2 wild food"), S("Eat @1×@2 different wild foods") },
})

local foodstuff_to_gather = {}
foodstuff_to_gather["default:apple"] = 1
foodstuff_to_gather["flowers:mushroom_brown"] = 1
foodstuff_to_gather["default:blueberries"] = 1
minetest.register_on_item_eat(function(_, _, itemstack, player, _)
    check_action_with_item_in_collection("eatwildfood", "eat", itemstack:get_name(), foodstuff_to_gather, player)
end)


--------------------------------
awards.register_trigger("max", {
	type = "counted_key",
	progress = S("@1/@2 reached"),
	auto_description = { S("Reach @2"), S("Reach @1 @2") },
    get_key = function (self, def)
        return def.trigger.max_param
    end,
})

local player_index = 1
local subbanding = 5
local function check_positions()
    local connected_players = minetest.get_connected_players()
    if player_index > #connected_players then
        player_index = 1
    end

    local end_index = math.min(player_index + subbanding, #connected_players)
    for i = player_index, end_index do
        local player = connected_players[i]
        if (player_ok(player)) then
            local awards_data = awards.player(player:get_player_name())
            if (awards_data) then
                local position = player:get_pos()
                local py = position.y
                local max_data = awards_data["max"]

                local depth_delta = math.floor(math.min(py + max_data["depth"], 0))
                if (depth_delta < 0) then
                    awards.notify_max(player, "depth", math.abs(depth_delta))
                end

                local altitude_delta = math.floor(math.max(py - max_data["altitude"], 0))
                if (altitude_delta > 0) then
                    awards.notify_max(player, "altitude", altitude_delta)
                end

                local px = position.x
                local pz = position.z
                local distance = math.floor(math.sqrt(px * px + pz * pz))
                local distance_delta = math.max(distance - max_data["distance"], 0)
                if (distance_delta > 0) then
                    awards.notify_max(player, "distance", distance_delta)
                end
            end
        end
    end

    player_index = player_index + player_index - end_index
    minetest.after(1, check_positions)
end
minetest.after(1, check_positions)


if (minetest.get_modpath("farming") and minetest.global_exists("farming") and farming.mod == "redo") then

    -------------------------------------------
    awards.register_trigger("gatherwildseeds",{
        type = "counted",
        progress = S("@1/@2 grains found"),
        auto_description = { S("Find @2 wild seed"), S("Find @1×@2 different wild seeds") },
    })

    local grains_to_gather = {"farming:seed_wheat", "farming:seed_oat", "farming:seed_barley", "farming:seed_rye", "farming:seed_cotton", "farming:rice", "farming:seed_hemp"}
    local function check_wildseeds(grassname)
        local grassitem = minetest.registered_nodes[grassname]
        if (grassitem) then
            local old_after_dig_node = grassitem.after_dig_node
            minetest.override_item(grassname, {
                after_dig_node = function(pos, oldnode, oldmetadata, digger)
                    if (old_after_dig_node) then
                        old_after_dig_node(pos, oldnode, oldmetadata, digger)
                    end
                    check_action_with_collection("gatherwildseeds", "collect", grains_to_gather, digger)
                end
            })
        end
    end

    -- Grass drops overrides from farming/grass.lua
    for i = 4, 5 do
        check_wildseeds("default:grass_" .. i)

        if minetest.registered_nodes["default:dry_grass_1"] then
            check_wildseeds("default:dry_grass_" .. i)
        end
    end

    check_wildseeds("default:junglegrass")

    ------------------------------------------------
    awards.register_trigger("gatherfruitvegetable",{
        type = "counted",
        progress = S("@1/@2 fruits and vegetables found"),
        auto_description = { S("Find @2 fruit or vegetable"), S("Find @1×@2 different fruits and vegetables") },
    })

    local function check_fruits_and_vegetables(cropname, index)
        local fullcropname = cropname .. "_" .. index
        local node = minetest.registered_nodes[fullcropname]
        if (node) then
            local old_after_dig_node = node.after_dig_node
            minetest.override_item(fullcropname, {
                after_dig_node = function(pos, oldnode, oldmetadata, digger)
                    if (old_after_dig_node) then
                        old_after_dig_node(pos, oldnode, oldmetadata, digger)
                    end
                    check_action_with_item_in_collection("gatherfruitvegetable", "collect", cropname, farming.registered_plants, digger)
                end
            })
        end
    end

    -- This doesn't work for all plants. Some, like beans, don't use the usual crop/seed naming conventions
    for _, plantdef in pairs(farming.registered_plants) do
        for i = 1, plantdef.steps do
            check_fruits_and_vegetables(plantdef.crop, i)
        end
    end


    -------------------------------------
    awards.register_trigger("plow_soil",{
        type = "counted",
        progress = S("@1/@2 plowed squares of soil"),
        auto_description = { S("Plow @2 square of soil"), S("Plow @1×@2 squares of soil") },
    })

    for name, itemdef in pairs(minetest.registered_tools) do
        if (string.find(name, "farming:hoe")) then
            local base_on_use = itemdef.on_use
            minetest.override_item(name, {
                on_use = function(itemstack, user, pointed_thing)
                    awards.notify_plow_soil(user)
                    if base_on_use then
                        return base_on_use(itemstack, user, pointed_thing)
                    else
                        return nil
                    end
                end
            })
        end
    end


    ---------------------------------------
    awards.register_trigger("plant_crops",{
        type = "counted",
        progress = S("@1/@2 different crop types planted"),
        auto_description = { S("Planted @2 crop"), S("Planted @1×@2 different types of crops") },
    })

    local registered_seeds = {}
    for _, plantdef in pairs(farming.registered_plants) do
        local seed_name = plantdef.seed
        local reg_item = minetest.registered_items[seed_name]
        if (reg_item) then
            registered_seeds[seed_name] = 1
            local base_on_place = reg_item.on_place
            minetest.override_item(seed_name, {
                on_place = function(itemstack, placer, pointed_thing)
                    awards.notify_place(placer, itemstack:get_name())
                    check_action_with_item_in_collection("plant_crops", "place", itemstack:get_name(), registered_seeds, placer)
                    if base_on_place then
                        return base_on_place(itemstack, placer, pointed_thing)
                    else
                        return itemstack:take_item(1)
                    end
                end
            })
        end
    end


end -- if farming


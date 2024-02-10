-- Check if a player object is valid for awards.
local function player_ok(player)
	return player and player.is_player and player:is_player() and not player.is_fake_player
end

-- Don't actually use translator here. We define empty S() to fool the update_translations script
-- into extracting those strings for the templates. Actual translation is done in api_triggers.lua.
local S = function (str)
	return str
end


local function get_prev_inventory(player)
    local awards_data = awards.player(player:get_player_name())
    if (awards_data) then
        -- persistent data
        awards_data.whynot_awards_data = awards_data.whynot_awards_data or {}
        local wna_data = awards_data.whynot_awards_data
        wna_data.prev_inventory = wna_data.prev_inventory or {}
        local prev_inventory = wna_data.prev_inventory

        return prev_inventory
    end
    return {}
end

local function prev_item_count(prev_inventory, item_name)
    if (prev_inventory[item_name] == nil) then
        prev_inventory[item_name] = 0
    end
    return prev_inventory[item_name]
end


function awards.register_collect_award(awname, def)
    awards.register_award(awname, def)

    if (not def or not def.trigger or not awname) then
        return
    end

    local trigger = def.trigger
    local itemname = trigger.item

    -- To prevent players from dropping and picking up items over and over to achieve the awards
    minetest.override_item(itemname, {
        on_pickup = function(itemstack, picker, pointed_thing, time_from_last_punch, ...)
            if (player_ok(picker) and itemstack) then
                local previnv = get_prev_inventory(picker)
                local prev_count = prev_item_count(previnv, itemname)
                prev_count = prev_count + itemstack:get_count()
                previnv[itemname] = prev_count
                for i=1,prev_count,1 do
                    awards.notify_collect(picker, itemname)
                end
            end
            return minetest.item_pickup(itemstack, picker, pointed_thing, time_from_last_punch, ...)
        end,
        on_drop = function(itemstack, dropper, pos)
            if (player_ok(dropper) and itemstack) then
                local previnv = get_prev_inventory(dropper)
                local prev_count = prev_item_count(previnv, itemname)
                prev_count = prev_count - itemstack:get_count()
                previnv[itemname] = prev_count
            end
            return minetest.item_drop(itemstack, dropper, pos)
        end,
    })


    if (trigger.parent_item) then
        local parent_item = trigger.parent_item
        parent_item = minetest.registered_aliases[parent_item] or parent_item

        minetest.override_item(parent_item, {
            preserve_metadata = function(pos, oldnode, oldmeta, drops)
                for _, dropstack in pairs(drops) do
                    if (dropstack and dropstack:get_name() == itemname) then

                    end
                end
            end,
        })
    end
end


minetest.register_on_player_inventory_action(function(player, action, _, inventory_info)
    if (not player_ok(player) or action == nil or inventory_info == nil or inventory_info.stack == nil) then
        return
    end

    minetest.log("warning", "player_inventory_action '"..action.."' by "..player:get_player_name())

    local itemstack = inventory_info.stack
    if (not itemstack:is_empty()) then
        local itemname = itemstack:get_name()
        itemname = minetest.registered_aliases[itemname] or itemname

        local previnv = get_prev_inventory(player, itemname)
        if (previnv == nil) then
            return
        end
        local prev_item_count = previnv[itemname]

        awards.notify_collect(player, itemname)

        previnv[itemname] = prev_item_count
    end
end)

minetest.override_item("default:dirt", {
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        --local inv = minetest.get_inventory({type="node", pos=pos})
        minetest.log("warning", "after_dig_node("..oldnode.name..") at ("..pos.x..","..pos.y..","..pos.z..") by "..digger:get_player_name())
        if oldmetadata and oldmetadata.inventory then
            minetest.log("warning", "after_dig_node metadata inventory")
            for listname, list in pairs(oldmetadata.inventory) do
                minetest.log("warning", "after_dig_node "..listname)
                for index, stack in ipairs(list) do
                    minetest.log("warning", "after_dig_node "..listname.."["..index.."] = "..stack:get_name())
                    if stack and not stack:is_empty() then
                        local itemname = stack:get_name()
                        itemname = minetest.registered_aliases[itemname] or itemname
                        awards.notify_collect(digger, itemname)
                    end
                end
            end
        end
    end
})


Whynot_awards.myawardsdata = {}
Whynot_awards.foodstuff_to_gather = {}
Whynot_awards.foodstuff_to_gather["default:apple"] = 1
Whynot_awards.foodstuff_to_gather["flowers:mushroom_brown"] = 1
Whynot_awards.foodstuff_to_gather["default:blueberries"] = 1


awards.register_trigger("eatwildfood", {
	type = "counted",
	progress = S("@1/@2 eaten"),
	auto_description = { S("Eat @2 different wild foods"), S("Eat @1×@2 different wild foods") },
})

minetest.register_on_item_eat(function(_, _, itemstack, player, _)
	if not player_ok(player) or itemstack:is_empty() then
		return
	end

    local awards_data = awards.player(player:get_player_name())
    --Whynot_awards.myawardsdata = awards_data

    if (awards_data) then
        awards_data.whynot_awards_data = awards_data.whynot_awards_data or {}
        local wna_data = awards_data.whynot_awards_data
        wna_data.gathered_foodstuff = wna_data.gathered_foodstuff or {}
        local gathered = wna_data.gathered_foodstuff

        local to_gather = Whynot_awards.foodstuff_to_gather
        local itemname = itemstack:get_name()
        itemname = minetest.registered_aliases[itemname] or itemname

        if (to_gather[itemname] ~= nil and gathered[itemname] == nil) then
            gathered[itemname] = 1
            awards.notify_eatwildfood(player)
        end
    end
end)
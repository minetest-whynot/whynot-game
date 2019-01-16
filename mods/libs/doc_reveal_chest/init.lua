
------------- Function copied from doc_items because local only
--[[ Reveal items as the player progresses through the game.
Items are revealed by:
* Digging, punching or placing node,
* Crafting
* Having item in inventory (not instantly revealed) ]]

local function reveal_item(playername, itemstring)
	local category_id
	if itemstring == nil or itemstring == "" or playername == nil or playername == "" then
		return false
	end
	if minetest.registered_nodes[itemstring] ~= nil then
		category_id = "nodes"
	elseif minetest.registered_tools[itemstring] ~= nil then
		category_id = "tools"
	elseif minetest.registered_craftitems[itemstring] ~= nil then
		category_id = "craftitems"
	elseif minetest.registered_items[itemstring] ~= nil then
		category_id = "craftitems"
	else
		return false
	end
	doc.mark_entry_as_revealed(playername, category_id, itemstring)
	return true
end
-----------------------------------------------------------

doc_reveal_chest = {}

local function reveal_inventory(pos, playername)
	local inv = minetest.get_inventory({type="node", pos=pos})
	if inv then
		for _, list in pairs(inv:get_lists()) do
			for _, stack in ipairs(list) do
				if not stack:is_empty() then
					reveal_item(playername, stack:get_name())
				end
			end
		end
	end
end

function doc_reveal_chest.override_on_rightclick(nodename)
	local def = minetest.registered_nodes[nodename]
	assert(def, "cannot apply doc_reveal_chest.override_node to "..nodename)
	assert(def.on_rightclick, "cannot override not existing on_rightclick")

	minetest.override_item(nodename, {
		doc_reveal_chest_orig_on_rightclick = def.on_rightclick,
		on_rightclick = function(pos, node, clicker)
			reveal_inventory(pos, clicker:get_player_name())
			return minetest.registered_nodes[nodename].doc_reveal_chest_orig_on_rightclick(pos, node, clicker)
		end
	})
end

doc_reveal_chest.override_on_rightclick("default:chest")

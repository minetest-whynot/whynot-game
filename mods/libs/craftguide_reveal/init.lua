local reg_items = minetest.registered_items

local revealed_cache = {}

minetest.register_on_leaveplayer(function(player)
	revealed_cache[player:get_player_name()] = nil
end)

local function item_has_groups(item_groups, groups)
	for i = 1, #groups do
		local group = groups[i]
		if not item_groups[group] then
			return
		end
	end
	return true
end

local function revealed_show_recipe(recipe, playername)
	if not revealed_cache[playername] then
		revealed_cache[playername] = {}
	end
	if revealed_cache[playername][recipe] then
		return true
	end

	local revealed = doc.data.players[playername].stored_data.revealed
	for _, item in pairs(recipe.items) do
		local is_revealed_item = false
		if item:sub(1,6) == "group:" then
			local groups = item:sub(7):split(",")
			for cid, items in pairs(revealed) do
				for revealed_item in pairs(items) do
					if reg_items[revealed_item] and item_has_groups(reg_items[revealed_item].groups, groups) then
						is_revealed_item = true
						break
					end
				end
				if is_revealed_item then
					break
				end
			end
		else
			for cid, items in pairs(revealed) do
				if items[item] then
					is_revealed_item = true
					break
				end
			end
		end

		if not is_revealed_item then
			return false
		end
	end
	revealed_cache[playername][recipe] = true
	return true
end

craftguide.remove_recipe_filter("Default progressive filter")
craftguide.add_recipe_filter('reveal', function(recipes, player)
	if not recipes then
		return
	end
	local filtered = {}
	for i = 1, #recipes do
		local recipe = recipes[i]
		if revealed_show_recipe(recipe, player:get_player_name()) then
			filtered[#filtered + 1] = recipe
		end
	end
	return filtered
end)

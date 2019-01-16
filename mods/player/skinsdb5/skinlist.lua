-- Get skinlist for player. If no player given, public skins only selected
function skinsdb5.get_skinlist_for_player(playername)
	local skinslist = {}
	for _, skin in pairs(player_api.registered_skins) do
		if skin.in_inventory_list ~= false and
				(not skin.playername or (playername and skin.playername:lower() == playername:lower())) then
			table.insert(skinslist, skin)
		end
	end
	table.sort(skinslist, function(a,b) return tostring(a.sort_id or
			a.description or a.name or "") < tostring(b.sort_id or b.description or b.name or "") end)
	return skinslist
end

-- Get skinlist selected by metadata
function skinsdb5.get_skinlist_with_meta(key, value)
	assert(key, "key parameter for skinsdb5.get_skinlist_with_meta() missed")
	local skinslist = {}
	for _, skin in pairs(player_api.registered_skins) do
		if skin[key] == value then
			table.insert(skinslist, skin)
		end
	end
	table.sort(skinslist, function(a,b) return (tostring(a.sort_id) or
			a.description or a.name or "") < (tostring(b.sort_id) or b.description or b.name or "") end)
	return skinslist
end

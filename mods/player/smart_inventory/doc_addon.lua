smart_inventory.doc_items_mod = minetest.get_modpath("doc_items")

local doc_addon = {}

local doc_item_entries = {}

function doc_addon.is_revealed_item(itemname, playername)
	if not smart_inventory.doc_items_mod then
		return true
	end

	doc_addon.get_category_list()
	itemname = minetest.registered_aliases[itemname] or itemname
	local doc_entry = doc_item_entries[itemname]
	if doc_entry then
		return doc.entry_revealed(playername, doc_entry.cid, doc_entry.eid)
	else
		-- unknown item
		return false
	end
	return true
end

function doc_addon.show(itemname, playername)
	if not smart_inventory.doc_items_mod then
		return
	end

	doc_addon.get_category_list()
	itemname = minetest.registered_aliases[itemname] or itemname
	local doc_entry = doc_item_entries[itemname]
	if doc_entry then
		doc.mark_entry_as_viewed(playername, doc_entry.cid, doc_entry.eid)
		local state = smart_inventory.get_page_state("doc", playername)
		local codebox = state:get("code")
		codebox.edata = doc_entry
		doc.data.players[playername].galidx = 1
		codebox:submit() --update the page
		state.location.parentState:get("doc_button"):submit() -- switch to the tab
	end

end

-- Get sorted category list
local doc_category_list = nil

function doc_addon.get_category_list()
	-- build on first usage
	if not doc_category_list and smart_inventory.doc_items_mod then
		doc_category_list = {}
		for _, category_name in ipairs(doc.data.category_order) do
			local category = doc.data.categories[category_name]
			if category then
				local entries_data = {}
				for _, eid in ipairs(doc.get_sorted_entry_names(category_name)) do
					local entry = doc.data.categories[category_name].entries[eid]
					if entry.data.itemstring and
							minetest.registered_items[entry.data.itemstring] and
							(entry.data.def == minetest.registered_items[entry.data.itemstring] or entry.data.def.door) then
						local edata = {cid = category_name, cid_data = category, eid = eid, data = entry}
						table.insert(entries_data, edata)
						doc_item_entries[entry.data.itemstring] = edata
					end
				end
				table.insert(doc_category_list, {cid = category_name, data = category, entries = entries_data})
			end
		end
	end
	return doc_category_list
end

-------------------------
return doc_addon

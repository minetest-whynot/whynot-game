local doc_addon = smart_inventory.doc_addon

if not smart_inventory.doc_items_mod then
	return
end

local COLOR_NOT_VIEWED = "#00FFFF"      -- cyan
local COLOR_VIEWED = "#FFFFFF"          -- white
local COLOR_HIDDEN = "#999999"          -- gray
local COLOR_ERROR = "#FF0000"           -- red

local function update_entry_list(state, selected_eid)
	local playername = state.location.rootState.location.player
	local category_id, category

	category_id = state:get("category"):getSelected()
	if category_id then
		category = doc_addon.get_category_list()[category_id]
	end
	if not category then
		return
	end

	local total = doc.get_entry_count(category.cid)
	local revealed = doc.get_revealed_count(playername, category.cid)
	local viewed = doc.get_viewed_count(playername, category.cid)
	local hidden = total - revealed
	local new = total - viewed - hidden

	state:get("lbl_category"):setText(category.data.def.description)
	state:get("lbl_viewed"):setText(minetest.colorize(COLOR_VIEWED,"Viewed: "..viewed.."/"..revealed))
	state:get("lbl_hidden"):setText(minetest.colorize(COLOR_HIDDEN,"Hidden: "..hidden.."/"..total))
	state:get("lbl_new"):setText(minetest.colorize(COLOR_NOT_VIEWED,"New: "..new))
	local entries_box = state:get("entries")
	entries_box:clearItems()
	state.param.doc_entry_list = {}
	for _, edata in ipairs(category.entries) do
		local viewedprefix
		if doc.entry_revealed(playername, category.cid, edata.eid) then
			if doc.entry_viewed(playername, category.cid, edata.eid) then
				viewedprefix = COLOR_VIEWED
			else
				viewedprefix = COLOR_NOT_VIEWED
			end

			local name = edata.data.name
			if name == nil or name == "" then
				name = edata.eid
			end

			local idx = entries_box:addItem(viewedprefix..name)
			table.insert(state.param.doc_entry_list, edata)
			if selected_eid == edata.eid then
				entries_box:setSelected(idx)
			end
		end
	end
end

local function doc_callback(state)
	local playername = state.location.rootState.location.player

	state:label(0, 0, "lbl_category", "")
	state:background(0,0,20,0.5,"cat_bg", "halo.png")
--	state:label(0, 0.5, "lbl_revealed", "")
	state:label(0, 0.5, "lbl_viewed", "")
	state:label(3, 0.5, "lbl_new", "")
	state:label(0, 1, "lbl_hidden", "")

	local category_box = state:listbox(0, 1.5, 4.8, 2, "category", nil, false)
	category_box:onClick(function(self, state, player)
		update_entry_list(state)
	end)

	state:listbox(0, 4, 4.8, 6, "entries", nil, false):onDoubleClick(function(self, state, player)
		local playername = state.location.rootState.location.player
		local selected = self:getSelected()
		local doc_entry = state.param.doc_entry_list[selected]
		if doc_entry then
			doc.mark_entry_as_viewed(playername, doc_entry.cid, doc_entry.eid)
			state:get("code").edata = doc_entry
			doc.data.players[playername].galidx = 1
			update_entry_list(state)
		end
	end)

	local codebox = state:element("code", { name = "code", code = "" })
	codebox:onBuild(function(self)
		if self.edata then
			local state = self.root
			local playername = state.location.rootState.location.player
			self.data.code = "container[5.5,0]".. self.edata.cid_data.def.build_formspec(self.edata.data.data, playername).."container_end[]"
		else
			self.data.code = ""
		end
	end)

	-- to trigger the page update
	codebox:onSubmit(function(self, state)
		-- select the right category
		for idx, category in ipairs(doc_addon.get_category_list()) do
			if category.cid == self.edata.cid then
				state:get("category"):setSelected(idx)
				break
			end
		end

		-- update page for new category
		update_entry_list(state, self.edata.eid)
	end)

	state:onInput(function(state, fields, player)
		if fields.doc_button_gallery_prev then
			if doc.data.players[playername].galidx - doc.data.players[playername].galrows > 0 then
				doc.data.players[playername].galidx = doc.data.players[playername].galidx - doc.data.players[playername].galrows
			end

		elseif fields.doc_button_gallery_next then
			if doc.data.players[playername].galidx + doc.data.players[playername].galrows <= doc.data.players[playername].maxgalidx then
				doc.data.players[playername].galidx = doc.data.players[playername].galidx + doc.data.players[playername].galrows
			end
		end
	end)

	-- fill category table
	for _, category in ipairs(doc_addon.get_category_list()) do
		category_box:addItem(category.data.def.name)
	end
end

smart_inventory.register_page({
	name = "doc",
	icon = "doc_awards_icon_generic.png",
	tooltip = "Ingame documentation",
	smartfs_callback = doc_callback,
	sequence = 30,
	on_button_click = update_entry_list,
})

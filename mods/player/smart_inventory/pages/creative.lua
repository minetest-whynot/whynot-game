if not minetest.setting_getbool("creative_mode") then
	return
end

local cache = smart_inventory.cache
local ui_tools = smart_inventory.ui_tools

-----------------------------------------------------
-- Update on group selection change
-----------------------------------------------------
local function update_group_selection(state, changed_group)
	local grouped = state.param.creative_grouped_items
	local groups_sel1 = state:get("groups_sel1")
	local groups_sel2 = state:get("groups_sel2")
	local groups_sel3 = state:get("groups_sel3")
	local grid = state:get("buttons_grid")
	local outlist

	if state.param.creative_grouped_shape_items and
			next(state.param.creative_grouped_shape_items) then
		local group_info = {}
		group_info.name = "shape"
		group_info.cgroup = cache.cgroups["shape"]
		group_info.group_desc = "#01DF74> "..group_info.cgroup.group_desc
		group_info.items = state.param.creative_grouped_shape_items
		grouped["shape"] = group_info
	end

	-- update group 1
	if changed_group < 1 or not state.param.creative_group_list1 then
		state.param.creative_group_list1 = ui_tools.update_group_selection(grouped, groups_sel1, state.param.creative_group_list1)
	end

	local sel_id = groups_sel1:getSelected()
	if state.param.creative_group_list1[sel_id] == "all"
			or not state.param.creative_group_list1[sel_id]
			or not grouped[state.param.creative_group_list1[sel_id]] then
		outlist = grouped["all"].items
		groups_sel2:clearItems()
		groups_sel3:clearItems()
	else
		-- update group 2
		grouped = ui_tools.get_list_grouped(grouped[state.param.creative_group_list1[sel_id]].items)
		if changed_group < 2 or not state.param.creative_group_list2 then
			state.param.creative_group_list2 = ui_tools.update_group_selection(grouped, groups_sel2, state.param.creative_group_list2)
		end

		sel_id = groups_sel2:getSelected()
		if state.param.creative_group_list2[sel_id] == "all"
				or not state.param.creative_group_list2[sel_id]
				or not grouped[state.param.creative_group_list2[sel_id]] then
			outlist = grouped["all"].items
			groups_sel3:clearItems()
		else
			-- update group 3
			grouped = ui_tools.get_list_grouped(grouped[state.param.creative_group_list2[sel_id]].items)
			if changed_group < 3 or not state.param.creative_group_list3 then
				state.param.creative_group_list3 = ui_tools.update_group_selection(grouped, groups_sel3, state.param.creative_group_list3)
			end
			sel_id = groups_sel3:getSelected()
			outlist = grouped[state.param.creative_group_list3[sel_id]].items
		end
	end

	-- update grid list
	if outlist then
		table.sort(outlist, function(a,b)
			return a.item < b.item
		end)
		grid:setList(outlist)
		state.param.creative_outlist = outlist
	else
		grid:setList({})
	end
end

-----------------------------------------------------
-- Page layout definition
-----------------------------------------------------
local function creative_callback(state)
	local player = state.location.rootState.location.player

	-- build up UI controller
	local ui_controller = {}
	ui_controller.state = state
	state.param.creative_ui_controller = ui_controller
	ui_controller.player =  minetest.get_player_by_name(state.location.rootState.location.player)

	function ui_controller:set_ui_variant(new_ui)
		-- check if change needed
		if new_ui == self.ui_toggle then
			return
		end

		-- toggle show/hide elements
		if new_ui == 'list_small' then
			self.ui_toggle = new_ui
			self.state:get("groups_sel2"):setVisible(true)
			self.state:get("groups_sel3"):setVisible(true)
			self.state:get("buttons_grid"):reset(9.55, 3.75, 9.0 , 6.5)
			self.state:get("buttons_grid_bg"):setPosition(9.2, 3.5)
			self.state:get("buttons_grid_bg"):setSize(9.5, 6.5)
			self.state:get("btn_tog"):setId(1)
		elseif new_ui == 'list_big' then
			self.ui_toggle = new_ui
			self.state:get("groups_sel2"):setVisible(false)
			self.state:get("groups_sel3"):setVisible(false)
			self.state:get("buttons_grid"):reset(9.55, 0.25, 9.0 , 10)
			self.state:get("buttons_grid_bg"):setPosition(9.2, 0)
			self.state:get("buttons_grid_bg"):setSize(9.5, 10)
			self.state:get("btn_tog"):setId(2)
		end
		self:save()
	end
	function ui_controller:save()
		local savedata = minetest.deserialize(self.player:get_attribute("smart_inventory_settings")) or {}
		savedata.creative_ui_toggle = self.ui_toggle
		self.player:set_attribute("smart_inventory_settings", minetest.serialize(savedata))
	end

	function ui_controller:restore()
		local savedata = minetest.deserialize(self.player:get_attribute("smart_inventory_settings")) or {}

		if savedata.creative_ui_toggle then
			ui_controller:set_ui_variant(savedata.creative_ui_toggle)
		end
	end

	-- groups 1-3
	local group_sel1 = state:listbox(1, 0.15, 5.6, 3, "groups_sel1",nil, false)
	group_sel1:onClick(function(self, state, player)
		local selected = self:getSelectedItem()
		if selected then
			state:get("groups_sel2"):setSelected(1)
			state:get("groups_sel3"):setSelected(1)
			update_group_selection(state, 1)
		end
	end)

	local group_sel2 = state:listbox(7, 0.15, 5.6, 3, "groups_sel2",nil, false)
	group_sel2:onClick(function(self, state, player)
		local selected = self:getSelectedItem()
		if selected then
			state:get("groups_sel3"):setSelected(1)
			update_group_selection(state, 2)
		end
	end)

	local group_sel3 = state:listbox(13, 0.15, 5.6, 3, "groups_sel3",nil, false)
	group_sel3:onClick(function(self, state, player)
		local selected = self:getSelectedItem()
		if selected then
			update_group_selection(state, 3)
		end
	end)

	-- functions
	local searchfield = state:field(1.3, 4.1, 4.8, 0.5, "search")
	searchfield:setCloseOnEnter(false)
	searchfield:onKeyEnter(function(self, state, player)
		local search_string = self:getText()
		local filtered_list = ui_tools.filter_by_searchstring(ui_tools.root_list, search_string)
		state.param.creative_grouped_items = ui_tools.get_list_grouped(filtered_list)
		filtered_list = ui_tools.filter_by_searchstring(ui_tools.root_list_shape, search_string)
		state.param.creative_grouped_shape_items = filtered_list
		update_group_selection(state, 0)
	end)

	-- action mode toggle
	state:toggle(6, 3.8,1.5,0.5, "btn_tog_mode", {"Give 1", "Give stack"})

	-- groups toggle
	local btn_toggle = state:toggle(7.5, 3.8,1.5,0.5, "btn_tog", {"Groups", "Hide"})
	btn_toggle:onToggle(function(self, state, player)
		local id = self:getId()
		if id == 1 then
			state.param.creative_ui_controller:set_ui_variant("list_small")
		elseif id == 2 then
			state.param.creative_ui_controller:set_ui_variant("list_big")
		end
	end)

	-- craftable items grid
	state:background(9.2, 3.5, 9.5, 6.5, "buttons_grid_bg", "minimap_overlay_square.png")
	local grid = smart_inventory.smartfs_elements.buttons_grid(state, 9.55, 3.75, 9.0 , 6.5, "buttons_grid", 0.75,0.75)
	grid:onClick(function(self, state, index, player)
		local mode = state:get("btn_tog_mode"):getId() or 1
		local selected = ItemStack(state.param.creative_outlist[index].item)
		if mode == 1 then -- give 1 item
			state.param.invobj:add_item(selected)
		elseif mode == 2 then --give full stack
			selected:set_count(selected:get_stack_max())
			state.param.invobj:add_sepearate_stack(selected)
		end
	end)

	-- inventory
	state:inventory(1, 5, 8, 4,"main")
	ui_tools.create_trash_inv(state, player)
	state:image(8,9,1,1,"trash_icon","smart_inventory_trash.png")
	state:element("code", {name = "trash_bg_code", code = "listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"})
	state:inventory(8,9,1,1, "trash"):useDetached(player.."_trash_inv")

	-- swap slots buttons
	state:image_button(0, 6, 1, 1, "swap1", "", "smart_inventory_swapline_button.png"):onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "creative", "swap1")
		state.param.invobj:swap_row_to_top(2)
	end)
	state:image_button(0, 7, 1, 1, "swap2", "", "smart_inventory_swapline_button.png"):onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "creative", "swap2")
		state.param.invobj:swap_row_to_top(3)
	end)
	state:image_button(0, 8, 1, 1, "swap3", "", "smart_inventory_swapline_button.png"):onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "creative", "swap3")
		state.param.invobj:swap_row_to_top(4)
	end)

	-- trash button
	local trash_all = state:image_button(7,9,1,1, "trash_all", "", "smart_inventory_trash_all_button.png")
	trash_all:setTooltip("Trash all inventory content")
	trash_all:onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "creative", "trash_all")
		state.param.invobj:remove_all()
	end)

	-- save/restore buttons
	local btn_save1 = state:image_button(1,9,1,1, "save1", "", "smart_inventory_save1_button.png")
	btn_save1:setTooltip("Save inventory content to slot 1")
	btn_save1:onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "creative", "save1")
		state.param.invobj:save_to_slot(1)
	end)
	local btn_save2 = state:image_button(1.9,9,1,1, "save2", "", "smart_inventory_save2_button.png")
	btn_save2:setTooltip("Save inventory content to slot 2")
	btn_save2:onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "creative", "save2")
		state.param.invobj:save_to_slot(2)
	end)
	local btn_save3 = state:image_button(2.8,9,1,1, "save3", "", "smart_inventory_save3_button.png")
	btn_save3:setTooltip("Save inventory content to slot 3")
	btn_save3:onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "creative", "save3")
		state.param.invobj:save_to_slot(3)
	end)
	local btn_restore1 = state:image_button(4,9,1,1, "restore1", "", "smart_inventory_get1_button.png")
	btn_restore1:setTooltip("Restore inventory content from slot 1")
	btn_restore1:onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "creative", "restore1")
		state.param.invobj:restore_from_slot(1)
	end)
	local btn_restore2 = state:image_button(4.9,9,1,1, "restore2", "", "smart_inventory_get2_button.png")
	btn_restore2:setTooltip("Restore inventory content from slot 2")
	btn_restore2:onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "creative", "restore2")
		state.param.invobj:restore_from_slot(2)
	end)
	local btn_restore3 = state:image_button(5.8,9,1,1, "restore3", "", "smart_inventory_get3_button.png")
	btn_restore3:setTooltip("Restore inventory content from slot 3")
	btn_restore3:onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "creative", "restore3")
		state.param.invobj:restore_from_slot(3)
	end)

	-- fill with data
	state.param.creative_grouped_items = ui_tools.get_list_grouped(ui_tools.root_list)
	state.param.creative_grouped_shape_items = ui_tools.root_list_shape
	update_group_selection(state, 0)
	ui_controller:restore()
end

-----------------------------------------------------
-- Register page in smart_inventory
-----------------------------------------------------
smart_inventory.register_page({
	name = "creative",
	tooltip = "The creative way to get items",
	icon = "smart_inventory_creative_button.png",
	smartfs_callback = creative_callback,
	sequence = 15
})

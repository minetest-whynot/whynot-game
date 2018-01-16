local cache = smart_inventory.cache
local crecipes = smart_inventory.crecipes
local doc_addon = smart_inventory.doc_addon
local ui_tools = smart_inventory.ui_tools

-----------------------------------------------------
-- Update recipe preview item informations about the selected item
-----------------------------------------------------
local function update_crafting_preview(state)
	local player = state.location.rootState.location.player
	local listentry = state.param.crafting_recipes_preview_listentry
	local selected = state.param.crafting_recipes_preview_selected
	local itemdef = listentry.itemdef
	local inf_state = state:get("inf_area"):getContainerState()
	local cr_type_img = state:get("cr_type_img")
	local craft_result = inf_state:get("craft_result")
	local group_list = inf_state:get("item_groups")

	-- get recipe to display, check paging buttons needed
	local all_recipes
	local valid_recipes = {}
	local recipe
	local revealed_items_cache = {}

	if listentry.recipes then -- preselected recipes (ie. craftable)
		all_recipes = listentry.recipes
	elseif cache.citems[listentry.item] then -- check all available recipes (ie. search)
		all_recipes = cache.citems[listentry.item].in_output_recipe or {}
	else -- no recipes
		all_recipes = {}
	end

	for _, recipe in ipairs(all_recipes) do
		if crecipes.crecipes[recipe]:is_revealed(player, revealed_items_cache) then
			table.insert(valid_recipes, recipe)
		end
	end

	if valid_recipes[1] then
		if not valid_recipes[selected] then
			selected = 1
		end
		state.param.crafting_recipes_preview_selected = selected
		if selected > 1 and valid_recipes[selected-1] then
			state:get("preview_prev"):setVisible(true)
		else
			state:get("preview_prev"):setVisible(false)
		end
		if valid_recipes[selected+1] then
			state:get("preview_next"):setVisible(true)
		else
			state:get("preview_next"):setVisible(false)
		end

		if valid_recipes[selected] then
			recipe = valid_recipes[selected]
			local crecipe = crecipes.crecipes[recipe]
			if crecipe then
				recipe = crecipe:get_with_placeholder(player, state.param.crafting_items_in_inventory)
			end
		end
	else
		state:get("preview_prev"):setVisible(false)
		state:get("preview_next"):setVisible(false)
	end

	-- display the recipe result or selected item
	if recipe then
		if recipe.type == "normal" then
			state:get("cr_type"):setText("")
			cr_type_img:setVisible(false)
			state:get("ac1"):setVisible(true)
		elseif recipe.type == "cooking" then
			state:get("cr_type"):setText(recipe.type)
			state:get("cr_type"):setText("")
			cr_type_img:setVisible(true)
			cr_type_img:setImage("default_furnace_front.png")
			state:get("ac1"):setVisible(false)
		else
			state:get("cr_type"):setText(recipe.type)
			cr_type_img:setVisible(false)
			state:get("ac1"):setVisible(false)
		end
		craft_result:setImage(recipe.output)
		craft_result:setVisible()
		state:get("craft_preview"):setCraft(recipe)
	else
		state:get("cr_type"):setText("")
		state:get("craft_preview"):setCraft(nil)
		cr_type_img:setVisible(false)
		state:get("ac1"):setVisible(false)
		if itemdef then
			craft_result:setVisible(true)
			craft_result:setImage(itemdef.name)
		else
			craft_result:setVisible(false)
		end
	end

	-- display docs icon if revealed item
	if smart_inventory.doc_items_mod then
		inf_state:get("doc_btn"):setVisible(false)
		local outitem = craft_result:getImage()
		if outitem then
			for z in outitem:gmatch("[^%s]+") do
				if doc_addon.is_revealed_item(z, player) then
					inf_state:get("doc_btn"):setVisible(true)
				end
				break
			end
		end
	end

	-- update info area
	if itemdef then
		inf_state:get("info1"):setText(itemdef.description)
		inf_state:get("info2"):setText("("..itemdef.name..")")
		if itemdef._doc_items_longdesc then
			inf_state:get("info3"):setText(itemdef._doc_items_longdesc)
		else
			inf_state:get("info3"):setText("")
		end

		group_list:clearItems()
		cache.add_item(listentry.itemdef)            -- Note: this addition does not affect the already prepared root lists
		if cache.citems[itemdef.name] then
			for _, groupdef in ipairs(ui_tools.get_tight_groups(cache.citems[itemdef.name].cgroups)) do
				group_list:addItem(groupdef.group_desc)
			end
		end
	elseif listentry.item then
		inf_state:get("info1"):setText("")
		inf_state:get("info2"):setText("("..listentry.item..")")
		inf_state:get("info3"):setText("")
	else
		inf_state:get("info1"):setText("")
		inf_state:get("info2"):setText("")
		inf_state:get("info3"):setText("")
		group_list:clearItems()
	end
end

-----------------------------------------------------
-- Update the group selection table
-----------------------------------------------------
local function update_group_selection(state, rebuild)
	local grouped = state.param.crafting_grouped_items
	local groups_sel = state:get("groups_sel")
	local grid = state:get("buttons_grid")
	local label = state:get("inf_area"):getContainerState():get("groups_label")

	if rebuild then
		state.param.crafting_group_list = ui_tools.update_group_selection(grouped, groups_sel, state.param.crafting_group_list)
	end

	local sel_id = groups_sel:getSelected()
	if state.param.crafting_group_list[sel_id] then
		state.param.crafting_craftable_list = grouped[state.param.crafting_group_list[sel_id]].items
		table.sort(state.param.crafting_craftable_list, function(a,b)
			return a.item < b.item
		end)
		grid:setList(state.param.crafting_craftable_list)
		label:setText(groups_sel:getSelectedItem())
	else
		label:setText("Empty List")
		grid:setList({})
	end
end

-----------------------------------------------------
-- Update the items list
-----------------------------------------------------
local function update_from_recipelist(state, recipelist, preview_item, replace_not_in_list)
	local old_preview_entry, old_preview_item, new_preview_entry, new_preview_item
	if state.param.crafting_recipes_preview_listentry then
		old_preview_item = state.param.crafting_recipes_preview_listentry.item
	end
	if preview_item == "" then
		new_preview_item = nil
	else
		new_preview_item = preview_item
	end

	local duplicate_index_tmp = {}
	local craftable_itemlist = {}

	for recipe, _ in pairs(recipelist) do
		local def = crecipes.crecipes[recipe].out_item
		if duplicate_index_tmp[def.name] then
			table.insert(duplicate_index_tmp[def.name].recipes, recipe)
		else
			local entry = {
				itemdef = def,
				recipes = {},
				-- buttons_grid related
				item = def.name,
				is_button = true
			}
			duplicate_index_tmp[def.name] = entry
			table.insert(entry.recipes, recipe)
			table.insert(craftable_itemlist, entry)
			if new_preview_item and def.name == new_preview_item then
				new_preview_entry = entry
			end
			if old_preview_item and def.name == old_preview_item then
				old_preview_entry = entry
			end
		end
	end

	-- update crafting preview if the old is not in list anymore
	if new_preview_item then
		if not replace_not_in_list or not old_preview_entry then
			if not new_preview_entry then
				new_preview_entry = {
						itemdef = minetest.registered_items[new_preview_item],
						item = new_preview_item
					}
			end
			state.param.crafting_recipes_preview_selected = 1
			state.param.crafting_recipes_preview_listentry = new_preview_entry
			update_crafting_preview(state)
			if state:get("info_tog"):getId() == 1 then
				state:get("info_tog"):submit()
			end
		end
	elseif replace_not_in_list and not old_preview_entry then
		state.param.crafting_recipes_preview_selected = 1
		state.param.crafting_recipes_preview_listentry = {}
		update_crafting_preview(state)
	end

	-- update the groups selection
	state.param.crafting_grouped_items = ui_tools.get_list_grouped(craftable_itemlist)
	update_group_selection(state, true)
end

-----------------------------------------------------
-- Build list matching the placed grid
-----------------------------------------------------
local function update_from_grid(state, craft_grid, lookup_item)
	-- get all grid items for reference
	local player = state.location.rootState.location.player
	local reference_items = {}
	local items_hash = ""
	for _, stack in ipairs(craft_grid) do
		local name = stack:get_name()
		if name and name ~= "" then
			reference_items[name] = true
			items_hash=items_hash.."|"..name
		else
			items_hash=items_hash.."|empty"
		end
	end

	if items_hash ~= state.param.survival_grid_items_hash then
		state.param.survival_grid_items_hash = items_hash
		if next(reference_items) then
			-- update the grid with matched recipe items
			local recipes = crecipes.get_recipes_started_craft(player, craft_grid, reference_items)
			update_from_recipelist(state, recipes, lookup_item, true)  -- replace_not_in_list=true
		end
	end
end

-----------------------------------------------------
-- Lookup for item lookup_item
-----------------------------------------------------
local function do_lookup_item(state, playername, lookup_item)
	state.param.crafting_items_in_inventory = state.param.invobj:get_items()
	state.param.crafting_items_in_inventory[lookup_item] = true -- prefer in recipe preview
	-- get all craftable recipes with lookup-item as ingredient. Add recipes of lookup item to the list
	local recipes = crecipes.get_revealed_recipes_with_items(playername, {[lookup_item] = true })
	update_from_recipelist(state, recipes, lookup_item)
	state.param.crafting_ui_controller:update_list_variant("lookup", lookup_item)
end

-----------------------------------------------------
-- Lookup inventory
-----------------------------------------------------
local function create_lookup_inv(name)
	local player = minetest.get_player_by_name(name)
	local invname = name.."_crafting_inv"
	local plistname = "crafting_inv_lookup"
	local listname = "lookup"
	local pinv = player:get_inventory()
	local inv = minetest.get_inventory({type="detached", name=invname})
	if not inv then
		inv = minetest.create_detached_inventory(invname, {
			allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
				return 0
			end,
			allow_put = function(inv, listname, index, stack, player)
				if pinv:is_empty(plistname) then
					return 99
				else
					return 0
				end
			end,
			allow_take = function(inv, listname, index, stack, player)
				return 99
			end,
			on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			end,
			on_put = function(inv, listname, index, stack, player)
				pinv:set_stack(plistname, index, stack)
				local name = player:get_player_name()
				local state = smart_inventory.get_page_state("crafting", name)
				do_lookup_item(state, name, stack:get_name())

				-- we are outsite of usual smartfs processing. So trigger the formspec update byself
				state.location.rootState:show()

				-- put back
				minetest.after(1, function(stack)
					local applied = pinv:add_item("main", stack)
					pinv:set_stack(plistname, 1, applied)
					inv:set_stack(listname, 1, applied)
				end, stack)
			end,
			on_take = function(inv, listname, index, stack, player)
				pinv:set_stack(plistname, index, nil)
			end,
		}, name)
	end
	-- copy the item from player:listname inventory to the detached
	inv:set_size(listname, 1)
	pinv:set_size(plistname, 1)
	local stack = pinv:get_stack(plistname, 1)
	inv:set_stack(listname, 1, stack)
end

-----------------------------------------------------
-- Page layout definition
-----------------------------------------------------
local function crafting_callback(state)
	local player = state.location.rootState.location.player

	-- build up UI controller
	local ui_controller = {}
	ui_controller.state = state
	ui_controller.player =  minetest.get_player_by_name(state.location.rootState.location.player)
	state.param.crafting_ui_controller = ui_controller

	function ui_controller:set_ui_variant(new_ui)
		-- check if change needed
		if new_ui == self.toggle1 or new_ui == self.toggle2 then
			return
		end

		-- toggle show/hide elements
		if new_ui == 'list_small' then
			self.toggle1 = new_ui
			self.state:get("craft_img2"):setVisible(true)  --rahmen oben
			self.state:get("lookup_icon"):setPosition(10, 4)
			self.state:get("lookup"):setPosition(10, 4)
			self.state:get("craftable"):setPosition(11, 4)
			self.state:get("btn_all"):setPosition(11, 4.5)
			self.state:get("btn_grid"):setPosition(11.5, 4.0)
			if smart_inventory.doc_items_mod then
				self.state:get("reveal_tipp"):setPosition(11.5, 4.5)
			end
			self.state:get("search"):setPosition(12.3, 4.5)
			self.state:get("search_bg"):setPosition(12, 4)
			self.state:get("info_tog"):setPosition(16, 4.2)

			self.state:get("buttons_grid_Bg"):setPosition(10, 5)
			self.state:get("buttons_grid_Bg"):setSize(8, 4)
			self.state:get("buttons_grid"):reset(10.25, 5.15, 8, 4)

		elseif new_ui == 'list_big' then
			self.toggle1 = new_ui
			self.state:get("craft_img2"):setVisible(false)  --rahmen oben
			self.state:get("lookup_icon"):setPosition(10, 0)
			self.state:get("lookup"):setPosition(10, 0)
			self.state:get("craftable"):setPosition(11, 0)
			self.state:get("btn_all"):setPosition(11, 0.5)
			self.state:get("btn_grid"):setPosition(11.5, 0.0)
			if smart_inventory.doc_items_mod then
				self.state:get("reveal_tipp"):setPosition(11.5, 0.5)
			end
			self.state:get("search"):setPosition(12.3, 0.5)
			self.state:get("search_bg"):setPosition(12, 0)
			self.state:get("info_tog"):setPosition(16, 0.2)

			self.state:get("groups_sel"):setVisible(false)
			self.state:get("inf_area"):setVisible(false)

			self.state:get("buttons_grid_Bg"):setPosition(10, 1)
			self.state:get("buttons_grid_Bg"):setSize(8, 8)
			self.state:get("buttons_grid"):reset(10.25, 1.15, 8, 8)
			self.state:get("info_tog"):setId(3)
		else
			self.toggle2 = new_ui
		end

		if self.toggle1 == 'list_small' then
			if self.toggle2 == 'info' then
				self.state:get("groups_sel"):setVisible(false)
				self.state:get("inf_area"):setVisible(true)
				self.state:get("info_tog"):setId(1)
			elseif self.toggle2 == 'groups' then
				self.state:get("groups_sel"):setVisible(true)
				self.state:get("inf_area"):setVisible(false)
				self.state:get("info_tog"):setId(2)
			end
		end
		self:save()
	end

	function ui_controller:update_list_variant(list_variant, add_info)
		self.add_info = add_info
		-- reset group selection and search field on proposal mode change
		if self.list_variant ~= list_variant then
			self.list_variant = list_variant
			self.state:get("groups_sel"):setSelected(1)
			if list_variant ~= "search" then
				self.state:get("search"):setText("")
			end
		end

		-- auto-switch to the groups
		if list_variant == "lookup" or list_variant == "reveal_tipp" then
			state.param.crafting_ui_controller:set_ui_variant("info")
		else
			state.param.crafting_ui_controller:set_ui_variant("groups")
		end


		state:get("lookup_icon"):setBackground()
		state:get("search_bg"):setBackground()
		state:get("craftable"):setBackground()
		state:get("btn_grid"):setBackground()
		state:get("btn_all"):setBackground()
		if smart_inventory.doc_items_mod then
			state:get("reveal_tipp"):setBackground()
		end
		-- highlight the right button
		if list_variant == "lookup" then
			state:get("lookup_icon"):setBackground("halo.png")
		elseif list_variant == "search" then
			state:get("search_bg"):setBackground("halo.png")
		elseif list_variant == "craftable" then
			state:get("craftable"):setBackground("halo.png")
		elseif list_variant == "grid" then
			state:get("btn_grid"):setBackground("halo.png")
		elseif list_variant == "btn_all" then
		state:get("btn_all"):setBackground("halo.png")
		elseif list_variant == "reveal_tipp" then
			state:get("reveal_tipp"):setBackground("halo.png")
		end
		self:save()
	end

	function ui_controller:save()
		local savedata = minetest.deserialize(self.player:get_attribute("smart_inventory_settings")) or {}
		savedata.survival_list_variant = self.list_variant
		savedata.survival_toggle1 = self.toggle1
		savedata.survival_toggle2 = self.toggle2
		savedata.survival_lookup_item = self.lookup_item
		savedata.survival_add_info = self.add_info
		self.player:set_attribute("smart_inventory_settings", minetest.serialize(savedata))
	end

	function ui_controller:restore()
		local savedata = minetest.deserialize(self.player:get_attribute("smart_inventory_settings")) or {}

		if savedata.survival_toggle1 then
			self:set_ui_variant(savedata.survival_toggle1)
		end
		if savedata.survival_toggle2 then
			self:set_ui_variant(savedata.survival_toggle2)
		end
		if savedata.survival_list_variant then
			if savedata.survival_list_variant == "search" then
				local ui_text = self.state:get(savedata.survival_list_variant)
				ui_text:setText(savedata.survival_add_info)
				ui_text:submit_key_enter("unused", self.state.location.rootState.location.player)
			elseif savedata.survival_list_variant == "lookup" then
				do_lookup_item(self.state, self.state.location.rootState.location.player, savedata.survival_add_info)
			else
				local ui_button = self.state:get(savedata.survival_list_variant)
				if ui_button then
					ui_button:submit("unused", self.state.location.rootState.location.player)
				end
			end
		else
			self.state:get("craftable"):submit("unused", self.state.location.rootState.location.player)
			self:set_ui_variant("groups")
			self:update_list_variant("craftable")
		end
	end

	-- set inventory style
	state:element("code", {name = "inventory_bg_code", code = "listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"})

	--Inventorys / left site
	state:inventory(1, 5, 8, 4,"main")
	state:inventory(1.2, 0.2, 3, 3,"craft")
	state:inventory(4.3, 1.2, 1, 1,"craftpreview")
	state:background(1, 0, 4.5, 3.5, "img1", "menu_bg.png")


	-- crafting helper buttons
	local btn_ac1 = state:image_button(4.4, 0.3, 0.8, 0.8, "ac1", "", "smart_inventory_preview_to_crafting_field.png")
	btn_ac1:onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "crafting", "ac1")
		local grid = state:get("craft_preview"):getCraft()
		state.param.invobj:craft_item(grid)
	end)
	btn_ac1:setVisible(false)

	-- swap slots buttons
	state:image_button(0, 6, 1, 1, "swap1", "", "smart_inventory_swapline_button.png"):onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "crafting", "swap1")
		state.param.invobj:swap_row_to_top(2)
	end)
	state:image_button(0, 7, 1, 1, "swap2", "", "smart_inventory_swapline_button.png"):onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "crafting", "swap2")
		state.param.invobj:swap_row_to_top(3)
	end)
	state:image_button(0, 8, 1, 1, "swap3", "", "smart_inventory_swapline_button.png"):onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "crafting", "swap3")
		state.param.invobj:swap_row_to_top(4)
	end)

	ui_tools.create_trash_inv(state, player)
	state:image(8,9,1,1,"trash_icon","smart_inventory_trash.png")
	state:inventory(8, 9, 1, 1, "trash"):useDetached(player.."_trash_inv")

	local btn_compress = state:image_button(1, 3.8, 1, 1, "compress", "","smart_inventory_compress_button.png")
	btn_compress:setTooltip("Merge stacks with same items to get free place")
	btn_compress:onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "crafting", "compress")
		state.param.invobj:compress()
	end)

	local btn_sweep = state:image_button(2, 3.8, 1, 1, "clear", "", "smart_inventory_sweep_button.png")
	btn_sweep:setTooltip("Move all items from crafting grid back to inventory")
	btn_sweep:onClick(function(self, state, player)
		ui_tools.image_button_feedback(player, "crafting", "clear")
		state.param.invobj:sweep_crafting_inventory()
	end)

	-- recipe preview area
	smart_inventory.smartfs_elements.craft_preview(state, 6, 0, "craft_preview"):onButtonClicked(function(self, item, player)
		do_lookup_item(state, player, item)
	end)
	state:image(7,2.8,1,1,"cr_type_img",""):setVisible(false)
	state:label(7,3,"cr_type", "")
	local pr_prev_btn = state:button(6, 3, 1, 0.5, "preview_prev", "<<")
	pr_prev_btn:onClick(function(self, state, player)
		state.param.crafting_recipes_preview_selected = state.param.crafting_recipes_preview_selected -1
		update_crafting_preview(state)
	end)
	pr_prev_btn:setVisible(false)
	local pr_next_btn = state:button(8, 3, 1, 0.5, "preview_next", ">>")
	pr_next_btn:onClick(function(self, state, player)
		state.param.crafting_recipes_preview_selected = state.param.crafting_recipes_preview_selected +1
		update_crafting_preview(state)
	end)
	pr_next_btn:setVisible(false)

	-- (dynamic-1) group selection
	local group_sel = state:listbox(10.2, 0.15, 7.6, 3.6, "groups_sel",nil, true)
	group_sel:onClick(function(self, state, player)
		local selected = self:getSelectedItem()
		if selected then
			update_group_selection(state, false)
		end
	end)

	-- (dynamic-2) item preview area
	state:background(10.0, 0.1, 8, 3.8, "craft_img2", "minimap_overlay_square.png")
	local inf_area = state:view(6.4, 0.1, "inf_area")
	local inf_state = inf_area:getContainerState()
	inf_state:label(11.5,0.5,"info1", "")
	inf_state:label(11.5,1.0,"info2", "")
	inf_state:label(11.5,1.5,"info3", "")
	inf_state:item_image(10.2,0.3, 1, 1, "craft_result",nil):setVisible(false)
	if smart_inventory.doc_items_mod then
		local doc_btn = inf_state:image_button(10.4,2.3, 0.7, 0.7, "doc_btn","", "doc_button_icon_lores.png")
		doc_btn:setTooltip("Show documentation for revealed item")
		doc_btn:setVisible(false)
		doc_btn:onClick(function(self, state, player)
			local outitem = state:get("craft_result"):getImage()
			if outitem then
				for z in outitem:gmatch("[^%s]+") do
					if minetest.registered_items[z] then
						doc_addon.show(z, player)
					end
					break
				end
			end
		end)
	end
	inf_state:label(10.3, 3.25, "groups_label", "All")

	inf_state:listbox(12, 2, 5.7, 1.3, "item_groups",nil, true)
	inf_area:setVisible(false)

	-- Lookup
	create_lookup_inv(player)
	state:image(10, 4, 1, 1,"lookup_icon", "smart_inventory_lookup_field.png")
	local inv_lookup = state:inventory(10, 4.0, 1, 1,"lookup"):useDetached(player.."_crafting_inv")


	-- Get craftable by items in inventory
	local btn_craftable = state:image_button(11, 4, 0.5, 0.5, "craftable", "", "smart_inventory_craftable_button.png")
	btn_craftable:setTooltip("Show items crafteable by items in inventory")
	btn_craftable:onClick(function(self, state, player)
		state.param.crafting_items_in_inventory = state.param.invobj:get_items()
		local craftable = crecipes.get_recipes_craftable(player, state.param.crafting_items_in_inventory)
		update_from_recipelist(state, craftable)
		ui_controller:update_list_variant("craftable")
	end)

	local grid_btn = state:image_button(11.5, 4, 0.5, 0.5, "btn_grid", "", "smart_inventory_craftable_button.png")
	grid_btn:setTooltip("Search for recipes matching the grid")
	grid_btn:onClick(function(self, state, player)
		local player = state.location.rootState.location.player
		state.param.crafting_ui_controller:update_list_variant("grid")
		local craft_grid = state.param.invobj.inventory:get_list("craft")
		local ret_item = state.param.invobj.inventory:get_list("craftpreview")[1]
		update_from_grid(state, craft_grid, ret_item:get_name())
	end)

	-- Get craftable by items in inventory
	local btn_all = state:image_button(11, 4.5, 0.5, 0.5, "btn_all", "", "smart_inventory_creative_button.png")
	if smart_inventory.doc_items_mod then
		btn_all:setTooltip("Show all already revealed items")
	else
		btn_all:setTooltip("Show all items")
	end
	btn_all:onClick(function(self, state, player)
		local all_revealed = ui_tools.filter_by_revealed(ui_tools.root_list_all, player, true)
		state.param.crafting_recipes_preview_selected = 1
		state.param.crafting_recipes_preview_listentry = all_revealed[1] or {}
		update_crafting_preview(state)
		state.param.crafting_grouped_items = ui_tools.get_list_grouped(all_revealed)

		update_group_selection(state, true)
		ui_controller:update_list_variant("btn_all")
	end)

	-- Reveal tipps button
	if smart_inventory.doc_items_mod then
		local reveal_button = state:image_button(11.5, 4.5, 0.5, 0.5, "reveal_tipp", "", "smart_inventory_reveal_tips_button.png")
		reveal_button:setTooltip("Show proposal what should be crafted to reveal more items")
		reveal_button:onClick(function(self, state, player)
			local all_revealed = ui_tools.filter_by_revealed(ui_tools.root_list_all, player)
			local top_revealed = ui_tools.filter_by_top_reveal(all_revealed, player)
			state.param.crafting_recipes_preview_selected = 1
			state.param.crafting_recipes_preview_listentry = top_revealed[1] or {}
			update_crafting_preview(state)
			state.param.crafting_grouped_items = ui_tools.get_list_grouped(top_revealed)

			update_group_selection(state, true)
			ui_controller:update_list_variant("reveal_tipp")
		end)
	end

	-- search
	state:background(12, 4, 4, 0.9, "search_bg", nil) --field background not usable
	local searchfield = state:field(12.3, 4.5, 4, 0.5, "search")
	searchfield:setCloseOnEnter(false)
	searchfield:onKeyEnter(function(self, state, player)
		local search_string = self:getText()
		if string.len(search_string) < 3 then
			return
		end

		local filtered_list = ui_tools.filter_by_searchstring(ui_tools.root_list_all, search_string)
		filtered_list = ui_tools.filter_by_revealed(filtered_list, player)
		state.param.crafting_grouped_items = ui_tools.get_list_grouped(filtered_list)
		update_group_selection(state, true)
		ui_controller:update_list_variant("search", search_string)
	end)

	-- groups toggle
	local info_tog = state:toggle(16,4.2,2,0.5, "info_tog", {"Info", "Groups", "Hide"})
	info_tog:onToggle(function(self, state, player)
		local id = self:getId()
		if id == 1 then
			state.param.crafting_ui_controller:set_ui_variant("list_small")
			state.param.crafting_ui_controller:set_ui_variant("info")
		elseif id == 2 then
			state.param.crafting_ui_controller:set_ui_variant("list_small")
			state.param.crafting_ui_controller:set_ui_variant("groups")
		elseif id == 3 then
			state.param.crafting_ui_controller:set_ui_variant("list_big")
		end
	end)

	-- craftable items grid
	state:background(10, 5, 8, 4, "buttons_grid_Bg", "minimap_overlay_square.png")
	local grid = smart_inventory.smartfs_elements.buttons_grid(state, 10.25, 5.15, 8 , 4, "buttons_grid", 0.75,0.75)
	grid:onClick(function(self, state, index, player)
		local listentry = state.param.crafting_craftable_list[index]
		if ui_controller.list_variant == "lookup" then
			do_lookup_item(state, state.location.rootState.location.player, listentry.item)
		else
			state.param.crafting_recipes_preview_selected = 1
			state.param.crafting_recipes_preview_listentry = listentry
			update_crafting_preview(state)
		end
		state.param.crafting_ui_controller:set_ui_variant("info")
	end)

	ui_controller:restore()
end

-----------------------------------------------------
-- Register page in smart_inventory
-----------------------------------------------------
smart_inventory.register_page({
	name = "crafting",
	tooltip = "Craft new items",
	icon = "smart_inventory_crafting_inventory_button.png",
	smartfs_callback = crafting_callback,
	sequence = 10
})

-----------------------------------------------------
-- Use lookup for predict item
-----------------------------------------------------
minetest.register_craft_predict(function(stack, player, old_craft_grid, craft_inv)
	local name = player:get_player_name()
	local state = smart_inventory.get_page_state("crafting", name)
	if not state then
		return
	end

	if state.param.crafting_ui_controller.list_variant ~= 'grid' then
		return
	end
	update_from_grid(state, old_craft_grid, stack:get_name())
	state.location.rootState:show()
end)

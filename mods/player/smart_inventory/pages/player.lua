smart_inventory.skins_mod = minetest.get_modpath("skinsdb")
smart_inventory.armor_mod = minetest.get_modpath("3d_armor")

if not smart_inventory.skins_mod and not smart_inventory.armor_mod then
	return
end

local filter = smart_inventory.filter
local cache = smart_inventory.cache
local ui_tools = smart_inventory.ui_tools
local txt = smart_inventory.txt
local creative = minetest.setting_getbool("creative_mode")

local function update_grid(state, listname)
-- Update the users inventory grid
	local list = {}
	state.param["armor_"..listname.."_list"] = list
	local name = state.location.rootState.location.player

	local inventory
	if listname == "armor" then
		inventory = minetest.get_inventory({type="detached", name=name.."_armor"})
	else
		inventory = minetest.get_player_by_name(name):get_inventory()
	end
	if not inventory then  --timing issue. The list is not created
		return
	end
	local invlist = inventory:get_list(listname)

	local list_dedup = {}
	for stack_index, stack in ipairs(invlist) do
		local itemdef = stack:get_definition()
		local is_armor = false
		if itemdef then
			cache.add_item(itemdef) -- analyze groups in case of hidden armor
			if cache.citems[itemdef.name].cgroups["armor"] then
				local entry = table.copy(cache.citems[itemdef.name].ui_item)
				entry.stack_index = stack_index
				local wear = stack:get_wear()
				if wear > 0 then
					entry.text = tostring(math.floor((1 - wear / 65535) * 100 + 0.5)).." %"
				end
				table.insert(list, entry)
				list_dedup[itemdef.name] = itemdef
			end
		end
	end

	-- add all usable in creative available armor to the main list
	if listname == "main" and creative == true then
		for _, itemdef in pairs(cache.cgroups["armor"].items) do
			if not list_dedup[itemdef.name] and not itemdef.groups.not_in_creative_inventory then
				list_dedup[itemdef.name] = itemdef
				table.insert(list, cache.citems[itemdef.name].ui_item)
			end
		end
	end

	table.sort(list, function(a,b)
		return a.sort_value < b.sort_value
	end)
	local grid = state:get(listname.."_grid")
	grid:setList(list)
end

local function update_selected_item(state, listentry)
	local name = state.location.rootState.location.player
	state.param.armor_selected_item = listentry or state.param.armor_selected_item
	listentry = state.param.armor_selected_item
	if not listentry then
		return
	end
	local i_list = state:get("i_list")
	i_list:clearItems()
	for _, groupdef in ipairs(ui_tools.get_tight_groups(cache.citems[listentry.itemdef.name].cgroups)) do
		i_list:addItem(groupdef.group_desc)
	end
	state:get("item_name"):setText(listentry.itemdef.description)
	state:get("item_image"):setImage(listentry.item)
end

local function update_page(state)
	local name = state.location.rootState.location.player
	local player_obj = minetest.get_player_by_name(name)
	local skin_obj
	if smart_inventory.skins_mod then
		skin_obj = skins.get_player_skin(player_obj)
	end
	if smart_inventory.armor_mod then
		update_grid(state, "main")
		update_grid(state, "armor")
		state:get("preview"):setImage(armor.textures[name].preview)
		state.location.parentState:get("player_button"):setImage(armor.textures[name].preview)
		local a_list = state:get("a_list")
		a_list:clearItems()
		for k, v in pairs(armor.def[name]) do
			local grouptext
			if k == "groups" then
				for gn, gv in pairs(v) do
					if txt and txt["armor:"..gn] then
						grouptext = txt["armor:"..gn]
					else
						grouptext = "armor:"..gn
					end
					if grouptext and gv ~= 0 then
						a_list:addItem(grouptext..": "..gv)
					end
				end
			else
				local is_physics = false
				for _, group in ipairs(armor.physics) do
					if group == k then
						is_physics = true
						break
					end
				end
				if is_physics then
					if txt and txt["physics:"..k] then
						grouptext = txt["physics:"..k]
					else
						grouptext = "physics:"..k
					end
					if grouptext and v ~= 1 then
						a_list:addItem(grouptext..": "..v)
					end
				else
					if txt and txt["armor:"..k] then
						grouptext = txt["armor:"..k]
					else
						grouptext = "armor:"..k
					end
					if grouptext and v ~= 0 then
						if k == "state" then
							a_list:addItem(grouptext..": "..tostring(math.floor((1 - v / armor.def[name].count / 65535) * 100 + 0.5)).." %")
						else
							a_list:addItem(grouptext..": "..v)
						end
					end
				end
			end
		end
		update_selected_item(state)
	elseif skin_obj then
		local skin_preview = skin_obj:get_preview()
		state.location.parentState:get("player_button"):setImage(skin_preview)
		state:get("preview"):setImage(skin_preview)
	end
	if skin_obj then
		local m_name = skin_obj:get_meta_string("name")
		local m_author = skin_obj:get_meta_string("author")
		local m_license = skin_obj:get_meta_string("license")
		if m_name then
			state:get("skinname"):setText("Skin name: "..(skin_obj:get_meta_string("name")))
		else
			state:get("skinname"):setText("")
		end
		if m_author then
			state:get("skinauthor"):setText("Author: "..(skin_obj:get_meta_string("author")))
		else
			state:get("skinauthor"):setText("")
		end
		if m_license then
			state:get("skinlicense"):setText("License: "..(skin_obj:get_meta_string("license")))
		else
			state:get("skinlicense"):setText("")
		end

		-- set the skins list
		state.param.skins_list = skins.get_skinlist_for_player(name)
		local cur_skin = skins.get_player_skin(player_obj)
		local skins_grid_data = {}
		local grid_skins = state:get("skins_grid")
		for idx, skin in ipairs(state.param.skins_list) do
			table.insert(skins_grid_data, {
					image = skin:get_preview(),
					tooltip = skin:get_meta_string("name"),
					is_button = true,
					size = { w = 0.87, h = 1.30 }
			})
			if not state.param.skins_initial_page_adjusted and skin:get_key() == cur_skin:get_key() then
				grid_skins:setFirstVisible(idx - 19) --8x5 (grid size) / 2 -1
				state.param.skins_initial_page_adjusted = true
			end
		end
		grid_skins:setList(skins_grid_data)
	end
end

local function move_item_to_armor(state, item)
	local name = state.location.rootState.location.player
	local player = minetest.get_player_by_name(name)
	local inventory = player:get_inventory()
	local armor_inv = minetest.get_inventory({type="detached", name=name.."_armor"})

	-- get item to be moved to armor inventory
	local itemstack, itemname, itemdef
	if creative == true then
		itemstack = ItemStack(item.item)
		itemname = item.item
	else
		itemstack = inventory:get_stack("main", item.stack_index)
		itemname = itemstack:get_name()
	end
	itemdef = minetest.registered_items[itemname]
	local new_groups = {}
	for _, element in ipairs(armor.elements) do
		if itemdef.groups["armor_"..element] then
			new_groups["armor_"..element] = true
		end
	end

	-- remove all items with the same group
	local removed_items = {}
	for stack_index, stack in ipairs(armor_inv:get_list("armor")) do
		local old_def = stack:get_definition()
		if old_def then
			for groupname, groupdef in pairs(old_def.groups) do
				if new_groups[groupname] then
					table.insert(removed_items, stack)
					armor_inv:set_stack("armor", stack_index, {}) --take old
					minetest.detached_inventories[name.."_armor"].on_take(armor_inv, "armor", stack_index, stack, player)
					if armor_inv:set_stack("armor", stack_index, itemstack) then --put new
						minetest.detached_inventories[name.."_armor"].on_put(armor_inv, "armor", stack_index, itemstack, player)
						itemstack = ItemStack("")
					end
				end
			end
		end
		if stack:is_empty() and not itemstack:is_empty() then
			if armor_inv:set_stack("armor", stack_index, itemstack) then
				minetest.detached_inventories[name.."_armor"].on_put(armor_inv, "armor", stack_index, itemstack, player)
				itemstack = ItemStack("")
			end
		end
	end

	-- handle put backs in non-creative to not lost items
	if creative == false then
		inventory:set_stack("main", item.stack_index, itemstack)
		for _, stack in ipairs(removed_items) do
			stack = inventory:add_item("main", stack)
			if not stack:is_empty() then
				armor_inv:add_item("armor", stack)
			end
		end
	end
end

local function move_item_to_inv(state, item)
	local name = state.location.rootState.location.player
	local player = minetest.get_player_by_name(name)
	local inventory = player:get_inventory()
	local armor_inv = minetest.get_inventory({type="detached", name=name.."_armor"})
	if creative == true then
		armor_inv:set_stack("armor", item.stack_index, {})
	else
		local itemstack = armor_inv:get_stack("armor", item.stack_index)
		itemstack = inventory:add_item("main", itemstack)
		armor_inv:set_stack("armor", item.stack_index, itemstack)
	end
	minetest.detached_inventories[name.."_armor"].on_take(armor_inv, "armor", item.stack_index, itemstack, player)
end

local function player_callback(state)
	local name = state.location.rootState.location.player
	state:background(0, 1.2, 6, 6.6, "it_bg", "smart_inventory_background_border.png")
	state:item_image(0.8, 1.5,2,2,"item_image","")
	state:label(2.5,1.2,"item_name", "")
	state:listbox(0.8,3.3,5.1,4,"i_list", nil, true)

	state:background(6.2, 1.2, 6, 6.6, "pl_bg", "smart_inventory_background_border.png")
	state:image(6.7,1.7,2,4,"preview","")
	state:listbox(8.6,1.7,3.5,3,"a_list", nil, true)
	state:label(6.7,5.5,"skinname","")
	state:label(6.7,6.0,"skinauthor", "")
	state:label(6.7,6.5, "skinlicense", "")

	state:background(0, 0, 20, 1, "top_bg", "halo.png")
	state:background(0, 8, 20, 2, "bottom_bg", "halo.png")
	if smart_inventory.armor_mod then
		local grid_armor = smart_inventory.smartfs_elements.buttons_grid(state, 0, 0, 8, 1, "armor_grid")

		grid_armor:onClick(function(self, state, index, player)
			if state.param.armor_armor_list[index] then
				update_selected_item(state, state.param.armor_armor_list[index])
				move_item_to_inv(state, state.param.armor_armor_list[index])
				update_page(state)
			end
		end)

		local grid_main = smart_inventory.smartfs_elements.buttons_grid(state, 0, 8, 20, 2, "main_grid")
		grid_main:onClick(function(self, state, index, player)
			update_selected_item(state, state.param.armor_main_list[index])
			move_item_to_armor(state, state.param.armor_main_list[index])
			update_page(state)
		end)
	end

	if smart_inventory.skins_mod then
		local player_obj = minetest.get_player_by_name(name)
		-- Skins Grid
		local grid_skins = smart_inventory.smartfs_elements.buttons_grid(state, 12.9, 1.5, 7 , 7, "skins_grid", 0.80, 1.20)
		state:background(12.4, 1.2, 7.5 , 6.6, "bg_skins", "smart_inventory_background_border.png")
		grid_skins:onClick(function(self, state, index, player)
			local cur_skin = state.param.skins_list[index]
			if state.location.rootState.location.type ~= "inventory" and cur_skin._key:sub(1,17) == "character_creator" then
				state.location.rootState.obsolete = true  -- other screen appears, obsolete the inventory session
			end
			skins.set_player_skin(player_obj, cur_skin)
			if smart_inventory.armor_mod then
				armor.textures[name].skin = cur_skin:get_texture()
				armor:set_player_armor(player_obj)
			end
			update_page(state)
		end)
	end

	-- not visible update plugin for updates from outsite (API)
	state:element("code", { name = "update_hook" }):onSubmit(function(self, state)
		update_page(state)
		state.location.rootState:show()
	end)

	update_page(state)
end

smart_inventory.register_page({
	name = "player",
	icon = "player.png",
	tooltip = "Customize yourself",
	smartfs_callback = player_callback,
	sequence = 20,
	on_button_click = update_page
})

-- register callback in 3d_armor for updates
if smart_inventory.armor_mod and armor.register_on_update then

	local function submit_update_hook(player)
		local name = player:get_player_name()
		local state = smart_inventory.get_page_state("player", name)
		if state then
			state:get("update_hook"):submit()
		end
	end

	armor:register_on_update(submit_update_hook)

	-- There is no callback in 3d_armor for wear change in on_hpchange implementation
	minetest.register_on_player_hpchange(function(player, hp_change)
		minetest.after(0, submit_update_hook, player)
	end)
end

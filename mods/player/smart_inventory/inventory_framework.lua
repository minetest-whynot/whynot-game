local smartfs = smart_inventory.smartfs
local maininv = smart_inventory.maininv
local modpath = smart_inventory.modpath

-- smartfs callback
local inventory_form = smartfs.create("smart_inventory:main", function(state)

	-- enhanced object to the main inventory functions
	state.param.invobj = maininv.get(state.location.player)
	-- tabbed view controller
	local tab_controller = {
		_tabs = {},
		active_name = nil,
		set_active = function(self, tabname)
			for name, def in pairs(self._tabs) do
				if name == tabname then
					def.button:setBackground("halo.png")
					def.view:setVisible(true)
				else
					def.button:setBackground(nil)
					def.view:setVisible(false)
				end
			end
			self.active_name = tabname
		end,
		tab_add = function(self, name, def)
			def.viewstate:size(20,10) --size of tab view
			self._tabs[name] = def
		end,
		get_active_name = function(self)
			return self.active_name
		end,
	}

	--set screen size
	state:size(20,12)
	state:label(1,0.2,"header","Smart Inventory")
	state:image(0,0,1,1,"header_logo", "logo.png")
	state:image_button(19,0,1,1,"exit", "","smart_inventory_exit_button.png", true):setTooltip("Close the inventory")
	local button_x = 0.1
	table.sort(smart_inventory.registered_pages, function(a,b)
		if not a.sequence then
			return false
		elseif not b.sequence then
			return true
		elseif a.sequence > b.sequence then
			return false
		else
			return true
		end
	end)
	for _, def in ipairs(smart_inventory.registered_pages) do
		assert(def.smartfs_callback, "Callback function needed")
		assert(def.name, "Name is needed")
		local tabdef = {}
		local label
		if not def.label then
			label = ""
		else
			label = def.label
		end
		tabdef.button = state:button(button_x,11.2,1,1,def.name.."_button",label)
		if def.icon then
			tabdef.button:setImage(def.icon)
		end
		tabdef.button:setTooltip(def.tooltip)
		tabdef.button:onClick(function(self)
			tab_controller:set_active(def.name)
			if def.on_button_click then
				def.on_button_click(tabdef.viewstate)
			end
		end)
		tabdef.view = state:container(0,1,def.name.."_container")
		tabdef.viewstate = tabdef.view:getContainerState()
		def.smartfs_callback(tabdef.viewstate)
		tab_controller:tab_add(def.name, tabdef)
		button_x = button_x + 1
	end
	tab_controller:set_active(smart_inventory.registered_pages[1].name)
end)

if minetest.settings:get_bool("smart_inventory_workbench_mode") then
	dofile(modpath.."/workbench.lua")
	smart_inventory.get_player_state = function(playername)
		-- check the inventory is shown
		local state = smartfs.opened[playername]
		if state and (not state.obsolete) and
				state.location.type == "player" and
				state.def.name == "smart_inventory:main" then
			return state
		end
	end
else
	smartfs.set_player_inventory(inventory_form)
	smart_inventory.get_player_state = function(playername)
		return smartfs.inv[playername]
	end
end

-- pages list
smart_inventory.registered_pages = {}

-- add new page
function smart_inventory.register_page(def)
	table.insert(smart_inventory.registered_pages, def)
end

-- smart_inventory.get_player_state(playername) defined above

-- get state of active page
function smart_inventory.get_page_state(pagename, playername)
	local rootstate = smart_inventory.get_player_state(playername)
	if not rootstate then
		return
	end
	local view = rootstate:get(pagename.."_container")
	if not view then
		return
	end
	return view:getContainerState()
end

-- get definition of registered page
function smart_inventory.get_registered_page(pagename)
	for _, registred_page in ipairs(smart_inventory.registered_pages) do
		if registred_page.name == pagename then
			return registred_page
		end
	end
end

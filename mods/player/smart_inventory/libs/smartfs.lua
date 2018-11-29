---------------------------
-- SmartFS: Smart Formspecs
-- License: CC0 or WTFPL
--    by Rubenwardy
---------------------------

local smartfs = {
	_fdef = {},
	_edef = {},
	_ldef = {},
	opened = {},
	inv = {}
}

local function boolToStr(v)
	return v and "true" or "false"
end

-- the smartfs() function
function smartfs.__call(self, name)
	return smartfs.get(name)
end

function smartfs.get(name)
	return smartfs._fdef[name]
end

------------------------------------------------------
-- Smartfs Interface -  Creates a new form and adds elements to it by running the function. Use before Minetest loads. (like minetest.register_node)
------------------------------------------------------
-- Register forms and elements
function smartfs.create(name, onload)
	assert(not smartfs._fdef[name],
			"SmartFS - (Error) Form "..name.." already exists!")
	assert(not smartfs.loaded or smartfs._loaded_override,
			"SmartFS - (Error) Forms should be declared while the game loads.")

	smartfs._fdef[name] = {
		form_setup_callback = onload,
		name = name,
		show = smartfs._show_,
		attach_to_node = smartfs._attach_to_node_
	}

	return smartfs._fdef[name]
end

------------------------------------------------------
-- Smartfs Interface - Creates a new element type
------------------------------------------------------
function smartfs.element(name, data)
	assert(not smartfs._edef[name],
			"SmartFS - (Error) Element type "..name.." already exists!")

	assert(data.onCreate, "element requires onCreate method")
	smartfs._edef[name] = data
	return smartfs._edef[name]
end

------------------------------------------------------
-- Smartfs Interface - Creates a dynamic form. Returns state
------------------------------------------------------
function smartfs.dynamic(name,player)
	if not smartfs._dynamic_warned then
		smartfs._dynamic_warned = true
		minetest.log("warning", "SmartFS - (Warning) On the fly forms are being used. May cause bad things to happen")
	end
	local statelocation = smartfs._ldef.player._make_state_location_(player)
	local state = smartfs._makeState_({name=name}, nil, statelocation, player)
	smartfs.opened[player] = state
	return state
end

------------------------------------------------------
-- Smartfs Interface - Returns the name of an installed and supported inventory mod that will be used above, or nil
------------------------------------------------------
function smartfs.inventory_mod()
	if minetest.global_exists("unified_inventory") then
		return "unified_inventory"
	elseif minetest.global_exists("inventory_plus") then
		return "inventory_plus"
	elseif minetest.global_exists("sfinv") then
		return "sfinv"
	else
		return nil
	end
end

------------------------------------------------------
-- Smartfs Interface - Adds a form to an installed advanced inventory. Returns true on success.
------------------------------------------------------
function smartfs.add_to_inventory(form, icon, title)
	local ldef
	local invmod = smartfs.inventory_mod()
	if  invmod then
		ldef = smartfs._ldef[invmod]
	else
		return false
	end
	return ldef.add_to_inventory(form, icon, title)
end

------------------------------------------------------
-- Smartfs Interface - Set the form as players inventory
------------------------------------------------------
function smartfs.set_player_inventory(form)
	smartfs._ldef.inventory.set_inventory(form)
end
------------------------------------------------------
-- Smartfs Interface - Allows you to use smartfs.create after the game loads. Not recommended!
------------------------------------------------------
function smartfs.override_load_checks()
	smartfs._loaded_override = true
end

------------------------------------------------------
-- Smartfs formspec locations
------------------------------------------------------
-- Unified inventory plugin
smartfs._ldef.unified_inventory = {
	add_to_inventory = function(form, icon, title)
		unified_inventory.register_button(form.name, {
			type = "image",
			image = icon,
		})
		unified_inventory.register_page(form.name, {
			get_formspec = function(player, formspec)
				local name = player:get_player_name()
				local state
				if smartfs.inv[name] and smartfs.inv[name].def.name == form.name then
					state = smartfs.inv[name]
				else
					local statelocation = smartfs._ldef.unified_inventory._make_state_location_(name)
					state = smartfs._makeState_(form, nil, statelocation, name)
					if form.form_setup_callback(state) ~= false then
						smartfs.inv[name] = state
					else
						smartfs.inv[name] = nil
						return ""
					end
				end
				return {formspec = state:_buildFormspec_(false)}
			end
		})
	end,
	_make_state_location_ = function(player)
		return {
			type = "inventory",
			player = player,
			_show_ = function(state)
				unified_inventory.set_inventory_formspec(minetest.get_player_by_name(state.location.player), state.def.name)
			end
		}
	end
}

-- Inventory plus plugin
smartfs._ldef.inventory_plus = {
	add_to_inventory = function(form, icon, title)
		minetest.register_on_joinplayer(function(player)
			inventory_plus.register_button(player, form.name, title)
		end)
		minetest.register_on_player_receive_fields(function(player, formname, fields)
			if formname == "" and fields[form.name] then
				local name = player:get_player_name()
				local statelocation = smartfs._ldef.inventory_plus._make_state_location_(name)
				local state = smartfs._makeState_(form, nil, statelocation, name)
				if form.form_setup_callback(state) ~= false then
					smartfs.inv[name] = state
					state:show()
				end
			end
		end)
	end,
	_make_state_location_ = function(player)
		return {
			type = "inventory",
			player = player,
			_show_ = function(state)
				inventory_plus.set_inventory_formspec(minetest.get_player_by_name(state.location.player), state:_buildFormspec_(true))
			end
		}
	end
}

-- Sfinv plugin
smartfs._ldef.sfinv = {
	add_to_inventory = function(form, icon, title)
		sfinv.register_page(form.name, {
			title = title,
			get = function(self, player, context)
				local name = player:get_player_name()
				local state
				if smartfs.inv[name] then
					state = smartfs.inv[name]
				else
					local statelocation = smartfs._ldef.sfinv._make_state_location_(name)
					state = smartfs._makeState_(form, nil, statelocation, name)
					smartfs.inv[name] = state
					if form.form_setup_callback(state) ~= false then
						smartfs.inv[name] = state
					else
						return ""
					end
				end
				local fs = state:_buildFormspec_(false)
				return sfinv.make_formspec(player, context, fs, true)
			end,
			on_player_receive_fields = function(self, player, _, fields)
				local name = player:get_player_name()
				if smartfs.inv[name] then
					smartfs.inv[name]:_sfs_on_receive_fields_(name, fields)
				end
			end,
			on_leave = function(self, player)
				local name = player:get_player_name()
				if smartfs.inv[name] then
					smartfs.inv[name].players:disconnect(name)
					smartfs.inv[name] = nil
				end
			end,
		})
	end,
	_make_state_location_ = function(player)
		return {
			type = "inventory",
			inventory_handles_fields = true,
			player = player,
			_show_ = function(state)
				sfinv.set_player_inventory_formspec(minetest.get_player_by_name(state.location.player))
			end,
		}
	end
}

-- Show to player
smartfs._ldef.player = {
	_make_state_location_ = function(player)
		return {
			type = "player",
			player = player,
			_show_ = function(state)
				if not state._show_queued then
					state._show_queued = true
					minetest.after(0, function(state)
						if state then
							state._show_queued = nil
							if (not state.closed) and (not state.obsolete) then
								minetest.show_formspec(state.location.player, state.def.name, state:_buildFormspec_(true))
							end
						end
					end, state) -- state given as reference. Maybe additional updates are done in the meantime or the form is obsolete
				end
			end
		}
	end
}

-- Standalone inventory
smartfs._ldef.inventory = {
	set_inventory = function(form)
		if sfinv and sfinv.enabled then
			sfinv.enabled = nil
		end
		minetest.register_on_joinplayer(function(player)
			local name = player:get_player_name()
			local statelocation = smartfs._ldef.inventory._make_state_location_(name)
			local state = smartfs._makeState_(form, nil, statelocation, name)
			if form.form_setup_callback(state) ~= false then
				smartfs.inv[name] = state
				state:show()
			end
		end)
		minetest.register_on_leaveplayer(function(player)
			local name = player:get_player_name()
			smartfs.inv[name].obsolete = true
			smartfs.inv[name] = nil
		end)
	end,
	_make_state_location_ = function(name)
		return {
			type = "inventory",
			player = name,
			_show_ = function(state)
				if not state._show_queued then
					state._show_queued = true
					minetest.after(0, function(state)
						if state then
							state._show_queued = nil
							local player = minetest.get_player_by_name(state.location.player)
							--print("smartfs formspec:", state:_buildFormspec_(true))
							player:set_inventory_formspec(state:_buildFormspec_(true))
						end
					end, state)
				end
			end
		}
	end
}

-- Node metadata
smartfs._ldef.nodemeta = {
	_make_state_location_ = function(nodepos)
		return {
			type = "nodemeta",
			pos = nodepos,
			_show_ = function(state)
				if not state._show_queued then
					state._show_queued = true
					minetest.after(0, function(state)
						if state then
							state._show_queued = nil
							local meta = minetest.get_meta(state.location.pos)
							meta:set_string("formspec", state:_buildFormspec_(true))
							meta:set_string("smartfs_name", state.def.name)
							meta:mark_as_private("smartfs_name")
						end
					end, state)
				end
			end,
		}
	end
}

-- Sub-container (internally used)
smartfs._ldef.container = {
	_make_state_location_ = function(element)
		local self = {
			type = "container",
			containerElement = element,
			parentState = element.root
		}
		if self.parentState.location.type == "container" then
			self.rootState = self.parentState.location.rootState
		else
			self.rootState = self.parentState
		end
		return self
	end
}

------------------------------------------------------
-- Minetest Interface - on_receive_fields callback can be used in minetest.register_node for nodemeta forms
------------------------------------------------------
function smartfs.nodemeta_on_receive_fields(nodepos, formname, fields, sender, params)
	local meta = minetest.get_meta(nodepos)
	local nodeform = meta:get_string("smartfs_name")
	if not nodeform then
		print("SmartFS - (Warning) smartfs.nodemeta_on_receive_fields for node without smarfs data")
		return false
	end

	-- get the currentsmartfs state
	local opened_id = minetest.pos_to_string(nodepos)
	local state
	local form = smartfs.get(nodeform)
	if not smartfs.opened[opened_id] or      -- If opened first time
			smartfs.opened[opened_id].def.name ~= nodeform or -- Or form is changed
			smartfs.opened[opened_id].obsolete then
		local statelocation = smartfs._ldef.nodemeta._make_state_location_(nodepos)
		state = smartfs._makeState_(form, params, statelocation)
		if smartfs.opened[opened_id] then
			smartfs.opened[opened_id].obsolete = true
		end
		smartfs.opened[opened_id] = state
		form.form_setup_callback(state)
	else
		state = smartfs.opened[opened_id]
	end

	-- Set current sender check for multiple users on node
	local name
	if sender then
		name = sender:get_player_name()
		state.players:connect(name)
	end

	-- take the input
	state:_sfs_on_receive_fields_(name, fields)

	-- Reset form if all players disconnected
	if sender and not state.players:get_first() and not state.obsolete then
		local statelocation = smartfs._ldef.nodemeta._make_state_location_(nodepos)
		local resetstate = smartfs._makeState_(form, params, statelocation)
		if form.form_setup_callback(resetstate) ~= false then
			resetstate:show()
		end
		smartfs.opened[opened_id] = nil
	end
end

------------------------------------------------------
-- Minetest Interface - on_player_receive_fields callback in case of inventory or player
------------------------------------------------------
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if smartfs.opened[name] and smartfs.opened[name].location.type == "player" then
		if smartfs.opened[name].def.name == formname then
			local state = smartfs.opened[name]
			state:_sfs_on_receive_fields_(name, fields)

			-- disconnect player if form closed
			if not state.players:get_first() then
				smartfs.opened[name].obsolete = true
				smartfs.opened[name] = nil
			end
		end
	elseif smartfs.inv[name] and smartfs.inv[name].location.type == "inventory" and not smartfs.inv[name].location.inventory_handles_fields then
		local state = smartfs.inv[name]
		state:_sfs_on_receive_fields_(name, fields)
	end
	return false
end)

------------------------------------------------------
-- Minetest Interface - Notify loading of smartfs is done
------------------------------------------------------
minetest.after(0, function()
	smartfs.loaded = true
end)

------------------------------------------------------
-- Form Interface [linked to form:show()] - Shows the form to a player
------------------------------------------------------
function smartfs._show_(form, name, params)
	assert(form)
	assert(type(name) == "string", "smartfs: name needs to be a string")
	assert(minetest.get_player_by_name(name), "player does not exist")
	local statelocation = smartfs._ldef.player._make_state_location_(name)
	local state = smartfs._makeState_(form, params, statelocation, name)
	if form.form_setup_callback(state) ~= false then
		if smartfs.opened[name] then -- set maybe previous form to obsolete
			smartfs.opened[name].obsolete = true
		end
		smartfs.opened[name] = state
		state:show()
	end
	return state
end

------------------------------------------------------
-- Form Interface [linked to form:attach_to_node()] - Attach a formspec to a node meta
------------------------------------------------------
function smartfs._attach_to_node_(form, nodepos, params)
	assert(form)
	assert(nodepos and nodepos.x)

	local statelocation = smartfs._ldef.nodemeta._make_state_location_(nodepos)
	local state = smartfs._makeState_(form, params, statelocation)
	if form.form_setup_callback(state) ~= false then
		local opened_id = minetest.pos_to_string(nodepos)
		if smartfs.opened[opened_id] then -- set maybe previous form to obsolete
			smartfs.opened[opened_id].obsolete = true
		end
		state:show()
	end
	return state
end

------------------------------------------------------
-- Smartfs Framework - Element class Methods
------------------------------------------------------
local element_class = {}

function element_class:remove()
	self.root._ele[self.name] = nil
end

function element_class:setPosition(x,y)
	self.data.pos = {x=x,y=y}
end

function element_class:getPosition()
	return self.data.pos
end

function element_class:setSize(w,h)
	self.data.size = {w=w,h=h}
end

function element_class:getSize()
	return self.data.size
end

function element_class:setVisible(visible)
	if visible == nil then
		self.data.visible = true
	else
		self.data.visible = visible
	end
end

function element_class:getVisible()
	return self.data.visible
end

function element_class:getAbsName()
	return self.root:getNamespace()..self.name
end

function element_class:setBackground(image)
	self.data.background = image
end

function element_class:getBackground()
	return self.data.background
end

function element_class:getBackgroundString()
	if self.data.background then
		local size = self:getSize()
		if size then
			return "background["..
					self.data.pos.x..","..self.data.pos.y..";"..
					size.w..","..size.h..";"..
					self.data.background.."]"
		else
			return ""
		end
	else
		return ""
	end
end

function element_class:setValue(value)
	self.data.value = value
end

function element_class:setTooltip(text)
	self.data.tooltip = minetest.formspec_escape(text)
end

function element_class:getTooltip()
	return self.data.tooltip
end

function element_class:getTooltipString()
	if self.data.tooltip then
		return "tooltip["..self:getAbsName()..";"..self:getTooltip().."]"
	else
		return ""
	end
end

------------------------------------------------------
-- Smartfs Framework - State class Methods
------------------------------------------------------
local state_class = {}
function state_class:get(name)
	return self._ele[name]
end

function state_class:close()
	self.closed = true
end

function state_class:getSize()
	return self._size
end

function state_class:size(w,h)
	self._size = {w=w,h=h}
end
state_class.setSize = state_class.size

function state_class:getNamespace()
	local ref = self
	local namespace = ""
	while ref.location.type == "container" do
		namespace = ref.location.containerElement.name.."#"..namespace
		ref = ref.location.parentState -- step near to the root
	end
	return namespace
end

function state_class:_buildFormspec_(size)
	local res = ""
	if self._size and size then
		res = "size["..self._size.w..","..self._size.h.."]"
	end
	for key,val in pairs(self._ele) do
		if val:getVisible() then
			res = res .. val:getBackgroundString() .. val:build() .. val:getTooltipString()
		end
	end
	return res
end

function state_class:_get_element_recursive_(field)
	local topfield
	for z in field:gmatch("[^#]+") do
		topfield = z
		break
	end
	local element = self._ele[topfield]
	if element and field == topfield then
		return element
	elseif element then
		if element._getSubElement_ then
			local rel_field = string.sub(field, string.len(topfield)+2)
			return element:_getSubElement_(rel_field)
		else
			return element
		end
	else
		return nil
	end
end

-- process onInput hook for the state
function state_class:_sfs_process_oninput_(fields, player)
	if self._onInput then
		self:_onInput(fields, player)
	end
	-- recursive all onInput hooks on visible containers
	for elename, eledef in pairs(self._ele) do
		if eledef.getContainerState and eledef:getVisible() then
			eledef:getContainerState():_sfs_process_oninput_(fields, player)
		end
	end
end

-- Receive fields and actions from formspec
function state_class:_sfs_on_receive_fields_(player, fields)
	local fields_todo = {}
	for field, value in pairs(fields) do
		local element = self:_get_element_recursive_(field)
		if element then
			fields_todo[field] = { element = element, value = value }
		end
	end

	for field, todo in pairs(fields_todo) do
		todo.element:setValue(todo.value)
	end

	self:_sfs_process_oninput_(fields, player)

	for field, todo in pairs(fields_todo) do
		if todo.element.submit then
			todo.element:submit(todo.value, player)
		end
	end
	-- handle key_enter
	if fields.key_enter and fields.key_enter_field then
		local element = self:_get_element_recursive_(fields.key_enter_field)
		if element and element.submit_key_enter then
			element:submit_key_enter(fields[fields.key_enter_field], player)
		end
	end

	if not fields.quit and not self.closed and not self.obsolete then
		self:show()
	else
		self.players:disconnect(player)
		if not fields.quit and self.closed and not self.obsolete then
			--closed by application (without fields.quit). currently not supported, see: https://github.com/minetest/minetest/pull/4675
			minetest.show_formspec(player,"","size[5,1]label[0,0;Formspec closing not yet created!]")
		end
	end
	return true
end

function state_class:onInput(func)
	self._onInput = func -- (fields, player)
end

function state_class:load(file)
	local file = io.open(file, "r")
	if file then
		local table = minetest.deserialize(file:read("*all"))
		if type(table) == "table" then
			if table.size then
				self._size = table.size
			end
			for key,val in pairs(table.ele) do
				self:element(val.type,val)
			end
			return true
		end
	end
	return false
end

function state_class:save(file)
	local res = {ele={}}

	if self._size then
		res.size = self._size
	end

	for key,val in pairs(self._ele) do
		res.ele[key] = val.data
	end

	local file = io.open(file, "w")
	if file then
		file:write(minetest.serialize(res))
		file:close()
		return true
	end
	return false
end

function state_class:setparam(key,value)
	if not key then return end
	self.param[key] = value
	return true
end

function state_class:getparam(key,default)
	if not key then return end
	return self.param[key] or default
end

function state_class:element(typen,data)
	local type = smartfs._edef[typen]
	assert(type, "Element type "..typen.." does not exist!")
	assert(not self._ele[data.name], "Element "..data.name.." already exists")

	local ele = setmetatable({}, {__index = element_class})
	ele.name = data.name
	ele.root = self
	ele.data = data
	ele.data.type = typen
	ele.data.visible = true
	for key, val in pairs(type) do
		ele[key] = val
	end
	self._ele[data.name] = ele
	type.onCreate(ele)
	return self._ele[data.name]
end

------------------------------------------------------
-- Smartfs Framework - State class Methods - Build time only
------------------------------------------------------
function state_class:button(x, y, w, h, name, text, exitf)
	return self:element("button", {
		pos    = {x=x,y=y},
		size   = {w=w,h=h},
		name   = name,
		value  = text,
		closes = exitf or false
	})
end

function state_class:image_button(x, y, w, h, name, text, image, exitf)
	return self:element("button", {
		pos    = {x=x,y=y},
		size   = {w=w,h=h},
		name   = name,
		value  = text,
		image  = image,
		closes = exitf or false
	})
end

function state_class:item_image_button(x, y, w, h, name, text, item, exitf)
	return self:element("button", {
		pos    = {x=x,y=y},
		size   = {w=w,h=h},
		name   = name,
		value  = text,
		item   = item,
		closes = exitf or false
	})
end

function state_class:label(x, y, name, text)
	return self:element("label", {
		pos   = {x=x,y=y},
		name  = name,
		value = text,
		vertical = false
	})
end

function state_class:vertlabel(x, y, name, text)
	return self:element("label", {
		pos   = {x=x,y=y},
		name  = name,
		value = text,
		vertical = true
	})
end

function state_class:toggle(x, y, w, h, name, list)
	return self:element("toggle", {
		pos  = {x=x, y=y},
		size = {w=w, h=h},
		name = name,
		id   = 1,
		list = list
	})
end

function state_class:field(x, y, w, h, name, label)
	return self:element("field", {
		pos   = {x=x, y=y},
		size  = {w=w, h=h},
		name  = name,
		value = "",
		label = label
	})
end

function state_class:pwdfield(x, y, w, h, name, label)
	local res = self:element("field", {
		pos   = {x=x, y=y},
		size  = {w=w, h=h},
		name  = name,
		value = "",
		label = label
	})
	res:isPassword(true)
	return res
end

function state_class:textarea(x, y, w, h, name, label)
	local res = self:element("field", {
		pos   = {x=x, y=y},
		size  = {w=w, h=h},
		name  = name,
		value = "",
		label = label
	})
	res:isMultiline(true)
	return res
end

function state_class:image(x, y, w, h, name, img)
	return self:element("image", {
		pos   = {x=x, y=y},
		size  = {w=w, h=h},
		name  = name,
		value = img,
		imgtype = "image"
	})
end

function state_class:background(x, y, w, h, name, img)
	return self:element("image", {
		pos   = {x=x, y=y},
		size  = {w=w, h=h},
		name  = name,
		background = img,
		imgtype  = "background"
	})
end

function state_class:item_image(x, y, w, h, name, img)
	return self:element("image", {
		pos   = {x=x, y=y},
		size  = {w=w, h=h},
		name  = name,
		value = img,
		imgtype  = "item"
	})
end

function state_class:checkbox(x, y, name, label, selected)
	return self:element("checkbox", {
		pos   = {x=x, y=y},
		name  = name,
		value = selected,
		label = label
	})
end

function state_class:listbox(x, y, w, h, name, selected, transparent)
	return self:element("list", {
		pos         = {x=x, y=y},
		size        = {w=w, h=h},
		name        = name,
		selected    = selected,
		transparent = transparent
	})
end

function state_class:dropdown(x, y, w, h, name, selected)
	return self:element("dropdown", {
		pos         = {x=x, y=y},
		size        = {w=w, h=h},
		name        = name,
		selected    = selected
	})
end

function state_class:inventory(x, y, w, h, name)
	return self:element("inventory", {
		pos  = {x=x, y=y},
		size = {w=w, h=h},
		name = name
	})
end

function state_class:container(x, y, name, relative)
	return self:element("container", {
		pos  = {x=x, y=y},
		name = name,
		relative = false
	})
end

function state_class:view(x, y, name, relative)
	return self:element("container", {
		pos  = {x=x, y=y},
		name = name,
		relative = true
	})
end

------------------------------------------------------
-- Smartfs Framework - create a form object (state)
------------------------------------------------------
function smartfs._makeState_(form, params, location, newplayer)
	------------------------------------------------------
	-- State - -- Object to manage players
	------------------------------------------------------
	local function _make_players_(newplayer)
		local self = {
			_list = {}
		}
		function self.connect(self, player)
			self._list[player] = true
		end
		function self.disconnect(self, player)
			self._list[player] = nil
		end
		function self.get_first(self)
			return next(self._list)
		end
		if newplayer then
			self:connect(newplayer)
		end
		return self
	end

	local state = {
		_ele = {},
		def = form,
		players = _make_players_(newplayer),
		location = location,
		is_inv = (location.type == "inventory"), -- obsolete. Please use location.type="inventory" instead
		player = newplayer, -- obsolete. Please use location.player
		param = params or {},
		show = location._show_,
	}
	return setmetatable(state, {__index = state_class})
end

-----------------------------------------------------------------
-------------------------  ELEMENTS  ----------------------------
-----------------------------------------------------------------

smartfs.element("button", {
	onCreate = function(self)
		assert(self.data.pos and self.data.pos.x and self.data.pos.y, "button needs valid pos")
		assert(self.data.size and self.data.size.w and self.data.size.h, "button needs valid size")
		assert(self.name, "button needs name")
		assert(self.data.value, "button needs label")
	end,
	build = function(self)
		local specstring
		if self.data.image then
			if self.data.closes then
				specstring = "image_button_exit["
			else
				specstring = "image_button["
			end
		elseif self.data.item then
			if self.data.closes then
				specstring = "item_image_button_exit["
			else
				specstring = "item_image_button["
			end
		else
			if self.data.closes then
				specstring = "button_exit["
			else
				specstring = "button["
			end
		end

		specstring = specstring ..
				self.data.pos.x..","..self.data.pos.y..";"..
				self.data.size.w..","..self.data.size.h..";"
		if self.data.image then
			specstring = specstring..minetest.formspec_escape(self.data.image)..";"
		elseif self.data.item then
			specstring = specstring..self.data.item..";"
		end
		specstring = specstring..self:getAbsName()..";"..
				minetest.formspec_escape(self.data.value).."]"
		return specstring
	end,
	submit = function(self, field, player)
		if self._click then
			self:_click(self.root, player)
		end
	end,
	onClick = function(self,func)
		self._click = func
	end,
	click = function(self,func)
		self._click = func
	end,
	setText = function(self,text)
		self:setValue(text)
	end,
	getText = function(self)
		return self.data.value
	end,
	setImage = function(self,image)
		self.data.image = image
		self.data.item = nil
	end,
	getImage = function(self)
		return self.data.image
	end,
	setItem = function(self,item)
		self.data.item = item
		self.data.image = nil
	end,
	getItem = function(self)
		return self.data.item
	end,
	setClose = function(self,bool)
		self.data.closes = bool
	end,
	getClose = function(self)
		return self.data.closes or false
	end
})

smartfs.element("toggle", {
	onCreate = function(self)
		assert(self.data.pos and self.data.pos.x and self.data.pos.y, "toggle needs valid pos")
		assert(self.data.size and self.data.size.w and self.data.size.h, "toggle needs valid size")
		assert(self.name, "toggle needs name")
		assert(self.data.list, "toggle needs data")
	end,
	build = function(self)
		return "button["..
			self.data.pos.x..","..self.data.pos.y..
			";"..
			self.data.size.w..","..self.data.size.h..
			";"..
			self:getAbsName()..
			";"..
			minetest.formspec_escape(self.data.list[self.data.id])..
			"]"
	end,
	submit = function(self, field, player)
		self.data.id = self.data.id + 1
		if self.data.id > #self.data.list then
			self.data.id = 1
		end
		if self._tog then
			self:_tog(self.root, player)
		end
	end,
	onToggle = function(self,func)
		self._tog = func
	end,
	setId = function(self,id)
		self.data.id = id
	end,
	getId = function(self)
		return self.data.id
	end,
	getText = function(self)
		return self.data.list[self.data.id]
	end
})

smartfs.element("label", {
	onCreate = function(self)
		assert(self.data.pos and self.data.pos.x and self.data.pos.y, "label needs valid pos")
		assert(self.data.value, "label needs text")
	end,
	build = function(self)
		local specstring
		if self.data.vertical then
			specstring = "vertlabel["
		else
			specstring = "label["
		end
		return specstring..
			self.data.pos.x..","..self.data.pos.y..
			";"..
			minetest.formspec_escape(self.data.value)..
			"]"
	end,
	setText = function(self,text)
		self:setValue(text)
	end,
	getText = function(self)
		return self.data.value
	end
})

smartfs.element("field", {
	onCreate = function(self)
		assert(self.data.pos and self.data.pos.x and self.data.pos.y, "field needs valid pos")
		assert(self.data.size and self.data.size.w and self.data.size.h, "field needs valid size")
		assert(self.name, "field needs name")
		self.data.value = self.data.value or ""
		self.data.label = self.data.label or ""
	end,
	build = function(self)
		if self.data.ml then
			return "textarea["..
				self.data.pos.x..","..self.data.pos.y..
				";"..
				self.data.size.w..","..self.data.size.h..
				";"..
				self:getAbsName()..
				";"..
				minetest.formspec_escape(self.data.label)..
				";"..
				minetest.formspec_escape(self.data.value)..
				"]"
		elseif self.data.pwd then
			return "pwdfield["..
				self.data.pos.x..","..self.data.pos.y..
				";"..
				self.data.size.w..","..self.data.size.h..
				";"..
				self:getAbsName()..
				";"..
				minetest.formspec_escape(self.data.label)..
				"]"..
				self:getCloseOnEnterString()
		else
			return "field["..
				self.data.pos.x..","..self.data.pos.y..
				";"..
				self.data.size.w..","..self.data.size.h..
				";"..
				self:getAbsName()..
				";"..
				minetest.formspec_escape(self.data.label)..
				";"..
				minetest.formspec_escape(self.data.value)..
				"]"..
				self:getCloseOnEnterString()
		end
	end,
	setText = function(self,text)
		self:setValue(text)
	end,
	getText = function(self)
		return self.data.value
	end,
	isPassword = function(self,bool)
		self.data.pwd = bool
	end,
	isMultiline = function(self,bool)
		self.data.ml = bool
	end,
	getCloseOnEnterString = function(self)
		if self.close_on_enter == nil then
			return ""
		else
			return "field_close_on_enter["..self:getAbsName()..";"..tostring(self.close_on_enter).."]"
		end
	end,
	setCloseOnEnter = function(self, value)
		self.close_on_enter = value
	end,
	getCloseOnEnter = function(self)
		return self.close_on_enter
	end,
	submit_key_enter = function(self, field, player)
		if self._key_enter then
			self:_key_enter(self.root, player)
		end
	end,
	onKeyEnter = function(self,func)
		self._key_enter = func
	end,
})

smartfs.element("image", {
	onCreate = function(self)
		assert(self.data.pos and self.data.pos.x and self.data.pos.y, "image needs valid pos")
		assert(self.data.size and self.data.size.w and self.data.size.h, "image needs valid size")
		self.data.value = self.data.value or ""
	end,
	build = function(self)
		if self.data.imgtype == "background" then
			return "" -- handled in _buildFormspec_ trough getBackgroundString()
		elseif self.data.imgtype == "item" then
			return "item_image["..
				self.data.pos.x..","..self.data.pos.y..
				";"..
				self.data.size.w..","..self.data.size.h..
				";"..
				minetest.formspec_escape(self.data.value)..
				"]"
		else
			return "image["..
				self.data.pos.x..","..self.data.pos.y..
				";"..
				self.data.size.w..","..self.data.size.h..
				";"..
				minetest.formspec_escape(self.data.value)..
				"]"
		end
	end,
	setImage = function(self,text)
		if self.data.imgtype == "background" then
			self.data.background = text
		else
			self:setValue(text)
		end
	end,
	getImage = function(self)
		if self.data.imgtype == "background" then
			return self.data.background
		else
			return self.data.value
		end
	end
})

smartfs.element("checkbox", {
	onCreate = function(self)
		assert(self.data.pos and self.data.pos.x and self.data.pos.y, "checkbox needs valid pos")
		assert(self.name, "checkbox needs name")
		self.data.value = minetest.is_yes(self.data.value)
		self.data.label = self.data.label or ""
	end,
	build = function(self)
		return "checkbox["..
			self.data.pos.x..","..self.data.pos.y..
			";"..
			self:getAbsName()..
			";"..
			minetest.formspec_escape(self.data.label)..
			";" .. boolToStr(self.data.value) .."]"
	end,
	submit = function(self, field, player)
		-- call the toggle function if defined
		if self._tog then
			self:_tog(self.root, player)
		end
	end,
	setValue = function(self, value)
		self.data.value = minetest.is_yes(value)
	end,
	getValue = function(self)
		return self.data.value
	end,
	onToggle = function(self,func)
		self._tog = func
	end,
})

smartfs.element("list", {
	onCreate = function(self)
		assert(self.data.pos and self.data.pos.x and self.data.pos.y, "list needs valid pos")
		assert(self.data.size and self.data.size.w and self.data.size.h, "list needs valid size")
		assert(self.name, "list needs name")
		self.data.value = minetest.is_yes(self.data.value)
		self.data.items = self.data.items or {}
	end,
	build = function(self)
		if not self.data.items then
			self.data.items = {}
		end
		return "textlist["..
				self.data.pos.x..","..self.data.pos.y..
				";"..
				self.data.size.w..","..self.data.size.h..
				";"..
				self:getAbsName()..
				";"..
				table.concat(self.data.items, ",")..
				";"..
				tostring(self.data.selected or "")..
				";"..
				tostring(self.data.transparent or "false").."]"
	end,
	submit = function(self, field, player)
		local _type = string.sub(field,1,3)
		local index = tonumber(string.sub(field,5))
		self.data.selected = index
		if _type == "CHG" and self._click then
			self:_click(self.root, index, player)
		elseif _type == "DCL" and self._doubleClick then
			self:_doubleClick(self.root, index, player)
		end
	end,
	onClick = function(self, func)
		self._click = func
	end,
	click = function(self, func)
		self._click = func
	end,
	onDoubleClick = function(self, func)
		self._doubleClick = func
	end,
	doubleclick = function(self, func)
		self._doubleClick = func
	end,
	addItem = function(self, item)
		table.insert(self.data.items, minetest.formspec_escape(item))
		-- return the index of item. It is the last one
		return #self.data.items
	end,
	removeItem = function(self,idx)
		table.remove(self.data.items,idx)
	end,
	getItem = function(self, idx)
		return self.data.items[idx]
	end,
	popItem = function(self)
		local item = self.data.items[#self.data.items]
		table.remove(self.data.items)
		return item
	end,
	clearItems = function(self)
		self.data.items = {}
	end,
	setSelected = function(self,idx)
		self.data.selected = idx
	end,
	getSelected = function(self)
		return self.data.selected
	end,
	getSelectedItem = function(self)
		return self:getItem(self:getSelected())
	end,
})

smartfs.element("dropdown", {
	onCreate = function(self)
		assert(self.data.pos and self.data.pos.x and self.data.pos.y, "dropdown needs valid pos")
		assert(self.data.size and self.data.size.w and self.data.size.h, "dropdown needs valid size")
		assert(self.name, "dropdown needs name")
		self.data.items = self.data.items or {}
		self.data.selected = self.data.selected or 1
		self.data.value = ""
	end,
	build = function(self)
		return "dropdown["..
			self.data.pos.x..","..self.data.pos.y..
			";"..
			self.data.size.w..","..self.data.size.h..
			";"..
			self:getAbsName()..
			";"..
			table.concat(self.data.items, ",")..
			";"..
			tostring(self:getSelected())..
			"]"
	end,
	submit = function(self, field, player)
		self:getSelected()
		if self._select then
			self:_select(self.root, field, player)
		end
	end,
	onSelect = function(self, func)
		self._select = func
	end,
	addItem = function(self, item)
		table.insert(self.data.items, item)
		if #self.data.items == self.data.selected then
			self.data.value = item
		end
		-- return the index of item. It is the last one
		return #self.data.items
	end,
	removeItem = function(self,idx)
		table.remove(self.data.items,idx)
	end,
	getItem = function(self, idx)
		return self.data.items[idx]
	end,
	popItem = function(self)
		local item = self.data.items[#self.data.items]
		table.remove(self.data.items)
		return item
	end,
	clearItems = function(self)
		self.data.items = {}
	end,
	setSelected = function(self,idx)
		self.data.selected = idx
		self.data.value = self:getItem(idx) or ""
	end,
	getSelected = function(self)
		self.data.selected = 1
		if #self.data.items > 1 then
			for i = 1, #self.data.items do
				if self.data.items[i] == self.data.value then
					self.data.selected = i
				end
			end
		end
		return self.data.selected
	end,
	getSelectedItem = function(self)
		return self.data.value
	end,
})

smartfs.element("inventory", {
	onCreate = function(self)
		assert(self.data.pos and self.data.pos.x and self.data.pos.y, "list needs valid pos")
		assert(self.data.size and self.data.size.w and self.data.size.h, "list needs valid size")
		assert(self.name, "list needs name")
	end,
	build = function(self)
		return "list["..
			(self.data.invlocation or "current_player") ..
			";"..
			self.name..    --no namespacing
			";"..
			self.data.pos.x..","..self.data.pos.y..
			";"..
			self.data.size.w..","..self.data.size.h..
			";"..
			(self.data.index or "") ..
			"]"
	end,
	-- available inventory locations
	-- "current_player": Player to whom the menu is shown
	-- "player:<name>": Any player
	-- "nodemeta:<X>,<Y>,<Z>": Any node metadata
	-- "detached:<name>": A detached inventory
	-- "context" does not apply to smartfs, since there is no node-metadata as context available
	setLocation = function(self,invlocation)
		self.data.invlocation = invlocation
	end,
	getLocation = function(self)
		return self.data.invlocation or "current_player"
	end,
	usePosition = function(self, pos)
		self.data.invlocation = string.format("nodemeta:%d,%d,%d", pos.x, pos.y, pos.z)
	end,
	usePlayer = function(self, name)
		self.data.invlocation = "player:" .. name
	end,
	useDetached = function(self, name)
		self.data.invlocation = "detached:" .. name
	end,
	setIndex = function(self,index)
		self.data.index = index
	end,
	getIndex = function(self)
		return self.data.index
	end
})

smartfs.element("code", {
	onCreate = function(self)
		self.data.code = self.data.code or ""
	end,
	build = function(self)
		if self._build then
			self:_build()
		end

		return self.data.code
	end,
	submit = function(self, field, player)
		if self._sub then
			self:_sub(self.root, field, player)
		end
	end,
	onSubmit = function(self,func)
		self._sub = func
	end,
	onBuild = function(self,func)
		self._build = func
	end,
	setCode = function(self,code)
		self.data.code = code
	end,
	getCode = function(self)
		return self.data.code
	end
})

smartfs.element("container", {
	onCreate = function(self)
		assert(self.data.pos and self.data.pos.x and self.data.pos.y, "container needs valid pos")
		assert(self.name, "container needs name")
		local statelocation = smartfs._ldef.container._make_state_location_(self)
		self._state = smartfs._makeState_(nil, self.root.param, statelocation)
	end,

	-- redefinitions. The size is not handled by data.size but by container-state:size
	setSize = function(self,w,h)
		self:getContainerState():setSize(w,h)
	end,
	getSize = function(self)
		return self:getContainerState():getSize()
	end,

	-- element interface methods
	build = function(self)
		if self.data.relative ~= true then
			return "container["..self.data.pos.x..","..self.data.pos.y.."]"..
					self:getContainerState():_buildFormspec_(false)..
					"container_end[]"
		else
			return self:getContainerState():_buildFormspec_(false)
		end
	end,
	getContainerState = function(self)
		return self._state
	end,
	_getSubElement_ = function(self, field)
		return self:getContainerState():_get_element_recursive_(field)
	end,
})

return smartfs

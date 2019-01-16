-- Based on "https://gist.githubusercontent.com/rubenwardy/10074b66bd6e409c72c3ad0f79f5771a/raw/47389bbf0dc6badd79362361d0592053add7ceab/init.lua

-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end

local buttons = {}
local button_names_sorted = {}
local buttons_num = 0

local button_prefix = "sfinv_button_"

-- Stores selected index in textlist
local player_indexes = {}
local player_selections = {}

sfinv_buttons = {}

sfinv_buttons.register_button = function(name, def)
	buttons[name] = def
	table.insert(button_names_sorted, name)
	buttons_num = buttons_num + 1
end

-- Turns a textlist index to a button name
local index_to_button_name = function(index, player)
	local internal_index = 1
	for i=1, #button_names_sorted do
		local name = button_names_sorted[i]
		local def = buttons[name]
		if internal_index == index then
			if def.show == nil or def.show(player) == true then
				return name
			end
		end
		internal_index = internal_index + 1
	end
	return
end

smart_sfinv_api.register_enhancement({
	make_formspec = function(handler, player, context, content, show_inv)
		handler.formspec_size_add_w = handler.formspec_size_add_w + 1

		local x = 8.1
		local y = 0

		local retval = ""

		local buttons_added = 0
		for i=1, #button_names_sorted do
			local name = button_names_sorted[i]
			local def = buttons[name]
			if def.show == nil or def.show(player) == true then
				local button_id = minetest.formspec_escape(button_prefix .. name)
				retval = retval .. table.concat({
					"image_button[",
					x, ",", y, ";",
					1, ",", 1, ";",
					def.image, ";",
					button_id, ";]"}, "")

				local tooltip = def.title
				if def.tooltip and def.tooltip ~= def.title then
					tooltip = tooltip or ""
					tooltip = tooltip .. " " .. def.tooltip
				end

				if tooltip ~= nil then
					retval = retval .. "tooltip["..button_id..";"..
						minetest.formspec_escape(tooltip).."]"
				end

				y = y + 1
			end
		end

		handler.formspec_after_navfs = handler.formspec_after_navfs .. retval
	end,

	receive_fields = function(handler, player, context, fields)
		local player_name = player:get_player_name()
		-- TODO: Test support case when some buttons are hidden for player
		if fields.sfinv_buttons_action then
			local button = buttons[player_selections[player_name]]
			if button ~= nil and button.action ~= nil then
				button.action(player)
			end
		else
			for widget_name, _ in pairs(fields) do
				local id = string.sub(widget_name, string.len(button_prefix) + 1, -1)
				if buttons[id] ~= nil and buttons[id].action ~= nil then
					buttons[id].action(player)
				end
			end
		end
	end
})

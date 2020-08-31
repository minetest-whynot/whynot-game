-- Based on "https://gist.githubusercontent.com/rubenwardy/10074b66bd6e409c72c3ad0f79f5771a/raw/47389bbf0dc6badd79362361d0592053add7ceab/init.lua

local button_prefix = "sfinv_button_"
local last_button = 0

sfinv_buttons = { registered_buttons = {}, MAX_ROWS = 9 }

sfinv_buttons.register_button = function(name, def)

	def.button_name = button_prefix .. minetest.get_current_modname() .. '_' .. name

	local idx_start = def.position or 1
	local idx_end = last_button + 1
	if idx_start > idx_end then
		sfinv_buttons.registered_buttons[idx_start] = def
		if idx_start > last_button then
			last_button = idx_start
		end
	else
		local bubble = def
		for idx = idx_start, idx_end do
			local current = sfinv_buttons.registered_buttons[idx]
			if not current then
				-- free slot found
				sfinv_buttons.registered_buttons[idx] = bubble
				if idx > last_button then
					last_button = idx
				end
				break
			elseif bubble.position and (not current.position or current.position < bubble.position ) then
				-- swap bubble
				sfinv_buttons.registered_buttons[idx] = bubble
				bubble = current
			end
		end
	end
end

smart_sfinv_api.register_enhancement({
	make_formspec = function(handler, player, context, content, show_inv)
		if last_button == 0 then -- no buttons
			return 
		end

		handler.formspec_size_add_w = handler.formspec_size_add_w + math.floor(last_button / sfinv_buttons.MAX_ROWS) + 1

		local retval = ""

		for idx = 1, last_button do
			local def = sfinv_buttons.registered_buttons[idx]

			local x = 8.1 + math.floor(idx / sfinv_buttons.MAX_ROWS)
			local y = (idx - 1) % sfinv_buttons.MAX_ROWS

			if def and (def.show == nil or def.show == true or def.show(player, context, content, show_inv) == true) then
				local button_id = minetest.formspec_escape(def.button_name)
				retval = retval .. table.concat({
					"image_button[",
					x, ",", y, ";",
					1, ",", 1, ";",
					def.image, ";",
					button_id, ";]"}, "")

				local tooltip
				if def.title then
					if def.tooltip and def.tooltip ~= def.title then
						tooltip = def.tooltip .. " " .. def.tooltip
					else
						tooltip = def.title
					end
				else
					tooltip = def.tooltip
				end

				if tooltip then
					retval = retval .. "tooltip["..button_id..";"..
						minetest.formspec_escape(tooltip).."]"
				end
			end
		end
		handler.formspec_after_navfs = handler.formspec_after_navfs .. retval
	end,

	receive_fields = function(handler, player, context, fields)
		local player_name = player:get_player_name()
		local button_prefix_len = button_prefix:len()
		for idx = 1, last_button do
			local def = sfinv_buttons.registered_buttons[idx]
			if def and fields[def.button_name] and def.action then
				def.action(player, context, fields)
				break
			end
		end
	end
})

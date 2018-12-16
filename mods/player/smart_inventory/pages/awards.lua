if not minetest.get_modpath("awards") then
	return
end

local function awards_callback(state)
	local codebox = state:element("code", { name = "code", code = "", playername = state.location.rootState.location.player })
	codebox:onBuild(function(self)
		local formspec = awards.getFormspec(self.data.playername, self.data.playername, self.data.awards_idx or 1)

		-- patch elememt sizes and positions
		formspec = formspec:gsub('textarea%[0.25,3.75;3.9,4.2', 'textarea[-0.75,3.75;5.9,4.2')
		formspec = formspec:gsub('box%[%-0.05,3.75;3.9,4.2', 'box[-1.05,3.75;5.9,4.2')
		formspec = formspec:gsub('textlist%[4,0;3.8,8.6', 'textlist[6,0;6.8,8.6')
		self.data.code = "container[3,0]".. formspec .."container_end[]"
	end)

	state:onInput(function(state, fields, player)
		if fields.awards then
			local event = minetest.explode_textlist_event(fields.awards)
			if event.type == "CHG" then
				state:get("code").data.awards_idx = event.index
			end
		end
	end)
end

smart_inventory.register_page({
	name = "awards",
	icon = "awards_ui_icon.png",
	tooltip = "Awards",
	smartfs_callback = awards_callback,
	sequence = 25,
})

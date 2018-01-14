if not minetest.get_modpath("awards") then
	return
end

local function awards_callback(state)
	state:label(3, 1, "lbl_header", "Awards")
	
	local codebox = state:element("code", { name = "code", code = "", playername = state.location.rootState.location.player })
	codebox:onBuild(function(self)
		self.data.code = "container[3,2]".. awards.getFormspec(self.data.playername, self.data.playername, self.data.awards_idx or 1).."container_end[]"
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

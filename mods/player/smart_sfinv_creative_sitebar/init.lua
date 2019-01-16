
smart_sfinv_api.register_enhancement({
----------------------------------------------
-- Rewrite get_nav_fs
----------------------------------------------
	get_nav_fs = function(handler, player, context, nav, current_idx)
		-- Only show tabs if there is more than one page
		if #nav < 2 then
			return
		end

		local nav_titles_above = {}
		local current_idx_above = -1
		context.nav_above = {}

		local nav_titles_site = {}
		context.current_idx_site = context.current_idx_site or 0
		context.nav_site = {}
		for idx, page in ipairs(context.nav) do
			if page:sub(1,9) == "creative:" then
				table.insert(nav_titles_site, nav[idx])
				table.insert(context.nav_site, page)
				if idx == current_idx then
					context.current_idx_site = #nav_titles_site
				end
			else
				table.insert(nav_titles_above, nav[idx])
				table.insert(context.nav_above, page)
				if idx == current_idx then
					current_idx_above = #nav_titles_above
				end
			end
		end
		-- Add the creative tab. Select it if any creative is selected
		if #nav_titles_site > 0 then
			table.insert(nav_titles_above, 2, "Creative")
			table.insert(context.nav_above, 2, "Creative")
			if current_idx_above == -1 then
				current_idx_above = 2 -- Creative
				handler.formspec_before_navfs = "textlist[0,0;2.8,8.6;smart_sfinv_nav_site;" .. table.concat(nav_titles_site, ",") ..
					";" .. context.current_idx_site .. ";true]container[3,0]"..handler.formspec_before_navfs
				handler.formspec_after_content = handler.formspec_after_content.."container_end[]"
				handler.formspec_size_add_w = handler.formspec_size_add_w + 3
			elseif current_idx_above >= 2 then
				-- Because "Creative" is inserted, the index needs to be adjusted
				current_idx_above = current_idx_above + 1
			end
		end

		if #nav_titles_above > 0 then
			handler.custom_nav_fs = "tabheader[0,0;smart_sfinv_nav_tabs_above;" .. table.concat(nav_titles_above, ",") ..
				";" .. current_idx_above .. ";true;false]"
		else
			handler.custom_nav_fs = ""
		end
	end,

------------------------------------------------------------------------
-- Process input for enhanced navfs
------------------------------------------------------------------------
	receive_fields = function(handler, player, context, fields)
		-- Was a header tab selected?
		if fields.smart_sfinv_nav_tabs_above and context.nav_above then
			local tid = tonumber(fields.smart_sfinv_nav_tabs_above)
			if tid and tid > 0 then
				local id = context.nav_above[tid]
				local page = sfinv.pages[id]
				if id and page then
					sfinv.set_page(player, id)
				elseif id == "Creative" then
					local id = context.nav_site[context.current_idx_site]
					local page = sfinv.pages[id]
					if id and page then
						sfinv.set_page(player, id)
					end
				end
			end

		-- Was a site table selected?
		elseif fields.smart_sfinv_nav_site and context.nav_site then
			local tid = minetest.explode_textlist_event(fields.smart_sfinv_nav_site).index
			if tid and tid > 0 then
				local id = context.nav_site[tid]
				local page = sfinv.pages[id]
				if id and page then
					sfinv.set_page(player, id)
				end
			end
		end
	end
})

local S = sfcg.get_translator
local esc = minetest.formspec_escape


local function coords(i, cols)
	return i % cols, math.floor(i / cols)
end


local function recipe_fs(fs, data)
	local recipe = data.recipes[data.rnum]
	local width = recipe.width
	local cooktime, shapeless

	if recipe.method == "cooking" then
		cooktime, width = width, 1
	elseif width == 0 then
		shapeless = true
		if #recipe.items == 1 then
			width = 1
		elseif #recipe.items <= 4 then
			width = 2
		else
			width = 3
		end
	end

	table.insert(fs, ("label[5.5,1;%s]"):format(esc(data.show_usages
		and S("Usage @1 of @2", data.rnum, #data.recipes)
		or S("Recipe @1 of @2", data.rnum, #data.recipes))))

	if #data.recipes > 1 then
		table.insert(fs,
			"image_button[5.5,1.6;0.8,0.8;craftguide_prev_icon.png;recipe_prev;]"..
			"image_button[6.2,1.6;0.8,0.8;craftguide_next_icon.png;recipe_next;]"..
			"tooltip[recipe_prev;"..esc(S("Previous recipe")).."]"..
			"tooltip[recipe_next;"..esc(S("Next recipe")).."]")
	end

	local rows = math.ceil(table.maxn(recipe.items) / width)
	if width > 3 or rows > 3 then
		table.insert(fs, ("label[0,1;%s]")
			:format(esc(S("Recipe is too big to be displayed."))))
		return
	end

	local base_x = 3 - width
	local base_y = rows == 1 and 1 or 0

	-- Use local variables for faster execution in loop
	local item_button_fs = sfcg.item_button_fs
	local extract_groups = sfcg.extract_groups
	local groups_to_item = sfcg.groups_to_item

	for i, item in pairs(recipe.items) do
		local x, y = coords(i - 1, width)

		local elem_name = item
		local groups = extract_groups(item)
		if groups then
			item = groups_to_item(groups)
			elem_name = esc(item.."."..table.concat(groups, "+"))
		end
		item_button_fs(fs, base_x + x, base_y + y, item, elem_name, groups)
	end

	if shapeless or recipe.method == "cooking" then
		table.insert(fs, ("image[3.2,0.5;0.5,0.5;craftguide_%s.png]")
			:format(shapeless and "shapeless" or "furnace"))
		local tooltip = shapeless and S("Shapeless") or
			S("Cooking time: @1", minetest.colorize("yellow", cooktime))
		table.insert(fs, "tooltip[3.2,0.5;0.5,0.5;"..esc(tooltip).."]")
	end
	table.insert(fs, "image[3,1;1,1;sfinv_crafting_arrow.png]")

	item_button_fs(fs, 4, 1, recipe.output, recipe.output:match("%S*"))
end


local function get_formspec(player)
	local name = player:get_player_name()
	local data = sfcg.player_data[name]
	data.pagemax = math.max(1, math.ceil(#data.items / 32))

	local fs = {}
	table.insert(fs,
		"style_type[item_image_button;padding=2]"..
		"field[0.3,4.2;2.8,1.2;filter;;"..esc(data.filter).."]"..
		"label[5.8,4.15;"..minetest.colorize("yellow", data.pagenum).." / "..
			data.pagemax.."]"..
		"image_button[2.63,4.05;0.8,0.8;craftguide_search_icon.png;search;]"..
		"image_button[3.25,4.05;0.8,0.8;craftguide_clear_icon.png;clear;]"..
		"image_button[5,4.05;0.8,0.8;craftguide_prev_icon.png;prev;]"..
		"image_button[7.25,4.05;0.8,0.8;craftguide_next_icon.png;next;]"..
		"tooltip[search;"..esc(S("Search")).."]"..
		"tooltip[clear;"..esc(S("Reset")).."]"..
		"tooltip[prev;"..esc(S("Previous page")).."]"..
		"tooltip[next;"..esc(S("Next page")).."]"..
		"field_enter_after_edit[filter;true]"..
		"field_close_on_enter[filter;false]")

	if #data.items == 0 then
		table.insert(fs, "label[3,2;"..esc(S("No items to show.")).."]")
	else

		local item_button_fs = sfcg.item_button_fs

		local first_item = (data.pagenum - 1) * 32
		for i = first_item, first_item + 31 do
			local item = data.items[i + 1]
			if not item then
				break
			end
			local x, y = coords(i % 32, 8)
			item_button_fs(fs, x, y, item, item)
		end
	end

	table.insert(fs, "container[0,5.6]")
	if data.recipes then
		recipe_fs(fs, data)
	elseif data.prev_item then
		table.insert(fs, ("label[2,1;%s]"):format(esc(data.show_usages
			and S("No usages.").."\n"..S("Click again to show recipes.")
			or S("No recipes.").."\n"..S("Click again to show usages."))))
	end
	table.insert(fs, "container_end[]")

	return table.concat(fs)
end

local orig_update_for_player = sfcg.update_for_player
function sfcg.update_for_player(playername)
	local player = orig_update_for_player(playername)
	if player then
		sfinv.set_player_inventory_formspec(player)
	end
  return player
end


sfinv.register_page("sfcraftguide:craftguide", {
	title = esc(S("Recipes")),
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, get_formspec(player))
	end,
	on_player_receive_fields = function(self, player, context, fields)
		if sfcg.on_receive_fields(player, fields) then
			sfinv.set_player_inventory_formspec(player)
		end
	end
})


minetest.register_on_mods_loaded(function()

  sfinv.pages["mtg_craftguide:craftguide"] = nil
  for idx = #sfinv.pages_unordered, 1, -1 do
    local page = sfinv.pages_unordered[idx]
    if page.name == "mtg_craftguide:craftguide" then
      table.remove(sfinv.pages_unordered, idx)
    end
  end

end)
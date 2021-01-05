local time = 0
local update_time = tonumber(minetest.settings:get("wieldview_update_time"))
if not update_time then
	update_time = 2
	minetest.settings:set("wieldview_update_time", tostring(update_time))
end
local node_tiles = minetest.settings:get_bool("wieldview_node_tiles")
if not node_tiles then
	node_tiles = false
	minetest.settings:set("wieldview_node_tiles", "false")
end

wieldview = {
	transform = {},
}

dofile(minetest.get_modpath(minetest.get_current_modname()).."/transform.lua")

wieldview.get_item_texture = function(self, item)
	local texture = "blank.png"
	if item ~= "" then
		if minetest.registered_items[item] then
			if minetest.registered_items[item].inventory_image ~= "" then
				texture = minetest.registered_items[item].inventory_image
			elseif node_tiles == true and minetest.registered_items[item].tiles
					and type(minetest.registered_items[item].tiles[1]) == "string"
					and minetest.registered_items[item].tiles[1] ~= "" then
				texture = minetest.inventorycube(minetest.registered_items[item].tiles[1])
			end
		end
		-- Get item image transformation, first from group, then from transform.lua
		local transform = minetest.get_item_group(item, "wieldview_transform")
		if transform == 0 then
			transform = wieldview.transform[item]
		end
		if transform then
			-- This actually works with groups ratings because transform1, transform2, etc.
			-- have meaning and transform0 is used for identidy, so it can be ignored
			texture = texture.."^[transform"..tostring(transform)
		end
	end
	return texture
end

wieldview.update_wielded_item_textures = function(self, player, textures)
	if not player then
		return
	end
	local name = player:get_player_name()
	local stack = player:get_wielded_item()
	local item = stack:get_name()
	if not item then
		return
	end
	if player:get_meta():get_int("show_wielded_item") == 2 then
		item = ""
	end
	textures.wielditem = self:get_item_texture(item)
end

player_api.register_skin_modifier(function(textures, player, model_name, skin_name, model_name)
	wieldview:update_wielded_item_textures(player, textures)
end)

minetest.register_globalstep(function(dtime)
	time = time + dtime
	if time > update_time then
		for _,player in ipairs(minetest.get_connected_players()) do
			-- -- Proper API usage but overhead because of all hooks calculated
			--player_api.update_textures(player)
			-- -- Therefore hacky solution
			local current = player_api.get_animation(player)

			wieldview:update_wielded_item_textures(player, current.textures)
			current.textures[4] = current.textures.wielditem
			current.textures.wielditem = nil
			player:set_properties({textures = current.textures })
		end
		time = 0
	end
end)

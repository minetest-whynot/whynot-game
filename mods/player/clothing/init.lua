local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/api.lua")
dofile(modpath.."/clothing.lua")

-- Inventory mod support

if minetest.get_modpath("inventory_plus") then
	clothing.inv_mod = "inventory_plus"
	clothing.formspec = clothing.formspec..
		"button[6,0;2,0.5;main;Back]"
elseif minetest.get_modpath("unified_inventory") and
		not unified_inventory.sfinv_compat_layer then
	clothing.inv_mod = "unified_inventory"
	unified_inventory.register_button("clothing", {
		type = "image",
		image = "inventory_plus_clothing.png",
	})
	unified_inventory.register_page("clothing", {
		get_formspec = function(player, perplayer_formspec)
			local fy = perplayer_formspec.formspec_y
			local name = player:get_player_name()
			local formspec = "background[0.06,"..fy..
				";7.92,7.52;clothing_ui_form.png]"..
				"label[0,0;Clothing]"..
				"list[detached:"..name.."_clothing;clothing;0,"..fy..";2,3;]"..
				"listring[current_player;main]"..
				"listring[detached:"..name.."_clothing;clothing]"
			return {formspec=formspec}
		end,
	})
elseif minetest.get_modpath("sfinv") then
	clothing.inv_mod = "sfinv"
	sfinv.register_page("clothing:clothing", {
		title = "Clothing",
		get = function(self, player, context)
			local name = player:get_player_name()
			local formspec = clothing.formspec..
				"list[detached:"..name.."_clothing;clothing;0,0.5;2,3;]"..
				"listring[current_player;main]"..
				"listring[detached:"..name.."_clothing;clothing]"
			return sfinv.make_formspec(player, context,
				formspec, false)
		end
	})
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if clothing.inv_mod == "inventory_plus" and fields.clothing then
		inventory_plus.set_inventory_formspec(player, clothing.formspec..
			"list[detached:"..name.."_clothing;clothing;0,0.5;2,3;]"..
			"listring[current_player;main]"..
			"listring[detached:"..name.."_clothing;clothing]")
	end
end)

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local player_inv = player:get_inventory()
	local clothing_inv = minetest.create_detached_inventory(name.."_clothing",{
		on_put = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, stack)
			clothing:run_callbacks("on_equip", player, index, stack)
			clothing:set_player_clothing(player)
		end,
		on_take = function(inv, listname, index, stack, player)
			player:get_inventory():set_stack(listname, index, nil)
			clothing:run_callbacks("on_unequip", player, index, stack)
			clothing:set_player_clothing(player)
		end,
		on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			local plaver_inv = player:get_inventory()
			local stack = inv:get_stack(to_list, to_index)
			player_inv:set_stack(to_list, to_index, stack)
			player_inv:set_stack(from_list, from_index, nil)
			clothing:set_player_clothing(player)
		end,
		allow_put = function(inv, listname, index, stack, player)
			local item = stack:get_name()
			if minetest.get_item_group(item, "clothing") > 0 or
					minetest.get_item_group(item, "cape") > 0 then
				return 1
			end
			return 0
		end,
		allow_take = function(inv, listname, index, stack, player)
			return stack:get_count()
		end,
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
			return count
		end,
	}, name)
	if clothing.inv_mod == "inventory_plus" then
		inventory_plus.register_button(player,"clothing", "Clothing")
	end
	clothing_inv:set_size("clothing", 6)
	player_inv:set_size("clothing", 6)
	for i=1, 6 do
		local stack = player_inv:get_stack("clothing", i)
		clothing_inv:set_stack("clothing", i, stack)
	end
	minetest.after(1, function(player)
		clothing:set_player_clothing(player)
	end, player)
end)

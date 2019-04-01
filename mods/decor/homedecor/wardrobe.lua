
local S = homedecor_i18n.gettext

local wd_cbox = {
	type = "fixed",
	fixed = { -0.5, -0.5, -0.5, 0.5, 1.5, 0.5 }
}

local skinslist = {"male1", "male2", "male3", "male4", "male5"}
local default_skin = "character.png"

if minetest.get_modpath("player_api") then
	for _, shrt in ipairs(skinslist) do
		for _, prefix in ipairs({"", "fe"}) do
			local skin_name = prefix..shrt
			local skin = {
				texture =  "homedecor_clothes_"..skin_name..".png",
				preview = "homedecor_clothes_"..skin_name.."_preview.png",
				description = "Wardrobe "..skin_name,
				author = 'Calinou and Jordach',
				license = 'CC-by-SA-4.0',
				in_inventory_list = false,
			}
			if minetest.get_modpath("multiskin_model") then
				local file = io.open(homedecor.modpath.."/textures/homedecor_clothes_"..skin_name..".png", "r")
				skin.format = multiskin_model.get_skin_format(file)
				file:close()
			end
			player_api.register_skin(skin.texture, skin)
		end
	end

	function homedecor.get_player_skin(player)
		return player_api.get_skin(player)
	end

	function homedecor.set_player_skin(player, skin, save)
		player_api.set_skin(player, skin, not save)
	end
else
	function homedecor.get_player_skin(player)
		local skin = player:get_attribute("homedecor:player_skin")
		if not skin or skin == "" then
			return default_skin, true
		end
		return skin, false
	end

	function homedecor.set_player_skin(player, skin, save)
		set_player_textures(player, { skin or default_skin})
		if save then
			if skin == default_skin then
				skin = "default"
				player:set_attribute("homedecor:player_skin", "")
			else
				player:set_attribute("homedecor:player_skin", skin)
			end
			if save == "player" then -- if player action
				minetest.log("verbose",
					S("player @1 sets skin to @2", player:get_player_name(), skin) ..
					(armor_mod_path and ' [3d_armor]' or '')
				)
			end
		end
	end

	minetest.register_on_joinplayer(function(player)
		local skin = player:get_attribute("homedecor:player_skin")

		if skin and skin ~= "" then
			-- setting player skin on connect has no effect, so delay skin change
			minetest.after(1, function(player, skin)
				homedecor.set_player_skin(player, skin)
			end, player, skin)
		end
	end)
end

function homedecor.unset_player_skin(player)
	homedecor.set_player_skin(player, nil, true)
end

homedecor.register("wardrobe", {
	mesh = "homedecor_bedroom_wardrobe.obj",
	tiles = {
		homedecor.plain_wood,
		"homedecor_wardrobe_drawers.png",
		"homedecor_wardrobe_doors.png"
	},
	inventory_image = "homedecor_wardrobe_inv.png",
	description = S("Wardrobe"),
	groups = {snappy=3},
	selection_box = wd_cbox,
	collision_box = wd_cbox,
	sounds = default.node_sound_wood_defaults(),
	expand = { top="placeholder" },
	on_rotate = screwdriver.rotate_simple,
	infotext = S("Wardrobe"),
	inventory = {
		size = 10
	},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		-- textures made by the Minetest community (mostly Calinou and Jordach)
		local clothes_strings = ""
		for i = 1,5 do
			clothes_strings = clothes_strings..
			  "image_button_exit["..(i-1)..".5,0;1.1,2;homedecor_clothes_"..skinslist[i].."_preview.png;"..skinslist[i]..";]"..
			  "image_button_exit["..(i-1)..".5,2;1.1,2;homedecor_clothes_fe"..skinslist[i].."_preview.png;fe"..skinslist[i]..";]"
		end
		meta:set_string("formspec", "size[5.5,8.5]"..default.gui_bg..default.gui_bg_img..default.gui_slots..
			"vertlabel[0,0.5;"..minetest.formspec_escape(S("Clothes")).."]"..
			"button_exit[0,3.29;0.6,0.6;default;x]"..
			clothes_strings..
			"vertlabel[0,5.2;"..minetest.formspec_escape(S("Storage")).."]"..
			"list[current_name;main;0.5,4.5;5,2;]"..
			"list[current_player;main;0.5,6.8;5,2;]" ..
			"listring[]")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		if fields.default then
			homedecor.set_player_skin(sender, nil, "player")
			return
		end

		for i = 1,5 do
			if fields[skinslist[i]] then
				homedecor.set_player_skin(sender, "homedecor_clothes_"..skinslist[i]..".png", "player")
				break
			elseif fields["fe"..skinslist[i]] then
				homedecor.set_player_skin(sender, "homedecor_clothes_fe"..skinslist[i]..".png", "player")
				break
			end
		end
	end
})

minetest.register_alias("homedecor:wardrobe_bottom", "homedecor:wardrobe")
minetest.register_alias("homedecor:wardrobe_top", "air")

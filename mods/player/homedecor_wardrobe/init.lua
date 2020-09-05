local modpath = minetest.get_modpath("homedecor_wardrobe")

screwdriver = screwdriver or {}

local placeholder_node = "air"
local wd_cbox = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}}

local skinslist = {"male1", "male2", "male3", "male4", "male5"}
local default_skin = "character.png"

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
			filename = modpath.."/textures/homedecor_clothes_"..skin_name..".png",
		}
		player_api.register_skin(skin.texture, skin)
	end
end

local function set_player_skin(player, skin, save)
	player_api.set_skin(player, skin, not save)
end

local def = {

	description = "Wardrobe",
	drawtype = "mesh",
	mesh = "homedecor_bedroom_wardrobe.obj",
	tiles = {
		{name = "homedecor_generic_wood_plain.png", color = 0xffa76820},
		"homedecor_wardrobe_drawers.png",
		"homedecor_wardrobe_doors.png"
	},
	inventory_image = "homedecor_wardrobe_inv.png",

	paramtype = "light",
	paramtype2 = "facedir",

	groups = {snappy = 3},
	selection_box = wd_cbox,
	collision_box = wd_cbox,
	sounds = default.node_sound_wood_defaults(),

	on_rotate = screwdriver.rotate_simple,

	on_place = function(itemstack, placer, pointed_thing)

		return homedecor.stack_vertically(itemstack, placer, pointed_thing,
				itemstack:get_name(), "placeholder")
	end,

	can_dig = function(pos,player)

		local meta = minetest.get_meta(pos)

		return meta:get_inventory():is_empty("main")
	end,

	on_construct = function(pos)

		local meta = minetest.get_meta(pos)

		meta:set_string("infotext", "Wardrobe")

		meta:get_inventory():set_size("main", 10)

		-- textures made by the Minetest community (mostly Calinou and Jordach)
		local clothes_strings = ""

		for i = 1, 5 do

			clothes_strings = clothes_strings ..
				"image_button_exit[" .. (i-1) ..
				".5,0;1.1,2;homedecor_clothes_" .. skinslist[i] ..
				"_preview.png;" .. skinslist[i] .. ";]" ..
				"image_button_exit[" .. (i-1) ..
				".5,2;1.1,2;homedecor_clothes_fe" .. skinslist[i] ..
				"_preview.png;fe" .. skinslist[i] .. ";]"
		end

		meta:set_string("formspec",  "size[5.5,8.5]" ..
			default.gui_bg .. default.gui_bg_img .. default.gui_slots ..
			"vertlabel[0,0.5;" .. minetest.formspec_escape("Clothes") .. "]" ..
			"button_exit[0,3.29;0.6,0.6;default;x]" ..
			clothes_strings ..
			"vertlabel[0,5.2;" .. minetest.formspec_escape("Storage") .. "]" ..
			"list[current_name;main;0.5,4.5;5,2;]" ..
			"list[current_player;main;0.5,6.8;5,2;]" ..
			"listring[]"
		)
	end,

	on_receive_fields = function(pos, formname, fields, sender)

		if fields.default then

			set_player_skin(sender, nil, "player")

			return
		end

		for i = 1, 5 do

			if fields[skinslist[i]] then

				set_player_skin(sender,
					"homedecor_clothes_" .. skinslist[i] .. ".png", "player")
				break

			elseif fields["fe" .. skinslist[i]] then

				set_player_skin(sender,
					"homedecor_clothes_fe" .. skinslist[i] .. ".png", "player")
				break
			end
		end
	end
}

-- register the actual minetest node
minetest.register_node(":homedecor:wardrobe", def)

minetest.register_alias("homedecor:wardrobe_bottom", "homedecor:wardrobe")
minetest.register_alias("homedecor:wardrobe_top", "air")

minetest.register_craft( {
	output = "homedecor:wardrobe",
	recipe = {
		{ "homedecor:drawer_small", "homedecor:kitchen_cabinet" },
		{ "homedecor:drawer_small", "default:wood" },
		{ "homedecor:drawer_small", "default:wood" }
	},
})

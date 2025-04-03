laptop = {}
laptop.class_lib = {}

function laptop.close_btn(pos, player)
	pos = pos or "15.5,-0.4"
	-- Note: player must be nil when node meta formspecs are used
	if player and minetest.global_exists("inv_themes") then
		return inv_themes.get_theme(player):close_btn(pos)
	end

	return "style[exit;content_offset=0]" ..
		-- Make the close texture opaque
		"image_button_exit[" .. pos .. ";0.75,0.75;close_pressed.png^[colorize:#D6D5E6^close.png;" ..
			"exit;;true;false;close_pressed.png]"
end

dofile(minetest.get_modpath('laptop')..'/themes.lua')
dofile(minetest.get_modpath('laptop')..'/block_devices.lua')
dofile(minetest.get_modpath('laptop')..'/app_fw.lua')
dofile(minetest.get_modpath('laptop')..'/mtos.lua')
dofile(minetest.get_modpath('laptop')..'/hardware_fw.lua')
dofile(minetest.get_modpath('laptop')..'/recipe_compat.lua')
dofile(minetest.get_modpath('laptop')..'/hardware_nodes.lua')
dofile(minetest.get_modpath('laptop')..'/craftitems.lua')

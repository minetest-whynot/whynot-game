laptop = {}
laptop.class_lib = {}
laptop.S = core.get_translator("laptop")

function laptop.close_btn(pos, player)
	pos = pos or "15.5,-0.4"
	-- Note: player must be nil when node meta formspecs are used
	if player and minetest.global_exists("inv_themes") and inv_themes then -- for default game
		return inv_themes.get_theme(player):close_btn(pos)
	end

	return "style[exit;content_offset=0]" ..
		-- Make the close texture opaque
		"image_button_exit[" .. pos .. ";0.75,0.75;close_pressed.png^[colorize:#D6D5E6^close.png;" ..
			"exit;;true;false;close_pressed.png]"
end

-- These sizes are in bytes
laptop.max_filename_size = 1000
laptop.max_text_size = 10000
laptop.max_files = 8

local utf8_remove = utf8.remove
function laptop.truncate_text(text, max_size)
	-- Like text:sub(1, max_size) but won't split a multi-byte character (which
	-- causes the text to be shown as <invalid UTF-8 string> or something)
	if text and #text > max_size then
		return utf8_remove(text:sub(1, max_size + 1))
	end
	return text
end

dofile(minetest.get_modpath('laptop')..'/themes.lua')
dofile(minetest.get_modpath('laptop')..'/block_devices.lua')
dofile(minetest.get_modpath('laptop')..'/app_fw.lua')
dofile(minetest.get_modpath('laptop')..'/mtos.lua')
dofile(minetest.get_modpath('laptop')..'/hardware_fw.lua')
dofile(minetest.get_modpath('laptop')..'/recipe_compat.lua')
dofile(minetest.get_modpath('laptop')..'/hardware_nodes.lua')
dofile(minetest.get_modpath('laptop')..'/craftitems.lua')


-- Remove existing paper that has too much data
minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	for i, stack in ipairs(inv:get_list("main")) do
		if stack:get_name() == "laptop:printed_paper" then
			local meta = stack:get_meta()
			if #meta:get_string("title") > laptop.max_filename_size or
					#meta:get_string("text") > laptop.max_text_size then
				meta:set_string("title", "")
				meta:set_string("text", "")
				inv:set_stack("main", i, stack)
			end
		end
	end
end)

local function sanitise_storage(storage, max_size)
	if not storage then return end

	-- Clear large sticky note files
	local items = storage["stickynote:files"] or {}
	local count = 0
	for k, v in pairs(items) do
		if count > 8 or #k > laptop.max_filename_size then
			items[k] = nil
		else
			count = count + 1
			items[k] = laptop.truncate_text(v, laptop.max_text_size)
		end
	end

	-- If storage is still unreasonably large, wipe it
	if #core.serialize(storage) > max_size then
		for k in pairs(storage) do
			storage[k] = nil
		end

		-- storage cannot be empty or it won't be saved
		storage["stickynote:files"] = {}
	end
end

minetest.register_lbm({
	label = "Sanitise laptop storage",
	name = "laptop:sanitise_storage",
	nodenames = {"group:laptop"},
	action = function(pos)
		local mtos = laptop.os_get(pos)
		local bdev = mtos.bdev

		sanitise_storage(bdev:get_hard_disk(), 200000)

		local disk = bdev:get_removable_disk()
		if disk then
			sanitise_storage(disk.storage, 65535)
		end

		-- Save
		bdev:sync()
	end,
})

if not minetest.get_translator then
	error("[character_creator] Translator API not found. "
		.. "Please update Minetest to a recent version.")
end

character_creator = {}
-- Fill character_creator.skins
dofile(minetest.get_modpath("character_creator") .. "/skins.lua")

-- Update with /path/to/i18n.py -p -s .
character_creator.S = minetest.get_translator("character_creator")
character_creator.FS = function(...)
	return minetest.formspec_escape(character_creator.S(...))
end
--local S = character_creator.S
local FS = character_creator.S

local skinsdb
if minetest.get_modpath("skinsdb") and minetest.global_exists("skins") then
	skinsdb = skins

	-- Create dummy skins with hand
	if skins.skin_class.set_hand_from_texture then
		for skin_name, skin_texture in pairs(character_creator.skins.skin) do
			local hand_skin = skinsdb.new("character_creator:"..skin_name)
			hand_skin:set_texture(skin_texture)
			hand_skin:set_hand_from_texture()
			hand_skin:set_meta("in_inventory_list", false)
		end
	end
end

local skin_default = {
	gender     = "Male",
	height     = 1,
	width      = 1,

	skin       = "Fair Skin",
	face       = "Human Face",
	hair       = "Brown Hair",
	hair_style = "Medium Hair",
	eyes       = "Blue Eyes",
	tshirt     = "Green T-Shirt",
	pants      = "Blue Pants",
	shoes      = "Leather Shoes"
}

local skins_array = {}

minetest.after(0, function()
	local function table_keys_to_array(associative)
		local array = {}
		for key in pairs(associative) do
			table.insert(array, key)
		end
		return array
	end

	-- part: skin, face, hair, ....
	for part, def in pairs(character_creator.skins) do
		skins_array[part] = table_keys_to_array(def)
	end
end)

-- Saved skins_array indexes in this
local skin_indexes = {}

local function show_formspec(player)
	local indexes = skin_indexes[player]
	local order = {
		"skin", "face", "hair", "hair_style", "eyes",
		"tshirt", "pants", "shoes"
	}

	local fs = {
		"formspec_version[2]",
		"size[13,9]",
		"no_prepend[]",
		"bgcolor[#00000000]",
		"style_type[button;noclip=true]",
		-- Gender
		"button[10,  0;2.5,.75;male;" .. FS("Male") .. "]",
		"button[12.5,0;2.5,.75;female;" .. FS("Female") .. "]",
		-- Height
		"button[10  ,1;2.5,.75;taller;" .. FS("Taller") .. "]",
		"button[10  ,2;2.5,.75;shorter;" .. FS("Shorter") .. "]",
		-- Width
		"button[12.5,1;2.5,.75;wider;" .. FS("Wider") .. "]",
		"button[12.5,2;2.5,.75;thinner;" .. FS("Thinner") .. "]",
	}
	local x = 11
	local y = 3

	for _, part in ipairs(order) do
		fs[#fs + 1] =
			("button[%g,%g;1,.75;%s_back;<<]"):format(x - 1, y, part) ..
			("button[%g,%g;3,.75;%s;%s]"     ):format(x + 0, y, part, skins_array[part][indexes[part]]) ..
			("button[%g,%g;1,.75;%s_next;>>]"):format(x + 3, y, part)
		y = y + 0.75
	end
	table.insert(fs,
		"button_exit[10,9.2;2.5,.75;done;" .. FS("Done") .. "]" ..
		"button_exit[12.5,9.2;2.5,.75;cancel;" .. FS("Cancel") .. "]")

	minetest.show_formspec(player:get_player_name(), "character_creator", table.concat(fs))
end

local function load_skin(player)
	skin_indexes[player] = {}

	local player_meta = player:get_meta()

	if not player_meta:contains("character_creator:gender") then
		player_meta:set_string("character_creator:gender", skin_default.gender)
	end

	if not player_meta:contains("character_creator:width") then
		player_meta:set_float("character_creator:width", skin_default.width)
	end

	if not player_meta:contains("character_creator:height") then
		player_meta:set_float("character_creator:height", skin_default.height)
	end

	local function load_data(data_name)
		local key   = player_meta:get_string("character_creator:" .. data_name)
		local index = table.indexof(skins_array[data_name], key)
		if index == -1 then
			index = table.indexof(skins_array[data_name], skin_default[data_name])
		end

		local indexes = skin_indexes[player]
		indexes[data_name] = index
	end

	load_data("skin")
	load_data("face")
	load_data("eyes")
	load_data("hair_style")
	load_data("hair")
	load_data("tshirt")
	load_data("pants")
	load_data("shoes")
end

local function save_skin(player)
	local player_meta = player:get_meta()
	if player_meta == nil then
		-- The player disconnected before this function was dispatched
		return
	end

	local function save_data(data_name)
		local indexes = skin_indexes[player]
		local index   = indexes[data_name]
		local key     = skins_array[data_name][index]
		player_meta:set_string("character_creator:" .. data_name, key)
	end

	save_data("skin")
	save_data("face")
	save_data("eyes")
	save_data("hair_style")
	save_data("hair")
	save_data("tshirt")
	save_data("pants")
	save_data("shoes")
end

local function get_texture(player)
	local player_meta = player:get_meta()
	if not player_meta then
		-- The player disconnected before this function was dispatched
		return ""
	end

	local defs = {}
	for part, selected in pairs(skin_indexes[player]) do
		local key = skins_array[part][selected]
		defs[part] = {
			key = key,
			-- Table reference to the selected hair/skin/...
			val = character_creator.skins[part][key]
		}
	end

	local gender = player_meta:get_string("character_creator:gender")
	local face = defs.face.val[gender][defs.skin.key]
	local hair = defs.hair.val[gender][defs.hair_style.key]
	return table.concat({
			"(" .. defs.skin.val .. ")",
			"(" .. face .. ")",
			"(" .. defs.eyes.val .. ")",
			"(" .. hair .. ")",
			"(" .. defs.tshirt.val .. ")",
			"(" .. defs.pants.val .. ")",
			"(" .. defs.shoes.val .. ")",
		}, "^")
end

local function change_skin(player)
	local player_meta = player:get_meta()
	if player_meta == nil then
		-- The player disconnected before this function was dispatched
		return
	end

	local texture = get_texture(player)

	local width  = player_meta:get_float("character_creator:width")
	local height = player_meta:get_float("character_creator:height")

	player:set_properties({
		visual_size = {
			x = width,
			y = height
		}
	})

	if minetest.get_modpath("multiskin") then
		local name = player:get_player_name()
		minetest.after(0, function(name)
			local player = minetest.get_player_by_name(name)
			if player then
				multiskin.layers[name].skin = texture
				armor:set_player_armor(player)
				multiskin:set_player_textures(player, {textures = {texture}})
			end
		end, name)

	elseif minetest.get_modpath("3d_armor") then
		local name = player:get_player_name()
		minetest.after(0, function(name)
			local player = minetest.get_player_by_name(name)
			if player then
				armor.textures[name].skin = texture
				armor:set_player_armor(player)
			end
		end, name)

	else
		player:set_properties({textures = {texture}})
	end

	save_skin(player)
end

if skinsdb then
	--change skin redefinition for skinsdb
	function change_skin(player)
		local player_meta = player:get_meta()
		if player_meta == nil then
			-- The player disconnected before this function was dispatched
			return
		end

		local playername = player:get_player_name()
		local skinname = "character_creator:"..playername
		local skin_obj = skinsdb.get(skinname) or skinsdb.new(skinname)
		skin_obj:set_meta("format", "1.0")
		skin_obj:set_meta("visual_size_x", player_meta:get_float("character_creator:width"))
		skin_obj:set_meta("visual_size_y", player_meta:get_float("character_creator:height"))
		skinsdb.assign_player_skin(player, skinname)
		skinsdb.update_player_skin(player)
		save_skin(player)
	end
end

minetest.register_on_joinplayer(function(player)
	load_skin(player)
	if skinsdb then
		local playername = player:get_player_name()
		local skinname = "character_creator:"..playername
		local skin_obj = skinsdb.get(skinname) or skinsdb.new(skinname)
		-- redefinitions
		function skin_obj:set_skin(player)
			if not player or not skin_indexes[player] then
				return -- not loaded or disconnected
			end
			change_skin(player)
			show_formspec(player)
		end
		function skin_obj:get_texture()
			return get_texture(minetest.get_player_by_name(self:get_meta("playername")))
		end
		function skin_obj:get_hand()
			local player = minetest.get_player_by_name(self:get_meta("playername"))
			local skin_key = skins_array.skin[skin_indexes[player].skin]
			local hand_skin = skinsdb.get("character_creator:"..skin_key)
			if hand_skin then
				return hand_skin:get_hand()
			end
		end

		-- set data
		skin_obj:set_meta("name","Character Creator")
		--skin_obj:set_meta("author", "???")
		skin_obj:set_meta("license", "MIT / CC-BY-SA 3.0 Unported")
		skin_obj:set_meta("playername",playername)
		--check if active and start the update (avoid race condition for both register_on_joinplayer)
		if skinsdb.get_player_skin(player):get_key() == skinname then
			minetest.after(0, change_skin, player)
		end
	else
		minetest.after(0, change_skin, player)
	end
end)

minetest.register_on_leaveplayer(function(player)
	if skinsdb then
		local skinname = "character_creator:"..player:get_player_name()
		skinsdb.meta[skinname] = nil
	end
	skin_indexes[player] = nil
end)

local skin_temp = {}
minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "character_creator" then
		return
	end

	local player_meta = player:get_meta()
	local indexes = skin_indexes[player]

	if not skin_temp[player] then
		skin_temp[player] = {
			gender = player_meta:get_string("character_creator:gender"),
			width = player_meta:get_float("character_creator:width"),
			height = player_meta:get_float("character_creator:height"),
			indexes = table.copy(indexes)
		}
	end

	-- Gender
	do
		if fields.male then
			player_meta:set_string("character_creator:gender", "Male")
			player_meta:set_float("character_creator:width", 1)
			player_meta:set_float("character_creator:height", 1)
		end

		if fields.female then
			player_meta:set_string("character_creator:gender", "Female")
			player_meta:set_float("character_creator:width", 0.95)
			player_meta:set_float("character_creator:height", 1)
		end
	end

	-- Height
	do
		local height = tonumber(player_meta:get_float("character_creator:height"))

		if fields.taller and height < 1.25 then
			player_meta:set_float("character_creator:height", height + 0.05)
		end

		if fields.shorter and height > 0.75 then
			player_meta:set_float("character_creator:height", height - 0.05)
		end
	end

	-- Width
	do
		local width = tonumber(player_meta:get_float("character_creator:width"))

		if fields.wider and width < 1.25 then
			player_meta:set_float("character_creator:width", width + 0.05)
		end

		if fields.thinner and width > 0.75 then
			player_meta:set_float("character_creator:width", width - 0.05)
		end
	end

	-- Switch skin
	do
		local function switch_skin(data_name, next_index)
			if not indexes[data_name]
					or not skins_array[data_name] then
				return -- Supplied invalid data
			end

			local index = indexes[data_name] + next_index
			local max = #skins_array[data_name]

			if index == 0 then
				index = max
			elseif index == (max + 1) then
				index = 1
			end

			indexes[data_name] = index
		end

		for field in pairs(fields) do
			if field:find("_back$") then
				local data_name = field:match("(.+)_back$")
				switch_skin(data_name, -1)
			elseif field:find("_next$") then
				local data_name = field:match("(.+)_next$")
				switch_skin(data_name, 1)
			end
		end
	end

	-- Close or update
	do
		local quit = false

		if fields.cancel then
			local temp = skin_temp[player]
			player_meta:set_string("character_creator:gender", temp.gender)
			player_meta:set_float("character_creator:width", temp.width)
			player_meta:set_float("character_creator:height", temp.height)
			skin_indexes[player] = table.copy(temp.indexes)
			skin_temp[player] = nil
			quit = true
		elseif fields.quit then
			skin_temp[player] = nil
			quit = true
		end

		if not quit then
			show_formspec(player)
		end
	end
	change_skin(player)
end)

minetest.register_chatcommand("character_creator", {
	func = function(name)
		minetest.after(0.5, function()
			local player = minetest.get_player_by_name(name)
			if player then
				show_formspec(player)
			end
		end)
	end
})

if minetest.global_exists("unified_inventory") then
	unified_inventory.register_button("character_creator", {
		type   = "image",
		image  = "inventory_plus_character_creator.png",
		action = show_formspec
	})
elseif minetest.global_exists("inventory_plus") then
	minetest.register_on_joinplayer(function(player)
		inventory_plus.register_button(player, "character_creator", "Character Creator")
	end)
	minetest.register_on_player_receive_fields(function(player, _, fields)
		if fields.character_creator then
			show_formspec(player)
		end
	end)
elseif not skinsdb and minetest.get_modpath("sfinv_buttons") then
	sfinv_buttons.register_button("character_creator", {
		image = "inventory_plus_character_creator.png",
		title = "Character Creator",
		action = show_formspec,
	})

elseif not skinsdb and not minetest.get_modpath("sfinv_buttons")
	and minetest.global_exists("sfinv") and sfinv.enabled then

	local old_func = sfinv.pages["sfinv:crafting"].get
	sfinv.override_page("sfinv:crafting", {
		get = function(self, player, context)
			local fs = old_func(self, player, context)
			return fs .. "image_button[0,0;1,1;inventory_plus_character_creator.png;character_creator;]"
		end
	})

	minetest.register_on_player_receive_fields(function(player, formname, fields)
		if fields.character_creator then
			show_formspec(player)
			return true
		end
	end)
end

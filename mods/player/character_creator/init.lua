character_creator = {}
character_creator.skins = dofile(minetest.get_modpath("character_creator") .. "/skins.lua")

local skinsdb
if minetest.get_modpath("skinsdb") and minetest.global_exists("skins") then
	skinsdb = skins
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

local skins = character_creator.skins
local skins_array = {}

minetest.after(0, function()
	local function associative_to_array(associative)
		local array = {}
		for key in pairs(associative) do
			table.insert(array, key)
		end
		return array
	end

	skins_array = {
		skin       = associative_to_array(skins.skin),
		face       = associative_to_array(skins.face),
		hair       = associative_to_array(skins.hair),
		hair_style = associative_to_array(skins.hair_style),
		eyes       = associative_to_array(skins.eyes),
		tshirt     = associative_to_array(skins.tshirt),
		pants      = associative_to_array(skins.pants),
		shoes      = associative_to_array(skins.shoes)
	}
end)

-- Saved skins_array indexes in this
local skin_indexes = {}

local function show_formspec(player)
	local indexes = skin_indexes[player]

	local formspec = "size[15,9.5]"
		.. "no_prepend[]"
		.. "bgcolor[#00000000]"
		-- Gender
		.. "button[10,;2.5,.5;male;Male]"
		.. "button[12.5,;2.5,.5;female;Female]"
		-- Height
		.. "button[10,1.1;2.5,.5;taller;Taller]"
		.. "button[10,2;2.5,.5;shorter;Shorter]"
		-- Width
		.. "button[12.5,1.1;2.5,.5;wider;Wider]"
		.. "button[12.5,2;2.5,.5;thinner;Thinner]"
		-- Skin
		.. "button[10,2.75;5,1;skin;" .. skins_array.skin[indexes.skin] .. "]"
		.. "button[10,2.75;1,1;skin_back;<<]"
		.. "button[14,2.75;1,1;skin_next;>>]"
		-- Face
		.. "button[10,3.5;5,1;face;" .. skins_array.face[indexes.face] .. "]"
		.. "button[10,3.5;1,1;face_back;<<]"
		.. "button[14,3.5;1,1;face_next;>>]"
		-- Hair
		.. "button[10,4.25;5,1;hair;" .. skins_array.hair[indexes.hair] .. "]"
		.. "button[10,4.25;1,1;hair_back;<<]"
		.. "button[14,4.25;1,1;hair_next;>>]"
		-- Hair Style
		.. "button[10,5;5,1;hair_style;" .. skins_array.hair_style[indexes.hair_style] .. "]"
		.. "button[10,5;1,1;hair_style_back;<<]"
		.. "button[14,5;1,1;hair_style_next;>>]"
		-- Eyes
		.. "button[10,5.75;5,1;eyes;" .. skins_array.eyes[indexes.eyes] .. "]"
		.. "button[10,5.75;1,1;eyes_back;<<]"
		.. "button[14,5.75;1,1;eyes_next;>>]"
		-- T-Shirt
		.. "button[10,6.5;5,1;tshirt;" .. skins_array.tshirt[indexes.tshirt] .. "]"
		.. "button[10,6.5;1,1;tshirt_back;<<]"
		.. "button[14,6.5;1,1;tshirt_next;>>]"
		-- Pants
		.. "button[10,7.25;5,1;pants;" .. skins_array.pants[indexes.pants] .. "]"
		.. "button[10,7.25;1,1;pants_back;<<]"
		.. "button[14,7.25;1,1;pants_next;>>]"
		-- Shoes
		.. "button[10,8;5,1;shoes;" .. skins_array.shoes[indexes.shoes] .. "]"
		.. "button[10,8;1,1;shoes_back;<<]"
		.. "button[14,8;1,1;shoes_next;>>]"
		-- Done
		.. "button_exit[10,9;2.5,.5;done;Done]"
		.. "button_exit[12.5,9;2.5,.5;cancel;Cancel]"

	minetest.show_formspec(player:get_player_name(), "character_creator", formspec)
end

local function load_skin(player)
	skin_indexes[player] = {}

	if not player:get_attribute("character_creator:gender") then
		player:set_attribute("character_creator:gender", skin_default.gender)
	end

	if not player:get_attribute("character_creator:width") then
		player:set_attribute("character_creator:width", skin_default.width)
	end

	if not player:get_attribute("character_creator:height") then
		player:set_attribute("character_creator:height", skin_default.height)
	end

	local function load_data(data_name)
		local key   = player:get_attribute("character_creator:" .. data_name)
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
	local function save_data(data_name)
		local indexes = skin_indexes[player]
		local index   = indexes[data_name]
		local key     = skins_array[data_name][index]
		player:set_attribute("character_creator:" .. data_name, key)
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
	local indexes = skin_indexes[player]
	local texture = ""
	local gender = player:get_attribute("character_creator:gender")

	local skin_key = skins_array.skin[indexes.skin]
	local skin = skins.skin[skin_key]
	texture = texture .. "(" .. skin .. ")"

	local face_key = skins_array.face[indexes.face]
	local face = skins.face[face_key][gender][skin_key]
	texture = texture .. "^(" .. face .. ")"

	local eyes_key = skins_array.eyes[indexes.eyes]
	local eyes = skins.eyes[eyes_key]
	texture = texture .. "^(" .. eyes .. ")"

	local hair_style = skins_array.hair_style[indexes.hair_style]
	local hair_key = skins_array.hair[indexes.hair]
	local hair = skins.hair[hair_key][gender][hair_style]
	texture = texture .. "^(" .. hair .. ")"

	local tshirt_key = skins_array.tshirt[indexes.tshirt]
	local tshirt = skins.tshirt[tshirt_key]
	texture = texture .. "^(" .. tshirt .. ")"

	local pants_key = skins_array.pants[indexes.pants]
	local pants = skins.pants[pants_key]
	texture = texture .. "^(" .. pants .. ")"

	local shoes_key = skins_array.shoes[indexes.shoes]
	local shoes = skins.shoes[shoes_key]
	texture = texture .. "^(" .. shoes .. ")"
	return texture
end

local function change_skin(player)
	local texture = get_texture(player)

	local width  = tonumber(player:get_attribute("character_creator:width"))
	local height = tonumber(player:get_attribute("character_creator:height"))

	player:set_properties({
		visual_size = {
			x = width,
			y = height
		}
	})

	local name = player:get_player_name()

	if minetest.get_modpath("multiskin") then
		multiskin.layers[name].skin = texture
		armor:set_player_armor(player)
		multiskin:set_player_textures(player, {textures = {texture}})
	elseif minetest.get_modpath("3d_armor") then
		armor.textures[name].skin = texture
		armor:set_player_armor(player)
	else
		player:set_properties({textures = {texture}})
	end

	save_skin(player)
end

if skinsdb then
	--change skin redefinition for skinsdb
	function change_skin(player)
		local playername = player:get_player_name()
		local skinname = "character_creator:"..playername
		local skin_obj = skinsdb.get(skinname) or skinsdb.new(skinname)
		skin_obj:set_meta("format", "1.0")
		skin_obj:set_meta("visual_size_x", tonumber(player:get_attribute("character_creator:width")))
		skin_obj:set_meta("visual_size_y", tonumber(player:get_attribute("character_creator:height")))
		skin_obj:apply_skin_to_player(player)
		skinsdb.assign_player_skin(player, "character_creator:"..playername)
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

		-- set data
		skin_obj:set_preview("inventory_plus_character_creator.png")
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

	local indexes = skin_indexes[player]
	if not skin_temp[player] then
		skin_temp[player] = {
			gender = player:get_attribute("character_creator:gender"),
			width = player:get_attribute("character_creator:width"),
			height = player:get_attribute("character_creator:height"),
			indexes = table.copy(indexes)
		}
	end

	-- Gender
	do
		if fields.male then
			player:set_attribute("character_creator:gender", "Male")
			player:set_attribute("character_creator:width", 1)
			player:set_attribute("character_creator:height", 1)
		end

		if fields.female then
			player:set_attribute("character_creator:gender", "Female")
			player:set_attribute("character_creator:width", 0.95)
			player:set_attribute("character_creator:height", 1)
		end
	end

	-- Height
	do
		local height = tonumber(player:get_attribute("character_creator:height"))

		if fields.taller and height < 1.25 then
			player:set_attribute("character_creator:height", height + 0.05)
		end

		if fields.shorter and height > 0.75 then
			player:set_attribute("character_creator:height", height - 0.05)
		end
	end

	-- Width
	do
		local width = tonumber(player:get_attribute("character_creator:width"))

		if fields.wider and width < 1.25 then
			player:set_attribute("character_creator:width", width + 0.05)
		end

		if fields.thinner and width > 0.75 then
			player:set_attribute("character_creator:width", width - 0.05)
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
			player:set_attribute("character_creator:gender", temp.gender)
			player:set_attribute("character_creator:width", temp.width)
			player:set_attribute("character_creator:height", temp.height)
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
end

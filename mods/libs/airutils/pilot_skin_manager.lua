local S = airutils.S

airutils.pilot_textures = {"pilot_clothes1.png","pilot_clothes2.png","pilot_clothes3.png","pilot_clothes4.png",
        "pilot_novaskin_girl.png","pilot_novaskin_girl_steampunk.png","pilot_novaskin_girl_2.png","pilot_novaskin_girl_steampunk_2.png"}
local skinsdb_mod_path = minetest.get_modpath("skinsdb")
local backup = "airutils:bcp_last_skin"
local curr_skin = "airutils:skin"

minetest.register_chatcommand("au_uniform", {
    func = function(name, param)
		local player = minetest.get_player_by_name(name)

		if player then
			if skinsdb_mod_path then
				local skdb_skin = skins.get_player_skin(player)
				if skdb_skin:get_meta("format") == "1.8" then
					minetest.chat_send_player(name, S("Sorry, but uniform cannot be applied to format 1.8 skins."))
					return
				end
			end
			airutils.uniform_formspec(name)
		else
			minetest.chat_send_player(name, S("Something isn't working..."))
		end
    end,
})

local set_player_textures =
	minetest.get_modpath("player_api") and player_api.set_textures
	or default.player_set_textures

if skinsdb_mod_path then
	-- Enhance apply_skin_to_player for all skins
	local orig_apply_skin_to_player = skins.skin_class.apply_skin_to_player
	function skins.skin_class:apply_skin_to_player(player)
		local orig_texture = self:get_texture()
		local player_meta = player:get_meta()
		local pilot_skin = player_meta:get_string("pilot_skin")
		if pilot_skin ~= "" then
			if self:get_meta("format") == "1.8" then
				-- format 1.8 is not suported
				orig_apply_skin_to_player(self, player)
			else
				local orig_get_texture = self.get_texture
				function self:get_texture()
					return "[combine:64x32:0,0="..orig_texture.."^"..pilot_skin
				end
				orig_apply_skin_to_player(self, player)
				self.get_texture = orig_get_texture
			end
		else
			orig_apply_skin_to_player(self, player)
		end
	end
end

function airutils.set_player_skin(player, skin)
    if not player then return end

	-- use skinsdb enhancement
	if skinsdb_mod_path then
		local player_meta = player:get_meta()
		player_meta:set_string("pilot_skin", skin)
		local skdb_skin = skins.get_player_skin(player)
		skdb_skin:apply_skin_to_player(player)
		return
	end

	-- manage byself
    local player_properties = player:get_properties()
    if not player_properties then return end

    local texture = player_properties.textures
    local name = player:get_player_name()
    if texture then
        local player_meta = player:get_meta()
        if skin then
            --get current texture
            texture = texture[1]

            --backup current texture
            local backup = player_meta:get_string("backup")
            if backup == nil or backup == "" then
                --player:set_attribute(backup, texture) --texture backup
                player_meta:set_string("backup",texture)
            else
                texture = backup
            end

            --combine the texture
            texture = texture.."^"..skin

            --sets the combined texture
            if texture ~= nil and texture ~= "" then
                set_player_textures(player, {texture})
                player_meta:set_string("curr_skin",texture)
                --player:set_attribute(curr_skin, texture)
            end
        else
            --remove texture
            local old_texture = player_meta:get_string("backup")
            if set_skin then
                if player:get_attribute("set_skin:player_skin") ~= nil and player:get_attribute("set_skin:player_skin") ~= "" then
                    old_texture = player:get_attribute("set_skin:player_skin")
                end
            elseif wardrobe then
                if wardrobe.playerSkins then
                    if wardrobe.playerSkins[name] ~= nil then
                        old_texture = wardrobe.playerSkins[name]
                    end
                end
            end
            --minetest.chat_send_all(dump(old_texture))
            if old_texture ~= nil and old_texture ~= "" then
                set_player_textures(player, { old_texture })
            end
            player_meta:set_string("backup","")
            player_meta:set_string("curr_skin","")

            --player:set_attribute(backup, nil)
            --player:set_attribute(curr_skin, nil)
        end
    end
end

function airutils.uniform_formspec(name)
    local basic_form = table.concat({
        "formspec_version[5]",
        "size[5,2.9]",
	}, "")

    --minetest.chat_send_all(dump(airutils.pilot_textures))

    local textures = ""
    if airutils.pilot_textures then
        for k, v in pairs( airutils.pilot_textures ) do
            textures = textures .. v .. ","
        end

	    basic_form = basic_form.."dropdown[0.5,0.5;4,0.8;textures;".. textures ..";0;false]"
        basic_form = basic_form.."button[0.5,1.6;4,0.8;set_texture;" .. S("Set Player Texture") .. "]"

        minetest.show_formspec(name, "airutils:change", basic_form)
    else
        minetest.chat_send_player(name, S("The isn't activated as secure. Aborting"))
    end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "airutils:change" then
        local name = player:get_player_name()
		if fields.textures or fields.set_texture then
            airutils.set_player_skin(player, fields.textures)
		end
        minetest.close_formspec(name, "airutils:change")
    end
end)

minetest.register_on_joinplayer(function(player)
    local player_meta = player:get_meta()
    local skin = player_meta:get_string("curr_skin")
    --minetest.chat_send_all(">>>"..skin)

	if skin and skin ~= "" and skin ~= nil then
		-- setting player skin on connect has no effect, so delay skin change
		minetest.after(3, function(player1, skin1)
            airutils.set_player_skin(player1, skin1)
		end, player, skin)
	end
end)

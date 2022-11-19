hidroplane={}
hidroplane.gravity = tonumber(minetest.settings:get("movement_gravity")) or 9.8
hidroplane.wing_angle_of_attack = 3
hidroplane.min_speed = 6
hidroplane.max_speed = 6
hidroplane.max_engine_acc = 7 --4.5
hidroplane.lift = 10 --12
hidroplane.trunk_slots = 6

hidroplane.colors ={
    black='#2b2b2b',
    blue='#0063b0',
    brown='#8c5922',
    cyan='#07B6BC',
    dark_green='#567a42',
    dark_grey='#6d6d6d',
    green='#4ee34c',
    grey='#9f9f9f',
    magenta='#ff0098',
    orange='#ff8b0e',
    pink='#ff62c6',
    red='#dc1818',
    violet='#a437ff',
    white='#FFFFFF',
    yellow='#ffe400',
}

dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_global_definitions.lua")
dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_crafts.lua")
dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_control.lua")
dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_fuel_management.lua")
dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_custom_physics.lua")
dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_utilities.lua")
dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_entities.lua")
dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_manual.lua")
dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_forms.lua")

--
-- helpers and co.
--

--
-- items
--

settings = Settings(minetest.get_worldpath() .. "/hidroplane_settings.conf")
local function fetch_setting(name)
    local sname = name
    return settings and settings:get(sname) or minetest.settings:get(sname)
end

hidroplane.restricted = fetch_setting("restricted")

minetest.register_privilege("flight_licence", {
    description = "Gives a flight licence to the player",
    give_to_singleplayer = true
})

-- add chatcommand to eject from hydroplane

minetest.register_chatcommand("hydro_eject", {
	params = "",
	description = "Ejects from hydroplane",
	privs = {interact = true},
	func = function(name, param)
        local colorstring = core.colorize('#ff0000', " >>> you are not inside your hydroplane")
        local player = minetest.get_player_by_name(name)
        local attached_to = player:get_attach()

		if attached_to ~= nil then
            local seat = attached_to:get_attach()
            if seat ~= nil then
                local entity = seat:get_luaentity()
                if entity then
                    if entity.driver_name == name and entity.name == "hidroplane:hidro" then
                        hidroplane.dettachPlayer(entity, player)
                    else
			            minetest.chat_send_player(name,colorstring)
                    end
                end
            end
		else
			minetest.chat_send_player(name,colorstring)
		end
	end
})

minetest.register_chatcommand("hydro_manual", {
	params = "",
	description = "Hydroplane operation manual",
	privs = {interact = true},
	func = function(name, param)
        hidroplane.manual_formspec(name)
	end
})


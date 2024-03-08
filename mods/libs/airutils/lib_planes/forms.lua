dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "lib_planes" .. DIR_DELIM .. "global_definitions.lua")
local S = airutils.S
--------------
-- Manual --
--------------

function airutils.getPlaneFromPlayer(player)
    local seat = player:get_attach()
    if seat then
        local plane = seat:get_attach()
        return plane
    end
    return nil
end

function airutils.pilot_formspec(name)
    local player = minetest.get_player_by_name(name)
    local plane_obj = airutils.getPlaneFromPlayer(player)
    if plane_obj == nil then
        return
    end
    local ent = plane_obj:get_luaentity()

    local flap_is_down = "false"
    local have_flaps = false
    if ent._wing_angle_extra_flaps then
        if ent._wing_angle_extra_flaps > 0 then
            have_flaps = true
        end
    end
    if have_flaps then
        if ent._flap then flap_is_down = "true" end
    end

    local light = "false"
    if ent._have_landing_lights then
        if ent._land_light then light = "true" end
    end

    local autopilot = "false"
    if ent._have_auto_pilot then
        if ent._autopilot then autopilot = "true" end
    end

    local yaw = "false"
    if ent._yaw_by_mouse then yaw = "true" end

    local eng_status = "false"
    local eng_status_color = "#ff0000"
    if ent._engine_running then
        eng_status = "true"
        eng_status_color = "#00ff00"
    end

    local ver_pos = 1.0
    local basic_form = ""
	--basic_form = basic_form.."button[1,"..ver_pos..";4,1;turn_on;Start/Stop Engines]"
    basic_form = basic_form.."checkbox[1,"..ver_pos..";turn_on;"..core.colorize(eng_status_color, S("Start/Stop Engines"))..";"..eng_status.."]"
    ver_pos = ver_pos + 1.1
	basic_form = basic_form.."button[1,"..ver_pos..";4,1;hud;" .. S("Show/Hide Gauges") .. "]"
    ver_pos = ver_pos + 1.1
	basic_form = basic_form.."button[1,"..ver_pos..";4,1;inventory;" .. S("Show Inventory") .. "]"
    ver_pos = ver_pos + 1.5

    basic_form = basic_form.."checkbox[1,"..ver_pos..";yaw;" .. S("Yaw by mouse") .. ";"..yaw.."]"
    ver_pos = ver_pos + 0.5

	basic_form = basic_form.."button[1,"..ver_pos..";4,1;go_out;" .. S("Go Out!") .. "]"

    --form second part
    local expand_form = false
    ver_pos = 1.2 --restart in second collumn
    if have_flaps then
        basic_form = basic_form.."checkbox[6,"..ver_pos..";flap_is_down;" .. S("Flaps down") .. ";"..flap_is_down.."]"
        ver_pos = ver_pos + 0.5
        expand_form = true
    end

    if ent._have_landing_lights then
        basic_form = basic_form.."checkbox[6,"..ver_pos..";light;" .. S("Landing Light") .. ";"..light.."]"
        ver_pos = ver_pos + 0.5
        expand_form = true
    end

    if ent._have_auto_pilot then
        basic_form = basic_form.."checkbox[6,"..ver_pos..";turn_auto_pilot_on;" .. S("Autopilot") .. ";"..autopilot.."]"
        ver_pos = ver_pos + 0.5
        expand_form = true
    end
    
    if ent._have_copilot and name == ent.driver_name then
        basic_form = basic_form.."button[6,"..ver_pos..";4,1;copilot_form;" .. S("Co-pilot Manager") .. "]"
        ver_pos = ver_pos + 1.25
        expand_form = true
    end

    if ent._have_adf then
        basic_form = basic_form.."button[6,"..ver_pos..";4,1;adf_form;" .. S("Adf Manager") .. "]"
        ver_pos = ver_pos + 1.1
        expand_form = true
    end

    if ent._have_manual then
    	basic_form = basic_form.."button[6,5.2;4,1;manual;" .. S("Manual") .. "]"
        expand_form = true
    end

    local form_width = 6
    if expand_form then form_width = 11 end
    local form = table.concat({
        "formspec_version[3]",
        "size["..form_width..",7.2]",
	}, "")

    minetest.show_formspec(name, "lib_planes:pilot_main", form..basic_form)
end

function airutils.manage_copilot_formspec(name)
    local player = minetest.get_player_by_name(name)
    local plane_obj = airutils.getPlaneFromPlayer(player)
    if plane_obj == nil then
        return
    end
    local ent = plane_obj:get_luaentity()

    local pass_list = ""
    for k, v in pairs(ent._passengers) do
        pass_list = pass_list .. v .. ","
    end

    local basic_form = table.concat({
        "formspec_version[3]",
        "size[6,4.5]",
	}, "")

    basic_form = basic_form.."label[1,1.0;" .. S("Bring a copilot") .. ":]"

    local max_seats = table.getn(ent._seats)
    if ent._have_copilot and max_seats > 2 then --no need to select if there are only 2 occupants
        basic_form = basic_form.."dropdown[1,1.5;4,0.6;copilot;"..pass_list..";0;false]"
    end

    basic_form = basic_form.."button[1,2.5;4,1;pass_control;" .. S("Pass the Control") .. "]"

    minetest.show_formspec(name, "lib_planes:manage_copilot", basic_form)
end

function airutils.adf_formspec(name)
    local player = minetest.get_player_by_name(name)
    local plane_obj = airutils.getPlaneFromPlayer(player)
    if plane_obj == nil then
        return
    end
    local ent = plane_obj:get_luaentity()

    local adf = "false"
    if ent._adf then adf = "true" end
    local x = 0
    local z = 0
    if ent._adf_destiny then
        if ent._adf_destiny.x then
            if type(ent._adf_destiny.x) ~= nil then
                x = math.floor(ent._adf_destiny.x)
            end
        end
        if ent._adf_destiny.z then
            if type(ent._adf_destiny.z) ~= nil then
                z = math.floor(ent._adf_destiny.z)
            end
        end
    else
        --return
    end

    local basic_form = table.concat({
        "formspec_version[3]",
        "size[6,3.5]",
	}, "")

    basic_form = basic_form.."checkbox[1.0,1.0;adf;" .. S("Auto Direction Find") .. ";"..adf.."]"
    basic_form = basic_form.."field[1.0,1.7;1.5,0.6;adf_x;pos x;"..x.."]"
    basic_form = basic_form.."field[2.8,1.7;1.5,0.6;adf_z;pos z;"..z.."]"
    basic_form = basic_form.."button[4.5,1.7;0.6,0.6;save_adf;" .. S("OK") .. "]"

    minetest.show_formspec(name, "lib_planes:adf_main", basic_form)
end

function airutils.pax_formspec(name)
    local basic_form = table.concat({
        "formspec_version[3]",
        "size[6,5]",
	}, "")

	basic_form = basic_form.."button[1,1.0;4,1;new_seat;" .. S("Change Seat") .. "]"
	basic_form = basic_form.."button[1,2.5;4,1;go_out;" .. S("Go Offboard") .. "]"

    minetest.show_formspec(name, "lib_planes:passenger_main", basic_form)
end

function airutils.go_out_confirmation_formspec(name)
    local basic_form = table.concat({
        "formspec_version[3]",
        "size[7,2.2]",
	}, "")

    basic_form = basic_form.."label[0.5,0.5;" .. S("Do you really want to go offboard now?") .. "]"
	basic_form = basic_form.."button[1.3,1.0;2,0.8;no;" .. S("No") .. "]"
	basic_form = basic_form.."button[3.6,1.0;2,0.8;yes;" .. S("Yes") .. "]"

    minetest.show_formspec(name, "lib_planes:go_out_confirmation_form", basic_form)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == "lib_planes:go_out_confirmation_form" then
        local name = player:get_player_name()
        local plane_obj = airutils.getPlaneFromPlayer(player)
        if plane_obj == nil then
            minetest.close_formspec(name, "lib_planes:go_out_confirmation_form")
            return
        end
        local ent = plane_obj:get_luaentity()
        if ent then
		    if fields.yes then
                airutils.dettach_pax(ent, player, true)
		    end
        end
        minetest.close_formspec(name, "lib_planes:go_out_confirmation_form")
    end
	if formname == "lib_planes:adf_main" then
        local name = player:get_player_name()
        local plane_obj = airutils.getPlaneFromPlayer(player)
        if plane_obj == nil then
            minetest.chat_send_player(name, core.colorize('#ff0000', S(" >>> There is something wrong with the plane...")))
            minetest.close_formspec(name, "lib_planes:adf_main")
            return
        end
        local ent = plane_obj:get_luaentity()
        if ent then
            if fields.adf then
                if ent._adf == true then
                    ent._adf = false
                    minetest.chat_send_player(name, core.colorize('#0000ff', S(" >>> ADF deactivated.")))
                else
                    ent._adf = true
                    minetest.chat_send_player(name, core.colorize('#00ff00', S(" >>> ADF activated.")))
                end
            end
            if fields.save_adf then
                if not ent._adf_destiny then ent._adf_destiny = {x=0,z=0} end
                if ent._adf_destiny then
                    if fields.adf_x and fields.adf_z then
                        if tonumber(fields.adf_x, 10) ~= nil and tonumber(fields.adf_z, 10) ~= nil then
                            ent._adf_destiny.x = tonumber(fields.adf_x, 10)
                            ent._adf_destiny.z = tonumber(fields.adf_z, 10)
                            minetest.chat_send_player(name, core.colorize('#00ff00', S(" >>> Destination written successfully.")))
                        else
                            minetest.chat_send_player(name, core.colorize('#ff0000', S(" >>> There is something wrong with the ADF fields values.")))
                        end
                    else
                        minetest.chat_send_player(name, core.colorize('#ff0000', S(" >>> Both ADF fields must be given to complete the operation.")))
                    end
                end
            end
        else
            minetest.chat_send_player(name, core.colorize('#ff0000', S(" >>> There is something wrong on ADF saving...")))
        end
        minetest.close_formspec(name, "lib_planes:adf_main")
	end
	if formname == "lib_planes:passenger_main" then
        local name = player:get_player_name()
        local plane_obj = airutils.getPlaneFromPlayer(player)
        if plane_obj == nil then
            minetest.close_formspec(name, "lib_planes:passenger_main")
            return
        end
        local ent = plane_obj:get_luaentity()
        if ent then
		    if fields.new_seat then
                airutils.dettach_pax(ent, player)
                airutils.attach_pax(ent, player)
		    end
		    if fields.go_out then
                local touching_ground, liquid_below = airutils.check_node_below(plane_obj, 2.5)
                if ent.isinliquid or touching_ground then --isn't flying?
                    airutils.dettach_pax(ent, player)
                else
                    airutils.go_out_confirmation_formspec(name)
                end
		    end
        end
        minetest.close_formspec(name, "lib_planes:passenger_main")
	end
	if formname == "lib_planes:pilot_main" then
        local name = player:get_player_name()
        local plane_obj = airutils.getPlaneFromPlayer(player)
        if plane_obj then
            local ent = plane_obj:get_luaentity()
		    if fields.turn_on then
                airutils.start_engine(ent)
		    end
            if fields.hud then
                if ent._show_hud == true then
                    ent._show_hud = false
                else
                    ent._show_hud = true
                end
            end
		    if fields.go_out then
                local touch_point = ent.initial_properties.collisionbox[2]-1.0
                -----////
                local is_on_ground = false
                local pos = plane_obj:get_pos()
                pos.y = pos.y + touch_point
                local node_below = minetest.get_node(pos).name
                local nodedef = minetest.registered_nodes[node_below]
                is_on_ground = not nodedef or nodedef.walkable or false -- unknown nodes are solid

                if ent.driver_name == name and ent.owner == ent.driver_name then --just the owner can do this
                    --minetest.chat_send_all(dump(noded))
                    if is_on_ground then --or clicker:get_player_control().sneak then
                        --minetest.chat_send_all(dump("is on ground"))
                        --remove the passengers first                
                        local max_seats = table.getn(ent._seats)
                        for i = max_seats,1,-1
                        do 
                            --minetest.chat_send_all("index: "..i.." - "..dump(ent._passengers[i]))
                            if ent._passengers[i] then
                                local passenger = minetest.get_player_by_name(ent._passengers[i])
                                if passenger then airutils.dettach_pax(ent, passenger) end
                            end
                        end
                        ent._instruction_mode = false
                    else
                        -- not on ground
                        if ent.co_pilot then
                            --give the control to the pax
                            ent._autopilot = false
                            airutils.transfer_control(ent, true)
                            ent._command_is_given = true
                            ent._instruction_mode = true
                        end
                    end
                    airutils.dettachPlayer(ent, player)
                elseif ent.owner == name then --just the owner too, but not driving
                    airutils.dettachPlayer(ent, player)
                else --anyone
                    airutils.dettach_pax(ent, player)
                end
		    end
            if fields.inventory then
                if ent._trunk_slots then
                    airutils.show_vehicle_trunk_formspec(ent, player, ent._trunk_slots)
                end
            end
            if fields.flap_is_down then
                if fields.flap_is_down == "true" then
                    ent._flap = true
                else
                    ent._flap = false
                end
                minetest.sound_play("airutils_collision", {
                    object = ent.object,
                    max_hear_distance = 15,
                    gain = 1.0,
                    fade = 0.0,
                    pitch = 0.5,
                }, true)
            end
            if fields.light then
                if ent._land_light == true then
                    ent._land_light = false
                else
                    ent._land_light = true
                end
            end
            if fields.yaw then
                if ent._yaw_by_mouse == true then
                    ent._yaw_by_mouse = false
                else
                    ent._yaw_by_mouse = true
                end
            end
            if fields.copilot_form then
                airutils.manage_copilot_formspec(name)
            end
            if fields.adf_form then
                airutils.adf_formspec(name)
            end
		    if fields.turn_auto_pilot_on then
                if ent._autopilot == true then
                    ent._autopilot = false
                else
                    ent._autopilot = true
                end
		    end
            if fields.manual then
                if ent._have_manual then
                    ent._have_manual(name)
                end
            end
        end
        minetest.close_formspec(name, "lib_planes:pilot_main")
    end
    if formname == "lib_planes:manage_copilot" then
        local name = player:get_player_name()
        local plane_obj = airutils.getPlaneFromPlayer(player)
        if plane_obj == nil then
            minetest.close_formspec(name, "lib_planes:manage_copilot")
            return
        end
        local ent = plane_obj:get_luaentity()

	    if fields.copilot then
            --look for a free seat first
            local is_there_a_free_seat = false
            for i = 2,1,-1 
            do 
                if ent._passengers[i] == nil then
                    is_there_a_free_seat = true
                    break
                end
            end
            --then move the current copilot to a free seat
            if ent.co_pilot and is_there_a_free_seat then
                local copilot_player_obj = minetest.get_player_by_name(ent.co_pilot)
                if copilot_player_obj then
                    airutils.dettach_pax(ent, copilot_player_obj)
                    airutils.attach_pax(ent, copilot_player_obj)
                else
                    ent.co_pilot = nil
                end
            end
            --so bring the new copilot
            if ent.co_pilot == nil then
                local new_copilot_player_obj = minetest.get_player_by_name(fields.copilot)
                if new_copilot_player_obj then
                    airutils.dettach_pax(ent, new_copilot_player_obj)
                    airutils.attach_pax(ent, new_copilot_player_obj, true)
                end
            end
	    end
	    if fields.pass_control then
            if ent._command_is_given == true then
			    --take the control
			    airutils.transfer_control(ent, false)
            else
			    --trasnfer the control to student
			    airutils.transfer_control(ent, true)
            end
	    end
        minetest.close_formspec(name, "lib_planes:manage_copilot")
    end


end)

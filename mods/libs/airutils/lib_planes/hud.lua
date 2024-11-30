airutils.hud_list = {}
local S = airutils.S

function airutils.animate_gauge(player, ids, prefix, x, y, angle)
    local angle_in_rad = math.rad(angle + 180)
    local dim = 10
    local pos_x = math.sin(angle_in_rad) * dim
    local pos_y = math.cos(angle_in_rad) * dim
    player:hud_change(ids[prefix .. "2"], "offset", {x = pos_x + x, y = pos_y + y})
    dim = 20
    pos_x = math.sin(angle_in_rad) * dim
    pos_y = math.cos(angle_in_rad) * dim
    player:hud_change(ids[prefix .. "3"], "offset", {x = pos_x + x, y = pos_y + y})
    dim = 30
    pos_x = math.sin(angle_in_rad) * dim
    pos_y = math.cos(angle_in_rad) * dim
    player:hud_change(ids[prefix .. "4"], "offset", {x = pos_x + x, y = pos_y + y})
    dim = 40
    pos_x = math.sin(angle_in_rad) * dim
    pos_y = math.cos(angle_in_rad) * dim
    player:hud_change(ids[prefix .. "5"], "offset", {x = pos_x + x, y = pos_y + y})
    dim = 50
    pos_x = math.sin(angle_in_rad) * dim
    pos_y = math.cos(angle_in_rad) * dim
    player:hud_change(ids[prefix .. "6"], "offset", {x = pos_x + x, y = pos_y + y})
    dim = 60
    pos_x = math.sin(angle_in_rad) * dim
    pos_y = math.cos(angle_in_rad) * dim
    player:hud_change(ids[prefix .. "7"], "offset", {x = pos_x + x, y = pos_y + y})
end

function airutils.update_hud(player, climb, speed, power, fuel)
    local player_name = player:get_player_name()

    local screen_pos_y = -150
    local screen_pos_x = 10

    local clb_gauge_x = screen_pos_x + 75
    local clb_gauge_y = screen_pos_y + 1
    local sp_gauge_x = screen_pos_x + 170
    local sp_gauge_y = clb_gauge_y

    local pwr_gauge_x = screen_pos_x + 330
    local pwr_gauge_y = clb_gauge_y

    local fu_gauge_x = screen_pos_x + 340
    local fu_gauge_y = clb_gauge_y

    local ids = airutils.hud_list[player_name]
    if ids then
        airutils.animate_gauge(player, ids, "clb_pt_", clb_gauge_x, clb_gauge_y, climb)
        airutils.animate_gauge(player, ids, "sp_pt_", sp_gauge_x, sp_gauge_y, speed)
        airutils.animate_gauge(player, ids, "pwr_pt_", pwr_gauge_x, pwr_gauge_y, power)
        airutils.animate_gauge(player, ids, "fu_pt_", fu_gauge_x, fu_gauge_y, fuel)
    else
        ids = {}

        ids["title"] = player:hud_add({
            hud_elem_type = "text",
            position  = {x = 0, y = 1},
            offset    = {x = screen_pos_x +140, y = screen_pos_y -100},
            text      = S("Flight Information"),
            alignment = 0,
            scale     = { x = 100, y = 30},
            number    = 0xFFFFFF,
        })

        ids["bg"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = screen_pos_x, y = screen_pos_y},
            text      = "airutils_hud_panel.png",
            scale     = { x = 0.5, y = 0.5},
            alignment = { x = 1, y = 0 },
        })

        ids["clb_pt_1"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = clb_gauge_x, y = clb_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })

        ids["clb_pt_2"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = clb_gauge_x, y = clb_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["clb_pt_3"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = clb_gauge_x, y = clb_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["clb_pt_4"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = clb_gauge_x, y = clb_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["clb_pt_5"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = clb_gauge_x, y = clb_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["clb_pt_6"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = clb_gauge_x, y = clb_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["clb_pt_7"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = clb_gauge_x, y = clb_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })

        ids["sp_pt_1"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = sp_gauge_x, y = sp_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["sp_pt_2"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = sp_gauge_x, y = sp_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["sp_pt_3"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = sp_gauge_x, y = sp_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["sp_pt_4"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = sp_gauge_x, y = sp_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["sp_pt_5"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = sp_gauge_x, y = sp_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["sp_pt_6"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = sp_gauge_x, y = sp_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["sp_pt_7"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = sp_gauge_x, y = sp_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })

        ids["pwr_pt_1"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = pwr_gauge_x, y = pwr_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })

        ids["pwr_pt_2"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = pwr_gauge_x, y = pwr_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["pwr_pt_3"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = pwr_gauge_x, y = pwr_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["pwr_pt_4"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = pwr_gauge_x, y = pwr_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["pwr_pt_5"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = pwr_gauge_x, y = pwr_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["pwr_pt_6"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = pwr_gauge_x, y = pwr_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["pwr_pt_7"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = pwr_gauge_x, y = pwr_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })

        ids["fu_pt_1"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = fu_gauge_x, y = fu_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })

        ids["fu_pt_2"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = fu_gauge_x, y = fu_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["fu_pt_3"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = fu_gauge_x, y = fu_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["fu_pt_4"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = fu_gauge_x, y = fu_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["fu_pt_5"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = fu_gauge_x, y = fu_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["fu_pt_6"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = fu_gauge_x, y = fu_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })
        ids["fu_pt_7"] = player:hud_add({
            hud_elem_type = "image",
            position  = {x = 0, y = 1},
            offset    = {x = fu_gauge_x, y = fu_gauge_y},
            text      = "airutils_ind_box.png",
            scale     = { x = 6, y = 6},
            alignment = { x = 1, y = 0 },
        })

        airutils.hud_list[player_name] = ids
    end
end


function airutils.remove_hud(player)
    if player then
        local player_name = player:get_player_name()
        --minetest.chat_send_all(player_name)
        local ids = airutils.hud_list[player_name]
        if ids then
            --player:hud_remove(ids["altitude"])
            --player:hud_remove(ids["time"])
            for key in pairs(ids) do
                player:hud_remove(ids[key])
            end
        end
        airutils.hud_list[player_name] = nil
    end

end

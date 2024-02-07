local function get_pointer(pointer_angle, gauge_center_x, gauge_center_y, full_pointer)
    full_pointer = full_pointer or 1
    local retval = ""
    local ind_pixel = "airutils_ind_box_2.png"

    pointer_img_size = 8
    local pointer_rad = math.rad(pointer_angle)
    local dim = 2*(pointer_img_size/2)
    local pos_x = math.sin(pointer_rad) * dim
    local pos_y = math.cos(pointer_rad) * dim
    retval = retval..(gauge_center_x+pos_x)..","..(gauge_center_y+pos_y).."="..ind_pixel..":"
    
    dim = 4*(pointer_img_size/2)
    pos_x = math.sin(pointer_rad) * dim
    pos_y = math.cos(pointer_rad) * dim
    retval = retval..(gauge_center_x+pos_x)..","..(gauge_center_y+pos_y).."="..ind_pixel..":"

    dim = 6*(pointer_img_size/2)
    pos_x = math.sin(pointer_rad) * dim
    pos_y = math.cos(pointer_rad) * dim
    retval = retval..(gauge_center_x+pos_x)..","..(gauge_center_y+pos_y).."="..ind_pixel..":"

    if full_pointer == 1 then
        dim = 8*(pointer_img_size/2)
        pos_x = math.sin(pointer_rad) * dim
        pos_y = math.cos(pointer_rad) * dim
        retval = retval..(gauge_center_x+pos_x)..","..(gauge_center_y+pos_y).."="..ind_pixel..":"

        dim = 10*(pointer_img_size/2)
        pos_x = math.sin(pointer_rad) * dim
        pos_y = math.cos(pointer_rad) * dim
        retval = retval..(gauge_center_x+pos_x)..","..(gauge_center_y+pos_y).."="..ind_pixel..":"
    end
    return retval
end

function airutils.plot_altimeter_gauge(self, scale, place_x, place_y)
    local bg_width_height = 100
    local pointer_img = 8   
    local gauge_center =  (bg_width_height / 2) - (pointer_img/2)
    local gauge_center_x = place_x + gauge_center
    local gauge_center_y = place_y + gauge_center


    --altimeter
    --[[local altitude = (height / 0.32) / 100
    local hour, minutes = math.modf( altitude )
    hour = math.fmod (hour, 10)
    minutes = minutes * 100
    minutes = (minutes * 100) / 100
    local minute_angle = (minutes*-360)/100
    local hour_angle = (hour*-360)/10 + ((minute_angle*36)/360)]]--

    --[[
    #### `[combine:<w>x<h>:<x1>,<y1>=<file1>:<x2>,<y2>=<file2>:...`

    * `<w>`: width
    * `<h>`: height
    * `<x>`: x position
    * `<y>`: y position
    * `<file>`: texture to combine

    Creates a texture of size `<w>` times `<h>` and blits the listed files to their
    specified coordinates.

    ]]--

    local altimeter = "^[resize:"..scale.."x"..scale.."^[combine:"..bg_width_height.."x"..bg_width_height..":"
                        ..place_x..","..place_y.."=airutils_altimeter_gauge.png:"

    --altimeter = altimeter..get_pointer(minute_angle+180, gauge_center_x, gauge_center_y, 1)
    --altimeter = altimeter..get_pointer(hour_angle+180, gauge_center_x, gauge_center_y, 0)

    return altimeter
end

function airutils.plot_fuel_gauge(self, scale, place_x, place_y)
    local bg_width_height = 100
    local pointer_img = 8   
    local gauge_center =  (bg_width_height / 2) - (pointer_img/2)
    local gauge_center_x = place_x + gauge_center
    local gauge_center_y = place_y + gauge_center

    --local fuel_percentage = (curr_level*100)/max_level
    --local fuel_angle = -(fuel_percentage*180)/100
    --minetest.chat_send_all(dump(fuel_angle))

    local fuel = "^[resize:"..scale.."x"..scale.."^[combine:"..bg_width_height.."x"..bg_width_height..":"
                        ..place_x..","..place_y.."=airutils_fuel_gauge.png:"

    --fuel = fuel..get_pointer(fuel_angle-90, gauge_center_x, gauge_center_y, 1)

    return fuel
end

function airutils.plot_speed_gauge(self, scale, place_x, place_y)
    local bg_width_height = 100
    local pointer_img = 8   
    local gauge_center =  (bg_width_height / 2) - (pointer_img/2)
    local gauge_center_x = place_x + gauge_center
    local gauge_center_y = place_y + gauge_center

    --local speed_percentage = (curr_level*100)/max_level
    --local speed_angle = -(speed_percentage*350)/100
    --minetest.chat_send_all(dump(fuel_angle))

    local speed = "^[resize:"..scale.."x"..scale.."^[combine:"..bg_width_height.."x"..bg_width_height..":"
                        ..place_x..","..place_y.."=airutils_speed_gauge.png:"

    --fuel = fuel..get_pointer(speed_angle-180, gauge_center_x, gauge_center_y, 1)

    return speed
end

function airutils.plot_power_gauge(self, scale, place_x, place_y)
    local bg_width_height = 100
    local pointer_img = 8   
    local gauge_center =  (bg_width_height / 2) - (pointer_img/2)
    local gauge_center_x = place_x + gauge_center
    local gauge_center_y = place_y + gauge_center

    --local speed_percentage = (curr_level*100)/max_level
    --local speed_angle = -(speed_percentage*350)/100
    --minetest.chat_send_all(dump(fuel_angle))

    local rpm = "^[resize:"..scale.."x"..scale.."^[combine:"..bg_width_height.."x"..bg_width_height..":"
                        ..place_x..","..place_y.."=airutils_rpm_gauge.png:"

    --fuel = fuel..get_pointer(speed_angle-180, gauge_center_x, gauge_center_y, 1)

    return rpm
end

-- Minetest 5.4.1 : airutils

airutils = {}

airutils.colors ={
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

airutils.fuel = {['biofuel:biofuel'] = 1,['biofuel:bottle_fuel'] = 1,
                ['biofuel:phial_fuel'] = 0.25, ['biofuel:fuel_can'] = 10}

if not minetest.settings:get_bool('airutils.disable_papi') then
    dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "airutils_papi.lua")
end
if not minetest.settings:get_bool('airutils.disable_tug') then
    dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "airutils_tug.lua")
end
if not minetest.settings:get_bool('airutils.disable_repair') then
    dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "airutils_repair.lua")
end
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "inventory_management.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "light.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "physics_lib.lua")

if player_api and not minetest.settings:get_bool('airutils.disable_uniforms') then
    dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "pilot_skin_manager.lua")
end

function airutils.remove(pos)
	local meta = core.get_meta(pos)
	if meta:get_string("dont_destroy") == "true" then
		-- when swapping it
		return
	end
end

function airutils.canDig(pos, player)
	local meta = core.get_meta(pos)
	return meta:get_string("dont_destroy") ~= "true"
		and player:get_player_name() == meta:get_string("owner")
end

function airutils.check_node_below(obj, how_low)
    local pos_below = obj:get_pos()
    if pos_below then
        pos_below.y = pos_below.y - how_low
        local node_below = minetest.get_node(pos_below).name
        local nodedef = minetest.registered_nodes[node_below]
        local touching_ground = not nodedef or -- unknown nodes are solid
		        nodedef.walkable or false
        local liquid_below = not touching_ground and nodedef.liquidtype ~= "none"
        return touching_ground, liquid_below
    end
    return nil, nil
end

function airutils.check_is_under_water(obj)
	local pos_up = obj:get_pos()
	pos_up.y = pos_up.y + 0.1
	local node_up = minetest.get_node(pos_up).name
	local nodedef = minetest.registered_nodes[node_up]
	local liquid_up = nodedef.liquidtype ~= "none"
	return liquid_up
end

function airutils.setText(self, vehicle_name)
    local properties = self.object:get_properties()
    local formatted = ""
    if self.hp_max then
        formatted = " Current hp: " .. string.format(
           "%.2f", self.hp_max
        )
    end
    if properties then
        properties.infotext = "Nice ".. vehicle_name .." of " .. self.owner .. "." .. formatted
        self.object:set_properties(properties)
    end
end

function airutils.transfer_control(self, status)
    if status == false then
        self._command_is_given = false
        if self._passenger then
            minetest.chat_send_player(self._passenger,
                core.colorize('#ff0000', " >>> The captain got the control."))
        end
        if self.driver_name then
            minetest.chat_send_player(self.driver_name,
                core.colorize('#00ff00', " >>> The control is with you now."))
        end
    else
        self._command_is_given = true
        if self._passenger then
            minetest.chat_send_player(self._passenger,
                core.colorize('#00ff00', " >>> The control is with you now."))
        end
        if self.driver_name then minetest.chat_send_player(self.driver_name," >>> The control was given.") end
    end
end

--returns 0 for old, 1 for new
function airutils.detect_player_api(player)
    local player_proterties = player:get_properties()
    local mesh = "character.b3d"
    if player_proterties.mesh == mesh or player_proterties.mesh == "max.b3d" then
        local models = player_api.registered_models
        local character = models[mesh]
        if character then
            if character.animations.sit.eye_height then
                return 1
            else
                return 0
            end
        end
    end

    return 0
end

local function get_nodedef_field(nodename, fieldname)
    if not minetest.registered_nodes[nodename] then
        return nil
    end
    return minetest.registered_nodes[nodename][fieldname]
end

--for 
function airutils.eval_vertical_interception(initial_pos, end_pos)
    local ret_y = nil
	local cast = minetest.raycast(initial_pos, end_pos, true, true)
	local thing = cast:next()
	while thing do
		if thing.type == "node" then
            local pos = thing.intersection_point
            if pos then
                local nodename = minetest.get_node(thing.under).name
                local drawtype = get_nodedef_field(nodename, "drawtype")
                if drawtype ~= "plantlike" then
                    ret_y = pos.y
                    break
                end
            end
        end
        thing = cast:next()
    end
    return ret_y
end

--lift
local function pitchroll2pitchyaw(aoa,roll)
	if roll == 0.0 then return aoa,0 end
	-- assumed vector x=0,y=0,z=1
	local p1 = math.tan(aoa)
	local y = math.cos(roll)*p1
	local x = math.sqrt(p1^2-y^2)
	local pitch = math.atan(y)
	local yaw=math.atan(x)*math.sign(roll)
	return pitch,yaw
end

local function lerp(a, b, c)
	return a + (b - a) * c
end
 
function airutils.quadBezier(t, p0, p1, p2)
	local l1 = lerp(p0, p1, t)
	local l2 = lerp(p1, p2, t)
	local quad = lerp(l1, l2, t)
	return quad
end

function airutils.get_ground_effect_lift(self, curr_pos, lift, wingspan)
    local half_wingspan = wingspan/2
    local lower_collision = self.initial_properties.collisionbox[2]
    local initial_pos = {x=curr_pos.x, y=curr_pos.y + lower_collision, z=curr_pos.z} --lets make my own table to avoid interferences

    if self._extra_lift == nil then self._extra_lift = 0 end
    if self._last_ground_effect_eval == nil then self._last_ground_effect_eval = 0 end

    self._last_ground_effect_eval = self._last_ground_effect_eval + self.dtime --dtime cames from airutils

    local ground_distance = wingspan
    if self._last_ground_effect_eval >= 0.25 then
        self._last_ground_effect_eval = 0
        self._last_ground_distance = ground_distance
        local ground_y = airutils.eval_vertical_interception(initial_pos, {x=initial_pos.x, y=initial_pos.y - half_wingspan, z=initial_pos.z})
        if ground_y then
            ground_distance = initial_pos.y - ground_y
        end
        --minetest.chat_send_all(dump(ground_distance))
    
        --smooth the curve
        local distance_factor = ((ground_distance) * 1) / (wingspan)
        local effect_factor = airutils.quadBezier(distance_factor, 0, wingspan, 0)
        if effect_factor < 0 then effect_factor = 0 end
        if effect_factor > 0 then
            effect_factor = math.abs( half_wingspan - effect_factor )
        end
        
        local lift_factor = ((effect_factor) * 1) / (half_wingspan) --agora isso é um percentual
        local max_extra_lift_percent = 0.5 * lift  --e aqui o maximo extra de sustentação
        local extra_lift = max_extra_lift_percent * lift_factor
        self._extra_lift = extra_lift
    end
    
    return self._extra_lift --return the value stored
end


-- velocity: velocity table
-- accel: current acceleration
-- longit_speed: the vehicle speed
-- roll: roll angle
-- curr_pos: current position
-- lift: lift factor (very simplified)
-- max_height: the max ceilling for the airplane
-- wingspan: for ground effect calculation
function airutils.getLiftAccel(self, velocity, accel, longit_speed, roll, curr_pos, lift, max_height, wingspan)
    if longit_speed == nil then longit_speed = 0 end
    wingspan = wingspan or 10
    local ground_effect_extra_lift = airutils.get_ground_effect_lift(self, curr_pos, lift, wingspan)
    --minetest.chat_send_all('lift: '.. lift ..' - extra lift: '.. ground_effect_extra_lift)
    lift = lift + ground_effect_extra_lift

    --lift calculations
    -----------------------------------------------------------
    max_height = max_height or 20000
    local wing_config = 0
    if self._wing_configuration then wing_config = self._wing_configuration end --flaps!
    
    local retval = accel
    if longit_speed > 1 then
        local angle_of_attack = math.rad(self._angle_of_attack + wing_config)
        --local acc = 0.8
        local daoa = deg(angle_of_attack)

        --to decrease the lift coefficient at hight altitudes
        local curr_percent_height = (100 - ((curr_pos.y * 100) / max_height))/100

	    local rotation=self.object:get_rotation()
	    local vrot = airutils.dir_to_rot(velocity,rotation)
	    
	    local hpitch,hyaw = pitchroll2pitchyaw(angle_of_attack,roll)

	    local hrot = {x=vrot.x+hpitch,y=vrot.y-hyaw,z=roll}
	    local hdir = airutils.rot_to_dir(hrot) --(hrot)
	    local cross = vector.cross(velocity,hdir)
	    local lift_dir = vector.normalize(vector.cross(cross,hdir))

        local lift_coefficient = (0.24*abs(daoa)*(1/(0.025*daoa+3))^4*math.sign(angle_of_attack))
        local lift_val = math.abs((lift*(vector.length(velocity)^2)*lift_coefficient)*curr_percent_height)
        --minetest.chat_send_all('lift: '.. lift_val)

        local lift_acc = vector.multiply(lift_dir,lift_val)
        --lift_acc=vector.add(vector.multiply(minetest.yaw_to_dir(rotation.y),acc),lift_acc)

        retval = vector.add(retval,lift_acc)
    end
    -----------------------------------------------------------
    -- end lift
    return retval
end

function airutils.get_plane_pitch(velocity, longit_speed, min_speed, angle_of_attack)
    local v_speed_factor = 0
    if longit_speed > min_speed then v_speed_factor = (velocity.y * math.rad(1)) end --the pitch for climbing os descenting
    local min_rotation_speed = min_speed/2
    local scale_pitch_graph = ((longit_speed-min_rotation_speed)*1)/min_rotation_speed --lets use the min rotation speed for reference to when we will start the control work
    if scale_pitch_graph > 1 then scale_pitch_graph = 1 end --normalize to 100%
    local pitch_by_longit_speed = 0
    if longit_speed > min_rotation_speed then --just start the rotation after the rotation speed
        pitch_by_longit_speed = airutils.quadBezier(scale_pitch_graph, 0, angle_of_attack, angle_of_attack) --here the magic happens using a bezier curve
    end
    return math.rad(pitch_by_longit_speed) + v_speed_factor
end

function airutils.adjust_attack_angle_by_speed(angle_of_attack, min_angle, max_angle, limit, longit_speed, ideal_step, dtime)
    --coloca em nivel gradualmente
    local factor = 0
    if angle_of_attack > max_angle then factor = -1 end
    if angle_of_attack < min_angle then factor = 1 end
    local correction = (limit*(longit_speed/5000)) * factor * (dtime/ideal_step)
    --minetest.chat_send_all("angle: "..angle_of_attack.." - correction: "..correction)
    local new_angle_of_attack = angle_of_attack + correction
    return new_angle_of_attack
end

function airutils.elevator_auto_correction(self, longit_speed, dtime, max_speed, elevator_angle, elevator_limit, ideal_step, intensity)
    intensity = intensity or 500
    if longit_speed <= 0 then return end
    local factor = 1
    
    if self._elevator_angle > 0 then factor = -1 end
    local ref_speed = longit_speed
    if ref_speed > max_speed then ref_speed = max_speed end
    local speed_scale = (elevator_limit + (elevator_limit/10)) - ((elevator_limit*ref_speed)/max_speed)
    local divisor = intensity
    speed_scale = speed_scale / divisor
    local correction = speed_scale * factor * (dtime/ideal_step)
    
    local before_correction = elevator_angle
    local new_elevator_angle = elevator_angle + correction

    if math.sign(before_correction) ~= math.sign(new_elevator_angle) then
        new_elevator_angle = 0
    end
    return new_elevator_angle
end

function airutils.set_paint(self, puncher, itmstck, texture_name)
    local item_name = ""
    if itmstck then item_name = itmstck:get_name() end

    if item_name == "automobiles_lib:painter" or item_name == "bike:painter" then
        --painting with bike painter
        local meta = itmstck:get_meta()
	    local colstr = meta:get_string("paint_color")
        --minetest.chat_send_all(dump(colstr))
        airutils.paint(self, colstr, texture_name)
        return true
    else
        --painting with dyes
        local split = string.split(item_name, ":")
        local color, indx, _
        if split[1] then _,indx = split[1]:find('dye') end
        if indx then
            for clr,_ in pairs(airutils.colors) do
                local _,x = split[2]:find(clr)
                if x then color = clr end
            end
            --lets paint!!!!
	        --local color = item_name:sub(indx+1)
	        local colstr = airutils.colors[color]
            --minetest.chat_send_all(color ..' '.. dump(colstr))
	        if colstr then
                airutils.paint(self, colstr, texture_name)
		        itmstck:set_count(itmstck:get_count()-1)
		        puncher:set_wielded_item(itmstck)
                return true
	        end
            -- end painting
        end
    end
    return false
end

--painting
function airutils.paint(self, colstr, texture_name)
    if colstr then
        self._color = colstr
        local l_textures = self.initial_properties.textures
        for _, texture in ipairs(l_textures) do
            local indx = texture:find(texture_name)
            if indx then
                l_textures[_] = texture_name.."^[multiply:".. colstr
            end
        end
	    self.object:set_properties({textures=l_textures})
    end
end

function airutils.getAngleFromPositions(origin, destiny)
    local angle_north = math.deg(math.atan2(destiny.x - origin.x, destiny.z - origin.z))
    if angle_north < 0 then angle_north = angle_north + 360 end
    return angle_north
end

function airutils.sit(player)
    --set_animation(frame_range, frame_speed, frame_blend, frame_loop)
    player:set_animation({x =  81, y = 160},30, 0, true)
end

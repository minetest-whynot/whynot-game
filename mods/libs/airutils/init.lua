-- Minetest 5.4.1 : airutils
airutils = {}

airutils.storage = minetest.get_mod_storage()

local storage = airutils.storage

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

airutils.S = nil

if(minetest.get_translator ~= nil) then
    airutils.S = minetest.get_translator(minetest.get_current_modname())

else
    airutils.S = function ( s ) return s end
end

local S = airutils.S

local load_blast_damage = storage:get_int("blast_damage")
airutils.blast_damage = true
-- 1 == true ---- 2 == false
if load_blast_damage == 2 then airutils.blast_damage = false end

airutils.is_minetest = minetest.get_modpath("player_api")
airutils.is_mcl = minetest.get_modpath("mcl_player")
airutils.is_repixture = minetest.get_modpath("rp_player")

airutils.fuel = {['biofuel:biofuel'] = 1,['biofuel:bottle_fuel'] = 1,
                ['biofuel:phial_fuel'] = 0.25, ['biofuel:fuel_can'] = 10,
                ['airutils:biofuel'] = 1,}

airutils.protect_in_areas = minetest.settings:get_bool('airutils_protect_in_areas')
airutils.debug_log = minetest.settings:get_bool('airutils_debug_log')

if not minetest.settings:get_bool('airutils_disable_papi') then
    dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "airutils_papi.lua")
end
if not minetest.settings:get_bool('airutils_disable_tug') then
    dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "airutils_tug.lua")
end
if not minetest.settings:get_bool('airutils_disable_repair') then
    dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "airutils_repair.lua")
end

airutils.splash_texture = "airutils_splash.png"
airutils.use_water_particles = false
if minetest.settings:get_bool('airutils_enable_water_particles', false) then
    airutils.use_water_particles = true
end

airutils._use_signs_api = true
if not minetest.get_modpath("signs_lib") then airutils._use_signs_api = false end
if minetest.settings:get_bool('airutils_disable_signs_api') then airutils._use_signs_api = false end

airutils.get_wind = dofile(minetest.get_modpath("airutils") .. DIR_DELIM ..'/wind.lua')
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "uuid_manager.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "common_entities.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "airutils_wind.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "water_splash.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "inventory_management.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "light.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "physics_lib.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "lib_planes" .. DIR_DELIM .. "init.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "lib_copter" .. DIR_DELIM .. "init.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "texture_management.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "attach_extern_ent.lua")
if airutils._use_signs_api then dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "text.lua") end

local is_biofuel_installed = false
if biomass then
    if biomass.convertible_groups then is_biofuel_installed = true end
end
local enable_internal_biofuel = minetest.settings:get_bool('airutils.force_enable_biofuel')
if not is_biofuel_installed or enable_internal_biofuel then
    dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "airutils_biofuel.lua")
end

if minetest.get_modpath("player_api") and not minetest.settings:get_bool('airutils.disable_uniforms') then
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
    if type(self.hp_max) ~= "number" then self.hp_max = 0.1 end --strange error when hpmax is NaN
    if self.hp_max then
        formatted = S(" Current hp: ") .. string.format(
           "%.2f", self.hp_max
        )
    end
    if properties then
        properties.infotext = S("Nice @1 of @2.@3", vehicle_name, self.owner, formatted)
        self.object:set_properties(properties)
    end
end

function airutils.transfer_control(self, status)
    if not self._have_copilot then return end
    if status == false then
        self._command_is_given = false
        if self.co_pilot then
            minetest.chat_send_player(self.co_pilot,
                core.colorize('#ff0000', S(" >>> The captain got the control.")))
        end
        if self.driver_name then
            minetest.chat_send_player(self.driver_name,
                core.colorize('#00ff00', S(" >>> The control is with you now.")))
        end
    else
        self._command_is_given = true
        if self.co_pilot then
            minetest.chat_send_player(self.co_pilot,
                core.colorize('#00ff00', S(" >>> The control is with you now.")))
        end
        if self.driver_name then minetest.chat_send_player(self.driver_name,S(" >>> The control was given.")) end
    end
end

--returns 0 for old, 1 for new
function airutils.detect_player_api(player)
    local player_proterties = player:get_properties()
    --local mesh = "character.b3d"
    --if player_proterties.mesh == mesh then
    if minetest.get_modpath("player_api") then
        local models = player_api.registered_models
        local character = models[player_proterties.mesh]
        --minetest.chat_send_all(dump(character));
        if character then
            if character.animations.sit.eye_height then
                --minetest.chat_send_all(dump(character.animations.sit.eye_height));
                if character.animations.sit.eye_height == 0.8 then
                    --minetest.chat_send_all("new model");
                    return 1
                else
                    --minetest.chat_send_all("new height");
                    return 2 --strange bug with armor ands skins returning 1.47
                end
            else
                --minetest.chat_send_all("old model");
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
    if not self._ground_effect_ammount_percent then self._ground_effect_ammount_percent = 0.5 end
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
        local max_extra_lift_percent = self._ground_effect_ammount_percent * lift  --e aqui o maximo extra de sustentação
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
function airutils.getLiftAccel(self, velocity, accel, longit_speed, roll, curr_pos, in_lift, max_height, wingspan)
    local new_velocity = vector.new(velocity)
    if not self._min_collective then --ignore if it is an helicopter
        --add wind to the lift calcs
        local wind = airutils.get_wind(curr_pos, 5)
        local accel_wind = vector.subtract(accel, wind)  --why? because I need to fake more speed when against the wind to gain lift
        local vel_wind = vector.multiply(accel_wind, self.dtime)
        new_velocity = vector.add(new_velocity, vel_wind)
    end

    if longit_speed == nil then longit_speed = 0 end
    wingspan = wingspan or 10
    local lift = in_lift
    if not airutils.ground_effect_is_disabled then
        local ground_effect_extra_lift = airutils.get_ground_effect_lift(self, curr_pos, in_lift, wingspan)
        lift = lift + ground_effect_extra_lift
    end

    --lift calculations
    -----------------------------------------------------------
    max_height = max_height or 20000
    local wing_config = 0
    if self._wing_configuration then wing_config = self._wing_configuration end --flaps!

    local retval = accel
    local min_speed = 1;
    if self._min_speed then min_speed = self._min_speed end
    min_speed = min_speed / 2

    local striped_velocity = vector.new(velocity)
    local cut_velocity = (min_speed * 1)/longit_speed
    striped_velocity.x = striped_velocity.x - (striped_velocity.x * cut_velocity)
    striped_velocity.z = striped_velocity.z - (striped_velocity.z * cut_velocity)

    local angle_of_attack = math.rad(self._angle_of_attack + wing_config)
    --local acc = 0.8
    local daoa = math.deg(angle_of_attack)
    --minetest.chat_send_all(dump(daoa))

    --to decrease the lift coefficient at hight altitudes
    local curr_percent_height = (100 - ((curr_pos.y * 100) / max_height))/100

    local rotation=self.object:get_rotation()
    local vrot = airutils.dir_to_rot(velocity,rotation)

    local hpitch,hyaw = pitchroll2pitchyaw(angle_of_attack,roll)

    local hrot = {x=vrot.x+hpitch,y=vrot.y-hyaw,z=roll}
    local hdir = airutils.rot_to_dir(hrot) --(hrot)
    local cross = vector.cross(velocity,hdir)
    local lift_dir = vector.normalize(vector.cross(cross,hdir))

    local lift_coefficient = (0.24*math.abs(daoa)*(1/(0.025*daoa+3))^4*math.sign(daoa))
    local lift_val = math.abs((lift*(vector.length(striped_velocity)^2)*lift_coefficient)*curr_percent_height)
    if lift_val < 1 then lift_val = 1 end -- hipotetical aerodinamic wing will have no "lift" for down

    if self._climb_speed then --for helicopters
        if (velocity.y) > self._climb_speed then lift_val = math.abs(airutils.gravity) end
    end
    if self._lift_dead_zone then
        if lift_val < (math.abs(airutils.gravity)+self._lift_dead_zone) and lift_val > (math.abs(airutils.gravity)-self._lift_dead_zone) then
            lift_val = math.abs(airutils.gravity)
        end
    end

    if airutils.show_lift then
        minetest.chat_send_player(airutils.show_lift,core.colorize('#ffff00', " >>> lift: "..lift_val))
    end

    local lift_acc = vector.multiply(lift_dir,lift_val)
    --lift_acc=vector.add(vector.multiply(minetest.yaw_to_dir(rotation.y),acc),lift_acc)

    retval = vector.add(retval,lift_acc)
    -----------------------------------------------------------
    -- end lift
    
    return retval
end

function airutils.get_plane_pitch(y_velocity, longit_speed, min_speed, angle_of_attack)
    local v_speed_factor = 0
    if longit_speed > 0 then v_speed_factor = (y_velocity * math.rad(2)) end --the pitch for climbing or descenting
    local min_rotation_speed = min_speed/2
    local pitch_by_longit_speed = 0
    if longit_speed > min_rotation_speed then --just start the rotation after the rotation speed
        local scale_pitch_graph = ((longit_speed-min_rotation_speed)*1)/min_rotation_speed --lets use the min rotation speed for reference to when we will start the control work
        if scale_pitch_graph > 1 then scale_pitch_graph = 1 end --normalize to 100%
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
            --[[for clr,_ in pairs(airutils.colors) do
                local _,x = split[2]:find(clr)
                if x then color = clr end
            end]]--
            --lets paint!!!!
	        local color = (item_name:sub(indx+1)):gsub(":", "")
	        local colstr = airutils.colors[color]
            --minetest.chat_send_all(color ..' '.. dump(colstr))
	        if colstr then
                airutils.paint(self, colstr, texture_name)
                if self._alternate_painting_texture and self._mask_painting_texture then
                    airutils.paint_with_mask(self, colstr, self._alternate_painting_texture, self._mask_painting_texture)
                end
		        itmstck:set_count(itmstck:get_count()-1)
                if puncher ~= nil then puncher:set_wielded_item(itmstck) end
                return true
	        end
            -- end painting
        end
    end
    return false
end

function airutils._set_name(self)
    if not airutils._use_signs_api then return end
    local l_textures = self.object:get_properties().textures   --self.initial_properties.textures
    for _, texture in ipairs(l_textures) do
        indx = texture:find('airutils_name_canvas.png')
        if indx then
            l_textures[_] = "airutils_name_canvas.png^"..airutils.convert_text_to_texture(self._ship_name, self._name_color or 0, self._name_hor_aligment or 0.8)
        end
    end
    self.object:set_properties({textures=l_textures})
end

--painting
function airutils.paint(self, colstr, texture_name)
    if not self then return end
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
    if minetest.get_modpath("emote") then emote.start(player:get_player_name(), "sit") end
end

local function get_norm_angle(angle)
    local new_angle = angle/360
    new_angle = (new_angle - math.floor(new_angle))*360
    if new_angle < -180 then new_angle = new_angle + 360 end
    if new_angle > 180 then new_angle = new_angle - 360 end
    return new_angle
end

function airutils.normalize_rotations(rotations)
    return {x = get_norm_angle(rotations.x), y = get_norm_angle(rotations.y), z = get_norm_angle(rotations.z)}
end

minetest.register_chatcommand("enable_blast_damage", {
    params = "<true/false>",
    description = S("Enable/disable explosion blast damage"),
    privs = {server=true},
    func = function(name, param)
        local command = param

        if command == "false" then
            airutils.blast_damage = false
            minetest.chat_send_player(name, S(">>> Blast damage by explosion is disabled"))
        else
            airutils.blast_damage = true
            minetest.chat_send_player(name, S(">>> Blast damage by explosion is enabled"))
        end
        local save = 2
        if airutils.blast_damage == true then save = 1 end
        storage:set_int("blast_damage", save)
    end,
})

minetest.register_chatcommand("transfer_ownership", {
    params = "<new_owner>",
    description = S("Transfer the property of a plane to another player"),
    privs = {interact=true},
	func = function(name, param)
        local player = minetest.get_player_by_name(name)
        local target_player = minetest.get_player_by_name(param)
        local attached_to = player:get_attach()

		if attached_to ~= nil then
            if target_player ~= nil then
                local seat = attached_to:get_attach()
                if seat ~= nil then
                    local entity = seat:get_luaentity()
                    if entity then
                        if entity.owner == name or minetest.check_player_privs(name, {protection_bypass=true}) then
                            entity.owner = param
                            minetest.chat_send_player(name,core.colorize('#00ff00', S(" >>> This plane now is property of: ")..param))
                        else
                            minetest.chat_send_player(name,core.colorize('#ff0000', S(" >>> only the owner or moderators can transfer this airplane")))
                        end
                    end
                end
            else
                minetest.chat_send_player(name,core.colorize('#ff0000', S(" >>> the target player must be logged in")))
            end
		else
			minetest.chat_send_player(name,core.colorize('#ff0000', S(" >>> you are not inside a plane to perform the command")))
		end
	end
})

minetest.register_chatcommand("eject_from_plane", {
	params = "",
	description = S("Ejects from a plane"),
	privs = {interact = true},
	func = function(name, param)
        local colorstring = core.colorize('#ff0000', S(" >>> you are not inside a plane"))
        local player = minetest.get_player_by_name(name)
        local attached_to = player:get_attach()

		if attached_to ~= nil then
            local seat = attached_to:get_attach()
            if seat ~= nil then
                local entity = seat:get_luaentity()
                if entity then
                    if entity.on_step == airutils.on_step then
                        if entity.driver_name == name then
                            airutils.dettachPlayer(entity, player)
                        elseif entity._passenger == name then
                            local passenger = minetest.get_player_by_name(entity._passenger)
                            airutils.dettach_pax(entity, passenger)
                        end
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

minetest.register_chatcommand("ground_effect", {
    params = "<on/off>",
    description = S("Enables/disables the ground effect (for debug purposes)"),
    privs = {server=true},
	func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if minetest.check_player_privs(name, {server=true}) then
            if param == "on" or param == "" then
                airutils.ground_effect_is_disabled = nil
                minetest.chat_send_player(name,core.colorize('#00ff00', S(" >>> Ground effect was turned on.")))
            elseif param == "off" then
                airutils.ground_effect_is_disabled = true
                minetest.chat_send_player(name,core.colorize('#0000ff', S(">>> Ground effect was turned off.")))
            end
        else
            minetest.chat_send_player(name,core.colorize('#ff0000', S(" >>> You need 'server' priv to run this command.")))
        end
	end
})

minetest.register_chatcommand("show_lift", {
    params = "<on/off>",
    description = S("Enables/disables the lift printing (for debug purposes)"),
    privs = {server=true},
	func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if minetest.check_player_privs(name, {server=true}) then
            if param == "on" or param == "" then
                airutils.show_lift = name
                minetest.chat_send_player(name,core.colorize('#0000ff', S(" >>> Lift printing turned on.")))
            elseif param == "off" then
                airutils.show_lift = nil
                minetest.chat_send_player(name,core.colorize('#00ff00', S(" >>> Lift printing turned off.")))
            end
        else
            minetest.chat_send_player(name,core.colorize('#ff0000', S(" >>> You need 'server' priv to run this command.")))
        end
	end
})

if airutils._use_signs_api then
    local function prefix_change(name, param)
        local colorstring = core.colorize('#ff0000', S(" >>> you are not inside a vehicle"))
        local player = minetest.get_player_by_name(name)
        if not player then return end
        local attached_to = player:get_attach()

        if attached_to ~= nil then
            local seat = attached_to:get_attach()
            if seat ~= nil then
                local entity = seat:get_luaentity()
                if entity then
                    if entity.owner == name or minetest.check_player_privs(name, {protection_bypass=true}) then
                        if param then
                            entity._ship_name = string.sub(param, 1, 40)
                        else
                            entity._ship_name = ""
                        end
                        airutils._set_name(entity)
                        minetest.chat_send_player(name,core.colorize('#00ff00', S(" >>> the vehicle name was changed")))
                    else
                        minetest.chat_send_player(name,core.colorize('#ff0000', S(" >>> only the owner or moderators can name this vehicle")))
                    end
                end
            end
        else
	        minetest.chat_send_player(name,colorstring)
        end
    end

    minetest.register_chatcommand("set_vehicle_name", {
	    params = "<name>",
	    description = S("this command is an alias for /set_prefix"),
	    privs = {interact = true},
	    func = prefix_change,
    })

    minetest.register_chatcommand("set_prefix", {
	    params = "<name>",
	    description = S("Sets the vehicle prefix"),
	    privs = {interact = true},
	    func = prefix_change,
    })
end

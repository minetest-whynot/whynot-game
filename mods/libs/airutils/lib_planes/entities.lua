dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "lib_planes" .. DIR_DELIM .. "global_definitions.lua")

local S = airutils.S

local function lib_change_color(self, colstr)
    airutils.param_paint(self, colstr)
end

function airutils.get_staticdata(self) -- unloaded/unloads ... is now saved
    return minetest.serialize({
        --stored_sound_handle = self.sound_handle,
        stored_energy = self._energy or 0,
        stored_owner = self.owner or "",
        stored_hp = self.hp_max or 10,
        stored_color = self._color or "#FFFFFF",
        stored_color_2 = self._color_2 or "#FFFFFF",
        stored_power_lever = self._power_lever or 0,
        stored_driver_name = self.driver_name or nil,
        stored_last_accell = self._last_accell or vector.new(),
        stored_inv_id = self._inv_id or nil,
        stored_flap = self._flap or false,
        stored_passengers = self._passengers or {},
        stored_adf_destiny = self._adf_destiny or vector.new(),
        stored_skin = self._skin or "",
        stored_vehicle_custom_data = self._vehicle_custom_data or nil,
        stored_ship_name = self._ship_name or "",
        remove = self._remove or false,
    })
end

function airutils.on_deactivate(self)
    airutils.save_inventory(self)
    local pos = self.object:get_pos()
    if airutils.debug_log then
        minetest.log("action","deactivating: "..self._vehicle_name.." from "..self.owner.." at position "..math.floor(pos.x)..","..math.floor(pos.y)..","..math.floor(pos.z))
    end
end

function airutils.on_activate(self, staticdata, dtime_s)
    local pos = self.object:get_pos()
    airutils.actfunc(self, staticdata, dtime_s)
    self._flap = false

    if staticdata ~= "" and staticdata ~= nil then
        local data = minetest.deserialize(staticdata) or {}
        self._energy = data.stored_energy or 0
        self.owner = data.stored_owner or ""
        self.hp_max = data.stored_hp or 10
        self._color = data.stored_color or "#FFFFFF"
        self._color_2 = data.stored_color_2 or data.stored_color --if it has no color 2, now it have!
        self._power_lever = data.stored_power_lever or 0
        self.driver_name = data.stored_driver_name or nil
        self._last_accell = data.stored_last_accell or vector.new()
        self._inv_id = data.stored_inv_id or nil
        if self._wing_angle_extra_flaps then self._flap = data.stored_flap or false end
        self._passengers = data.stored_passengers or {}
        self._adf_destiny = data.stored_adf_destiny or vector.new()
        self._skin = data.stored_skin or ""
        self._ship_name = data.stored_ship_name or ""
        self._remove = data.remove or false
        local custom_data = data.stored_vehicle_custom_data or nil
        if custom_data then
            self._vehicle_custom_data = custom_data
        else
            -- o macete aqui eh inicializar mesmo que não exista no escopo da entity
            self._vehicle_custom_data = {} --initialize it
        end
        --minetest.debug("loaded: ", self._energy)
        if self._engine_running then
            self._last_applied_power = -1 --signal to start
        end

        if self._remove == true then
            airutils.destroy_inventory(self)
            self.object:remove()
            return
        end
    end
    
    self._climb_rate = 0
    self._yaw = 0
    self._roll = 0
    self._pitch = 0

    if airutils.debug_log then
        minetest.log("action","activating: "..self._vehicle_name.." from "..self.owner.." at position "..math.floor(pos.x)..","..math.floor(pos.y)..","..math.floor(pos.z))
    end

    if self._register_parts_method then
        self._register_parts_method(self)
    end

    airutils.param_paint(self, self._color, self._color_2)

	self.object:set_armor_groups({immortal=1})

    local start_frame = 1
    local end_frame = self._anim_frames
    if self._anim_start_frame then
        start_frame = self._anim_start_frame
        end_frame = self._anim_start_frame + self._anim_frames
    end    

    self.object:set_animation({x = start_frame, y = end_frame}, 0, 0, true)
    if self.wheels then
        self.wheels:set_animation({x = 1, y = self._anim_frames}, 0, 0, true)
    end

	local inv = nil
    if self._inv_id then
        inv = minetest.get_inventory({type = "detached", name = self._inv_id})
    end
	-- if the game was closed the inventories have to be made anew, instead of just reattached
	if not inv then
        airutils.create_inventory(self, self._trunk_slots)
	else
	    self._inv = inv
    end

    --airutils.seats_create(self)
    self._passengers = {}
    if not self._vehicle_custom_data then self._vehicle_custom_data = {} end --initialize when it does not exists

    if self._flap then airutils.flap_on(self) end

    if self._vehicle_name then airutils.setText(self, self._vehicle_name) end

    self._change_color = lib_change_color

    --initialize array with seats
    airutils.seats_create(self)
end

function airutils.on_step(self,dtime,colinfo)
    self.dtime = math.min(dtime,0.2)
    self.colinfo = colinfo
    self.height = airutils.get_box_height(self)
    
--  physics comes first
    local vel = self.object:get_velocity()
    local pos = self.object:get_pos()
    local props = self.object:get_properties()

-- handle visibility on radar
    if (pos and pos.y < airutils.radarMinHeight and props.show_on_minimap) then
        props.show_on_minimap = false
        self.object:set_properties(props)
    end
    if (pos and pos.y >= airutils.radarMinHeight and not props.show_on_minimap) then
        props.show_on_minimap = true
        self.object:set_properties(props)
    end
    if self.isonground and props.show_on_minimap then
        props.show_on_minimap = false
        self.object:set_properties(props)
    end
    
    if colinfo then 
	    self.isonground = colinfo.touching_ground
    else
	    if self.lastvelocity.y==0 and vel.y==0 then
		    self.isonground = true
	    else
		    self.isonground = false
	    end
    end
    
    if self.hp_max <= 0 then
        airutils.destroy(self)
    end

    self:physics()

    if self.logic then
	    self:logic()
    end
    
    self.lastvelocity = self.object:get_velocity()
    self.time_total=self.time_total+self.dtime
end

local function ground_pitch(self, longit_speed, curr_pitch)
    local newpitch = curr_pitch
    if self._last_longit_speed == nil then self._last_longit_speed = 0 end

    -- Estado atual do sistema
    if self._current_value == nil then self._current_value = 0 end -- Valor atual do sistema
    if self._last_error == nil then self._last_error = 0 end -- Último erro registrado

    -- adjust pitch at ground
    if math.abs(longit_speed) < self._tail_lift_max_speed then
        local speed_range = self._tail_lift_max_speed - self._tail_lift_min_speed
        local percentage = 1-((math.abs(longit_speed) - self._tail_lift_min_speed)/speed_range)
        if percentage > 1 then percentage = 1 end
        if percentage < 0 then percentage = 0 end
        local angle = self._tail_angle * percentage
        local rad_angle = math.rad(angle)

        if newpitch < rad_angle then newpitch = rad_angle end --ja aproveita o pitch atual se ja estiver cerrto
        --[[self._current_value = curr_pitch
        local kp = (longit_speed - self._tail_lift_min_speed)/10
        local output, last_error = airutils.pid_controller(self._current_value, rad_angle, self._last_error, self.dtime, kp)
        self._last_error = last_error
        newpitch = output]]--

        if newpitch > math.rad(self._tail_angle) then newpitch = math.rad(self._tail_angle) end --não queremos arrastar o cauda no chão
    end
    
    return newpitch
end

function airutils.logic(self)
    local velocity = self.object:get_velocity()
    local rem_obj = self.object:get_attach()
    local extern_ent = nil
    if rem_obj then
        extern_ent = rem_obj:get_luaentity()
    end
    local curr_pos = self.object:get_pos()
    self._curr_pos = curr_pos --shared
    self._last_accel = self.object:get_acceleration()

    self._last_time_command = self._last_time_command + self.dtime

    if self._last_time_command > 1 then self._last_time_command = 1 end

    local player = nil
    if self.driver_name then player = minetest.get_player_by_name(self.driver_name) end
    local co_pilot = nil
    if self.co_pilot and self._have_copilot then co_pilot = minetest.get_player_by_name(self.co_pilot) end

    --test collision
    airutils.testImpact(self, velocity, curr_pos)

    --if self._autoflymode == true then airutils.seats_update(self) end

    if player then
        local ctrl = player:get_player_control()
        ---------------------
        -- change the driver
        ---------------------
        if co_pilot and self._have_copilot and self._last_time_command >= 1 then
            if self._command_is_given == true then
                if ctrl.sneak or ctrl.jump or ctrl.up or ctrl.down or ctrl.right or ctrl.left then
                    self._last_time_command = 0
                    --take the control
                    airutils.transfer_control(self, false)
                end
            else
                if ctrl.sneak == true and ctrl.jump == true then
                    self._last_time_command = 0
                    --trasnfer the control to student
                    airutils.transfer_control(self, true)
                end
            end
        end
        -----------
        --autopilot
        -----------
        if self._instruction_mode == false and self._last_time_command >= 1 then
            if self._autopilot == true then
                if ctrl.sneak or ctrl.jump or ctrl.up or ctrl.down or ctrl.right or ctrl.left then
                    self._last_time_command = 0
                    self._autopilot = false
                    minetest.chat_send_player(self.driver_name,S(" >>> Autopilot deactivated"))
                end
            else
                if ctrl.sneak == true and ctrl.jump == true and self._have_auto_pilot then
                    self._last_time_command = 0
                    self._autopilot = true
                    self._auto_pilot_altitude = curr_pos.y
                    minetest.chat_send_player(self.driver_name,core.colorize('#00ff00', S(" >>> Autopilot on")))
                end
            end
        end
    end

    if not self.object:get_acceleration() then return end
    local accel_y = self.object:get_acceleration().y
    local rotation = self.object:get_rotation()
    local yaw = rotation.y
	local newyaw=yaw
    local pitch = rotation.x
	local roll = rotation.z
	local newroll=roll
    newroll = math.floor(newroll/360)
    newroll = newroll * 360

    local hull_direction = airutils.rot_to_dir(rotation) --minetest.yaw_to_dir(yaw)
    local nhdir = {x=hull_direction.z,y=0,z=-hull_direction.x}		-- lateral unit vector

    local longit_speed = vector.dot(velocity,hull_direction)

    if extern_ent then
        if extern_ent.curr_speed then longit_speed = extern_ent.curr_speed end
        --minetest.chat_send_all(dump(longit_speed))
    end

    self._longit_speed = longit_speed
    local longit_drag = vector.multiply(hull_direction,longit_speed*
            longit_speed*self._longit_drag_factor*-1*airutils.sign(longit_speed))
	local later_speed = airutils.dot(velocity,nhdir)
    --minetest.chat_send_all('later_speed: '.. later_speed)
	local later_drag = vector.multiply(nhdir,later_speed*later_speed*
            self._later_drag_factor*-1*airutils.sign(later_speed))
    local accel = vector.add(longit_drag,later_drag)
    local stop = false

    local is_flying = true
    if self.colinfo then
        is_flying = (not self.colinfo.touching_ground) and (self.isinliquid == false)
    else
        --special routine for automated plane
        if extern_ent then
            if not extern_ent.on_rightclick then
                local touch_point = (self.initial_properties.collisionbox[2])-0.5
                local node_bellow = airutils.nodeatpos(airutils.pos_shift(curr_pos,{y=touch_point}))
                --minetest.chat_send_all(dump(node_bellow.drawtype))
                if (node_bellow and node_bellow.drawtype ~= 'airlike') then
	                is_flying = false
                end
            end
        end
    end
    --minetest.chat_send_all(dump(is_flying))
    --if is_flying then minetest.chat_send_all('is flying') end

    local is_attached = airutils.checkAttach(self, player)
    if self._indicated_speed == nil then self._indicated_speed = 0 end

    -- for some engine error the player can be detached from the machine, so lets set him attached again
    airutils.checkattachBug(self)


    if self._custom_step_additional_function then
        self._custom_step_additional_function(self)
    end

    --fix old planes
    if not self._flap then self._flap = false end
    if not self._wing_configuration then self._wing_configuration = self._wing_angle_of_attack end


    if self._wing_configuration == self._wing_angle_of_attack and self._flap then
        airutils.flap_on(self)
    end
    if self._wing_configuration ~= self._wing_angle_of_attack and self._flap == false then
        airutils.flap_off(self)
    end

    --landing light
    if self._have_landing_lights then
        airutils.landing_lights_operate(self)
    end

    --smoke and fire
    if self._engine_running then
        local curr_health_percent = (self.hp_max * 100)/self._max_plane_hp
        if curr_health_percent < 20 then
            airutils.add_smoke_trail(self, 2)
        elseif curr_health_percent < 50 then
            airutils.add_smoke_trail(self, 1)
        end
    else
        if self._smoke_spawner and not self._smoke_semaphore then
            self._smoke_semaphore = 1 --to set it only one time
            minetest.after(5, function()
                if self._smoke_spawner then
                    minetest.delete_particlespawner(self._smoke_spawner)
                    self._smoke_spawner = nil
                    self._smoke_semaphore = nil
                end
            end)
        end
    end

    --adjust elevator pitch (3d model)
    self.object:set_bone_position("elevator", self._elevator_pos, {x=-self._elevator_angle*2 - 90, y=0, z=0})
    --adjust rudder
    self.object:set_bone_position("rudder", self._rudder_pos, {x=0,y=self._rudder_angle,z=0})
    --adjust ailerons
    if self._aileron_r_pos and self._aileron_l_pos then
        local ailerons = self._rudder_angle
        if self._invert_ailerons then ailerons = ailerons * -1 end
        self.object:set_bone_position("aileron.r", self._aileron_r_pos, {x=-ailerons - 90,y=0,z=0})
        self.object:set_bone_position("aileron.l", self._aileron_l_pos, {x=ailerons - 90,y=0,z=0})
    end

    if (math.abs(velocity.x) < 0.1 and math.abs(velocity.z) < 0.1) and is_flying == false and is_attached == false and self._engine_running == false then
        if self._ground_friction then
            if not self.isinliquid then self.object:set_velocity({x=0,y=airutils.gravity*self.dtime,z=0}) end
        end
        return
    end

    --adjust climb indicator
    local y_velocity = 0
    if self._engine_running or is_flying then y_velocity = velocity.y end
    local climb_rate =  y_velocity
    if climb_rate > 5 then climb_rate = 5 end
    if climb_rate < -5 then
        climb_rate = -5
    end

    -- pitch
    local newpitch = airutils.get_plane_pitch(y_velocity, longit_speed, self._min_speed, self._angle_of_attack)

    --for airplanes with cannard or pendulum wing
    local actuator_angle = self._elevator_angle
    if self._inverted_pitch_reaction then actuator_angle = -1*self._elevator_angle end

    --is an stall, force a recover
    if longit_speed < (self._min_speed+0.5) and climb_rate < -1.5 and is_flying then
        if player and self.driver_name then
            --minetest.chat_send_player(self.driver_name,core.colorize('#ff0000', " >>> STALL"))
        end
        self._elevator_angle = 0
        actuator_angle = 0
        self._angle_of_attack = -1
        newpitch = math.rad(self._angle_of_attack)
    else
        --ajustar angulo de ataque
        if longit_speed > self._min_speed then
            local percentage = math.abs(((longit_speed * 100)/(self._min_speed + 5))/100)
            if percentage > 1.5 then percentage = 1.5 end

            self._angle_of_attack = self._wing_angle_of_attack - ((actuator_angle / self._elevator_response_attenuation)*percentage)

            --airutils.adjust_attack_angle_by_speed(angle_of_attack, min_angle, max_angle, limit, longit_speed, ideal_step, dtime)
            self._angle_of_attack = airutils.adjust_attack_angle_by_speed(self._angle_of_attack, self._min_attack_angle, self._max_attack_angle, 40, longit_speed, airutils.ideal_step, self.dtime)

            if self._angle_of_attack < self._min_attack_angle then
                self._angle_of_attack = self._min_attack_angle
                actuator_angle = actuator_angle - 0.2
            end --limiting the negative angle]]--
            --[[if self._angle_of_attack > self._max_attack_angle then
                self._angle_of_attack = self._max_attack_angle
                actuator_angle = actuator_angle + 0.2
            end --limiting the very high climb angle due to strange behavior]]--]]--

            if self._inverted_pitch_reaction then self._elevator_angle = -1*actuator_angle end --revert the reversion
            
        end
    end

    --minetest.chat_send_all(self._angle_of_attack)

    -- adjust pitch at ground
    if math.abs(longit_speed) > self._tail_lift_min_speed and is_flying == false then
        newpitch = ground_pitch(self, longit_speed, newpitch)
    else
        if math.abs(longit_speed) < self._tail_lift_min_speed then
            newpitch = math.rad(self._tail_angle)
        end
    end

    -- new yaw
	if math.abs(self._rudder_angle)>1.5 then
        local turn_rate = math.rad(self._yaw_turn_rate)
        local yaw_turn = self.dtime * math.rad(self._rudder_angle) * turn_rate *
                airutils.sign(longit_speed) * math.abs(longit_speed/2)
		newyaw = yaw + yaw_turn
	end

    --roll adjust
    ---------------------------------
    local delta = 0.002
    if is_flying then
        local roll_reference = newyaw
        local sdir = minetest.yaw_to_dir(roll_reference)
        local snormal = {x=sdir.z,y=0,z=-sdir.x}	-- rightside, dot is negative
        local prsr = airutils.dot(snormal,nhdir)
        local rollfactor = -90
        local roll_rate = math.rad(10)
        newroll = (prsr*math.rad(rollfactor)) * (later_speed * roll_rate) * airutils.sign(longit_speed)

        --[[local rollRotation = -self._rudder_angle * 0.1
        newroll = rollRotation]]--

        --minetest.chat_send_all('newroll: '.. newroll)
    else
        delta = 0.2
        if roll > 0 then
            newroll = roll - delta
            if newroll < 0 then newroll = 0 end
        end
        if roll < 0 then
            newroll = roll + delta
            if newroll > 0 then newroll = 0 end
        end
    end

    ---------------------------------
    -- end roll

    local pilot = player
    if self._have_copilot then
        if self._command_is_given and co_pilot then
            pilot = co_pilot
        else
            self._command_is_given = false
        end
    end

    ------------------------------------------------------
    --accell calculation block
    ------------------------------------------------------
    if is_attached or co_pilot then
        if self._autopilot ~= true then
            accel, stop = airutils.control(self, self.dtime, hull_direction,
                longit_speed, longit_drag, later_speed, later_drag, accel, pilot, is_flying)
        else
            accel = airutils.autopilot(self, self.dtime, hull_direction, longit_speed, accel, curr_pos)
        end
    end
    --end accell

    --get disconnected players
    if not self._autoflymode == true then
        airutils.rescueConnectionFailedPassengers(self)
    end

    if accel == nil then accel = {x=0,y=0,z=0} end

    --lift calculation
    accel.y = accel_y

    --lets apply some bob in water
	if self.isinliquid then
        local bob = airutils.minmax(airutils.dot(accel,hull_direction),0.02)	-- vertical bobbing
        if bob < 0 then bob = 0 end
        accel.y = accel.y + bob
        local max_pitch = 6
        local ref_speed = longit_speed * 20
        if ref_speed < 0 then ref_speed = 0 end
        local h_vel_compensation = ((ref_speed * 100)/max_pitch)/100
        if h_vel_compensation < 0 then h_vel_compensation = 0 end
        if h_vel_compensation > max_pitch then h_vel_compensation = max_pitch end
        --minetest.chat_send_all(h_vel_compensation)
        newpitch = newpitch + (velocity.y * math.rad(max_pitch - h_vel_compensation))

        if airutils.use_water_particles == true and airutils.add_splash and self._splash_x_position and self.buoyancy then
            local splash_frequency = 0.15
            if self._last_splash == nil then self._last_splash = 0.5 else self._last_splash = self._last_splash + self.dtime end
            if longit_speed >= 2.0 and self._last_vel and self._last_splash >= splash_frequency then
                self._last_splash = 0
                local splash_pos = vector.new(curr_pos)
                local bellow_position = self.initial_properties.collisionbox[2]
                local collision_height = self.initial_properties.collisionbox[5] - bellow_position
                splash_pos.y = splash_pos.y + (bellow_position + (collision_height * self.buoyancy)) - (collision_height/10)
                airutils.add_splash(splash_pos, newyaw, self._splash_x_position)
            end
        end
    end

    local new_accel = accel
    if longit_speed > self._min_speed*0.66 then
        --[[lets do something interesting:
        here I'll fake the longit speed effect for takeoff, to force the airplane
        to use more runway 
        ]]--
        local factorized_longit_speed = longit_speed
        if is_flying == false and airutils.quadBezier then
            local takeoff_speed = self._min_speed * 4  --so first I'll consider the takeoff speed 4x the minimal flight speed
            if longit_speed < takeoff_speed and longit_speed > self._min_speed then -- then if the airplane is above the mininam speed and bellow the take off
                local scale = (longit_speed*1)/takeoff_speed --get a scale of current longit speed relative to takeoff speed
                if scale == nil then scale = 0 end --lets avoid any nil
                factorized_longit_speed = airutils.quadBezier(scale, self._min_speed, longit_speed, longit_speed) --here the magic happens using a bezier curve
                --minetest.chat_send_all("factor: " .. factorized_longit_speed .. " - longit: " .. longit_speed .. " - scale: " .. scale)
                if factorized_longit_speed < 0 then factorized_longit_speed = 0 end --lets avoid negative numbers
                if factorized_longit_speed == nil then factorized_longit_speed = longit_speed end --and nil numbers
            end
        end

        local ceiling = 15000
        new_accel = airutils.getLiftAccel(self, velocity, new_accel, factorized_longit_speed, roll, curr_pos, self._lift, ceiling, self._wing_span)
    end
    -- end lift

    --wind effects
    if longit_speed > 1.5 and airutils.wind then
        local wind = airutils.get_wind(curr_pos, 0.1)
        new_accel = vector.add(new_accel, wind)
    end

    if stop ~= true then --maybe == nil
        self._last_accell = new_accel
	    self.object:move_to(curr_pos)
        --airutils.set_acceleration(self.object, new_accel)
        local limit = (self._max_speed/self.dtime)
        if new_accel.y > limit then new_accel.y = limit end --it isn't a rocket :/

    else
        if stop == true then
            self._last_accell = vector.new() --self.object:get_acceleration()
            self.object:set_acceleration({x=0,y=0,z=0})
            self.object:set_velocity({x=0,y=0,z=0})
        end
    end

    if self.wheels then
        if is_flying == false then --isn't flying?
            --animate wheels
            local min_speed_animation = 0.1
            if math.abs(velocity.x) > min_speed_animation or math.abs(velocity.z) > min_speed_animation then
                self.wheels:set_animation_frame_speed(longit_speed * 10)
            else
                if extern_ent then
                    self.wheels:set_animation_frame_speed(longit_speed * 10)
                else
                    self.wheels:set_animation_frame_speed(0)
                end
            end
        else
            --stop wheels
            self.wheels:set_animation_frame_speed(0)
        end
    end

    ------------------------------------------------------
    -- end accell
    ------------------------------------------------------

    ------------------------------------------------------
    -- sound and animation
    ------------------------------------------------------
    airutils.engine_set_sound_and_animation(self)

    ------------------------------------------------------

    --self.object:get_luaentity() --hack way to fix jitter on climb

    --GAUGES
    --minetest.chat_send_all('rate '.. climb_rate)
    local climb_angle = airutils.get_gauge_angle(climb_rate)
    self._climb_rate = climb_rate

    local indicated_speed = longit_speed * 0.9
    if indicated_speed < 0 then indicated_speed = 0 end
    self._indicated_speed = indicated_speed
    local speed_angle = airutils.get_gauge_angle(indicated_speed, -45)

    --adjust power indicator
    local power_indicator_angle = airutils.get_gauge_angle(self._power_lever/10) + 90
    local fuel_in_percent = (self._energy * 1)/self._max_fuel
    local energy_indicator_angle = (180*fuel_in_percent)-180    --(airutils.get_gauge_angle((self._max_fuel - self._energy)*2)) - 90

    if is_attached then
        if self._show_hud then
            airutils.update_hud(player, climb_angle, speed_angle, power_indicator_angle, energy_indicator_angle)
        else
            airutils.remove_hud(player)
        end
    end

    if is_flying == false then
        -- new yaw
        local turn_rate = math.rad(30)
        local yaw_turn = self.dtime * math.rad(self._rudder_angle) * turn_rate *
                    airutils.sign(longit_speed) * math.abs(longit_speed/2)
	    newyaw = yaw + yaw_turn
    end

    if player and self._use_camera_relocation then
        --minetest.chat_send_all(dump(newroll))
        local new_eye_offset = airutils.camera_reposition(player, newpitch, newroll)
        player:set_eye_offset(new_eye_offset, {x = 0, y = 1, z = -30})
    end

    --apply rotations
    self.object:set_rotation({x=newpitch,y=newyaw,z=newroll})
    --end

    if (longit_speed / 2) > self._max_speed and self._flap == true then
        if is_attached and self.driver_name then
            minetest.chat_send_player(self.driver_name, core.colorize('#ff0000', S(" >>> Flaps retracted due for overspeed")))
        end
        self._flap = false
    end

    -- calculate energy consumption --
    airutils.consumptionCalc(self, accel)

    --saves last velocity for collision detection (abrupt stop)
    self._last_accel = new_accel
    self._last_vel = self.object:get_velocity()
    self._last_longit_speed = longit_speed
    self._yaw = newyaw
    self._roll = newroll
    self._pitch = newpitch
end

local function damage_vehicle(self, toolcaps, ttime, damage)
    damage = damage or 0
    if (not toolcaps) then
        return
    end
    local value = toolcaps.damage_groups.fleshy or 0
    if (toolcaps.damage_groups.vehicle) then
        value = toolcaps.damage_groups.vehicle
    end
    damage = damage + value / 10
    self.hp_max = self.hp_max - damage
    airutils.setText(self, self._vehicle_name)
end

function airutils.on_punch(self, puncher, ttime, toolcaps, dir, damage)
    local name = ""
    local ppos = {}

    if not puncher or not puncher:is_player() then
		return
	end

    if (puncher:is_player()) then
	    name = puncher:get_player_name()
        ppos = puncher:get_pos()
        if (minetest.is_protected(ppos, name) and
            airutils.protect_in_areas) then
            return
        end
    end

    if self.hp_max <= 0 then
        airutils.destroy(self, name)
        return
    end
    if self._vehicle_name then airutils.setText(self, self._vehicle_name) end

    if (string.find(puncher:get_wielded_item():get_name(), "rayweapon") or 
        toolcaps.damage_groups.vehicle) then
            damage_vehicle(self, toolcaps, ttime, damage)
    end

    local is_admin = false
    is_admin = minetest.check_player_privs(puncher, {server=true})
    if self.owner == nil then
        self.owner = name
    end
    if self.owner and self.owner ~= name and self.owner ~= "" then
        if is_admin == false then return end
    end
    
    if is_admin == false and minetest.check_player_privs(puncher, {protection_bypass=false})  then
        if self.driver_name and self.driver_name ~= name then
		    -- do not allow other players to remove the object while there is a driver
		    return
	    end
    end
    
    local is_attached = false
    local player_attach = puncher:get_attach()
    if player_attach then
        if player_attach ~= self.object then
            local slot_attach = player_attach:get_attach()
            if slot_attach == self.object then is_attached = true end
        else
            is_attached = true
        end
    end
    
    if puncher:get_attach() == self.object then is_attached = true end
    --if puncher:get_attach() == self.pilot_seat_base then is_attached = true end

    local itmstck=puncher:get_wielded_item()
    local item_name = ""
    if itmstck then item_name = itmstck:get_name() end

    if is_attached == false then
        if airutils.loadFuel(self, puncher:get_player_name()) then
            return
        end

        --repair
        if (item_name == "airutils:repair_tool")
                and self._engine_running == false  then
            if self.hp_max < self._max_plane_hp then
                local inventory_item = "default:steel_ingot"
                local inv = puncher:get_inventory()
                if inv:contains_item("main", inventory_item) then
                    local stack = ItemStack(inventory_item .. " 1")
                    inv:remove_item("main", stack)
                    self.hp_max = self.hp_max + 10
                    if self.hp_max > self._max_plane_hp then self.hp_max = self._max_plane_hp end
                    airutils.setText(self, self._vehicle_name)
                else
                    minetest.chat_send_player(puncher:get_player_name(), S("You need steel ingots in your inventory to perform this repair."))
                end
            end
            return
        end

        -- deal with painting or destroying
	    if itmstck then
		    if airutils.set_param_paint(self, puncher, itmstck, 1) == false then
			    if not self.driver and toolcaps and toolcaps.damage_groups
                        and toolcaps.groupcaps and (toolcaps.groupcaps.choppy or toolcaps.groupcaps.axey_dig) and item_name ~= airutils.fuel then
				    --airutils.hurt(self,toolcaps.damage_groups.fleshy - 1)
				    --airutils.make_sound(self,'hit')
                    damage_vehicle(self, toolcaps, ttime, damage)
                    minetest.sound_play(self._collision_sound, {
                        object = self.object,
                        max_hear_distance = 5,
                        gain = 1.0,
                        fade = 0.0,
                        pitch = 1.0,
                    })
                    airutils.setText(self, self._vehicle_name)
			    end
		    end
        end

        if self.hp_max <= 0 then
            airutils.destroy(self, name)
        end
    else
        if self._custom_punch_when_attached then self._custom_punch_when_attached(self, puncher) end
    end
end

--returns the vehicle to inventory if it is registered as a tool
local function get_vehicle(self, player)
    if not player then return false end

    local itmstck=player:get_wielded_item()
    local item_name = ""
    if itmstck then item_name = itmstck:get_name() end
    --remove
    if (item_name == "airutils:repair_tool") and self._engine_running == false  then

        local lua_ent = self.object:get_luaentity()
        local staticdata = lua_ent:get_staticdata(self)
        local obj_name = lua_ent.name

        local stack = ItemStack(obj_name)
        local max = stack:get_stack_max()
        local tool = false
        if stack:get_stack_max() == 1 then tool = true end

        if tool == false then return false end

        local stack_meta = stack:get_meta()
        stack_meta:set_string("staticdata", staticdata)

        local inv = player:get_inventory()
        if inv then
            if inv:room_for_item("main", stack) then
                inv:add_item("main", stack)
            else
                minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5}, stack)
            end
        else
            minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5}, stack)
        end

        airutils.seats_destroy(self)
        local obj_children = self.object:get_children()
        for _, child in ipairs(obj_children) do
            child:remove()
        end
        airutils.destroy_inventory(self)
        self.object:remove()

        return true
    end
    
    return false
end

function airutils.on_rightclick(self, clicker)
    local message = ""
	if not clicker or not clicker:is_player() then
		return
	end

    local name = clicker:get_player_name()

    if self.owner == "" then
        self.owner = name
    end

    local copilot_name = nil
    if self.co_pilot and self._have_copilot then
        copilot_name = self.co_pilot
    end

    --minetest.chat_send_all(dump(self.driver_name))

    local touching_ground, liquid_below = airutils.check_node_below(self.object, 2.5)
    local is_on_ground = self.isinliquid or touching_ground or liquid_below
    local is_under_water = airutils.check_is_under_water(self.object)

    --minetest.chat_send_all('name '.. dump(name) .. ' - pilot: ' .. dump(self.driver_name) .. ' - pax: ' .. dump(copilot_name))
    --=========================
    --  form to pilot
    --=========================
    local is_attached = false
    local seat = clicker:get_attach()
    if seat then
        local plane = seat:get_attach()
        if plane == self.object then is_attached = true end
    end
    
    if name == self.driver_name then
        if is_attached then
            local itmstck=clicker:get_wielded_item()
            local item_name = ""
            if itmstck then item_name = itmstck:get_name() end
            --adf program function
            if (item_name == "compassgps:cgpsmap_marked") then
                local meta = minetest.deserialize(itmstck:get_metadata())
                if meta then
                    self._adf_destiny = {x=meta["x"], z=meta["z"]}
                end
            else
                --formspec of the plane
                if not self._custom_pilot_formspec then
                    airutils.pilot_formspec(name)
                else
                    self._custom_pilot_formspec(name)
                end
                airutils.sit(clicker)
            end
        else
            self.driver_name = nil --error, so clean it
        end
    --=========================
    --  detach copilot
    --=========================
    elseif name == copilot_name then
        if self._command_is_given then
            --formspec of the plane
            if not self._custom_pilot_formspec then
                airutils.pilot_formspec(name)
            else
                self._custom_pilot_formspec(name)
            end
        else
            airutils.pax_formspec(name)
        end

    --=========================
    --  attach pilot
    --=========================
    elseif not self.driver_name and not self._autoflymode then
        if self.owner == name or minetest.check_player_privs(clicker, {protection_bypass=true}) then

            local itmstck=clicker:get_wielded_item()
            local item_name = ""
            if itmstck then item_name = itmstck:get_name() end

	        if itmstck then
		        if airutils.set_param_paint(self, clicker, itmstck, 2) == true then
                    return
		        end
                if get_vehicle(self, clicker) then
                    return
                end
            end

            if clicker:get_player_control().sneak == true then --lets see the inventory
                airutils.show_vehicle_trunk_formspec(self, clicker, self._trunk_slots)
            else
                if is_under_water then return end

                --remove the passengers first                
                local max_seats = table.getn(self._seats)
                for i = max_seats,1,-1
                do 
                    if self._passengers[i] and self._passengers[i] ~= "" then
                        local passenger = minetest.get_player_by_name(self._passengers[i])
                        if passenger then airutils.dettach_pax(self, passenger) end
                    end
                end

                --attach player
                --airutils.seat_create(self, 1)
                --airutils.seat_create(self, 2)
                if clicker:get_player_control().aux1 == true and max_seats > 1 then
                    -- flight instructor mode
                    self._instruction_mode = true
                    self.co_pilot_seat_base = self._passengers_base[1]
                    self.pilot_seat_base = self._passengers_base[2]
                else
                    -- no driver => clicker is new driver
                    self._instruction_mode = false
                    self.co_pilot_seat_base = self._passengers_base[2]
                    self.pilot_seat_base = self._passengers_base[1]
                end
                airutils.attach(self, clicker)
                self._command_is_given = false
            end
        else
            airutils.dettach_pax(self, clicker)
            minetest.chat_send_player(name, core.colorize('#ff0000', S(" >>> You aren't the owner of this "..self.infotext..".")))
        end

    --=========================
    --  attach passenger
    --=========================
    elseif self.driver_name ~= nil or self._autoflymode == true then
        local d_name = self.driver_name
        if d_name == nil then d_name = "" end
        local player = minetest.get_player_by_name(d_name)
        if player or self._autoflymode == true then
            is_attached = airutils.check_passenger_is_attached(self, name)

            if is_attached then
                --remove pax
                airutils.pax_formspec(name)
            else
                --attach normal passenger
                airutils.attach_pax(self, clicker)
            end

        else
            minetest.chat_send_player(clicker:get_player_name(), message)
        end
    else
        minetest.chat_send_player(clicker:get_player_name(), message)
    end

end


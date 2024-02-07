dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "lib_planes" .. DIR_DELIM .. "global_definitions.lua")
dofile(minetest.get_modpath("airutils") .. DIR_DELIM .. "lib_planes" .. DIR_DELIM .. "hud.lua")

local S = airutils.S

function airutils.properties_copy(origin_table)
    local tablecopy = {}
    for k, v in pairs(origin_table) do
      tablecopy[k] = v
    end
    return tablecopy
end

function airutils.get_hipotenuse_value(point1, point2)
    return math.sqrt((point1.x - point2.x) ^ 2 + (point1.y - point2.y) ^ 2 + (point1.z - point2.z) ^ 2)
end

function airutils.dot(v1,v2)
	return v1.x*v2.x+v1.y*v2.y+v1.z*v2.z
end

function airutils.sign(n)
	return n>=0 and 1 or -1
end

function airutils.minmax(v,m)
	return math.min(math.abs(v),m)*airutils.sign(v)
end

function airutils.get_gauge_angle(value, initial_angle)
    initial_angle = initial_angle or 90
    local angle = value * 18
    angle = angle - initial_angle
    angle = angle * -1
	return angle
end

local function sit_player(player, name)
    if not player then return end
    if airutils.is_minetest then
        player_api.player_attached[name] = true
        player_api.set_animation(player, "sit")
    elseif airutils.is_mcl then
		mcl_player.player_attached[name] = true
        mcl_player.player_set_animation(player, "sit" , 30)
        airutils.sit(player)
    end

    -- make the driver sit
    minetest.after(1, function()
        if player then
            --minetest.chat_send_all("okay")
            airutils.sit(player)
            --apply_physics_override(player, {speed=0,gravity=0,jump=0})
        end
    end)
end

-- attach player
function airutils.attach(self, player, instructor_mode)
    if not player then return end
    if self._needed_licence then
        local can_fly = minetest.check_player_privs(player, self._needed_licence)
        if not can_fly then
            minetest.chat_send_player(player:get_player_name(), core.colorize('#ff0000', S(' >>> You need the priv') .. '"'..self._needed_licence..'" ' .. S('to fly this plane.')))
            return
        end
    end

    instructor_mode = instructor_mode or false
    local name = player:get_player_name()
    self.driver_name = name

    -- attach the driver
    local eye_y = 0
    if instructor_mode == true and self._have_copilot then
        eye_y = -4
        player:set_attach(self.co_pilot_seat_base, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
    else
        eye_y = -4
        player:set_attach(self.pilot_seat_base, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
    end
    if airutils.detect_player_api(player) == 1 then
        eye_y = eye_y + 6.5
    end
    if airutils.detect_player_api(player) == 2 then
        eye_y = -4
    end
    
    player:set_eye_offset({x = 0, y = eye_y, z = 2}, {x = 0, y = 1, z = -30})
    sit_player(player, name)
end


function airutils.dettachPlayer(self, player)
    local name = self.driver_name
    airutils.setText(self, self._vehicle_name)

    airutils.remove_hud(player)

    --self._engine_running = false

    -- driver clicked the object => driver gets off the vehicle
    self.driver_name = nil

    -- detach the player
    --player:set_physics_override({speed = 1, jump = 1, gravity = 1, sneak = true})
    if player then
        player:set_detach()
        player:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
        if airutils.is_minetest then
            player_api.player_attached[name] = nil
            player_api.set_animation(player, "stand")
        elseif airutils.is_mcl then
            mcl_player.player_attached[name] = nil
            mcl_player.player_set_animation(player, "stand")
        end
    end
    self.driver = nil
    --remove_physics_override(player, {speed=1,gravity=1,jump=1})
end

function airutils.check_passenger_is_attached(self, name)
    local is_attached = false
    if self._passenger == name then is_attached = true end
    if is_attached == false then
        local max_occupants = table.getn(self._seats)
        for i = max_occupants,1,-1 
        do 
            if self._passengers[i] == name then
                is_attached = true
                break
            end
        end
    end
    return is_attached
end

local function attach_copilot(self, name, player, eye_y)
    if not self.co_pilot_seat_base or not player then return end
    self.co_pilot = name
    self._passengers[2] = name
    -- attach the driver
    player:set_attach(self.co_pilot_seat_base, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
    player:set_eye_offset({x = 0, y = eye_y, z = 2}, {x = 0, y = 3, z = -30})

    sit_player(player, name)
end

-- attach passenger
function airutils.attach_pax(self, player, is_copilot)
    if not player then return end
    local is_copilot = is_copilot or false
    local name = player:get_player_name()

    local eye_y = -4
    if airutils.detect_player_api(player) == 1 then
        eye_y = 2.5
    end

    if is_copilot == true then
        if self.co_pilot == nil then
            attach_copilot(self, name, player, eye_y)
        end
    else
        --randomize the seat
        local max_seats = table.getn(self._seats)
        local crew = 1
        if self._have_copilot and max_seats > 2 then
            crew = crew + 1
        else
            attach_copilot(self, name, player, eye_y)
            return
        end

        t = {}    -- new array
        for i=1, max_seats - crew do --(the first are for the crew
            t[i] = i
        end

        for i = 1, #t*2 do
            local a = math.random(#t)
            local b = math.random(#t)
            t[a],t[b] = t[b],t[a]
        end

        --for i = 1,10,1 do
        for k,v in ipairs(t) do
            i = t[k] + crew --jump the crew seats
            if self._passengers[i] == nil then
                --minetest.chat_send_all(self.driver_name)
                self._passengers[i] = name
                player:set_attach(self._passengers_base[i], "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
                player:set_eye_offset({x = 0, y = eye_y, z = 0}, {x = 0, y = 3, z = -30})

                sit_player(player, name)
                break
            end
        end

    end
end

function airutils.dettach_pax(self, player, is_flying)
    if not player then return end
    is_flying = is_flying or false
    local name = player:get_player_name() --self._passenger

    -- passenger clicked the object => driver gets off the vehicle
    if self.co_pilot == name then
        self.co_pilot = nil
        self._passengers[2] = nil
    else
        local max_seats = table.getn(self._seats)
        for i = max_seats,1,-1
        do 
            if self._passengers[i] == name then
                self._passengers[i] = nil
                break
            end
        end
    end

    -- detach the player
    if player then
        local pos = player:get_pos()
        player:set_detach()
        if is_flying then
            pos.y = pos.y - self.initial_properties.collisionbox[2] - 2
            player:set_pos(pos)
        end

        if airutils.is_minetest then
            player_api.player_attached[name] = nil
            player_api.set_animation(player, "stand")
        elseif airutils.is_mcl then
            mcl_player.player_attached[name] = nil
            mcl_player.player_set_animation(player, "stand")
        end

        player:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
        --remove_physics_override(player, {speed=1,gravity=1,jump=1})
    end
end

function airutils.checkAttach(self, player)
    if player then
        local player_attach = player:get_attach()
        if player_attach then
            local max_seats = table.getn(self._seats)
            for i = max_seats,1,-1
            do
                if player_attach == self._passengers_base[i] then
                    return true
                end
            end
        end
    end
    return false
end

local function spawn_drops(self, pos)
    if self._drops then
        for k,v in pairs(self._drops) do
            --print(k,v)
            for i=1,v do
                minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},k)
            end
        end
    end
end

function airutils.destroy(self, by_name)
    by_name = by_name or ""
    local with_fire = self._enable_fire_explosion
    local owner = self.owner
    if by_name == owner then with_fire = false end
    local pos = self.object:get_pos()
    local rot = self.object:get_rotation()
    local trunk_slots = self._trunk_slots
    local inv_id = self._inv_id
    if pos == nil then return end

    if owner and self._vehicle_name then
        minetest.log("action", "airutils: The player "..owner.." had it's "..self._vehicle_name.." destroyed at position x="..math.floor(pos.x).." y="..math.floor(pos.y).." z="..math.floor(pos.z))
    else
        minetest.log("action", "airutils: An airplane was destroyed at position x="..math.floor(pos.x).." y="..math.floor(pos.y).." z="..math.floor(pos.z))
    end

    if self.sound_handle then
        minetest.sound_stop(self.sound_handle)
        self.sound_handle = nil
    end

    --remove the passengers first                
    local max_seats = table.getn(self._seats)
    for i = max_seats,2,-1
    do 
        if self._passengers[i] then
            local passenger = minetest.get_player_by_name(self._passengers[i])
            if passenger then airutils.dettach_pax(self, passenger) end
        end
    end

    if self.driver_name then
        -- detach the driver
        local player = minetest.get_player_by_name(self.driver_name)
        airutils.dettachPlayer(self, player)
    end

    airutils.add_destruction_effects(pos, 5, with_fire)

    airutils.seats_destroy(self)
    if self._destroy_parts_method then
        self._destroy_parts_method(self)
    end

    local destroyed_ent = nil
    if self._destroyed_ent then
        destroyed_ent = self._destroyed_ent
    end

    --if dont have a destroyed version, destroy the inventory
    if not destroyed_ent then
        airutils.destroy_inventory(self)
        spawn_drops(self, pos)
    else
        if not with_fire then --or by the owner itself
            airutils.destroy_inventory(self)
            spawn_drops(self, pos)
        end
    end

    self.object:remove()

    if airutils.blast_damage == true and with_fire == true then
        airutils.add_blast_damage(pos, 7, 10)
        if destroyed_ent then

		    local dest_ent = minetest.add_entity(pos, destroyed_ent)
		    if dest_ent then
                local ent = dest_ent:get_luaentity()
                if ent then
                    ent.owner = owner
                    ent._inv_id = inv_id
                    ent._trunk_slots = trunk_slots
                    ent._game_time = minetest.get_gametime()
			        dest_ent:set_yaw(rot.y)
                end
		    end

        end
    end
end

function airutils.testImpact(self, velocity, position)
    if self.hp_max < 0 then --if acumulated damage is greater than 50, adieu
        airutils.destroy(self)
    end
    if velocity == nil then return end
    local impact_speed = 2
    local p = position --self.object:get_pos()
    local collision = false
    if self._last_vel == nil then return end
    local touch_point = self.initial_properties.collisionbox[2]-0.5
    --lets calculate the vertical speed, to avoid the bug on colliding on floor with hard lag
    if math.abs(velocity.y - self._last_vel.y) > impact_speed then
		local noded = airutils.nodeatpos(airutils.pos_shift(p,{y=touch_point}))
	    if (noded and noded.drawtype ~= 'airlike') then
		    collision = true
	    else
            self.object:set_velocity(self._last_vel)
            --self.object:set_acceleration(self._last_accell)
            self.object:set_velocity(vector.add(velocity, vector.multiply(self._last_accell, self.dtime/8)))
        end
    end
    local impact = math.abs(airutils.get_hipotenuse_value(velocity, self._last_vel))
    local vertical_impact = math.abs(velocity.y - self._last_vel.y)

    --minetest.chat_send_all('impact: '.. impact .. ' - hp: ' .. self.hp_max)
    if impact > impact_speed then
        --minetest.chat_send_all('impact: '.. impact .. ' - hp: ' .. self.hp_max)
        if self.colinfo then
            collision = self.colinfo.collides
        end
    end

    if self._last_water_touch == nil then self._last_water_touch = 3 end
    if self._last_water_touch <= 3 then self._last_water_touch = self._last_water_touch + self.dtime end
    if impact > 0.2  and self._longit_speed > 0.6 and self._last_water_touch >=3 then
        local noded = airutils.nodeatpos(airutils.pos_shift(p,{y=touch_point}))
	    if (noded and noded.drawtype ~= 'airlike') then
            if noded.drawtype == 'liquid' then
                self._last_water_touch = 0
                minetest.sound_play("airutils_touch_water", {
                    --to_player = self.driver_name,
                    object = self.object,
                    max_hear_distance = 15,
                    gain = 1.0,
                    fade = 0.0,
                    pitch = 1.0,
                }, true)
                return
            end
	    end
    end

    if self._last_touch == nil then self._last_touch = 1 end
    if self._last_touch <= 1 then self._last_touch = self._last_touch + self.dtime end
    if vertical_impact > 1.0  and self._longit_speed > self._min_speed/2 and self._last_touch >= 1 then
        local noded = airutils.nodeatpos(airutils.pos_shift(p,{y=touch_point}))
	    if (noded and noded.drawtype ~= 'airlike') and (noded.drawtype ~= 'liquid') then
            self._last_touch = 0
            if not self._ground_friction then self._ground_friction = 0.99 end

            if self._ground_friction > 0.97 and self.wheels then
                minetest.sound_play("airutils_touch", {
                    --to_player = self.driver_name,
                    object = self.object,
                    max_hear_distance = 15,
                    gain = 1.0,
                    fade = 0.0,
                    pitch = 1.0,
                }, true)
            else
                minetest.sound_play("airutils_collision", {
                    --to_player = self.driver_name,
                    object = self.object,
                    max_hear_distance = 15,
                    gain = 1.0,
                    fade = 0.0,
                    pitch = 1.0,
                }, true)
            end
	    end
    end

    --damage by speed
    if self._speed_not_exceed then
        if self._last_speed_damage_time == nil then self._last_speed_damage_time = 0 end
        self._last_speed_damage_time = self._last_speed_damage_time + self.dtime
        if self._last_speed_damage_time > 2 then self._last_speed_damage_time = 2 end
        if math.abs(self._longit_speed) > self._speed_not_exceed and self._last_speed_damage_time >= 2 then
            self._last_speed_damage_time = 0
            minetest.sound_play("airutils_collision", {
                --to_player = self.driver_name,
                object = self.object,
                max_hear_distance = 15,
                gain = 1.0,
                fade = 0.0,
                pitch = 1.0,
            }, true)
            self.hp_max = self.hp_max - self._damage_by_wind_speed
            if self.driver_name then
                local player_name = self.driver_name
                airutils.setText(self, self._vehicle_name)
            end
            if self.hp_max < 0 then --if acumulated damage is greater than 50, adieu
                airutils.destroy(self)
            end
        end
    end

    if collision then
        local damage = impact/2 --default for basic planes and trainers
        if self._hard_damage then
            damage = impact*3
            --check if the impact was on landing gear area
            if math.abs(impact - vertical_impact) < (impact*0.1) and --vert speed difference less than 10% of total
                 math.abs(math.deg(self.object:get_rotation().x)) < 20 and --nose angle between +20 and -20 degrees
                self._longit_speed < (self._min_speed*2) and  --longit speed less than the double of min speed
                self._longit_speed > (self._min_speed/2) then --longit speed bigger than the half of min speed
                damage = impact / 2 --if the plane was landing, the damage is mainly on landing gear, so lets reduce the damage
            end
            --end check
        end

        self.hp_max = self.hp_max - damage --subtract the impact value directly to hp meter
        minetest.sound_play(self._collision_sound, {
            --to_player = self.driver_name,
            object = self.object,
            max_hear_distance = 15,
            gain = 1.0,
            fade = 0.0,
            pitch = 1.0,
        }, true)

        --stop engine
        if damage > 7 then
            self._power_lever = 0
            self._engine_running = false
        end
        
        airutils.setText(self, self._vehicle_name)

        if self.driver_name then
            local player_name = self.driver_name

            --minetest.chat_send_all('damage: '.. damage .. ' - hp: ' .. self.hp_max)
            if self.hp_max < 0 then --adieu
                airutils.destroy(self)
            end

            local player = minetest.get_player_by_name(player_name)
            if player then
		        if player:get_hp() > 0 then
                    local hurt_by_impact_divisor = 0.5 --less is more
                    if self.hp_max > 0 then hurt_by_impact_divisor = 4 end
			        player:set_hp(player:get_hp()-(damage/hurt_by_impact_divisor))
		        end
            end
            if self._passenger ~= nil then
                local passenger = minetest.get_player_by_name(self._passenger)
                if passenger then
		            if passenger:get_hp() > 0 then
			            passenger:set_hp(passenger:get_hp()-(damage/2))
		            end
                end
            end
        end

    end
end

--this method checks for a disconected player who comes back
function airutils.rescueConnectionFailedPassengers(self)
    if self._disconnection_check_time == nil then self._disconnection_check_time = 1 end
    self._disconnection_check_time = self._disconnection_check_time + self.dtime
    if not self._passengers_base then return end
    local max_seats = table.getn(self._passengers_base)
    if self._disconnection_check_time > 1 then
        --minetest.chat_send_all(dump(self._passengers))
        self._disconnection_check_time = 0
        for i = max_seats,1,-1 
        do 
            if self._passengers[i] then
                local player = minetest.get_player_by_name(self._passengers[i])
                if player then --we have a player!
                    if player:get_attach() == nil then
                    --if player_api.player_attached[self._passengers[i]] == nil then --but isn't attached?
                        --minetest.chat_send_all("okay")
		                if player:get_hp() > 0 then
                            self._passengers[i] = nil --clear the slot first
                            do_attach(self, player, i) --attach
		                end
                    end
                end
            end
        end
    end
end

function airutils.checkattachBug(self)
    -- for some engine error the player can be detached from the submarine, so lets set him attached again
    local have_driver = (self.driver_name ~= nil)
    if have_driver then
        -- attach the driver again
        if self.driver_name ~= self.owner then
            self.driver_name = nil
            return
        end
        local player = minetest.get_player_by_name(self.driver_name)
        if player then
		    if player:get_hp() > 0 then
                if player:get_attach() == nil then
                    airutils.attach(self, player, self._instruction_mode)
                else
                    self.driver_name = nil
                end
            else
                airutils.dettachPlayer(self, player)
		    end
        else
            if self._passenger ~= nil and self._command_is_given == false then
                self._autopilot = false
                airutils.transfer_control(self, true)
            end
        end
    end
end

function airutils.engineSoundPlay(self)
    --sound
    if self.sound_handle then minetest.sound_stop(self.sound_handle) end
    if self.object then
        local pitch_adjust = 0.5 + ((self._power_lever/100)/2)
        self.sound_handle = minetest.sound_play({name = self._engine_sound},
            {object = self.object, gain = 2.0,
                pitch = pitch_adjust,
                max_hear_distance = 15,
                loop = true,})
    end
end

function airutils.engine_set_sound_and_animation(self)
    --minetest.chat_send_all('test1 ' .. dump(self._engine_running) )
    if self._engine_running then
        if self._last_applied_power ~= self._power_lever and not self._autopilot then
            self._last_applied_power = self._power_lever
            self.object:set_animation_frame_speed(60 + self._power_lever)
            airutils.engineSoundPlay(self)
        end
    else
        if self.sound_handle then
            minetest.sound_stop(self.sound_handle)
            self.sound_handle = nil
            self.object:set_animation_frame_speed(0)
        end
    end
end

function airutils.add_paintable_part(self, entity_ref)
    if not self._paintable_parts then self._paintable_parts = {} end
    table.insert(self._paintable_parts, entity_ref:get_luaentity())
end

function airutils.set_param_paint(self, puncher, itmstck, mode)
    mode = mode or 1
    local item_name = ""
    if itmstck then item_name = itmstck:get_name() end
    
    if item_name == "automobiles_lib:painter" or item_name == "bike:painter" then
        self._skin = ""
        --painting with bike painter
        local meta = itmstck:get_meta()
	    local colour = meta:get_string("paint_color")

        local colstr = self._color
        local colstr_2 = self._color_2

        if mode == 1 then colstr = colour end
        if mode == 2 then colstr_2 = colour end
        airutils.param_paint(self, colstr, colstr_2)
        return true
    else
        --painting with dyes
        local split = string.split(item_name, ":")
        local color, indx, _
        if split[1] then _,indx = split[1]:find('dye') end
        if indx then
            self._skin = ""
            --[[for clr,_ in pairs(airutils.colors) do
                local _,x = split[2]:find(clr)
                if x then color = clr end
            end]]--
            --lets paint!!!!
	        local color = (item_name:sub(indx+1)):gsub(":", "")

            local colstr = self._color
            local colstr_2 = self._color_2
            if mode == 1 then colstr = airutils.colors[color] end
            if mode == 2 then colstr_2 = airutils.colors[color] end

            --minetest.chat_send_all(color ..' '.. dump(colstr))
            --minetest.chat_send_all(dump(airutils.colors))
	        if colstr then
                airutils.param_paint(self, colstr, colstr_2)
		        itmstck:set_count(itmstck:get_count()-1)
                if puncher ~= nil then puncher:set_wielded_item(itmstck) end
                return true
	        end
            -- end painting
        end
    end
    return false
end

local function _paint(self, l_textures, colstr, paint_list, mask_associations)
    paint_list = paint_list or self._painting_texture
    mask_associations = mask_associations or self._mask_painting_associations
    
    for _, texture in ipairs(l_textures) do
        for i, texture_name in ipairs(paint_list) do --textures list
            local indx = texture:find(texture_name)
            if indx then
                l_textures[_] = texture_name.."^[multiply:".. colstr  --paint it normally
                local mask_texture = mask_associations[texture_name] --check if it demands a maks too
                --minetest.chat_send_all(texture_name .. " -> " .. dump(mask_texture))
                if mask_texture then --so it then
                    l_textures[_] = "("..l_textures[_]..")^("..texture_name.."^[mask:"..mask_texture..")" --add the mask
                end
            end
        end
    end
    return l_textures
end

local function _set_skin(self, l_textures, paint_list, target_texture, skin)
    skin = skin or self._skin
    paint_list = paint_list or self._painting_texture
    target_texture = target_texture or self._skin_target_texture
    if not target_texture then return l_textures end
    for _, texture in ipairs(l_textures) do
        for i, texture_name in ipairs(paint_list) do --textures list
            local indx = texture:find(target_texture)
            if indx then
                l_textures[_] = l_textures[_].."^"..skin  --paint it normally
            end
        end
    end
    return l_textures
end

--painting
function airutils.param_paint(self, colstr, colstr_2)
    colstr_2 = colstr_2 or colstr
    if not self then return end
    if self._skin ~= nil and self._skin ~= "" then
        local l_textures = self.initial_properties.textures
        l_textures = _set_skin(self, l_textures, self._painting_texture, self._skin_target_texture, self._skin)
        self.object:set_properties({textures=l_textures})

        if self._paintable_parts then --paint individual parts
            for i, part_entity in ipairs(self._paintable_parts) do
                local p_textures = part_entity.initial_properties.textures
                p_textures = _set_skin(part_entity, p_textures, self._painting_texture, self._skin_target_texture, self._skin)
                part_entity.object:set_properties({textures=p_textures})
            end
        end
        return
    end

    if colstr then
        self._color = colstr
        self._color_2 = colstr_2
        local l_textures = self.initial_properties.textures
        l_textures = _paint(self, l_textures, colstr) --paint the main plane
        l_textures = _paint(self, l_textures, colstr_2, self._painting_texture_2) --paint the main plane
        self.object:set_properties({textures=l_textures})

        if self._paintable_parts then --paint individual parts
            for i, part_entity in ipairs(self._paintable_parts) do
                local p_textures = part_entity.initial_properties.textures
                p_textures = _paint(part_entity, p_textures, colstr, self._painting_texture, self._mask_painting_associations)
                p_textures = _paint(part_entity, p_textures, colstr_2, self._painting_texture_2, self._mask_painting_associations)
                part_entity.object:set_properties({textures=p_textures})
            end
        end
    end
end

function airutils.paint_with_mask(self, colstr, target_texture, mask_texture)
    if colstr then
        self._color = colstr
        self._det_color = mask_colstr
        local l_textures = self.initial_properties.textures
        for _, texture in ipairs(l_textures) do
            local indx = texture:find(target_texture)
            if indx then
                --"("..target_texture.."^[mask:"..mask_texture..")"
                l_textures[_] = "("..target_texture.."^[multiply:".. colstr..")^("..target_texture.."^[mask:"..mask_texture..")"
            end
        end
	    self.object:set_properties({textures=l_textures})
    end
end

function airutils.pid_controller(current_value, setpoint, last_error, d_time, kp, ki, kd)
    kp = kp or 0
    ki = ki or 0.00000000000001
    kd = kd or 0.005

    local ti = kp/ki
    local td = kd/kp
    local delta_t = d_time

    local _error = setpoint - current_value
    local derivative = _error - last_error
    --local output = kpv*erro + (kpv/Tiv)*I + kpv*Tdv*((erro - erro_passado)/delta_t);
    if integrative == nil then integrative = 0 end
    integrative = integrative + (((_error + last_error)/delta_t)/2);
    local output = kp*_error + (kp/ti)*integrative + kp * td*((_error - last_error)/delta_t)
    last_error = _error
    return output, last_error
end

function airutils.add_smoke_trail(self, smoke_type)
    smoke_type = smoke_type or 1
    local smoke_texture = "airutils_smoke.png"
    if smoke_type == 2 then
        smoke_texture = "airutils_smoke.png^[multiply:#020202"
    end

    if self._curr_smoke_type ~= smoke_type then
        self._curr_smoke_type = smoke_type
        if self._smoke_spawner then
            minetest.delete_particlespawner(self._smoke_spawner)
            self._smoke_spawner = nil
        end
    end

    if self._smoke_spawner == nil then
        local radius = 1
	    self._smoke_spawner = minetest.add_particlespawner({
		    amount = 3,
		    time = 0,
		    --minpos = vector.subtract(pos, radius / 2),
		    --maxpos = vector.add(pos, radius / 2),
		    minvel = {x = -1, y = -1, z = -1},
		    maxvel = {x = 1, y = 5, z = 1},
		    minacc = vector.new(),
		    maxacc = vector.new(),
            attached = self.object,
		    minexptime = 3,
		    maxexptime = 5.5,
		    minsize = 10,
		    maxsize = 15,
		    texture = smoke_texture,
	    })
    end
end

function airutils.add_destruction_effects(pos, radius, w_fire)
    if pos == nil then return end
    w_fire = w_fire
    if w_fire == nil then w_fire = true end
	local node = airutils.nodeatpos(pos)
    local is_liquid = false
    if (node.drawtype == 'liquid' or node.drawtype == 'flowingliquid') then is_liquid = true end

    minetest.sound_play("airutils_explode", {
        pos = pos,
        max_hear_distance = 100,
        gain = 2.0,
        fade = 0.0,
        pitch = 1.0,
    }, true)
    if is_liquid == false and w_fire == true then
	    minetest.add_particle({
		    pos = pos,
		    velocity = vector.new(),
		    acceleration = vector.new(),
		    expirationtime = 0.4,
		    size = radius * 10,
		    collisiondetection = false,
		    vertical = false,
		    texture = "airutils_boom.png",
		    glow = 15,
	    })
	    minetest.add_particlespawner({
		    amount = 32,
		    time = 0.5,
		    minpos = vector.subtract(pos, radius / 2),
		    maxpos = vector.add(pos, radius / 2),
		    minvel = {x = -10, y = -10, z = -10},
		    maxvel = {x = 10, y = 10, z = 10},
		    minacc = vector.new(),
		    maxacc = vector.new(),
		    minexptime = 1,
		    maxexptime = 2.5,
		    minsize = radius * 3,
		    maxsize = radius * 5,
		    texture = "airutils_boom.png",
	    })
    end
	minetest.add_particlespawner({
		amount = 64,
		time = 1.0,
		minpos = vector.subtract(pos, radius / 2),
		maxpos = vector.add(pos, radius / 2),
		minvel = {x = -10, y = -10, z = -10},
		maxvel = {x = 10, y = 10, z = 10},
		minacc = vector.new(),
		maxacc = vector.new(),
		minexptime = 1,
		maxexptime = 2.5,
		minsize = radius * 3,
		maxsize = radius * 5,
		texture = "airutils_smoke.png",
	})
end

function airutils.add_blast_damage(pos, radius, damage_cal)
    if not pos then return end
    radius = radius or 10
    damage_cal = damage_cal or 4

    local objs = minetest.get_objects_inside_radius(pos, radius)
	for _, obj in pairs(objs) do
		local obj_pos = obj:get_pos()
		local dist = math.max(1, vector.distance(pos, obj_pos))
        local damage = (damage_cal / dist) * radius
        
        if obj:is_player() then
            obj:set_hp(obj:get_hp() - damage)
        else
            local luaobj = obj:get_luaentity()

            -- object might have disappeared somehow
            if luaobj then
				local do_damage = true
				local do_knockback = true
				local entity_drops = {}
				local objdef = minetest.registered_entities[luaobj.name]

				if objdef and objdef.on_blast then
					do_damage, do_knockback, entity_drops = objdef.on_blast(luaobj, damage)
				end

				if do_knockback then
					local obj_vel = obj:get_velocity()
				end
				if do_damage then
                    obj:punch(obj, 1.0, {
                        full_punch_interval = 1.0,
                        damage_groups = {fleshy = damage},
                    }, nil)
				end
				for _, item in pairs(entity_drops) do
					add_drop(drops, item)
				end
			end

        end
    end
    --lets light some bombs
    if airutils.is_minetest then
        local pr = PseudoRandom(os.time())
        for z = -radius, radius do
            for y = -radius, radius do
                for x = -radius, radius do
                    -- remove the nodes
                    local r = vector.length(vector.new(x, y, z))
                    if (radius * radius) / (r * r) >= (pr:next(80, 125) / 100) then
                        local p = {x = pos.x + x, y = pos.y + y, z = pos.z + z}
	                    local node = minetest.get_node(p).name
                        if node == "tnt:tnt" then minetest.set_node(p, {name = "tnt:tnt_burning"}) end
                    end
                end
            end
        end
    end

end

function airutils.start_engine(self)
    if self._engine_running then
	    self._engine_running = false
        self._autopilot = false
        self._power_lever = 0 --zero power
        self._last_applied_power = 0 --zero engine
    elseif self._engine_running == false and self._energy > 0 then
        local curr_health_percent = (self.hp_max * 100)/self._max_plane_hp
        if curr_health_percent > 20 then
	        self._engine_running = true
            self._last_applied_power = -1 --send signal to start
        else
            if self.driver_name then
                minetest.chat_send_player(self.driver_name,core.colorize('#ff0000', S(" >>> The engine is damaged, start procedure failed.")))
            end
        end
    end
end

function airutils.get_xz_from_hipotenuse(orig_x, orig_z, yaw, distance)
    --cara, o minetest é bizarro, ele considera o eixo no sentido ANTI-HORÁRIO... Então pra equação funcionar, subtrair o angulo de 360 antes
    yaw = math.rad(360) - yaw
    local z = (math.cos(yaw)*distance) + orig_z
    local x = (math.sin(yaw)*distance) + orig_x
    return x, z
end

function airutils.camera_reposition(player, pitch, roll)
    local new_eye_offset = player:get_eye_offset()

    if roll < -0.4 then roll = -0.4 end
    if roll > 0.4 then roll = 0.4 end

    local player_properties = player:get_properties()

    local eye_y = -5
    if airutils.detect_player_api(player) == 1 then
        --minetest.chat_send_all("1")
        eye_y = 0.5
    end
    if airutils.detect_player_api(player) == 2 then
        --minetest.chat_send_all("2")
        eye_y = -5
    end
     
    local z, y = airutils.get_xz_from_hipotenuse(0, eye_y, pitch, player_properties.eye_height)
    new_eye_offset.z = z*7
    new_eye_offset.y = y*1.5
    local x, _ = airutils.get_xz_from_hipotenuse(0, eye_y, roll, player_properties.eye_height)
    new_eye_offset.x = -x*15

    return new_eye_offset
end

function airutils.seats_create(self)
    if self.object then
        local pos = self.object:get_pos()
        self._passengers_base = {}
        if self._seats then 
            local max_seats = table.getn(self._seats)
            for i=1, max_seats do
                self._passengers_base[i] = minetest.add_entity(pos,'airutils:seat_base')
                if not self._seats_rot then
                    self._passengers_base[i]:set_attach(self.object,'',self._seats[i],{x=0,y=0,z=0})
                else
                    self._passengers_base[i]:set_attach(self.object,'',self._seats[i],{x=0,y=self._seats_rot[i],z=0})
                end
            end

            self.pilot_seat_base = self._passengers_base[1] --sets pilot seat reference
            if self._have_copilot and self._passengers_base[2] then
                self.co_pilot_seat_base = self._passengers_base[2] --sets copilot seat reference
            end
        end
    end
end

function airutils.seats_destroy(self)
    local max_seats = table.getn(self._passengers_base)
    for i=1, max_seats do
        if self._passengers_base[i] then self._passengers_base[i]:remove() end
    end
end

function airutils.flap_on(self)
    if not self._wing_angle_extra_flaps then
        self._flap = false
        self._wing_configuration = self._wing_angle_of_attack
        return
    end

    if self._wing_angle_extra_flaps == nil then self._wing_angle_extra_flaps = 0 end --if not, just keep the same as normal angle of attack
    local flap_limit = 15
    if self._flap_limit then flap_limit = self._flap_limit end
    self._wing_configuration = self._wing_angle_of_attack + self._wing_angle_extra_flaps
    if flap_limit >= 0 then
        for i = 0,flap_limit do
            minetest.after(0.02*i, function()
                self.object:set_bone_position("flap.l", {x=0, y=0, z=0}, {x=-i, y=0, z=0})
                self.object:set_bone_position("flap.r", {x=0, y=0, z=0}, {x=-i, y=0, z=0})
            end)
        end
    else
        for i = flap_limit,0 do
            minetest.after(0.02*-i, function()
                self.object:set_bone_position("flap.l", {x=0, y=0, z=0}, {x=-i, y=0, z=0})
                self.object:set_bone_position("flap.r", {x=0, y=0, z=0}, {x=-i, y=0, z=0})
            end)
        end
        --self.object:set_bone_position("flap.l", {x=0, y=0, z=0}, {x=-flap_limit, y=0, z=0})
        --self.object:set_bone_position("flap.r", {x=0, y=0, z=0}, {x=-flap_limit, y=0, z=0})
    end
end

function airutils.flap_off(self)
    self._wing_configuration = self._wing_angle_of_attack
    local flap_limit = 15
    if self._flap_limit then flap_limit = self._flap_limit end
    if flap_limit >= 0 then
        for i = 0,flap_limit do
            minetest.after(0.01*i, function()
                self.object:set_bone_position("flap.l", {x=0, y=0, z=0}, {x=-flap_limit+i, y=0, z=0})
                self.object:set_bone_position("flap.r", {x=0, y=0, z=0}, {x=-flap_limit+i, y=0, z=0})
            end)
        end
    else
        for i = flap_limit,0 do
            minetest.after(0.01*-i, function()
                self.object:set_bone_position("flap.l", {x=0, y=0, z=0}, {x=-flap_limit+i, y=0, z=0})
                self.object:set_bone_position("flap.r", {x=0, y=0, z=0}, {x=-flap_limit+i, y=0, z=0})
            end)
        end
        --self.object:set_bone_position("flap.l", {x=0, y=0, z=0}, {x=0, y=0, z=0})
        --self.object:set_bone_position("flap.r", {x=0, y=0, z=0}, {x=0, y=0, z=0})
    end
end

function airutils.flap_operate(self, player)
    if self._flap == false then
        minetest.chat_send_player(player:get_player_name(), S(">>> Flap down"))
        self._flap = true
        airutils.flap_on(self)
        minetest.sound_play("airutils_collision", {
            object = self.object,
            max_hear_distance = 15,
            gain = 1.0,
            fade = 0.0,
            pitch = 0.5,
        }, true)
    else
        minetest.chat_send_player(player:get_player_name(), S(">>> Flap up"))
        self._flap = false
        airutils.flap_off(self)
        minetest.sound_play("airutils_collision", {
            object = self.object,
            max_hear_distance = 15,
            gain = 1.0,
            fade = 0.0,
            pitch = 0.7,
        }, true)
    end
end

local function do_attach(self, player, slot)
    if slot == 0 then return end
    if self._passengers[slot] == nil then
        local name = player:get_player_name()
        --minetest.chat_send_all(self.driver_name)
        self._passengers[slot] = name
        player:set_attach(self._passengers_base[slot], "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})

        local eye_y = -4
        if airutils.detect_player_api(player) == 1 then
            eye_y = 2.5
        end
        player:set_eye_offset({x = 0, y = eye_y, z = 2}, {x = 0, y = 3, z = -30})
        sit_player(player, name)
    end
end

function airutils.landing_lights_operate(self)
    if self._last_light_move == nil then self._last_light_move = 0.15 end
    self._last_light_move = self._last_light_move + self.dtime
    if self._last_light_move > 0.15 then
        self._last_light_move = 0
        if self._land_light == true and self._engine_running == true then
            self._light_active_time = self._light_active_time + self.dtime
            --minetest.chat_send_all(self._light_active_time)
            if self._light_active_time > 24 then self._land_light = false end
            airutils.put_light(self)
        else
            self._land_light = false
            self._light_active_time = 0
            airutils.remove_light(self)
        end
    end
end

function airutils.get_adf_angle(self, pos)
    local adf = 0
    if self._adf == true then
        if airutils.getAngleFromPositions and self._adf_destiny then
            adf = airutils.getAngleFromPositions(pos, self._adf_destiny)
            adf = -(adf + math.deg(self._yaw))
        end
    end
    return adf
end

function airutils.destroyed_save_static_data(self)
        return minetest.serialize(
            {
                stored_owner = self.owner,
                stored_slots = self._trunk_slots,
                stored_inv_id = self._inv_id,
                stored_game_time = self._game_time,
            }
        )
end

function airutils.destroyed_on_activate(self, staticdata, dtime_s)
    local pos = self.object:get_pos()

    if staticdata ~= "" and staticdata ~= nil then
        local data = minetest.deserialize(staticdata) or {}
        self.owner = data.stored_owner
        self._inv_id = data.stored_inv_id
        self._trunk_slots = data.stored_slots
        self._game_time = data.stored_game_time
    end

	local inv = minetest.get_inventory({type = "detached", name = self._inv_id})
	-- if the game was closed the inventories have to be made anew, instead of just reattached
	if inv then
	    self._inv = inv
    end

    airutils.set_acceleration(self.object,{x=0,y=airutils.gravity,z=0})
    self.object:set_bone_position("elevator", self._elevator_pos, {x=-170, y=0, z=0})
end

local function check_shared_by_time(self)
    local shared_by_time = false
    if self._game_time then
        --check if it was created in the last 20 minutes (1200 seconds)
        if minetest.get_gametime() - self._game_time >= 1200 then shared_by_time = true end
    end
    return shared_by_time
end

function airutils.destroyed_open_inventory(self, clicker)
    local message = ""
	if not clicker or not clicker:is_player() then
		return
	end

    local name = clicker:get_player_name()

    if self.owner == "" then
        self.owner = name
    end

    local shared_by_time = check_shared_by_time(self)

    if name == self.owner or shared_by_time then
        if not self._inv then
            airutils.create_inventory(self, self._trunk_slots)
        end
        airutils.show_vehicle_trunk_formspec(self, clicker, self._trunk_slots)
    else
        minetest.chat_send_player(name, core.colorize('#ff0000', S('>>> You cannot claim this scrap yet, wait some minutes.')))
    end
end

function airutils.destroyed_on_punch(self, puncher, ttime, toolcaps, dir, damage)
    if not puncher or not puncher:is_player() then
		return
	end

    local name = puncher:get_player_name()
    local shared_by_time = check_shared_by_time(self)
    local pos = self.object:get_pos()

    local is_admin = false
    is_admin = minetest.check_player_privs(puncher, {server=true})
    if shared_by_time == false then
        if self.owner and self.owner ~= name and self.owner ~= "" then
            if is_admin == false then return end
        end
    end

    minetest.sound_play("airutils_collision", {
        object = self.object,
        max_hear_distance = 5,
        gain = 1.0,
        fade = 0.0,
        pitch = 1.0,
    })

    spawn_drops(self, pos)

    airutils.destroy_inventory(self)
    self.object:remove()
end

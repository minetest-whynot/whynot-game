dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_global_definitions.lua")

--
-- entity
--

hidroplane.vector_up = vector.new(0, 1, 0)

minetest.register_entity('hidroplane:engine',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
    backface_culling = false,
	mesh = "hidroplane_propeller.b3d",
    --visual_size = {x = 3, y = 3, z = 3},
	textures = {"hidroplane_rotor.png", "hidroplane_black.png",},
	},
	
    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,
	
})

minetest.register_entity('hidroplane:front_wheels',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
	mesh = "hidroplane_front_wheels.b3d",
    --visual_size = {x = 3, y = 3, z = 3},
	textures = {"hidroplane_metal.png", "hidroplane_metal.png", "hidroplane_black.png", "hidroplane_metal.png", },
	},
	
    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,
	
})

minetest.register_entity('hidroplane:wheels',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
	mesh = "hidroplane_wheels.b3d",
    --visual_size = {x = 3, y = 3, z = 3},
	textures = {"hidroplane_black.png", "hidroplane_metal.png", },
	},
	
    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,
	
})

minetest.register_entity('hidroplane:stick',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
	mesh = "hidroplane_stick.b3d",
	textures = {"hidroplane_metal.png", "hidroplane_black.png", "hidroplane_red.png", },
	},
	
    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,
	
})

--
-- fuel
--
minetest.register_entity('hidroplane:pointer',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
	mesh = "pointer.b3d",
    visual_size = {x = 0.4, y = 0.4, z = 0.4},
	textures = {"hidroplane_grey.png"},
	},
	
    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,
})

--
-- seat pivot
--
minetest.register_entity('hidroplane:seat_base',{
initial_properties = {
	physical = false,
	collide_with_objects=false,
	pointable=false,
	visual = "mesh",
	mesh = "hidroplane_seat_base.b3d",
    textures = {"hidroplane_black.png",},
	},
	
    on_activate = function(self,std)
	    self.sdata = minetest.deserialize(std) or {}
	    if self.sdata.remove then self.object:remove() end
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return minetest.serialize(self.sdata)
    end,
	
})

minetest.register_entity("hidroplane:hidro", {
	initial_properties = {
	    physical = true,
        collide_with_objects = true,
	    collisionbox = {-1.2, -2.3, -1.2, 1.2, 1, 1.2}, --{-1,0,-1, 1,0.3,1},
	    selectionbox = {-2, -2.3, -2, 2, -1, 2},
	    visual = "mesh",
	    mesh = "hidroplane_fuselage.b3d",
        stepheight = 0.5,
        textures = {
                    "hidroplane_painting.png", --superficies controle
                    "hidroplane_black.png", --banco1
                    "hidroplane_black.png", --banco2
                    "hidroplane_metal.png", --motor
                    "hidroplane_painting.png", --est horizontal
                    "hidroplane_metal.png", --longarinas
                    "hidroplane_painting.png", --montantes
                    "hidroplane_painting.png", --flutuadores
                    "hidroplane_panel.png", --painel
                    "hidroplane_painting.png", --lado esquerdo
                    "hidroplane_painting.png", --lado direito
                    "hidroplane_glass.png", --parabrisa
                    "hidroplane_glass.png", --janelas laterais
                    "hidroplane_black.png", --entradas motor
                    "hidroplane_grey.png", --interior
                    "hidroplane_black.png", --cobertura painel
                    "hidroplane_black.png", --fundo painel
                    "hidroplane_black.png", --cabeçote
                    "hidroplane_glass.png", --teto
                    "hidroplane_black.png", --fendas flutuadores
                    "hidroplane_painting.png", --asas
                    },
    },
    textures = {},
	driver_name = nil,
	sound_handle = nil,
    owner = "",
    static_save = true,
    infotext = "A nice hidroplane",
    hp_max = 50,
    shaded = true,
    show_on_minimap = true,
    buoyancy = 0.25,
    physics = hidroplane.physics,
    _passenger = nil,
    _color = "#ffe400",
    _rudder_angle = 0,
    _acceleration = 0,
    _engine_running = false,
    _angle_of_attack = 2,
    _elevator_angle = 0,
    _power_lever = 0,
    _last_applied_power = 0,
    _energy = 0.001,
    _last_vel = {x=0,y=0,z=0},
    _longit_speed = 0,
    _land_retracted = true,
    _show_hud = false,
    _instruction_mode = false, --flag to intruction mode
    _command_is_given = false, --flag to mark the "owner" of the commands now
    _autopilot = false,
    _auto_pilot_altitude = 0,
    _last_accell = {x=0,y=0,z=0},
    _last_time_command = 1,
    _wing_configuration = hidroplane.wing_angle_of_attack,
    _inv = nil,
    _inv_id = "",

    _change_color = function(self, colstr)
        airutils.paint(self, colstr, "hidroplane_painting.png")
    end,

    get_staticdata = function(self) -- unloaded/unloads ... is now saved
        return minetest.serialize({
            --stored_sound_handle = self.sound_handle,
            stored_energy = self._energy,
            stored_owner = self.owner,
            stored_hp = self.hp_max,
            stored_color = self._color,
            stored_power_lever = self._power_lever,
            stored_driver_name = self.driver_name,
            stored_last_accell = self._last_accell,
            stored_engine_running = self._engine_running,
            stored_inv_id = self._inv_id,
        })
    end,

	on_deactivate = function(self)
        airutils.save_inventory(self)
	end,

	on_activate = function(self, staticdata, dtime_s)
        airutils.actfunc(self, staticdata, dtime_s)
        if staticdata ~= "" and staticdata ~= nil then
            local data = minetest.deserialize(staticdata) or {}
            self._energy = data.stored_energy
            self.owner = data.stored_owner
            self.hp_max = data.stored_hp
            self._color = data.stored_color
            self._power_lever = data.stored_power_lever
            self.driver_name = data.stored_driver_name
            self._last_accell = data.stored_last_accell
            self._engine_running = data.stored_engine_running
            self._inv_id = data.stored_inv_id
            --self.sound_handle = data.stored_sound_handle
            --minetest.debug("loaded: ", self._energy)
            if self._engine_running then
                self._last_applied_power = -1 --signal to start
            end
        end
        airutils.setText(self, "hydroplane")
        self.object:set_animation({x = 1, y = 12}, 0, 0, true)

        local pos = self.object:get_pos()

	    local engine=minetest.add_entity(pos,'hidroplane:engine')
	    engine:set_attach(self.object,'',{x=0,y=0,z=0},{x=0,y=0,z=0})
		-- set the animation once and later only change the speed
        engine:set_animation({x = 1, y = 12}, 0, 0, true)
	    self.engine = engine

	    local wheels=minetest.add_entity(pos,'hidroplane:wheels')
	    wheels:set_attach(self.object,'',{x=0,y=0,z=0},{x=0,y=0,z=0})
		-- set the animation once and later only change the speed
        wheels:set_animation({x = 1, y = 12}, 0, 0, true)
	    self.wheels = wheels

	    local f_wheels=minetest.add_entity(pos,'hidroplane:front_wheels')
	    f_wheels:set_attach(self.object,'',{x=0,y=-14.2,z=13.5},{x=29.4,y=0,z=0})
		-- set the animation once and later only change the speed
        f_wheels:set_animation({x = 1, y = 12}, 0, 0, true)
	    self.f_wheels = f_wheels

	    local fuel_gauge=minetest.add_entity(pos,'hidroplane:pointer')
        local energy_indicator_angle = hidroplane.get_gauge_angle(self._energy)
	    fuel_gauge:set_attach(self.object,'',HIDROPLANE_GAUGE_FUEL_POSITION,{x=0,y=0,z=energy_indicator_angle})
	    self.fuel_gauge = fuel_gauge

	    local power_gauge=minetest.add_entity(pos,'hidroplane:pointer')
        local power_indicator_angle = hidroplane.get_gauge_angle(self._power_lever)
	    power_gauge:set_attach(self.object,'',HIDROPLANE_GAUGE_POWER_POSITION,{x=0,y=0,z=power_indicator_angle})
	    self.power_gauge = power_gauge

	    local climb_gauge=minetest.add_entity(pos,'hidroplane:pointer')
        local climb_angle = hidroplane.get_gauge_angle(0)
	    climb_gauge:set_attach(self.object,'',HIDROPLANE_GAUGE_CLIMBER_POSITION,{x=0,y=0,z=climb_angle})
	    self.climb_gauge = climb_gauge

	    local speed_gauge=minetest.add_entity(pos,'hidroplane:pointer')
        local speed_angle = hidroplane.get_gauge_angle(100)
	    speed_gauge:set_attach(self.object,'',HIDROPLANE_GAUGE_SPEED_POSITION,{x=0,y=0,z=speed_angle})
	    self.speed_gauge = speed_gauge

        local pilot_seat_base=minetest.add_entity(pos,'hidroplane:seat_base')
        pilot_seat_base:set_attach(self.object,'',{x=0,y=-4,z=2},{x=0,y=0,z=0})
	    self.pilot_seat_base = pilot_seat_base

        local passenger_seat_base=minetest.add_entity(pos,'hidroplane:seat_base')
        passenger_seat_base:set_attach(self.object,'',{x=0,y=-5,z=-6},{x=0,y=0,z=0})
	    self.passenger_seat_base = passenger_seat_base

	    local stick=minetest.add_entity(pos,'hidroplane:stick')
	    stick:set_attach(self.object,'',{x=0,y=-6.85,z=8},{x=0,y=0,z=0})
	    self.stick = stick

        airutils.paint(self, self._color, "hidroplane_painting.png")

		self.object:set_armor_groups({immortal=1})

		local inv = minetest.get_inventory({type = "detached", name = self._inv_id})
		-- if the game was closed the inventories have to be made anew, instead of just reattached
		if not inv then
            airutils.create_inventory(self, hidroplane.trunk_slots)
		else
		    self.inv = inv
        end
	end,

    --on_step = airutils.stepfunc,
    on_step = function(self,dtime,colinfo)
	    self.dtime = math.min(dtime,0.2)
	    self.colinfo = colinfo
	    self.height = airutils.get_box_height(self)
	    
    --  physics comes first
	    local vel = self.object:get_velocity()
	    
	    if colinfo then 
		    self.isonground = colinfo.touching_ground
	    else
		    if self.lastvelocity.y==0 and vel.y==0 then
			    self.isonground = true
		    else
			    self.isonground = false
		    end
	    end
	    
	    self:physics()

	    if self.logic then
		    self:logic()
	    end
	    
	    self.lastvelocity = self.object:get_velocity()
	    self.time_total=self.time_total+self.dtime
    end,
    logic = hidroplane.flightstep,

	on_punch = function(self, puncher, ttime, toolcaps, dir, damage)
		if not puncher or not puncher:is_player() then
			return
		end

        local is_admin = false
        is_admin = minetest.check_player_privs(puncher, {protection_bypass=true})
		local name = puncher:get_player_name()
        if self.owner and self.owner ~= name and self.owner ~= "" then
            if is_admin == false then return end
        end
        if self.owner == nil then
            self.owner = name
        end
        	
        if self.driver_name and self.driver_name ~= name then
			-- do not allow other players to remove the object while there is a driver
			return
		end
        
        local is_attached = false
        if puncher:get_attach() == self.object then is_attached = true end

        local itmstck=puncher:get_wielded_item()
        local item_name = ""
        if itmstck then item_name = itmstck:get_name() end

        if is_attached == false then
            if hidroplane.loadFuel(self, puncher:get_player_name()) then
                return
            end

            --repair
            if (item_name == "airutils:repair_tool")
                    and self._engine_running == false  then
                if self.hp_max < 50 then
                    local inventory_item = "default:steel_ingot"
                    local inv = puncher:get_inventory()
                    if inv:contains_item("main", inventory_item) then
                        local stack = ItemStack(inventory_item .. " 1")
                        inv:remove_item("main", stack)
                        self.hp_max = self.hp_max + 10
                        if self.hp_max > 50 then self.hp_max = 50 end
                        airutils.setText(self, "hydroplane")
                    else
                        minetest.chat_send_player(puncher:get_player_name(), "You need steel ingots in your inventory to perform this repair.")
                    end
                end
                return
            end

            -- deal with painting or destroying
		    if itmstck then
			    if airutils.set_paint(self, puncher, itmstck, "hidroplane_painting.png") == false then
				    if not self.driver and toolcaps and toolcaps.damage_groups
                            and toolcaps.damage_groups.fleshy and item_name ~= airutils.fuel then
					    --airutils.hurt(self,toolcaps.damage_groups.fleshy - 1)
					    --airutils.make_sound(self,'hit')
                        self.hp_max = self.hp_max - 10
                        minetest.sound_play("hidroplane_collision", {
	                        object = self.object,
	                        max_hear_distance = 5,
	                        gain = 1.0,
                            fade = 0.0,
                            pitch = 1.0,
                        })
                        airutils.setText(self, "hydroplane")
				    end
			    end
            end

            if self.hp_max <= 0 then
                hidroplane.destroy(self)
            end

        end
        
	end,

	on_rightclick = function(self, clicker)
		if not clicker or not clicker:is_player() then
			return
		end

        local name = clicker:get_player_name()

        if self.owner == "" then
            self.owner = name
        end

        local passenger_name = nil
        if self._passenger then
            passenger_name = self._passenger
        end

        local touching_ground, liquid_below = airutils.check_node_below(self.object, 1.3)
        local is_on_ground = self.isinliquid or touching_ground or liquid_below
        local is_under_water = airutils.check_is_under_water(self.object)

        --minetest.chat_send_all('name '.. dump(name) .. ' - pilot: ' .. dump(self.driver_name) .. ' - pax: ' .. dump(passenger_name))
        --=========================
        --  detach pilot
        --=========================
        if name == self.driver_name then
            hidroplane.pilot_formspec(name)
        --=========================
        --  detach passenger
        --=========================
        elseif name == passenger_name then
            if is_on_ground or clicker:get_player_control().sneak then
                hidroplane.dettach_pax(self, clicker)
            else
                minetest.chat_send_player(name, "Hold sneak and right-click to disembark while flying")
            end

        --=========================
        --  attach pilot
        --=========================
        elseif not self.driver_name then
            if self.owner == name or minetest.check_player_privs(clicker, {protection_bypass=true}) then
                if clicker:get_player_control().aux1 == true then --lets see the inventory
                    airutils.show_vehicle_trunk_formspec(self, clicker, hidroplane.trunk_slots)
                else
                    if hidroplane.restricted == "true" and not minetest.check_player_privs(clicker, {flight_licence=true}) then
                        minetest.show_formspec(name, "hidroplane:flightlicence",
                            "size[4,2]" ..
                            "label[0.0,0.0;Sorry ...]"..
                            "label[0.0,0.7;You need a flight licence to fly it.]" ..
                            "label[0.0,1.0;You must obtain it from server admin.]" ..
                            "button_exit[1.5,1.9;0.9,0.1;e;Exit]")
                        return
                    end

                    if is_under_water then return end
                    --remove pax to prevent bug
                    if self._passenger then 
                        local pax_obj = minetest.get_player_by_name(self._passenger)
                        hidroplane.dettach_pax(self, pax_obj)
                    end

                    --attach player
                    if clicker:get_player_control().sneak == true then
                        -- flight instructor mode
                        self._instruction_mode = true
                        hidroplane.attach(self, clicker, true)
                    else
                        -- no driver => clicker is new driver
                        self._instruction_mode = false
                        hidroplane.attach(self, clicker)
                    end
                    self._elevator_angle = 0
                    self._rudder_angle = 0
                    self._command_is_given = false
                end
            else
                minetest.chat_send_player(name, core.colorize('#ff0000', " >>> You aren't the owner of this airplane."))
            end

        --=========================
        --  attach passenger
        --=========================
        elseif self.driver_name and not self._passenger then
            hidroplane.attach_pax(self, clicker)
        
        else
            minetest.chat_send_player(name, core.colorize('#ff0000', " >>> Can't enter airplane."))
        end

	end,
})

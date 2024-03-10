supercub={}

dofile(minetest.get_modpath("supercub") .. DIR_DELIM .. "manual.lua")

function supercub.register_parts_method(self)
    local pos = self.object:get_pos()

    local wheels=minetest.add_entity(pos,'supercub:wheels')
    wheels:set_attach(self.object,'',{x=0,y=0,z=0},{x=0,y=0,z=0})
	-- set the animation once and later only change the speed
    wheels:set_animation({x = 1, y = 12}, 0, 0, true)
    self.wheels = wheels
    airutils.add_paintable_part(self, self.wheels)

    --minetest.chat_send_all(self.initial_properties.textures[19])
    --airutils.paint(self.wheels:get_luaentity(), self._color)
end

function supercub.destroy_parts_method(self)
    if self.wheels then self.wheels:remove() end

    local pos = self.object:get_pos()
    if not minetest.settings:get_bool('supercub.disable_craftitems') then
        pos.y=pos.y+2
        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'supercub:wings')

        for i=1,6 do
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:steel_ingot')
        end

        for i=1,2 do
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'wool:white')
        end

        for i=1,6 do
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:mese_crystal')
            minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:diamond')
        end
    else
        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'supercub:supercub')
    end
end

function supercub.internal_controls(self)
    local pos = self._curr_pos

    local climb_angle = airutils.get_gauge_angle(self._climb_rate)
    self.object:set_bone_position("climber", {x=-3.76796,y=0.780199,z=10.7283}, {x=0,y=0,z=climb_angle-90})

    local speed_angle = airutils.get_gauge_angle(self._indicated_speed, -45)
    self.object:set_bone_position("speed", {x=-2.02454,y=2.10852,z=10.7283}, {x=0,y=0,z=speed_angle})

    local energy_indicator_angle = airutils.get_gauge_angle((self._max_fuel - self._energy)) - 90
    self.object:set_bone_position("fuel", {x=3.92667, y=-0.062289, z=10.7283}, {x=0, y=0, z=-energy_indicator_angle+180})

    --altimeter
    local altitude = (pos.y / 0.32) / 100
    local hour, minutes = math.modf( altitude )
    hour = math.fmod (hour, 10)
    minutes = minutes * 100
    minutes = (minutes * 100) / 100
    local minute_angle = (minutes*-360)/100
    local hour_angle = (hour*-360)/10 + ((minute_angle*36)/360)
    self.object:set_bone_position("altimeter_pt_1", {x=1.89403, y=2.15618, z=10.7283}, {x=0, y=0, z=(hour_angle)})
    self.object:set_bone_position("altimeter_pt_2", {x=1.89403, y=2.15618, z=10.7283}, {x=0, y=0, z=(minute_angle)})

    --adjust power indicator
    local power_indicator_angle = airutils.get_gauge_angle(self._power_lever/6.5)
    self.object:set_bone_position("power", {x=-0.026448,y=0.903035,z=10.7283}, {x=0,y=0,z=power_indicator_angle - 90})

    --set stick position
    self.object:set_bone_position("stick", {x=0, y=-6.98695, z=7.80197}, {x=self._elevator_angle/2,y=0,z=self._rudder_angle})
end

function supercub.step_additional_function(self)
    if (self.driver_name==nil) and (self.co_pilot==nil) then --pilot or copilot
        return
    end

    supercub.internal_controls(self)
end

supercub.plane_properties = {
	initial_properties = {
	    physical = true,
        collide_with_objects = true,
	    collisionbox = {-1.2, -1.28, -1.2, 1.2, 1.0, 1.2}, --{-1,0,-1, 1,0.3,1},
	    selectionbox = {-2, -1.28, -2, 2, 1, 2},
	    visual = "mesh",
        backface_culling = true,
	    mesh = "supercub_body.b3d",
        stepheight = 0.5,
        textures = {
                    "airutils_painting_2.png", --sup controle
                    "airutils_white.png", --ponteiros
                    "airutils_metal.png", "airutils_black.png", "airutils_red.png", --stick
                    "supercub_painting.png", --rudder
                    "supercub_metal.png", --sup bequilha
                    "airutils_black.png", "airutils_black.png", --bancos
                    "airutils_metal.png", --motor
                    "airutils_painting_2.png", --estab horizontal
                    "airutils_metal.png", --longarina asas interno
                    "airutils_painting_2.png", --montantes asas
                    "supercub_panel.png", --painel
                    "supercub_painting.png", --pintura inferior
                    "airutils_painting_2.png", --pintura superior
                    "airutils_name_canvas.png",
                    "supercub_glass.png", --para brisa frontal
                    "supercub_glass.png", --janelas
                    "airutils_black.png", --nacele motor
                    "supercub_grey.png", -- interior
                    "airutils_black.png", --topo painel
                    "supercub_black.png", -- painel cor 2
                    "supercub_rotor.png", --helice
                    "airutils_black.png", --cubo helice
                    "airutils_black.png", --pneu bequilha
                    "airutils_metal.png", --roda bequilha
                    "airutils_black.png", --cabeçote motor
                    "supercub_glass.png", --janela superior
                    "airutils_painting_2.png", --asas
                    "supercub_painting.png", --ponta de asa
                    "airutils_red.png",
                    "airutils_green.png",
                    "airutils_blue.png",
                    "airutils_metal.png",
                    },
    },
    textures = {},
    _anim_frames = 12,
	driver_name = nil,
	sound_handle = nil,
    owner = "",
    static_save = true,
    infotext = "",
    hp_max = 50,
    shaded = true,
    show_on_minimap = true,
    springiness = 0.1,
    buoyancy = 1.02,
    physics = airutils.physics,
    _vehicle_name = "Super Cub",
    _seats = {{x=0,y=-4,z=2},{x=0,y=-5,z=-6},},
    _seats_rot = {0, 0,},  --necessary when using reversed seats
    _have_copilot = true, --wil use the second position of the _seats list
    _have_landing_lights = true,
    _have_auto_pilot = true,
    _have_adf = false,
    _have_manual = supercub.manual_formspec,
    _max_plane_hp = 50,
    _enable_fire_explosion = true,
    _longit_drag_factor = 0.13*0.13,
    _later_drag_factor = 2.0,
    _wing_angle_of_attack = 2.0,
    _wing_angle_extra_flaps = 0,
    _wing_span = 15, --meters
    _min_speed = 3,
    _max_speed = 8,
    _max_fuel = 10,
    _speed_not_exceed = 16,
    _damage_by_wind_speed = 2,
    _hard_damage = true,
    _min_attack_angle = 0.2,
    _max_attack_angle = 90,
    _elevator_auto_estabilize = 100,
    _tail_lift_min_speed = 4,
    _tail_lift_max_speed = 8,
    _max_engine_acc = 7.5,
    _tail_angle = 12,
    _lift = 16,
    _trunk_slots = 12, --the trunk slots
    _rudder_limit = 30.0,
    _elevator_limit = 40.0,
    _flap_limit = 0.0, --just a decorarion, in degrees
    _elevator_response_attenuation = 10,
    _pitch_intensity = 0.4,
    _yaw_intensity = 25,
    _yaw_turn_rate = 14, --degrees
    _elevator_pos = {x=0, y=4.0066, z=-35.6517},
    _rudder_pos = {x=0,y=8.3886,z=-36.8955},
    _aileron_r_pos = {x=30.3772,y=8.2167,z=-7.0038},
    _aileron_l_pos = {x=-30.3772,y=8.2167,z=-7.0038},
    _color = "#ffe400",
    _color_2 = nil,
    _rudder_angle = 0,
    _acceleration = 0,
    _engine_running = false,
    _angle_of_attack = 0,
    _elevator_angle = 0,
    _power_lever = 0,
    _last_applied_power = 0,
    _energy = 1.0,
    _last_vel = {x=0,y=0,z=0},
    _longit_speed = 0,
    _show_hud = false,
    _instruction_mode = false, --flag to intruction mode
    _command_is_given = false, --flag to mark the "owner" of the commands now
    _autopilot = false,
    _auto_pilot_altitude = 0,
    _last_accell = {x=0,y=0,z=0},
    _last_time_command = 1,
    _inv = nil,
    _inv_id = "",
    _collision_sound = "airutils_collision", --the col sound
    _engine_sound = "airutils_engine",
    _painting_texture = {"supercub_painting.png",}, --the texture to paint
    _painting_texture_2 = {"airutils_painting_2.png",}, --the texture to paint
    _mask_painting_associations = {},
    _register_parts_method = supercub.register_parts_method, --the method to register plane parts
    _destroy_parts_method = supercub.destroy_parts_method,
    _plane_y_offset_for_bullet = 1,
    _name_color = 0,
    _name_hor_aligment = 3.0,
    --_custom_punch_when_attached = ww1_planes_lib._custom_punch_when_attached, --the method to execute click action inside the plane
    _custom_pilot_formspec = airutils.pilot_formspec,
    --_custom_pilot_formspec = supercub.pilot_formspec,
    _custom_step_additional_function = supercub.step_additional_function,

    get_staticdata = airutils.get_staticdata,
    on_deactivate = airutils.on_deactivate,
    on_activate = airutils.on_activate,
    logic = airutils.logic,
    on_step = airutils.on_step,
    on_punch = airutils.on_punch,
    on_rightclick = airutils.on_rightclick,
}

dofile(minetest.get_modpath("supercub") .. DIR_DELIM .. "crafts.lua")
dofile(minetest.get_modpath("supercub") .. DIR_DELIM .. "entities.lua")

--
-- items
--

settings = Settings(minetest.get_worldpath() .. "/supercub.conf")
local function fetch_setting(name)
    local sname = name
    return settings and settings:get(sname) or minetest.settings:get(sname)
end


local old_entities = {"supercub:seat_base","supercub:engine","supercub:pointer","supercub:stick"}
for _,entity_name in ipairs(old_entities) do
    minetest.register_entity(":"..entity_name, {
        on_activate = function(self, staticdata)
            self.object:remove()
        end,
    })
end


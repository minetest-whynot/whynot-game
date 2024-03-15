hydroplane={}

dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "manual.lua")

function hydroplane.land_gear_operate(self)
    local pos = {x=0,y=-23.4,z=8.5}
    local pos2 = {x=0,y=-18.7,z=-3.5}
    if self.isonground then
        --if self._land_retracted == true then
            self._land_retracted = false
            --extends landing gear
            self.wheels:set_bone_position("arms", pos, {x=0,y=0,z=0})
            self.wheels:set_bone_position("rear", pos2, {x=0,y=0,z=0})
            --minetest.chat_send_all("extended")
        --end
    else
        --if self._land_retracted == false then
            self._land_retracted = true
            --retracts landing gear
            self.wheels:set_bone_position("arms", pos, {x=-14.6,y=0,z=0})
            local pos2_retracted = vector.new(pos2)
            pos2_retracted.y = pos2_retracted.y + 3
            self.wheels:set_bone_position("rear", pos2_retracted, {x=0,y=0,z=0})
            --minetest.chat_send_all("retracted")
        --end
    end

end

function hydroplane.register_parts_method(self)
    local pos = self.object:get_pos()

    local wheels=minetest.add_entity(pos,'hidroplane:floaters')
    wheels:set_attach(self.object,'',{x=0,y=0,z=0},{x=0,y=0,z=0})
	-- set the animation once and later only change the speed
    wheels:set_animation({x = 1, y = 12}, 0, 0, true)
    self.wheels = wheels
    airutils.add_paintable_part(self, self.wheels)

    --minetest.chat_send_all(self.initial_properties.textures[19])
    --airutils.paint(self.wheels:get_luaentity(), self._color)
end

function hydroplane.destroy_parts_method(self)
    if self.wheels then self.wheels:remove() end

    local pos = self.object:get_pos()
    if not minetest.settings:get_bool('hidroplane.disable_craftitems') then
        pos.y=pos.y+2

        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'supercub:wings')

        for i=1,5 do
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:tin_ingot')
        end

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
        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'hidroplane:hidro')
    end
end

function hydroplane.step_additional_function(self)
    hydroplane.land_gear_operate(self)

    if (self.driver_name==nil) and (self.co_pilot==nil) then --pilot or copilot
        return
    end

    supercub.internal_controls(self)
end

hydroplane.plane_properties = airutils.properties_copy(supercub.plane_properties)
hydroplane.plane_properties._tail_angle = 0
hydroplane.plane_properties._lift = 18
hydroplane.plane_properties.buoyancy = 0.25
hydroplane.plane_properties._max_speed = 7.5
hydroplane.plane_properties._speed_not_exceed = 15
hydroplane.plane_properties._vehicle_name = "Super Duck Hydroplane"
hydroplane.plane_properties._custom_step_additional_function = hydroplane.step_additional_function
hydroplane.plane_properties._register_parts_method = hydroplane.register_parts_method
hydroplane.plane_properties._destroy_parts_method = hydroplane.destroy_parts_method
hydroplane.plane_properties._have_manual = hydroplane.manual_formspec
hydroplane.plane_properties.initial_properties = airutils.properties_copy(supercub.plane_properties.initial_properties)
hydroplane.plane_properties.initial_properties.collisionbox = {-1.2, -2.3, -1.2, 1.2, 1, 1.2}
hydroplane.plane_properties.initial_properties.selectionbox = {-2, -2.3, -2, 2, 1, 2}

dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "crafts.lua")
dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "entities.lua")

--
-- items
--

settings = Settings(minetest.get_worldpath() .. "/hidroplane.conf")
local function fetch_setting(name)
    local sname = name
    return settings and settings:get(sname) or minetest.settings:get(sname)
end

local old_entities = {"hidroplane:seat_base","hidroplane:engine","hidroplane:pointer","hidroplane:stick","hidroplane:front_wheels","hidroplane:wheels"}
for _,entity_name in ipairs(old_entities) do
    minetest.register_entity(":"..entity_name, {
        on_activate = function(self, staticdata)
            self.object:remove()
        end,
    })
end


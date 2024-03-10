local function check_protection(pos, name)
	if minetest.is_protected(pos, name) then
		minetest.log("action", name
			.. " tried to place a Wind Indicator"
			.. " at protected position "
			.. minetest.pos_to_string(pos)
        )
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end

function airutils.WindDplace(player,pos)
    if not player then
        return
    end

	local dir = minetest.dir_to_facedir(vector.new())
	local pos1 = vector.new(pos)

    local player_name = player:get_player_name()
	if check_protection(pos, player_name) then
		return
	end

	core.set_node(pos1, {name="airutils:wind", param2=dir})
	local meta = core.get_meta(pos)
	meta:set_string("infotext", "Wind Indicator\rOwned by: "..player_name)
	meta:set_string("owner", player_name)
	meta:set_string("dont_destroy", "false")
	return true
end

airutils.wind_collision_box = {
	type = "fixed",
	fixed={{-0.5,0,-0.5,0.5,5.0,0.5},},
}

airutils.wind_selection_box = {
	type = "fixed",
	fixed={{-0.5,0,-0.5,0.5,5.0,0.5},},
}

local function get_smooth(angle_initial, reference, last_ref, value)
    local range = reference-last_ref
    local retVal = (value*angle_initial)/range
    retval = angle_initial - retVal
    if retval < 0 then retval = 0 end
    return retval
end

minetest.register_entity("airutils:wind_indicator",{
											-- common props
	physical = true,
	stepheight = 0.5,				
	collide_with_objects = true,
	collisionbox = {-0.5, 0, -0.5, 0.5, 5.0, 0.5},
	visual = "mesh",
	mesh = "airutils_wind.b3d",
	textures = {"airutils_red.png", "airutils_black.png", "airutils_white.png", "airutils_metal.png"},
	static_save = true,
	makes_footstep_sound = false,
    _pos = nil,

    on_activate = function(self, staticdata, dtime_s)
        self._pos = self.object:get_pos()
    end,

	on_step = function(self,dtime,colinfo)
        self.object:set_pos(self._pos)

        local wind = airutils.get_wind(self._pos, 1.0)
        local wind_yaw = minetest.dir_to_yaw(wind)
        self.object:set_bone_position("ajuste", {x=0,y=42,z=0}, {x=0,y=0,z=90})
        self.object:set_bone_position("b_a", {x=0,y=0,z=0}, {x=math.deg(wind_yaw)-90,y=0,z=0})

        local false_div = 1 --trying to make it more o minus sensible
        local vel = ((vector.dot(vector.multiply(wind,dtime),wind))/false_div)*100
        --minetest.chat_send_all(vel)
        local b_b = 65
        if vel > 11 then
            b_b = get_smooth(65, 11, 0, vel)
        end
        self.object:set_bone_position("b_b", {x=0,y=8.25,z=0}, {x=0,y=0,z=-b_b})

        local b_c = 15
        if vel > 16 then
            b_c = get_smooth(15, 16, 11, vel)
        end
        self.object:set_bone_position("b_c", {x=0,y=6.0,z=0}, {x=0,y=0,z=-b_c})

        local b_d = 5
        if vel > 22 then
            b_d = get_smooth(5, 22, 16, vel)
        end
        self.object:set_bone_position("b_d", {x=0,y=4.5,z=0}, {x=0,y=0,z=-b_d})

        local b_e = 2
        if vel > 28 then
            b_e = get_smooth(2, 28, 22, vel)
        end
        self.object:set_bone_position("b_e", {x=0,y=3,z=0}, {x=0,y=0,z=-b_e})

        --minetest.chat_send_all("Wind Direction: "..math.deg(wind_yaw))
    end,	-- required
	--on_activate = mobkit.actfunc,		-- required
	--get_staticdata = mobkit.statfunc,
	max_hp = 65535,
	timeout = 0,
    on_punch=function(self, puncher)
		return
	end,
                                            
    on_rightclick = function(self, clicker)
        local wind = airutils.get_wind(pos, 2.0)
        local wind_yaw = minetest.dir_to_yaw(wind)
        minetest.chat_send_player(clicker:get_player_name(),core.colorize('#00ff00', " >>> The wind direction now is "..math.deg(wind_yaw)))
		return
    end,
                                            
})



-- Wind Indicator node (default left)
minetest.register_node("airutils:wind",{
	description = "Wind Direction Indicator",
	waving = 1,
	tiles = {"default_tin_block.png","default_tin_block.png","default_tin_block.png","default_tin_block.png","default_tin_block.png","default_tin_block.png"},
	paramtype = "light",
	paramtype2 = "leveled",
	is_ground_content = false,
	groups = {cracky = 1, level = 2},
	walkable = true,
	selection_box = {
		type = "fixed",
		fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
				{-0.1,  0.5, -0.1, 0.1, 2.0, 0.1}
		}
	},          
	
	node_dig_prediction = "default:dirt",
	node_placement_prediction = "airutils:wind",
	
	on_place = function(itemstack, placer, pointed_thing)
                                                
		local pos = pointed_thing.above

			local player_name = placer:get_player_name()


			if not minetest.is_protected(pos, player_name) and not minetest.is_protected(pos, player_name) then
				minetest.set_node(pos, {name = "airutils:wind",param2 = 1 })
				minetest.add_entity({x=pos.x, y=pos.y, z=pos.z},"airutils:wind_indicator")
				local meta = minetest.get_meta(pos)
				if not (creative and creative.is_enabled_for and creative.is_enabled_for(player_name)) then
					itemstack:take_item()
				end
			else
				minetest.chat_send_player(player_name, "Node is protected")
				minetest.record_protection_violation(pos, player_name)
			end


		return itemstack
	end,
	
	on_destruct = function(pos)
		local meta=minetest.get_meta(pos)
		if meta then
		    local cpos = {x=pos.x, y= pos.y, z=pos.z}
		    local object = minetest.get_objects_inside_radius(cpos, 1)
		    for _,obj in ipairs(object) do
			    local entity = obj:get_luaentity()
			    if entity and entity.name == "airutils:wind_indicator" then
				    obj:remove()
			    end
		    end
		end
	end,
})

-- WIND craft
minetest.register_craft({
	output = 'airutils:wind',
	recipe = {
		{'wool:white', 'wool:white', 'wool:white'},
		{'wool:white', 'default:steel_ingot' , 'wool:white'},
		{''             , 'default:steel_ingot' , ''},
	}
})

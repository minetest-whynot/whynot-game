local S = minetest.get_translator("airutils")

function airutils.move_target(player, pointed_thing)
    local pos = player:get_pos()
    local yaw = player:get_look_horizontal()

    local object = pointed_thing.ref
    --minetest.chat_send_all(dump(object))
    if object then
        local obj_pos = object:get_pos()
        local hip = math.sqrt(math.pow(obj_pos.x - pos.x,2)+math.pow(obj_pos.z - pos.z,2)) + 1
        pos_x = math.sin(yaw) * -hip
        pos_z = math.cos(yaw) * hip
        obj_pos.x = pos.x + pos_x
        obj_pos.z = pos.z + pos_z

        local node = minetest.get_node(obj_pos).name
        local nodedef = minetest.registered_nodes[node]
        local is_airlike = nodedef.drawtype == "airlike"
        local is_liquid = (nodedef.drawtype == "flowingliquid" or nodedef.drawtype == "liquid")

        if player:get_player_control().sneak == true then
            local rotation = object:get_rotation()
            if rotation then
                rotation.y = yaw + math.rad(180)
                object:set_rotation(rotation)
            end
        else
            if is_airlike or is_liquid then object:set_pos(obj_pos) end
        end
        --[[if object:get_attach() then
            local dir = player:get_look_dir()
            minetest.chat_send_all('detach')
            object:set_detach()
            object:set_rotation(dir)
        else
            minetest.chat_send_all('object found')
            object:set_attach(player, "", {x=0, y=0, z=20})
        end]]--
    end
end

minetest.register_tool("airutils:tug", {
	description = "Tug tool for airport",
	inventory_image = "airutils_tug.png",
	stack_max=1,
	on_use = function(itemstack, player, pointed_thing)
		if not player then
			return
		end

        local is_admin = false
        is_admin = minetest.check_player_privs(player, {server=true})            
            
        local pos = player:get_pos()
        local pname = player:get_player_name()

        --[[if areas then
            if not areas:canInteract(pos, pname) then
		        local owners = areas:getNodeOwners(pos)
		        minetest.chat_send_player(pname,
			        S("@1 is protected by @2.",
				        minetest.pos_to_string(pos),
				        table.concat(owners, ", ")))
	        else
                airutils.move_target(player, pointed_thing)
            end
        end]]--
        local is_protected = minetest.is_protected
        if is_protected then
            local owner = nil
            local object = pointed_thing.ref
            if object then
                local ent = object:get_luaentity()
                if ent then
                    if ent.owner then owner = ent.owner end
                end
            end
            if not is_protected(pos, pname) or pname == owner or is_admin then
                airutils.move_target(player, pointed_thing)
            else
		        minetest.chat_send_player(pname,
			        S("@1 is protected.",
				        minetest.pos_to_string(pos)))
            end
        end

        if not is_protected then
            airutils.move_target(player, pointed_thing)
        end


	end,

	sound = {breaks = "default_tool_breaks"},
})

minetest.register_craft({
	output = "airutils:tug",
	recipe = {
		{"", "", "default:steel_ingot"},
		{"", "default:steel_ingot", ""},
		{"default:steel_ingot", "default:stick", "default:diamond"},
	}
})

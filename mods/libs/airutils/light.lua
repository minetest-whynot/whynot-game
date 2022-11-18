
function airutils.get_xz_from_hipotenuse(orig_x, orig_z, yaw, distance)
    --cara, o minetest é bizarro, ele considera o eixo no sentido ANTI-HORÁRIO... Então pra equação funcionar, subtrair o angulo de 360 antes
    yaw = math.rad(360) - yaw
    local z = (math.cos(yaw)*distance) + orig_z
    local x = (math.sin(yaw)*distance) + orig_x
    return x, z
end

minetest.register_node("airutils:light", {
	drawtype = "airlike",
	--tile_images = {"airutils_light.png"},
	inventory_image = minetest.inventorycube("airutils_light.png"),
	paramtype = "light",
	walkable = false,
	is_ground_content = true,
	light_propagates = true,
	sunlight_propagates = true,
	light_source = 14,
	selection_box = {
		type = "fixed",
		fixed = {0, 0, 0, 0, 0, 0},
	},
})

function airutils.remove_light(self)
    if self._light_old_pos then
        --force the remotion of the last light
        minetest.add_node(self._light_old_pos, {name="air"})
        self._light_old_pos = nil
    end
end

function airutils.swap_node(self, pos)
    local target_pos = pos
    local have_air = false
    local node = nil
    local count = 0
    while have_air == false and count <= 3 do
        node = minetest.get_node(target_pos)
        if node.name == "air" then
            have_air = true
            break
        end
        count = count + 1
        target_pos.y = target_pos.y + 1
    end
    
    if have_air then
        minetest.set_node(target_pos, {name='airutils:light'})
        airutils.remove_light(self)
        self._light_old_pos = target_pos
        return true
    end
    return false
end

function airutils.put_light(self)
    local pos = self.object:get_pos()
    pos.y = pos.y + 1
    local yaw = self.object:get_yaw()
    local lx, lz = airutils.get_xz_from_hipotenuse(pos.x, pos.z, yaw, 10)
    local light_pos = {x=lx, y=pos.y, z=lz}

	local cast = minetest.raycast(pos, light_pos, false, false)
	local thing = cast:next()
    local was_set = false
	while thing do
		if thing.type == "node" then
            local ipos = thing.intersection_point
            if ipos then
                was_set = airutils.swap_node(self, ipos)
            end
        end
        thing = cast:next()
    end
    if was_set == false then
        local n = minetest.get_node_or_nil(light_pos)
        if n and n.name == 'air' then
            airutils.swap_node(self, light_pos)
        end
    end
end

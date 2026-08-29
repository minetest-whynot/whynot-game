
-- lib_mount by Blert2112 (edited by TenPlus1)

local is_mc2 = core.get_modpath("mcl_mobs") -- MineClone2 check

-- one of these is needed to ride mobs, otherwise no riding for you

if not core.get_modpath("player_api") and not is_mc2 then

	function mobs.attach() end
	function mobs.detach() end
	function mobs.fly() end
	function mobs.drive() end

	return
end

-- Localise some functions

local abs, cos, floor, sin, pi = math.abs, math.cos, math.floor, math.sin, math.pi
local min, max, sqrt = math.min, math.max, math.sqrt

-- helper functions

local function get_sign(i)

	if not i or i == 0 then return 0 end

	return i / abs(i)
end


local function get_velocity(v, yaw, y)
	return {x = -sin(yaw) * v, y = y, z =  cos(yaw) * v}
end


local function get_v(v)
	return sqrt(v.x * v.x + v.z * v.z)
end


local function force_detach(player)

	local attached_to = player and player:get_attach()

	if not attached_to then return end

	local entity = attached_to:get_luaentity()

	if entity and entity.driver and entity.driver == player then
		entity.driver = nil
	end

	player:set_detach()

	local name = player:get_player_name()

	if is_mc2 then
		mcl_player.player_attached[player:get_player_name()] = false
		mcl_player.player_set_animation(player, "stand", 30)
	else
		player_api.player_attached[name] = false
		player_api.set_animation(player, "stand", 30)
	end

	player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
	player:set_properties({visual_size = {x = 1, y = 1}})
end

-- detach player on leaving

core.register_on_leaveplayer(function(player)
	force_detach(player)
end)

-- detatch all players on shutdown

core.register_on_shutdown(function()

	for _, player in ipairs(core.get_connected_players()) do
		force_detach(player)
	end
end)

-- detatch player when dead

core.register_on_dieplayer(function(player)
	force_detach(player)
	return true
end)

-- find free position to detach player

local check = {
	{x = 1,  y = 0, z =  0}, {x = 1,  y = 1, z =  0}, {x = -1, y = 0, z =  0},
	{x = -1, y = 1, z =  0}, {x = 0,  y = 0, z =  1}, {x = 0,  y = 1, z =  1},
	{x = 0,  y = 0, z = -1}, {x = 0,  y = 1, z = -1}
}

local function find_free_pos(pos)

	for _, c in pairs(check) do

		local npos = {x = pos.x + c.x, y = pos.y + c.y, z = pos.z + c.z}
		local def = core.registered_nodes[core.get_node(npos).name] or {}

		if def.liquidtype == "none" and not def.walkable and def.name ~= "ignore" then
			return npos
		end
	end

	return pos
end

-- are we a real player ?

local function is_player(player)

	if player and type(player) == "userdata" and core.is_player(player) then
		return true
	end
end

-- attach player to mob entity

function mobs.attach(entity, player)

	if not player or not entity then return end

	entity.player_rotation = entity.player_rotation or {x = 0, y = 0, z = 0}
	entity.driver_attach_at = entity.driver_attach_at or {x = 0, y = 0, z = 0}
	entity.driver_eye_offset = entity.driver_eye_offset or {x = 0, y = 0, z = 0}
	entity.driver_scale = entity.driver_scale or {x = 1, y = 1}

	local rot_view = (entity.player_rotation.y == 90) and (pi / 2) or 0
	local attach_at = entity.driver_attach_at
	local eye_offset = entity.driver_eye_offset

	entity.driver = player

	force_detach(player)

	if is_mc2 then
		mcl_player.player_attached[player:get_player_name()] = true
	else
		player_api.player_attached[player:get_player_name()] = true
	end

	player:set_attach(entity.object, "", attach_at, entity.player_rotation)
	player:set_eye_offset(eye_offset, {x = 0, y = 0, z = 0})

	player:set_properties({
		visual_size = {x = entity.driver_scale.x, y = entity.driver_scale.y}
	})

	core.after(0.2, function()

		if is_player(player) then

			if is_mc2 then
				mcl_player.player_set_animation(player, "sit_mount" , 30)
			else
				player_api.set_animation(player, "sit", 30)
			end
		end
	end)

	player:set_look_horizontal(entity.object:get_yaw() - rot_view)
end

-- detatch player from mob

function mobs.detach(player)

	force_detach(player)

	core.after(0.1, function()

		if player and player:is_player() then

			local pos = find_free_pos(player:get_pos())

			pos.y = pos.y + 0.5

			player:set_pos(pos)
		end
	end)
end

-- ride mob like horse or even a car

function mobs.drive(entity, moving_anim, stand_anim, can_fly, dtime)

	local yaw = entity.object:get_yaw() ; if not yaw then return end
	local rot_view = (entity.player_rotation.y == 90) and (pi / 2) or 0
	local acce_y = 0
	local velo = entity.object:get_velocity() ; if not velo then return end

	entity.v = get_v(velo) * get_sign(entity.v)

	-- process controls
	if entity.driver then

		local ctrl = entity.driver:get_player_control()

		if ctrl.up then -- move forwards

			entity.v = entity.v + (entity.accel * dtime)

		elseif ctrl.down then -- move backwards

			if entity.max_speed_reverse ~= 0 then
				entity.v = entity.v - (entity.accel * dtime)
			end
		end

		-- mob rotation
		local horz = entity.alt_turn and yaw or (entity.driver:get_look_horizontal() or 0)

		if entity.alt_turn then

			if ctrl.left then horz = horz + 0.05
			elseif ctrl.right then horz = horz - 0.05 end
		end

		entity.object:set_yaw(horz - entity.rotate)

		-- firing arrows
		if ctrl.LMB and ctrl.sneak and entity.do_mount_action then
			entity.do_mount_action(entity, dtime)
		end

		if can_fly then

			if ctrl.jump then -- fly up

				velo.y = min(velo.y + 1, entity.accel)

			elseif velo.y > 0 then

				velo.y = max(velo.y - dtime, 0)
			end

			if ctrl.sneak then -- fly down

				velo.y = max(velo.y - 1, -entity.accel)

			elseif velo.y < 0 then

				velo.y = min(velo.y + dtime, 0)
			end
		else
			-- jump (only when standing on solid surface)
			if ctrl.jump and velo.y == 0 and entity.standing_on ~= "air"
			and entity.standing_on ~= "ignore"
			and core.get_item_group(entity.standing_on, "liquid") == 0 then
				velo.y = velo.y + entity.jump_height
				acce_y = acce_y + (acce_y * 3) + 1
			end
		end
	end

	-- if not moving then set animation and return
	if entity.v == 0 and velo.x == 0 and velo.y == 0 and velo.z == 0 then

		if stand_anim then entity:set_animation(stand_anim) end ; return
	end

	-- set moving animation
	if moving_anim then entity:set_animation(moving_anim) end

	-- Stop!
	local s = get_sign(entity.v)

	entity.v = entity.v - (0.02 * s)

	if s ~= get_sign(entity.v) then

		entity.object:set_velocity({x = 0, y = 0, z = 0})
		entity.v = 0

		return
	end

	-- enforce speed limit forward and reverse
	if entity.v > entity.max_speed_forward then
		entity.v = entity.max_speed_forward
	elseif entity.v < -entity.max_speed_reverse then
		entity.v = -entity.max_speed_reverse
	end

	-- Set position, velocity and acceleration
	local p = entity.object:get_pos() ; if not p then return end
	local v = entity.v
	local new_velo = get_velocity(v, yaw - rot_view, velo.y)
	local fall_speed = can_fly and 0 or entity.fall_speed

	new_velo.y = new_velo.y  + acce_y

	entity.object:set_velocity(new_velo)
	entity.object:set_acceleration({x = 0, y = fall_speed, z = 0})
end

-- fly mob in facing direction (by D00Med, edited by TenPlus1)

function mobs.fly(entity, dtime, speed, shoots, arrow, moving_anim, stand_anim)

	if not entity.driver then return end -- player check

	local ctrl = entity.driver:get_player_control() ; if not ctrl then return end
	local velo = entity.object:get_velocity() ; if not velo then return end
	local dir = entity.driver:get_look_dir()
	local yaw = entity.driver:get_look_horizontal() ; if not yaw then return end

	yaw = yaw  + 1.57 -- fix from get_yaw to get_look_horizontal

	if ctrl.up then

		entity.object:set_velocity(
				{x = dir.x * speed, y = dir.y * speed + 2, z = dir.z * speed})

	elseif ctrl.down then

		entity.object:set_velocity(
				{x = -dir.x * speed, y =  dir.y * speed + 2, z = -dir.z * speed})

	elseif not ctrl.down or ctrl.up or ctrl.jump then
		entity.object:set_velocity({x = 0, y = -2, z = 0})
	end

	entity.object:set_yaw(yaw + pi + (pi / 2) - entity.rotate)

	-- shooting feature
	if ctrl.LMB and ctrl.sneak then

		-- custom function if found
		if entity.do_mount_action then

			entity.do_mount_action(entity, dtime)

		-- old arrow method for compatibility
		elseif shoots and arrow then

			entity.arrow_shoot_timer = entity.arrow_shoot_timer or 0

			-- 1 second timer between shots
			if (os.time() - entity.arrow_shoot_timer) >= 1 then

				local pos = entity.object:get_pos()
				local obj = core.add_entity({
					x = pos.x + 0 + dir.x * 2.5,
					y = pos.y + 1.5 + dir.y,
					z = pos.z + 0 + dir.z * 2.5}, arrow)

				local ent = obj:get_luaentity()

				if ent then

					ent.switch = 1 -- for mob specific arrows
					ent.owner_id = tostring(entity.object) -- so arrows dont hurt mob

					local vec = {x = dir.x * 12, y = dir.y * 12, z = dir.z * 12}

					yaw = entity.driver:get_look_horizontal()

					obj:set_yaw(yaw + pi / 2)
					obj:set_velocity(vec)
				end

				entity.arrow_shoot_timer = os.time()
			end
		end
	end

	if velo.x == 0 and velo.y == 0 and velo.z == 0 then
		entity:set_animation(stand_anim) -- stopped animation
	else
		entity:set_animation(moving_anim) -- moving animation
	end
end

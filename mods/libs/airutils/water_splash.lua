local function calculateVelocity(magnitude, angle)
    -- Calcula os componentes do vetor usando ângulo polar
    -- Supondo que o ângulo é dado no plano XY, com z = 0
    local velocity = {
        x = magnitude * math.cos(angle),
        y = 0, -- Se a velocidade não tem componente z
        z = magnitude * math.sin(angle),
    }

    return velocity
end

local function water_particle(pos, accell)
    if airutils.splash_texture == nil then return end
    if airutils.splash_texture == "" then return end

	minetest.add_particle({
		pos = pos,
		velocity = {x = 0, y = 0, z = 0},
		acceleration = accell, --{x = 0, y = 0, z = 0},
		expirationtime = 2.0,
		size = 4.8,
		collisiondetection = false,
		collision_removal = false,
		vertical = false,
		texture = airutils.splash_texture,
	})
end

function airutils.add_splash(pos, yaw, x_pos)
    local direction = yaw

    local spl_pos = vector.new(pos)
    --water_particle(spl_pos, {x=0,y=0,z=0})

    --right
    local move = x_pos/10
    spl_pos.x = spl_pos.x + move * math.cos(direction)
    spl_pos.z = spl_pos.z + move * math.sin(direction)

    local velocity = calculateVelocity(0.2, yaw)
    water_particle(spl_pos, velocity)

    --left
    direction = direction - math.rad(180)
    spl_pos = vector.new(pos)
    spl_pos.x = spl_pos.x + move * math.cos(direction)
    spl_pos.z = spl_pos.z + move * math.sin(direction)

    velocity = calculateVelocity(0.2, yaw - math.rad(180))
    water_particle(spl_pos, velocity)
end

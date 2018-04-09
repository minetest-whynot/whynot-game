
-- load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")


-- creative check
local creative_mode_cache = minetest.settings:get_bool("creative_mode")
function is_creative(name)
	return creative_mode_cache or minetest.check_player_privs(name, {creative = true})
end


-- hoe bomb function
local function hoe_area(pos)

	local r = 5 -- radius

	-- remove flora (grass, flowers etc.)
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
		{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
		{"group:flora"})

	for n = 1, #res do
		minetest.swap_node(res[n], {name = "air"})
	end

	-- replace dirt with tilled soil
	res = nil
	res = minetest.find_nodes_in_area_under_air(
		{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
		{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
		{"group:soil"})

	for n = 1, #res do
		minetest.swap_node(res[n], {name = "farming:soil"})
	end
end


-- throwable hoe bomb
minetest.register_entity("farming:hoebomb_entity", {
	physical = true,
	visual = "sprite",
	visual_size = {x = 1.0, y = 1.0},
	textures = {"farming_hoe_bomb.png"},
	collisionbox = {0,0,0,0,0,0},
	lastpos = {},
	player = "",

	on_step = function(self, dtime)

		if not self.player then

			self.object:remove()

			return
		end

		local pos = self.object:get_pos()

		if self.lastpos.x ~= nil then

			local vel = self.object:getvelocity()

			-- only when potion hits something physical
			if vel.x == 0
			or vel.y == 0
			or vel.z == 0 then

				if self.player ~= "" then

					-- round up coords to fix glitching through doors
					self.lastpos = vector.round(self.lastpos)

					hoe_area(self.lastpos)
				end

				self.object:remove()

				return

			end
		end

		self.lastpos = pos
	end
})


-- actual throwing function
local function throw_potion(itemstack, player)

	local playerpos = player:get_pos()

	local obj = minetest.add_entity({
		x = playerpos.x,
		y = playerpos.y + 1.5,
		z = playerpos.z
	}, "farming:hoebomb_entity")

	local dir = player:get_look_dir()
	local velocity = 20

	obj:setvelocity({
		x = dir.x * velocity,
		y = dir.y * velocity,
		z = dir.z * velocity
	})

	obj:setacceleration({
		x = dir.x * -3,
		y = -9.5,
		z = dir.z * -3
	})

	obj:setyaw(player:get_look_yaw() + math.pi)
	obj:get_luaentity().player = player
end


-- hoe bomb item
minetest.register_craftitem("farming:hoe_bomb", {
	description = S("Hoe Bomb (use or throw on grassy areas to hoe land"),
	inventory_image = "farming_hoe_bomb.png",
	groups = {flammable = 2, not_in_creative_inventory = 1},
	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type == "node" then
			hoe_area(pointed_thing.above)
		else
			throw_potion(itemstack, user)

			if not is_creative(user:get_player_name()) then

				itemstack:take_item()

				return itemstack
			end
		end
	end,
})

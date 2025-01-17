-- Home decor seating
-- forked from the previous lrfurn mod

local S = minetest.get_translator("homedecor_seating")
local modpath = minetest.get_modpath("homedecor_seating")

lrfurn = {}

lrfurn.fdir_to_right = {
	{  1,  0 },
	{  0, -1 },
	{ -1,  0 },
	{  0,  1 },
}

lrfurn.colors = {
	"black",
	"brown",
	"blue",
	"cyan",
	"dark_grey",
	"dark_green",
	"green",
	"grey",
	"magenta",
	"orange",
	"pink",
	"red",
	"violet",
	"white",
	"yellow",
}

function lrfurn.check_right(pos, fdir, long, placer)
	if not fdir or fdir > 3 then fdir = 0 end

	local pos2 = {
		x = pos.x + lrfurn.fdir_to_right[fdir+1][1],
		y = pos.y, z = pos.z + lrfurn.fdir_to_right[fdir+1][2]
	}
	local pos3 = {
		x = pos.x + lrfurn.fdir_to_right[fdir+1][1] * 2,
		y = pos.y, z = pos.z + lrfurn.fdir_to_right[fdir+1][2] * 2
	}

	local node2 = minetest.get_node(pos2)
	if node2 and node2.name ~= "air" then
		return false
	elseif minetest.is_protected(pos2, placer:get_player_name()) then
		if not long then
			minetest.chat_send_player(placer:get_player_name(), S("Someone else owns the spot where the other end goes!"))
		else
			minetest.chat_send_player(placer:get_player_name(),
				S("Someone else owns the spot where the middle or far end goes!"))
		end
		return false
	end

	if long then
		local node3 = minetest.get_node(pos3)
		if node3 and node3.name ~= "air" then
			return false
		elseif minetest.is_protected(pos3, placer:get_player_name()) then
			minetest.chat_send_player(placer:get_player_name(), S("Someone else owns the spot where the other end goes!"))
			return false
		end
	end

	return true
end

function lrfurn.fix_sofa_rotation_nsew(pos, placer, itemstack, pointed_thing)
	local node = minetest.get_node(pos)
	local colorbits = node.param2 - (node.param2 % 8)
	local yaw = placer:get_look_horizontal()
	local dir = minetest.yaw_to_dir(yaw)
	local fdir = minetest.dir_to_wallmounted(dir)
	minetest.swap_node(pos, { name = node.name, param2 = fdir+colorbits })
end

local seated_cache = {}
local offset_cache = {}

minetest.register_entity("homedecor_seating:seat", {
	initial_properties = {
		visual = "cube",
		--comment out the following when testing so you can see it
		textures = {"blank.png", "blank.png", "blank.png", "blank.png", "blank.png", "blank.png"},
		collisionbox = { -0.01, -0.01, -0.01, 0.01, 0.01, 0.01 },
		selectionbox = { -0.01, -0.01, -0.01, 0.01, 0.01, 0.01, rotate = false },
		static_save = false,
	},
	on_punch = function(self)
		self.object:remove()
	end,
})

--we only care about 4 rotations, but just in case someone worldedits, etc - do something other than crash
--radians are stupid, using degrees and then converting
local p2r = {
	0*math.pi/180,
	0*math.pi/180, --correct
	180*math.pi/180, --correct
	90*math.pi/180, --correct
	270*math.pi/180, --correct
	0*math.pi/180,
	0*math.pi/180,
	0*math.pi/180,
}
p2r[0] = p2r[1]

local p2r_sofa = {
	0*math.pi/180,
	90*math.pi/180, --correct
	270*math.pi/180, --correct
	180*math.pi/180, --correct
	0*math.pi/180, --correct
	0*math.pi/180,
	0*math.pi/180,
	0*math.pi/180,
}
p2r_sofa[0] = p2r_sofa[1]

local p2r_facedir = {
	[0] = 180*math.pi/180,
	[1] = 90*math.pi/180,
	[2] = 0*math.pi/180,
	[3] = 270*math.pi/180,
}

function lrfurn.sit(pos, node, clicker, itemstack, pointed_thing, seats)
	if not clicker:is_player() then
		return itemstack
	end

	local name = clicker:get_player_name()
	if seated_cache[name] then --already sitting
		lrfurn.stand(clicker)
		return itemstack
	end

	--conversion table for param2 to dir
	local p2d = {
		vector.new(0, 0, 0),
		vector.new(0, 0, -1),
		vector.new(0, 0, 1),
		vector.new(1, 0, 0),
		vector.new(-1, 0, 0),
		vector.new(0, 0, 0),
		vector.new(0, 0, 0)
	}

	--generate posible seat positions
	local valid_seats = {[minetest.hash_node_position(pos)] = pos}
	if seats > 1 then
		for i=1,seats-1 do
			--since this are hardware colored nodes, node.param2 gives us a actual param to get a dir from
			local npos = vector.add(pos, vector.multiply(p2d[node.param2 % 8], i))
			valid_seats[minetest.hash_node_position(npos)] = npos
		end
	end

	--see if we can find a non occupied seat
	local sit_pos
	local sit_hash
	for hash, spos in pairs(valid_seats) do
		local pstatus = false
		for _, ref in pairs(minetest.get_objects_inside_radius(spos, 0.5)) do
			if ref:is_player() and seated_cache[ref:get_player_name()] then
				pstatus = true
			end
		end
		if not pstatus then
			sit_pos = spos
			sit_hash = hash
			break;
		end
	end
	if not sit_pos then
		minetest.chat_send_player(name, "sorry, this seat is currently occupied")
		return itemstack
	end

	--seat the player
	clicker:set_pos(sit_pos)

	local entity = minetest.add_entity(sit_pos, "homedecor_seating:seat")
	if not entity then return itemstack end --catch for when the entity fails to spawn just in case

	clicker:set_attach(entity, "", {x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0}, true)
	local nodedef = minetest.registered_nodes[node.name]
	if nodedef.paramtype2 == "facedir" then
		entity:set_rotation({x = 0, y = p2r_facedir[node.param2 % 4], z = 0})
	elseif string.find(node.name, "sofa") then
		entity:set_rotation({x = 0, y = p2r_sofa[node.param2 % 8], z = 0})
	else
		entity:set_rotation({x = 0, y = p2r[node.param2 % 8], z = 0})
	end

	xcompat.player.player_attached[name] = true
    xcompat.player.set_animation(clicker, "sit", 0)
	seated_cache[name] = minetest.hash_node_position(pos)
	if seated_cache[name] ~= sit_hash then
		offset_cache[name] = core.hash_node_position(vector.subtract(pos, sit_pos))
	end

	return itemstack
end

function lrfurn.stand(clicker)
	local name = clicker:get_player_name()
	xcompat.player.player_attached[name] = false
	if seated_cache[name] then
		local attached_to = clicker:get_attach()
		-- Check, clearobjects might have been called, etc
		if attached_to then
			-- Removing also detaches
			attached_to:remove()
		end
		seated_cache[name] = nil
		offset_cache[name] = nil
	end
end

-- Called when a seat is destroyed
function lrfurn.on_seat_destruct(pos)
	for name, seatpos in pairs(seated_cache) do
		if seatpos == minetest.hash_node_position(pos) then
			local player = minetest.get_player_by_name(name)
			if player then
				lrfurn.stand(player)
			end
		end
	end
end

function lrfurn.on_seat_movenode(from_pos, to_pos)
	local hashed_from_pos = core.hash_node_position(from_pos)
	local hashed_to_pos = core.hash_node_position(to_pos)
	for name, seatpos in pairs(seated_cache) do
		if seatpos == hashed_from_pos then
			local player = core.get_player_by_name(name)
			if player then
				local attached_to = player:get_attach()
				-- Check, clearobjects might have been called, etc
				if attached_to then
					if offset_cache[name] then
						-- multi-seat node aka sofas
						attached_to:set_pos(vector.subtract(to_pos,
							core.get_position_from_hash(offset_cache[name])))
					else
						attached_to:set_pos(to_pos)
					end
					seated_cache[name] = hashed_to_pos
				end
			end
		end
	end
end

--if the player gets killed in the seat, handle it
minetest.register_on_dieplayer(function(player)
	if seated_cache[player:get_player_name()] then
		lrfurn.stand(player)
	end
end)

dofile(modpath.."/longsofas.lua")
dofile(modpath.."/sofas.lua")
dofile(modpath.."/armchairs.lua")
dofile(modpath.."/misc.lua")

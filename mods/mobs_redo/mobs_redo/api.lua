-- translation & mod checks

local S = core.get_translator("mobs")
local FS = function(...) return core.formspec_escape(S(...)) end
local use_cmi = core.global_exists("cmi")
local use_mc2 = core.get_modpath("mcl_core") -- MineClonia support
local use_vh1 = core.get_modpath("visual_harm_1ndicators")
local use_tr = core.get_modpath("toolranks")
local use_invisibility = core.get_modpath("invisibility")

-- node check helper

local registered_nodes = core.registered_nodes
local registered_items = core.registered_items
local function has(nodename)
	return registered_nodes[nodename] and nodename
end

-- global table

mobs = {
	mod = "redo", version = "20260823",
	spawning_mobs = {}, translate = S,
	node_snow = has(core.registered_aliases["mapgen_snow"])
			or has("mcl_core:snow") or has("default:snow") or "air",
	node_dirt = has(core.registered_aliases["mapgen_dirt"])
			or has("mcl_core:dirt") or has("default:dirt") or "mobs:fallback_node"
}
mobs.fallback_node = mobs.node_dirt

-- load compatibility check function

dofile(core.get_modpath("mobs") .. "/compatibility.lua")

-- localize common functions

local pi, abs, min, max = math.pi, math.abs, math.min, math.max
local square, random = math.sqrt, math.random
local sin, cos, rad, deg = math.sin, math.cos, math.rad, math.deg
local floor, ceil, vdirection = math.floor, math.ceil, vector.direction
local vmultiply, vsubtract = vector.multiply, vector.subtract
local settings, atann = core.settings, math.atan
local function atan(x)
	if not x or x ~= x then return 0 else return atann(x) end
end
local table_copy, table_remove = table.copy, table.remove

-- store connected players once every second

local get_connected_players = core.get_connected_players
local player_list = {}
local ptimer = 1

core.register_globalstep(function(dtime)

	ptimer = ptimer + dtime ; if ptimer < 1 then return end ; ptimer = 0

	player_list = get_connected_players()
end)

-- creative check

local creative_cache = core.settings:get_bool("creative_mode")
function mobs.is_creative(name)
	return creative_cache or core.check_player_privs(name, {creative = true})
end

-- load settings

local damage_enabled = settings:get_bool("enable_damage")
local mobs_spawn = settings:get_bool("mobs_spawn") ~= false
local peaceful_only = settings:get_bool("only_peaceful_mobs")
local disable_blood = settings:get_bool("mobs_disable_blood")
local mob_hit_effect = settings:get_bool("mob_hit_effect")
local mobs_drop_items = settings:get_bool("mobs_drop_items") ~= false
local mobs_griefing = settings:get_bool("mobs_griefing") ~= false
local spawn_protected = settings:get_bool("mobs_spawn_protected") ~= false
local spawn_monster_protected = settings:get_bool("mobs_spawn_monster_protected") ~= false
local remove_far = settings:get_bool("remove_far_mobs") ~= false
local mob_area_spawn = settings:get_bool("mob_area_spawn")
local difficulty = tonumber(settings:get("mob_difficulty")) or 1.0
local max_per_block = tonumber(settings:get("max_objects_per_block") or 99)
local mob_nospawn_range = tonumber(settings:get("mob_nospawn_range") or 12)
local active_limit = tonumber(settings:get("mob_active_limit")) or 0
local mob_chance_multiplier = tonumber(settings:get("mob_chance_multiplier") or 1)
local peaceful_player_enabled = settings:get_bool("enable_peaceful_player")
local mob_smooth_rotate = settings:get_bool("mob_smooth_rotate") ~= false
local mob_height_fix = settings:get_bool("mob_height_fix")
local mob_log_spawn = settings:get_bool("mob_log_spawn") == true
local active_mobs = 0
local mob_infotext = settings:get_bool("mob_infotext") ~= false
local gravity = tonumber(settings:get("movement_gravity")) or 9.81

-- loop interval timers

local node_timer_interval = tonumber(settings:get("mob_node_timer_interval") or 0.25)
local main_timer_interval = tonumber(settings:get("mob_main_timer_interval") or 1.0)

-- pathfind settings

local pathfinding_enable = settings:get_bool("mob_pathfinding_enable") ~= false
local pathfinding_stuck_timeout = tonumber(
		settings:get("mob_pathfinding_stuck_timeout")) or 3.0
local pathfinding_stuck_path_timeout = tonumber(
		settings:get("mob_pathfinding_stuck_path_timeout")) or 5.0
local pathfinding_algorithm = settings:get("mob_pathfinding_algorithm") or "A*_noprefetch"

if pathfinding_algorithm == "AStar_noprefetch" then pathfinding_algorithm = "A*_noprefetch"
elseif pathfinding_algorithm == "AStar" then pathfinding_algorithm = "A*"
end

local pathfinding_max_jump = tonumber(settings:get("mob_pathfinding_max_jump") or 4)
local pathfinding_max_drop = tonumber(settings:get("mob_pathfinding_max_drop") or 6)
local pathfinding_searchdistance = tonumber(
		settings:get("mob_pathfinding_searchdistance") or 16)

-- show peaceful mode message

if peaceful_only then
	core.register_on_joinplayer(function(player)
		core.chat_send_player(player:get_player_name(),
				S("** Peaceful Mode Active - No Monsters Will Spawn"))
	end)
end

-- calculate aoc range for mob count

local aoc_range = (tonumber(settings:get("active_block_range")) or 4) * 16

-- can we attack Creatura mobs ?

local creatura = core.get_modpath("creatura") and
		settings:get_bool("mobs_attack_creatura") == true

-- default settings

mobs.mob_class = {
	state = "stand",
	texture_mods = "",
	node_damage = true,
	fall_damage = true,
	knock_back = true,
	passive = false,
	floats = true, -- floats in water
	timer = 0,
	env_damage_timer = 0,
	tamed = false,
	pause_timer = 0,
	horny = false,
	hornytimer = 0,
	child = false,
	gotten = false,
	health = 0,
	docile_by_day = false,
	time_of_day = 0.5,
	runaway_timer = 0,
	allow_fuse_reset = true,
	stop_to_explode = true,
	dogshoot_count = 0,
	group_attack = false,
	attack_monsters = false,
	attack_animals = false,
	attack_players = true,
	attack_npcs = true,
	attack_ignore = nil,
	friendly_fire = true,
	facing_fence = false,
	_breed_countdown = nil,
	_tame_countdown = nil,
	_cmi_is_mob = true
}

local mob_class = mobs.mob_class -- compatibility
local mob_class_meta = {__index = mob_class}

-- return True if mob limit reached

local function at_limit()

	if active_limit and active_limit > 0
	and active_mobs and active_mobs >= active_limit then return true end
end

-- play sound

function mob_class:mob_sound(sound)

	if not sound or not self.sounds then return end

	if type(sound) == "string" then sound = {name = sound} end

	sound.pitch = (sound.pitch or 1.0) + random(-10, 10) * 0.005 -- random differences

	sound.pitch = self.child and sound.pitch + .3 or sound.pitch -- higher for a child

	sound.max_hear_distance = sound.max_hear_distance or self.sounds.distance or 10

	sound.object = self.object -- bind sound to mob

	core.sound_play(sound.name, sound, true)
end

-- set attack

function mob_class:do_attack(player, force)

	if (self.state == "attack" or self.state == "die" or self.state == "runaway")
	and not force then return end

	self.attack = player ; self.state = "attack"

	if random(100) < 90 then self:mob_sound(self.sounds.war_cry) end
end

-- calculate distance

local function get_distance(a, b)

	if not a or not b then return 50 end -- nil check with default distance

	local x, y, z = a.x - b.x, a.y - b.y, a.z - b.z

	return square(x * x + y * y + z * z)
end

-- are we a real player?

local function is_player(player)

	if player and type(player) == "userdata" and core.is_player(player) then
		return true
	end
end

-- collision function

function mob_class:collision()

	local pos = self.object:get_pos() ; if not pos then return 0, 0 end
	local x, z = 0, 0
	local width = -self.prop.collisionbox[1] + self.prop.collisionbox[4] + 0.5
	local width_sq = width * width
	local players = core.get_objects_inside_radius(pos, width)

	for i = 1, #players do

		if players[i]:is_player() then

			local pos2 = players[i]:get_pos()
			local vx, vz = pos.x - pos2.x, pos.z - pos2.z
			local dist_sq = vx * vx + vz * vz

			if dist_sq < width_sq then

				local force = (width - dist_sq ^ 0.5) * 2

				x = x + vx * force ; z = z + vz * force
			end
		end
	end

	return x, z
end

-- helper function to scale mob

function mobs:scale_mob(self, w, h, perma)

	if not w or not h then return end

	local vis_size = {x = self.base_size.x * w, y = self.base_size.y * h}

	local colbox = {
		self.base_colbox[1] * w, self.base_colbox[2] * h,
		self.base_colbox[3] * w, self.base_colbox[4] * w,
		self.base_colbox[5] * h, self.base_colbox[6] * w}

	local selbox = {
		self.base_selbox[1] * w, self.base_selbox[2] * h,
		self.base_selbox[3] * w, self.base_selbox[4] * w,
		self.base_selbox[5] * h, self.base_selbox[6] * w}

	if perma then -- makes new scale permanent by overriding base values
		self.base_size = vis_size
		self.base_colbox = colbox
		self.base_selbox = selbox
	end

	self.object:set_properties(
			{visual_size = vis_size, collisionbox = colbox, selectionbox = selbox})
end

-- check for string inside table or string

local function check_for(look_for, look_inside)

	if look_inside == look_for then return true end

	if type(look_inside) ~= "table" then return end

	for _, str in pairs(look_inside) do

		if str == look_for then return true end

		if type(str) == "string" and str:sub(1, 6) == "group:" then

			local group = str:sub(7)
			local def = registered_items[look_for]

			if def and def.groups[group] and def.groups[group] ~= 0 then return true end
		end
	end
end

-- move mob in facing direction

function mob_class:set_velocity(v)

	v = v or 0.01

	-- halt mob if ordered to stay
	if self.order == "stand" then

		local vel = self.object:get_velocity() or {y = 0}

		self.object:set_velocity({x = 0, y = vel.y, z = 0})

		return
	end

	local c_x, c_y = 0, 0

	-- calculate direction if mob can be pushed
	if self.pushable then c_x, c_y = self:collision() end

	local yaw = (self.object:get_yaw() or 0) + self.rotate

	-- is mob standing in liquid?
	local visc = min(registered_nodes[self.standing_in].liquid_viscosity or 0, 7)

	-- only slow moving mobs when inside a viscous fluid they cannot swim in
	-- e.g. fish in water, spiders in cobweb
	if v > 0 and visc > 0 and not check_for(self.standing_in, self.fly_in) then
		v = v / (visc + 1)
	end

	local vel = self.object:get_velocity() or {y = 0}

	self.object:set_velocity({
			x = (sin(yaw) * -v) + c_x, y = vel.y, z = (cos(yaw) * v) + c_y})
end

-- return velocity

function mob_class:get_velocity()

	local v = self.object:get_velocity() ; if not v then return 0 end

	return (v.x * v.x + v.z * v.z) ^ 0.5
end

-- helper function for smooth rotation

local function shortest_rotation(from, to)

	local diff = to - from

	if diff > pi then return diff - 2 * pi
	elseif diff < -pi then return diff + 2 * pi
	end

	return diff
end

-- set and return valid yaw, pitch or roll

function mob_class:set_yaw(yaw, delay)

	yaw = (yaw or 0) % (2 * pi) -- clamp yaw

	delay = (mob_smooth_rotate and delay) or 0

	if delay == 0 then

		local rot = self.object:get_rotation() ; rot.y = yaw ; self.object:set_rotation(rot)

		return yaw
	end

	self.target_yaw = yaw
	self.delay = delay

	return self.target_yaw
end

function mob_class:set_pitch(pitch)

	pitch = pitch or 0

	local rot = self.object:get_rotation() ; rot.x = pitch ; self.object:set_rotation(rot)

	return pitch
end

function mob_class:set_roll(roll)

	roll = roll or 0

	local rot = self.object:get_rotation() ; rot.z = roll ; self.object:set_rotation(rot)

	return roll
end

-- set defined animation

function mob_class:set_animation(anim, force)

	if not self.animation or not anim then return end

	local current = self.animation_current or ""
	local anims = self.animation

	-- only use different animation for attacks when using same set
	if not force and anim ~= "punch" and anim ~= "shoot"
	and current == anim then return end

	local num = 0

	for n = 1, 4 do -- check for more than one animation (max 4)

		if anims[anim .. n .. "_start"] and anims[anim .. n .. "_end"] then num = n end
	end

	if num > 0 then -- choose random animation from set
		num = random(0, num)
		anim = anim .. (num ~= 0 and num or "")
	end

	if (anim == current and not force)
	or not anims[anim .. "_start"] or not anims[anim .. "_end"] then return end

	self.animation_current = anim

	self.object:set_animation(
			{x = anims[anim .. "_start"], y = anims[anim .. "_end"]},
			anims[anim .. "_speed"] or anims.speed_normal or 15, anims.frame_blend,
			anims[anim .. "_loop"] ~= false)
end

-- use new functions if available

local get_id = core.get_node_raw
local get_id_name = core.get_name_from_content_id
local get_node = core.get_node

if get_id then get_node = function(pos)

		local id, p1, p2, ok = get_id(pos.x, pos.y, pos.z)

		return ok and {name = get_id_name(id), param1 = p1, param2 = p2, loaded = ok}
	end
end

-- get node at pos, return fallback for unknown

local function node_ok(pos, fallback)

	local node = get_node(pos)

	if node and registered_nodes[node.name] then return node end

	local def = registered_nodes[fallback or mobs.fallback_node]

	return {name = def.name, param1 = 0, param2 = 0, loaded = false}
end

function mobs:node_ok(pos, fallback)
	return node_ok(pos, fallback)
end

-- check line of sight using raycasting (thx Astrobe)

function mob_class:line_of_sight(pos1, pos2)

	local rays = core.raycast(pos1, pos2, true, false) -- ignore entities
	local next_ray = rays.next

	for thing in next_ray, rays do

		if thing.type == "node" then

			local nodedef = registered_items[get_node(thing.under).name]

			if nodedef and nodedef.walkable then return end
		end
	end

	return true
end

-- are we flying in what we are suppose to? (taikedz)

function mob_class:flight_check()

	local def = registered_nodes[self.standing_in] ; if not def then return end

	-- are we standing inside what we should be to fly/swim ?
	if check_for(self.standing_in, self.fly_in) then return true end

	-- stops mobs getting stuck inside stairs or plantlike nodes
	return def.drawtype ~= "airlike" and def.drawtype ~= "liquid"
			and def.drawtype ~= "flowingliquid"
end

-- if not flying in set medium, find some nearby to move to

function mob_class:attempt_flight_correction(override)

	if not override and self:flight_check() then return true end

	local pos = self.object:get_pos() ; if not pos then return true end
	local flyable_nodes = core.find_nodes_in_area(
			{x = pos.x - 1, y = pos.y - 1, z = pos.z - 1},
			{x = pos.x + 1, y = pos.y + 1, z = pos.z + 1}, self.fly_in)

	if #flyable_nodes == 0 then return end

	local escape_target = flyable_nodes[random(#flyable_nodes)]

	if escape_target.y ~= pos.y then

		local y_off = escape_target.y > pos.y and 2 or -2
		local check_pos = {
			x = escape_target.x,
			y = escape_target.y + y_off,
			z = escape_target.z}

		if not core.find_node_near(check_pos, 0, self.fly_in, true) then
			escape_target.y = pos.y
		end
	end

	self.object:set_velocity(vdirection(pos, escape_target))

	return true
end

-- turn to face position

function mob_class:yaw_to_pos(target, rot, delay)

	local pos = self.object:get_pos()
	local vec = vector.subtract(target, pos)
	local yaw = core.dir_to_yaw(vec) + (rot or 0) - self.rotate

	return self:set_yaw(yaw, delay)
end

-- look for stay_near nodes and move towards them

function mob_class:do_stay_near()

	if not self.stay_near then return end

	local pos = self.object:get_pos()

	if not pos or random(self.stay_near[2] or 10) > 1 then return end

	local r = self.view_range

	if core.find_node_near(pos, 3, self.stay_near[1], true) then return end

	local nearby_nodes = core.find_nodes_in_area(
			{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
			{x = pos.x + r, y = pos.y + 1, z = pos.z + r}, self.stay_near[1])

	if #nearby_nodes == 0 then return end

	local yaw = self:yaw_to_pos(nearby_nodes[random(#nearby_nodes)], 0, 1)

	self:set_yaw(yaw, 0)
	self:set_animation("walk")
	self:set_velocity(self.walk_velocity)

	return true
end

-- particle effects

local function effect(pos, amount, texture, min_size, max_size, radius, grav, glow, fall)

	radius = radius or 2
	grav = grav or -10
	fall = fall == true and 0 or fall == false and radius or -radius

	core.add_particlespawner({
		amount = amount,
		time = 0.25,
		minpos = pos, maxpos = pos,
		minvel = {x = -radius, y = fall, z = -radius},
		maxvel = {x = radius, y = radius, z = radius},
		minacc = {x = 0, y = grav, z = 0},
		maxacc = {x = 0, y = grav, z = 0},
		minexptime = 0.1, maxexptime = 1,
		minsize = min_size or 0.5, maxsize = max_size or 1,
		texture = texture,
		glow = glow or 0
	})
end

function mobs:effect(pos, amount, texture, min_size, max_size, radius, grav, glow, fall)
	effect(pos, amount, texture, min_size, max_size, radius, grav, glow, fall)
end

local function tpart(pos, time) -- for testing only

	core.add_particle({pos = pos, texture = "mobs_heart_particle.png", glow = 5,
		expirationtime = time, size = 4, collisiondetection = false, vertical = false})
end

-- Thx Wuzzy for easy settings

local HORNY_TIME = 30
local HORNY_AGAIN_TIME = 60 * 5 -- 5 minutes
local CHILD_GROW_TIME = 60 * 20 -- 20 minutes

-- update nametag & infotext

function mob_class:update_tag(newname)

	if not self.object then return end

	local qua = self.prop.hp_max / 6
	local old_nametag = self.prop.nametag
	local old_nametag_color = self.nametag_col

	-- backwards compatibility
	if self.nametag and self.nametag ~= "" then
		newname = self.nametag ; self.nametag = nil
	end

	if newname or (self._nametag and self._nametag ~= "") then

		self._nametag = newname or self._nametag -- adopt new name if found

		-- change tag colour depending on health
		if self.health <= qua then				self.nametag_col = "#FF0000"
		elseif self.health <= (qua * 2) then	self.nametag_col = "#FF7A00"
		elseif self.health <= (qua * 3) then	self.nametag_col = "#FFB500"
		elseif self.health <= (qua * 4) then	self.nametag_col = "#FFFF00"
		elseif self.health <= (qua * 5) then	self.nametag_col = "#B4FF00"
		elseif self.health > (qua * 5) then		self.nametag_col = "#00FF00"
		end

		if self._nametag ~= old_nametag or self.nametag_col ~= old_nametag_color then

			self.object:set_properties({
					nametag = self._nametag, nametag_color = self.nametag_col})
		end
	end

	if not mob_infotext then return end

	local text = ""

	if self.horny then
		text = "\n" .. S("Loving: @1", (self.hornytimer - (HORNY_TIME + HORNY_AGAIN_TIME)))
	elseif self.child then
		text = "\n" .. S("Growing: @1", (self.hornytimer - CHILD_GROW_TIME))
	elseif self._tame_countdown then
		text = "\n" .. S("Taming: @1", self._tame_countdown)
	elseif self._breed_countdown then
		text = "\n" .. S("Breeding: @1", self._breed_countdown)
	end

	if self.protected then

		if self.protected == 2 then
			text = text .. "\n" .. S("Protection: Level 2")
		else
			text = text .. "\n" .. S("Protection: Level 1")
		end
	end

	self.infotext = (self.description and (self.description .. "\n") or "")
		.. S("Health: @1", self.health) .. " / " .. self.prop.hp_max
		.. ("\n" .. S("Entity: @1", self.name))
		.. ("\n" .. S("Type: @1", self.type))
		.. (self.owner == "" and "" or "\n" .. S("Owner: @1", self.owner)) .. text

	if self.infotext ~= self.prop.infotext then
		self.object:set_properties({infotext = self.infotext})
	end
end

-- item drops

function mob_class:item_drop()

	if not mobs_drop_items or self.child then return end

	local pos = self.object:get_pos()
	local drops = self.drops

	-- check for drops function
	if type(drops) == "function" then drops = self.drops(pos) end

	if not drops or #drops == 0 then return end

	-- was mob killed by player?
	local death_by_player = self.cause_of_death and self.cause_of_death.puncher
			and is_player(self.cause_of_death.puncher)

	-- check for tool 'looting_level' under tool_capabilities as default, or use
	-- meta string 'looting_level' if found (max looting level is 3).
	local looting = 0

	if death_by_player then

		local wield_stack = self.cause_of_death.puncher:get_wielded_item()
		local wield_stack_meta = wield_stack:get_meta()
		local item_def = registered_items[wield_stack:get_name()]
		local item_looting = item_def and item_def.tool_capabilities and
				item_def.tool_capabilities.looting_level or 0

		looting = tonumber(wield_stack_meta:get_string("looting_level")) or item_looting
		looting = min(looting, 3)
	end

	for n = 1, #drops do

		if random(drops[n].chance) == 1 then

			local num = random(drops[n].min or 1, drops[n].max or 1) + looting
			local item = drops[n].name

			-- cook items for a hot death
			if self.cause_of_death.hot then

				local output = core.get_craft_result(
						{method = "cooking", width = 1, items = {item}})

				if output and output.item and not output.item:is_empty() then
					item = output.item:get_name()
				end
			end

			-- only drop rare items (drops.min = 0) if killed by player
			if death_by_player or drops[n].min ~= 0 then

				local obj = core.add_item(pos, ItemStack(item .. " " .. num))

				if obj then
					obj:set_velocity({x = random() - 0.5, y = 5, z = random() - 0.5})
				end
			end
		end
	end

	self.drops = {}
end

-- remove mob and descrease counter

local function remove_mob(self, decrease)

	self.object:remove()

	if decrease and active_limit and active_limit > 0 then
		active_mobs = active_mobs - 1
--print("-- active mobs: " .. active_mobs .. " / " .. active_limit)
	end
end

function mobs:remove(self, decrease)
	remove_mob(self, decrease)
end

-- death animation

function mob_class:death_anim()

	if not (self.animation and self.animation.die_start and self.animation.die_end) then
		return
	end

	local frames = self.animation.die_end - self.animation.die_start
	local speed = self.animation.die_speed or 15
	local length = max(frames / speed, 0)
	local rot = self.animation.die_rotate and 5

	self.object:set_properties({
		pointable = false, collide_with_objects = false,
		automatic_rotate = rot, static_save = false
	})

	self:set_velocity(0)
	self:set_animation("die")

	core.after(length, function()

		if self.object:get_luaentity() then

			if use_cmi then cmi.notify_die(self.object, cmi_cause) end

			remove_mob(self, true)
		end
	end)

	return true
end

-- check if dead

function mob_class:check_for_death(cmi_cause)

	if self.state == "die" then return true end -- already dead

	-- has health changed?
	if self.health == self.old_health and self.health > 0 then return end

	local damaged = self.health < self.old_health

	self.old_health = self.health

	if use_vh1 then VH1.update_bar(self.object, self.health) end

	if self.health > 0 then -- mob still alive but damaged

		if damaged then self:mob_sound(self.sounds.damage) end

		-- make sure health isn't higher than max
		if self.health > self.prop.hp_max then self.health = self.prop.hp_max end

		self:update_tag() ; return
	end

	-- mob is dead
	self.cause_of_death = cmi_cause
	self:item_drop() -- drop items
	self:mob_sound(self.sounds.death) -- play death sound

	-- reset vars and fall
	self.attack = nil
	self.following = nil
	self.v_start = false ; self.blinktimer = 0
	self.state = "die"
	self.object:set_acceleration({x = 0, y = -9.5, z = 0})

	local pos = self.object:get_pos() ; if not pos then return end

	-- execute mob api custom death function first for any special features
	if self.on_die then

		if use_cmi then cmi.notify_die(self.object, cmi_cause) end

		if self:on_die(pos) then return true end -- skips removal of mob

		remove_mob(self, true) ; return true
	end

	-- execute official engine on_death function if found
	if self.on_death then

		-- only return killer if punched by player
		cmi_cause = (cmi_cause.type == "punch" and is_player(cmi_cause.puncher))
				and cmi_cause.puncher or nil

		self:on_death(cmi_cause)

		remove_mob(self, true) ; return true
	end

	-- did we find a death animation
	if self:death_anim() then return true end

	-- otherwise remove mob and show particle effect
	if use_cmi then cmi.notify_die(self.object, cmi_cause) end

	remove_mob(self, true)

	effect(pos, 20, "mobs_tnt_smoke.png")

	return true
end

-- return true if node can deal damage

local function is_node_dangerous(self, nodename)

	local def = registered_nodes[nodename] ; if not def then return end

	if (self.water_damage > 0 and def.groups.water)
	or (self.lava_damage > 0 and def.groups.lava)
	or (self.fire_damage > 0 and def.groups.fire) then return true end

	local dmg = self.node_damage and def.damage_per_second and def.damage_per_second > 0

	if dmg then

		if self.immune_to then

			for n = 1, #self.immune_to do

				if self.immune_to[n][1] == nodename then
					return (self.immune_to[n][2] or 0) > 0
				end
			end
		end

		return true
	end
end

function mobs:is_node_dangerous(mob_object, nodename)
	return mob_object and is_node_dangerous(mob_object, nodename)
end

-- are we facing a cliff?

function mob_class:is_at_cliff()

	if self.driver or self.fear_height == 0
	or self.disable_falling then return end -- 0 for no fear of heights

	-- if path already blocked, dont check for cliff
	if registered_nodes[self.looking_at].walkable or self.facing_fence then
		return
	end

	local yaw = self.object:get_yaw() ; if not yaw then return end
	local cb = self.prop.collisionbox
	local dir_x, dir_z = -sin(yaw) * (cb[4] + 0.5), cos(yaw) * (cb[4] + 0.5)
	local pos = self.object:get_pos()
	local ypos = pos.y + cb[2] + 0.25-- foot level

	for i = 1, self.fear_height do -- check each node going down

		local check_pos = {x = pos.x + dir_x, y = ypos - i, z = pos.z + dir_z}
		local bnode = get_node(check_pos) or {name = "air"}
		local def = registered_nodes[bnode.name]

		if is_node_dangerous(self, bnode.name) then return true end

		if def and def.walkable then return end -- can step down onto something
	end

	return true -- straight drop with no obstructions
end

-- check for nodes or groups inside mob collision area

function mob_class:is_inside(itemtable)

	local cb = self.prop.collisionbox
	local pos = self.object:get_pos()

	return #core.find_nodes_in_area(
			vector.offset(pos, cb[1], cb[2], cb[3]),
			vector.offset(pos, cb[4], cb[5], cb[6]), itemtable) > 0
end

-- environmental damage

function mob_class:do_env_damage()

	local pos = self.object:get_pos() ; if not pos then return end

	self:update_tag()

	self.time_of_day = core.get_timeofday()

	-- halt mob when standing in ignore node
	if self.standing_in == "ignore" then
		self.object:set_velocity({x = 0, y = 0, z = 0}) ; return true
	end

	local py = {x = pos.x, y = pos.y + self.prop.collisionbox[5], z = pos.z}
	local nodef = registered_nodes[self.standing_in]

	-- water damage
	if self.water_damage ~= 0 and nodef.groups.water then

		self.health = self.health - self.water_damage

		effect(py, 5, "mobs_bubble_particle.png", nil, nil, 1, nil)

		if self:check_for_death({type = "environment",
				pos = pos, node = self.standing_in}) then return true end
	end

	-- lava damage
	if self.lava_damage ~= 0 and nodef.groups.lava then

		self.health = self.health - self.lava_damage

		effect(py, 15, "mobs_fire_particle.png", 1, 5, 1, 0.2, 15, true)

		if self:check_for_death({type = "environment", pos = pos,
				node = self.standing_in, hot = true}) then return true end
	end

	-- fire damage
	if self.fire_damage ~= 0 and nodef.groups.fire then

		self.health = self.health - self.fire_damage

		effect(py, 15, "mobs_fire_particle.png", 1, 5, 1, 0.2, 15, true)

		if self:check_for_death({type = "environment", pos = pos,
				node = self.standing_in, hot = true}) then return true end
	end

	-- damage_per_second node check
	if self.node_damage and nodef.damage_per_second ~= 0
	and not nodef.groups.lava and not nodef.groups.fire then

		local damage = nodef.damage_per_second

		-- check for node immunity or special damage
		for n = 1, #self.immune_to do

			if self.immune_to[n][1] == self.standing_in then
				damage = self.immune_to[n][2] or 0 ; break
			end
		end

		self.health = self.health - damage

		if damage > 0 then effect(py, 5, "mobs_tnt_smoke.png") end

		if self:check_for_death({type = "environment",
				pos = pos, node = self.standing_in}) then return true end
	end

	-- air damage
	if self.air_damage ~= 0 and self.standing_in == "air" then

		self.health = self.health - self.air_damage

		effect(py, 3, "mobs_bubble_particle.png", 1, 1, 1, 0.2)

		if self:check_for_death({type = "environment",
				pos = pos, node = self.standing_in}) then return true end
	end

	-- is mob light sensitive, or scared of the dark :P
	if self.light_damage ~= 0 then

		local light

		-- if max set to 16 then only natural sunlight can kill mob
		if self.light_damage_max == 16 then
			light = core.get_natural_light(pos) or 0
		else
			light = core.get_node_light(pos) or 0
		end

		if light >= self.light_damage_min and light <= self.light_damage_max then

			self.health = self.health - self.light_damage

			effect(py, 5, "mobs_tnt_smoke.png")

			if self:check_for_death({type = "light"}) then return true end
		end
	end

	--- suffocation
	if self.suffocation and self.suffocation ~= 0 and self.protected ~= 2
	and nodef.walkable ~= false
	and (nodef.collision_box == nil or nodef.collision_box.type == "regular")
	and (nodef.node_box == nil or nodef.node_box.type == "regular")
	and nodef.groups.disable_suffocation ~= 1 then

		local damage = type(self.suffocation) == "number" and self.suffocation or 2

		self.health = self.health - damage

		if self:check_for_death({type = "suffocation",
				pos = pos, node = self.standing_in}) then return true end

		-- try to jump out of block
		self.object:set_velocity({x = 0, y = self.jump_height, z = 0})
	end

	return self:check_for_death({type = "unknown"})
end

-- jumping

function mob_class:do_jump()

	local vel = self.object:get_velocity() ; if not vel then return end

	-- is mob allowed to jump
	if self.state == "stand" or self.order == "stand" or vel.y ~= 0
	or self.fly or self.child or self.jump_height == 0 then return end

	local ndef = registered_nodes[self.standing_on]

	-- only jump on solid nodes that allow it
	if not ndef.walkable or ndef.groups.disable_jump == 1 then return end

	-- is there anything stopping us from jumping up onto a block?
	local blocked = registered_nodes[self.looking_above].walkable or self.facing_fence

	-- if mob can leap then remove blockages and let them try
	if self.can_leap then blocked = false end

	ndef = registered_nodes[self.looking_at] -- what node are we looking at?

	-- jump if we have space above to, or are a jumping mob
	if self.walk_chance == 0 or (not blocked
	and (ndef.drawtype == "normal" or ndef.drawtype:sub(1, 5) == "glass")) then

		vel.y = self.jump_height

		self:set_animation("jump") ; self.object:set_velocity(vel)

		core.after(0.3, function() -- move forward when in air

			if self.object:get_luaentity() then
				self.object:set_acceleration({x = vel.x * 2, y = 0, z = vel.z * 2})
			end
		end)

		if self:get_velocity() > 0 then
			self:mob_sound(self.sounds.jump)
		end

		self.jump_count = 0 ; return true
	end

	-- if blocked for 3 jump counts, turn
	if not self.following and (self.facing_fence or blocked) then

		self.jump_count = (self.jump_count or 0) + 1

		if self.jump_count > 2 then

			self:set_yaw(self.object:get_yaw() + random(0, 2) + 1.35, 12)

			self.jump_count = 0
		end
	end
end

-- blast damage to nearby entities

local function entity_physics(pos, radius)

	radius = radius * 2

	local objs = core.get_objects_inside_radius(pos, radius)
	local obj_pos, dist

	for n = 1, #objs do

		obj_pos = objs[n]:get_pos()

		dist = max(1, get_distance(pos, obj_pos))

		local damage = floor((4 / dist) * radius)

		objs[n]:punch(objs[n], 1.0,
				{full_punch_interval = 1.0, damage_groups = {fleshy = damage}}, pos)
	end
end

-- can mob see player

local function is_invisible(self, player_name)

	if use_invisibility and not self.ignore_invisibility
	and invisibility.is_visible and not invisibility.is_visible(player_name) then
		return true
	end
end

function mobs:is_invisible(self, player_name)
	return is_invisible(self, player_name)
end

-- should mob follow what I'm holding?

function mob_class:follow_holding(clicker)

	if is_invisible(self, clicker:get_player_name()) then return end

	return check_for(clicker:get_wielded_item():get_name(), self.follow)
end

-- find two animals of same type, breed if nearby and horny

function mob_class:breed()

	if self.child then -- child takes a while to grow into an adult

		self.hornytimer = self.hornytimer + 1

		if self.hornytimer > CHILD_GROW_TIME then

			self.child = false ; self.hornytimer = 0

			if self.mommy_tex then -- replace child texture with adult one
				self.base_texture = self.mommy_tex ; self.mommy_tex = nil
			end

			self.object:set_properties({
				textures = self.base_texture,
				mesh = self.base_mesh, visual_size = self.base_size,
				collisionbox = self.base_colbox, selectionbox = self.base_selbox
			})

			-- run custom function when grown
			if self.on_grown then self.on_grown(self)
			else
				local pos = self.object:get_pos() ; if not pos then return end

				pos.y = pos.y - self.prop.collisionbox[2] + 0.1

				self.object:set_pos(pos)

				-- jump slightly when grown so as not to fall into ground
				self.object:set_velocity({x = 0, y = 2, z = 0 })
			end
		end

		return
	end

	-- horny animal can mate for HORNY_TIME seconds,
	-- afterwards horny animal cannot mate again for HORNY_AGAIN_TIME seconds
	if self.horny and self.hornytimer < HORNY_TIME + HORNY_AGAIN_TIME then

		self.hornytimer = self.hornytimer + 1

		if self.hornytimer >= HORNY_TIME + HORNY_AGAIN_TIME then
			self.hornytimer = 0
			self.horny = false
		end

		self:update_tag()
	end

	if not (self.horny and self.hornytimer <= HORNY_TIME) then return end

	-- find similar animal who is horny and mate if nearby
	local pos = self.object:get_pos()

	effect({x = pos.x, y = pos.y + self.prop.collisionbox[5], z = pos.z}, 8,
			"mobs_heart_particle.png", 3, 4, 1, 0.1, 1, true)

	local objs = core.get_objects_inside_radius(pos, 3)
	local ent

	for n = 1, #objs do

		ent = objs[n]:get_luaentity()

		-- check for same animal with different colour
		local canmate = false

		if ent then

			if ent.name == self.name then canmate = true
			else
				local entname = ent.name:split(":")
				local selfname = self.name:split(":")

				if entname[1] == selfname[1] then

					entname = entname[2]:split("_")
					selfname = selfname[2]:split("_")

					if entname[1] == selfname[1] then canmate = true end
				end
			end
		end

		-- found another similar horny?
		if canmate and ent and ent.object ~= self.object
		and ent.horny and ent.hornytimer <= HORNY_TIME then

			local pos2 = ent.object:get_pos()

			-- have mobs face one another
			self:yaw_to_pos(pos2)
			ent:yaw_to_pos(self.object:get_pos())

			self.hornytimer = HORNY_TIME + 1
			ent.hornytimer = HORNY_TIME + 1

			self:update_tag()

			-- have we reached active mob limit
			if at_limit() then

				core.chat_send_player(self.owner, S("Active Mob Limit Reached!")
						.. "  (" .. active_mobs .. " / " .. active_limit .. ")")
				return
			end

			-- spawn baby
			core.after(5, function(self, ent)

				if not self.object:get_luaentity() then return end

				-- custom breed function
				if self.on_breed and self:on_breed(ent) == false then return end

				-- add baby
				local ent2 = mobs:add_mob(pos, {
					name = self.name, child = true, owner = self.owner,
					ignore_count = true
				})

				-- set baby textures
				if ent2 then

					local textures = self.base_texture

					if self.child_texture then -- use custom texture if found
						textures = self.child_texture[1]
					end

					ent2.mommy_tex = self.base_texture -- when grown
					ent2.object:set_properties({textures = textures})
					ent2.base_texture = textures
					mobs:scale_mob(ent2, .5, .5)
				end
			end, self, ent)

			break
		end
	end
end

-- find and replace what mob is looking for (grass, wheat etc.)

function mob_class:replace(pos)

	local vel = self.object:get_velocity()

	if not vel or not mobs_griefing or not self.replace_rate or not self.replace_what
	or self.child or vel.y ~= 0 or random(self.replace_rate) > 1 then return end

	local what, with, y_offset, reach

	if type(self.replace_what[1]) == "table" then

		local replacement = self.replace_what[random(#self.replace_what)]

		what = replacement[1] or ""
		with = replacement[2] or ""
		y_offset = replacement[3] or 0
		reach = replacement[4] or 0
	else
		what = self.replace_what
		with = self.replace_with or ""
		y_offset = self.replace_offset or 0
		reach = 0
	end

	pos.y = pos.y + y_offset

	local found = core.find_nodes_in_area(
			{x = pos.x - reach, y = pos.y, z = pos.z - reach},
			{x = pos.x + reach, y = pos.y, z = pos.z + reach}, what)

	if #found == 0 then return end

	pos = found[random(#found)]

-- print("replace node = ".. core.get_node(pos).name, pos.y)

	if self.on_replace then

		local oldnode = what or ""
		local newnode = with

		-- pass node name when using table or groups
		if type(oldnode) == "table" or oldnode:sub(1, 6) == "group:" then
			oldnode = get_node(pos).name
		end

		if self:on_replace(pos, oldnode, newnode) == false then return end
	end

	core.set_node(pos, {name = with})

	self:mob_sound(self.sounds.replace)
end

-- look directly around mob to see if it can pickup any dropped items

function mob_class:check_item_pickup(pos)

	if not self.on_pick_up or not self.pick_up or #self.pick_up == 0 then return end

	for _,o in pairs(core.get_objects_inside_radius(pos, 2)) do

		local l = o:get_luaentity()

		if l and l.name == "__builtin:item" then

			for k,v in pairs(self.pick_up) do

				if self.on_pick_up and l.itemstring:find(v, 1, true) then

					local r = self.on_pick_up(self, l)

					if r and r.is_empty and not r:is_empty() then
						l.itemstring = r:to_string()
					elseif r and r.is_empty and r:is_empty() then
						o:remove()
					end
				end
			end
		end
	end
end

-- are we docile during daylight hours?

function mob_class:day_docile()
	return self.docile_by_day and self.time_of_day > 0.2 and self.time_of_day < 0.8
end

-- are we able to dig & drop a node?

local function can_dig_drop(pos)

	if core.is_protected(pos, "") then return end

	local node = node_ok(pos, "air").name
	local ndef = registered_nodes[node]

	if not ndef or not ndef.walkable or ndef.groups.level or ndef.groups.unbreakable then
		return
	end

	local drops = core.get_node_drops(node)

	core.remove_node(pos)

	for n = 1, #drops do
		core.add_item(pos, drops[n])
	end

	return true
end

-- process found path (nil if not found) way leading to target_pos
-- if add_jump is true, add jump if below target_pos
-- if set_velocity is true and path found, start moving at self.walk_velocity

function mob_class:apply_path(way, target_pos, add_jump, set_velocity)

	local s = self.object:get_pos() ; if not s or not target_pos then return end

	self.path.way = way

	if self.attack then self:do_attack(self.attack) end

	if not self.path.way then -- no path found

		self.path.following = false

		 -- lets make a way by digging/building
		if self.pathfinding == 2 and mobs_griefing then

			local cb = self.prop.collisionbox
			local height_diff = target_pos.y - s.y

			-- is player more than 1 block higher than mob?
			if height_diff > 1.1 then

				if not core.is_protected(s, "") then -- build upwards

					local ndef1 = registered_nodes[self.standing_in]

					if ndef1 and (ndef1.buildable_to or ndef1.groups.liquid) then

						s.y = s.y + (cb[2] + 0.25)

						core.set_node(s, {name = mobs.fallback_node})
					end
				end

				-- can we dig block above head so we can jump
				can_dig_drop({x = s.x, y = s.y + ceil(cb[5]) + 1, z = s.z})

				self.object:set_pos({x = s.x, y = s.y + 2, z = s.z})

			elseif height_diff < -1.1 then -- is player move than 1 block lower

				 -- try to dig down
				can_dig_drop({x = s.x, y = s.y + (cb[2] - 0.25), z = s.z})

			else -- dig 2 blocks to make door toward player direction

				local yaw1 = self.object:get_yaw() + pi / 2
				local p1 = {
					x = s.x + cos(yaw1),
					y = s.y + (cb[2] + 0.25),
					z = s.z + sin(yaw1)
				}

				-- dig bottom node first incase of door
				can_dig_drop(p1) ; p1.y = p1.y + 1 ; can_dig_drop(p1)
			end
		end

		-- will try again in 2 second
		self.path.stuck_timer = pathfinding_stuck_timeout - 2

	elseif add_jump and s.y < target_pos.y and not self.fly then

		self:do_jump() --add jump to pathfinding
		self.path.following = true

	else -- yay i found path

		self:mob_sound(self.attack and self.sounds.war_cry or self.sounds.random)

		if set_velocity then
			self:set_velocity(self.walk_velocity)
		end

		self.path.following = true -- now follow path
	end
end

-- path height checker

local function path_height_blocked(self)

	local node, pos

	for i = 1, #self.path.way do

		pos = self.path.way[i]

		node = get_node({x = pos.x, y = pos.y + 1, z = pos.z})
				or {name = "mobs:fallback_node"}

		if registered_nodes[node.name].walkable then return true end
	end
end

-- path finding and smart mob routine by rnd, line_of_sight and other edits by Elkien3

function mob_class:smart_mobs(s, p, dist, dtime)

	local s1 = self.path.lastpos
	local target_pos = p

	-- are we stuck?
	if (abs(s1.x - s.x) + abs(s1.z - s.z)) / dtime < 0.5 then
		self.path.stuck_timer = self.path.stuck_timer + dtime
	else
		self.path.stuck_timer = 0
	end

	self.path.lastpos = {x = s.x, y = s.y, z = s.z}

	if self.path.stuck_timer <= pathfinding_stuck_timeout then return end

	local has_lineofsight = core.line_of_sight(
			{x = s.x, y = s.y + 0.5, z = s.z},
			{x = target_pos.x, y = target_pos.y + 1.5, z = target_pos.z}, .2)

	self.path.stuck_timer = 0

	if has_lineofsight then
		self.path.following = false ; return
	end

	-- round position to avoid getting stuck in walls
	local sx, sz = floor(s.x + 0.5), floor(s.z + 0.5)

	local ssight, sground = core.line_of_sight(s, {x = sx, y = s.y - 4, z = sz}, 1)

	-- determine node above ground (adjust height for player models)
	if not ssight then s.y = sground.y + 1 end

	local dropheight = self.fear_height ~= 0 and self.fear_height or pathfinding_max_drop
	local jumpheight = 0

	if self.jump_height >= pathfinding_max_jump then

		jumpheight = min(ceil(self.jump_height / pathfinding_max_jump), pathfinding_max_jump)

	elseif self.prop.stepheight > 0.5 then jumpheight = 1 end

	local p1 = {
		x = floor(target_pos.x + 0.5),
		y = floor(target_pos.y + 0.5),
		z = floor(target_pos.z + 0.5)}

	self.path.way = core.find_path(s, p1, pathfinding_searchdistance,
			jumpheight, dropheight, pathfinding_algorithm)

	local height = self.prop.collisionbox[5] - self.prop.collisionbox[2]

	-- since we have a path, double check clearance height for 2x node high mobs
	if self.path.way and #self.path.way > 0 then

		if height > 1 then
			if path_height_blocked(self) then -- make sure 2 high mobs can get access
				self.path.way = nil
			end
		end
	end

	--[[ do we still have a path after check
	if self.path.way and #self.path.way > 0 then

		-- show path length and particle trail
		print("-- path length:" .. tonumber(#self.path.way))

		for i = 1, #self.path.way do

			local pos = self.path.way[i]

			tpart(pos, 2)

			if height > 1 then
				pos.y = pos.y + 1 ; tpart(pos, 2)
			end
		end
	end]]

	self.state = ""

	 -- factored out for reuse / possible override
	self:apply_path(self.path.way, target_pos, true, true)
end

-- temporary entity for go_to() function

core.register_entity("mobs:_pos", {
	initial_properties = {
		visual = "sprite", texture = "", hp_max = 1, physical = false,
		static_save = false, pointable = false, is_visible = false
	}, health = 1, _cmi_is_mob = true,

	on_step = function(self, dtime)

		self.counter = (self.counter or 0) + dtime

		if self.counter > 20 then self.object:remove() end
	end
})

-- add temp entity and make mob go to that entity position

function mob_class:go_to(pos)

	local obj = core.add_entity(pos, "mobs:_pos")

	if obj and obj:get_luaentity() then self:do_attack(obj, true) end
end

-- peaceful player

local function is_peaceful_player(player)

	if peaceful_player_enabled then return true end

	local player_name = player:get_player_name() or ""

	return core.check_player_privs(player_name, "peaceful_player")
end

-- general attack function

function mob_class:general_attack()

	-- return if already attacking, passive or docile during day
	if self.passive or self.state == "runaway" or self.state == "attack"
	or self.state == "flop" or self:day_docile() then
		return
	end

	local s = self.object:get_pos() ; if not s then return end
	local objs = core.get_objects_inside_radius(s, self.view_range)

	if not objs or #objs == 1 then return end -- only mob itself

	-- remove entities we aren't interested in
	for n = 1, #objs do

		local ent = objs[n]:get_luaentity()

		if damage_enabled and is_player(objs[n]) then -- are we a viable player?

			-- remove player if owner, invisible or just not interesting enough to attack
			if not self.attack_players or self.owner == objs[n]:get_player_name()
			or (self.type ~= "monster" and self.tamed) -- tamed animals must be provoked
			or is_invisible(self, objs[n]:get_player_name())
			or is_peaceful_player(objs[n])
			or (self.specific_attack and not check_for("player", self.specific_attack)) then
				objs[n] = nil
			end

		-- are we a creatura mob?
		elseif creatura and ent and ent._cmi_is_mob ~= true
		and ent.hitbox and ent.stand_node then

			-- monsters attack all creatura mobs, npc and animals will only attack
			-- if the animal owner is currently being attacked by creatura mob
			if self.name == ent.name or (self.type ~= "monster"
			and self.owner ~= (ent._target and ent._target:get_player_name() or "."))
			or (self.specific_attack and not check_for(ent.name, self.specific_attack)) then
				objs[n] = nil
			end

		-- or are we a mob?
		elseif ent and ent._cmi_is_mob then

			-- remove mobs to not attack
			if self.name == ent.name or check_for(ent.name, self.attack_ignore)
			or (not self.attack_animals and ent.type == "animal")
			or (not self.attack_monsters and ent.type == "monster")
			or (not self.attack_npcs and ent.type == "npc")
			or (self.specific_attack and not check_for(ent.name, self.specific_attack)) then
				objs[n] = nil
			end
		else -- remove all other entities
			objs[n] = nil
		end
	end

	local min_dist, min_target = self.view_range + 1

	for _, target in pairs(objs) do

		local p = target:get_pos()
		local dist = get_distance(p, s)
		local ey = self.base_colbox[5] * 0.9 -- mob eye level

		-- choose closest entity to attack while looking higher for better sights
		if dist ~= 0 and dist < min_dist and self:line_of_sight(
				{x = s.x, y = s.y + ey, z = s.z}, {x = p.x, y = p.y + .5, z = p.z}) then

			min_dist = dist
			min_target = target
		end
	end

	if min_target and random(100) > self.attack_chance then -- attack!
		self:do_attack(min_target)
	end
end

-- find someone to runaway from

function mob_class:do_runaway_from()

	if not self.runaway_from or self.state == "flop" then return end

	local s = self.object:get_pos() ; if not s then return end
	local target, min_target, name
	local min_dist = self.view_range + 1
	local objs = core.get_objects_inside_radius(s, self.view_range)

	if not objs or #objs == 1 then return end -- only mob itself

	for n = 1, #objs do -- loop through entities surrounding mob

		if is_player(objs[n]) then

			local pname = objs[n]:get_player_name()

			if self.owner == pname or is_invisible(self, pname) then
				name = ""
			else
				target = objs[n] ; name = "player"
			end
		else
			local obj = objs[n]:get_luaentity()

			if obj then
				target = obj.object ; name = obj.name or ""
			end
		end

		-- find specific mob to runaway from
		if name ~= "" and name ~= self.name
		and (self.runaway_from and check_for(name, self.runaway_from)) then

			local p = target and target:get_pos() or s
			local dist = get_distance(p, s)
			local ey = self.base_colbox[5] * 0.9 -- mob eye level

			-- choose closest entity to runaway from
			if dist < min_dist and self:line_of_sight(
					{x = s.x, y = s.y + ey, z = s.z},
					{x = p.x, y = p.y + .5, z = p.z}) then

				min_dist = dist
				min_target = target
			end
		end
	end

	if min_target then

		self:yaw_to_pos(min_target:get_pos(), 3) -- opposite dir

		self.state = "runaway"
		self.runaway_timer = 3
		self.following = nil

		return
	end

	-- check for nodes to runaway from when seen
	local p = core.find_node_near(s, self.view_range, self.runaway_from, true)
	local ey = self.base_colbox[5] * 0.9 -- mob eye level

	if p and core.line_of_sight(
			{x = s.x, y = s.y + ey, z = s.z}, {x = p.x, y = p.y + 0.5, z = p.z}) then

		self:yaw_to_pos(p, 3) -- opposite dir
		self.state = "runaway"
		self.runaway_timer = 3
		self.following = nil
	end
end

-- follow a target located at pos p starting from our current pos s

function mob_class:follow_target(s, p, dtime)

	local dist = get_distance(p, s)

	-- dont follow if out of range
	if dist > self.view_range then
		self.following = nil ; self.state = "stand" ; return
	else
		self:yaw_to_pos(p, 0, 2)

		-- only move if not ordered to stand
		if dist >= self.reach and self.order ~= "stand" then

			self:set_velocity(self.walk_velocity)

			if self.walk_chance ~= 0 then self:set_animation("walk") end

		elseif self.state ~= "attack" then

			self.state = "standing" -- fake state to pause mob within reach
			self:set_velocity(0)
			self:set_animation("stand")
		end

		return true
	end
end

-- follow player if owner or holding item, if fish outta water then flop

function mob_class:follow_flop(dtime)

	-- find player to follow
	if (self.follow ~= "" or self.order == "follow") and not self.following
	and self.state ~= "attack" and self.state ~= "runaway" then

		local s = self.object:get_pos() ; if not s then return end

		for _, player in ipairs(player_list) do

			if player and not is_invisible(self, player:get_player_name())
			and get_distance(player:get_pos(), s) < self.view_range then

				self.following = player ; break
			end
		end
	end

	if self.type == "npc" and self.order == "follow"
	and self.state ~= "attack" and self.owner ~= "" then

		-- npc stop following player if not owner
		if self.following
		and self.owner and self.owner ~= self.following:get_player_name() then
			self.following = nil
		end
	else
		-- stop following player if not holding specific item or mob is horny
		if self.following and is_player(self.following)
		and (self.horny or not self:follow_holding(self.following)) then
			self.following = nil
		end
	end

	if self.following then -- follow that thing

		local s = self.object:get_pos()
		local p

		if is_player(self.following) then p = self.following:get_pos()
		elseif self.following.object then p = self.following.object:get_pos() end

		if p and self.state ~= "attack" and self:follow_target(s, p, dtime) then return end

	elseif self.state == "standing" then self.state = "stand" -- end fake state
	end

	-- swimmers flop when out of their element, and swim again when back in
	if self.fly then

		if not self:attempt_flight_correction() then

			self.state = "flop"

			-- do we have a custom on_flop function?
			if self.on_flop and self:on_flop(self) then return end

			self.object:set_velocity({x = 0, y = -5, z = 0})

			self:set_animation("stand") ; return

		elseif self.state == "flop" then self.state = "stand" end
	end
end

-- dogshoot attack switch & counter function

function mob_class:dogswitch(dtime)

	if not self.dogshoot_switch then return 0 end

	self.dogshoot_count = self.dogshoot_count + dtime

	local switch_max = (self.dogshoot_switch == 1) and self.dogshoot_count_max
			or self.dogshoot_count2_max

	if self.dogshoot_count > switch_max then
		self.dogshoot_count = 0
		self.dogshoot_switch = (self.dogshoot_switch == 1) and 2 or 1
	end

	return self.dogshoot_switch
end

-- stop attack & reset vars

function mob_class:stop_attack()

	self.attack = nil
	self.following = nil
	self.v_start = false ; self.blinktimer = 0
	self.path.way = nil
	self:set_velocity(0)
	self.state = "stand"
	self:set_animation("stand", true)
end

-- execute current state (stand, walk, run, attack)

function mob_class:do_states(dtime)

	local yaw = self.object:get_yaw() ; if not yaw then return end
	local s = self.object:get_pos()

	-- are we standing in something that hurts?  Try to get out
	if is_node_dangerous(self, self.standing_in) then

		local lp = core.find_nodes_in_area_under_air(
				{x = s.x - 6, y = s.y - 2, z = s.z - 6},
				{x = s.x + 6, y = s.y + 0, z = s.z + 6},
				{"group:cracky", "group:crumbly", "group:choppy", "group:solid"})

		if lp and #lp > 0 then -- if we found land try to climb out

			yaw = self:yaw_to_pos( lp[random(#lp)], 0, 1 )
			self:set_yaw(yaw, 0)

			self.state = "walk"
			self.pause_timer = 3
			self.following = nil
			self:set_velocity(self.run_velocity)

			if self.animation and self.animation.run_end then
				self:set_animation("run")
			else
				self:set_animation("walk")
			end

			return
		end
	end

	if self.state == "stand" then

		if self.randomly_turn and random(4) == 1 then

			local objs = core.get_objects_inside_radius(s, 3)
			local obj_pos

			for _,obj in pairs(objs) do

				if obj:is_player() then
					obj_pos = obj:get_pos() ; break
				end
			end

			if obj_pos then
				self:yaw_to_pos(obj_pos, 0, 8) -- look at player
			else
				self:set_yaw(yaw + random() - 0.5, 8) -- random turn
			end
		end

		self:set_velocity(0)
		self:set_animation("stand")

		-- are we able to walk
		if self.order ~= "stand" and self.walk_chance ~= 0
		and not self.facing_fence and not self.at_cliff
		and random(100) <= self.walk_chance then

			self:set_velocity(self.walk_velocity)
			self.state = "walk"
			self:set_animation("walk")

		-- or are we able to jump
		elseif self.walk_chance == 0 and not self.at_cliff
		and self.jump_chance and random(100) <= self.jump_chance then
			self:set_velocity(self.walk_velocity)
			self.state = "jump"
		end

	elseif self.state == "jump" then

		self.state = "stand" -- we jump for one cycle before standing again

	elseif self.state == "walk" and not self.following then

		if self.randomly_turn and random(100) <= 30 then

			self:set_yaw(yaw + random() - 0.5, 4)

			-- for flying/swimming mobs randomly move up and down also
			if self.fly_in and not self.following then
				self:attempt_flight_correction(true)
			end
		end

		-- stand depending on situation
		if self.facing_fence or self.at_cliff or random(100) <= self.stand_chance then

			-- don't stand if mob flies and keep_flying set
			if (self.fly and not self.keep_flying) or not self.fly then

				self:set_velocity(0)
				self.state = "stand"
				self:set_animation("stand", true)
			end
		else
			self:set_velocity(self.walk_velocity)

			-- figure out which animation to use while in motion
			if self:flight_check() and self.animation
			and self.animation.fly_start and self.animation.fly_end then

				local on_ground = registered_nodes[self.standing_on].walkable
				local in_water = registered_nodes[self.standing_in].groups.water

				if on_ground and in_water then
					self:set_animation("fly")
				elseif on_ground then
					self:set_animation("walk")
				else
					self:set_animation("fly")
				end
			else
				self:set_animation("walk")
			end
		end

	elseif self.state == "runaway" then

		self.runaway_timer = self.runaway_timer - 1

		-- stand when timer runs out, or at cliff
		if self.runaway_timer <= 0 or self.at_cliff or self.order == "stand" then

			self:set_velocity(0)
			self.state = "stand"
			self:set_animation("stand")

			yaw = self:set_yaw(yaw + random(-1, 1) * 1.5, 4) -- turn so we arent stuck
		else
			self:set_velocity(self.run_velocity)
			self:set_animation("walk")
		end

	-- attack routines (explode, dogfight, shoot, dogshoot)
	elseif self.state == "attack" then

		-- get enemy position and distance between mob
		local p = self.attack and self.attack:get_pos()
		local dist = p and get_distance(p, s) or 500

		-- stop attacking if player out of range or invisible
		if dist > self.view_range_attacking
		or not self.attack or not self.attack:get_pos() or self.attack:get_hp() <= 0
		or (is_player(self.attack)
		and is_invisible(self, self.attack:get_player_name())) then

--print(" ** stop attacking **", self.name, self.health, dist, self.view_range_attacking)

			self:stop_attack() ; return
		end

		-- check enemy is in sight
		local ey = self.base_colbox[5] * 0.9 -- mob eye level
		local in_sight = self:line_of_sight(
				{x = s.x, y = s.y + ey, z = s.z}, {x = p.x, y = p.y + 0.5, z = p.z})

		-- stop attacking when enemy not seen for 11 seconds
		if not in_sight then

			self.target_time_lost = (self.target_time_lost or 0) + dtime

			if self.target_time_lost > self.attack_patience then
				self:stop_attack() ; return
			end
		else
			self.target_time_lost = 0
		end

		local ds_var = (self.attack_type == "dogshoot") and self:dogswitch(dtime) or 0

		if self.attack_type == "explode" then

			self:yaw_to_pos(p)

			local node_break_radius = self.explosion_radius or 1
			local entity_damage_radius = self.explosion_damage_radius
					or (node_break_radius * 2)

			-- start timer when in reach and line of sight
			if not self.v_start and dist <= self.reach and in_sight then

				self.v_start = true
				self.explode_timer = 0
				self.blinktimer = 0
				self:mob_sound(self.sounds.fuse)

--print("=== explosion timer started", self.explosion_timer)

			-- stop timer if out of reach or direct line of sight
			elseif self.allow_fuse_reset and self.v_start
			and (dist > self.reach or not in_sight) then

--print("=== explosion timer stopped")

				self.v_start = false
				self.explode_timer = 0
				self.blinktimer = 0
				self.blinkstatus = false
				self.object:set_texture_mod("")
				self.object:set_properties({glow = self.glow})
			end

			-- walk right up to player unless the timer is active
			if self.v_start and (self.stop_to_explode or dist < 1.5) then
				self:set_velocity(0)
			else
				self:set_velocity(self.run_velocity)
			end

			if self.animation and self.animation.run_start then
				self:set_animation("run")
			else
				self:set_animation("walk")
			end

			if self.v_start then

				self.explode_timer = (self.explode_timer or 0) + dtime
				self.blinktimer = (self.blinktimer or 0) + dtime

				if self.blinktimer > 0.2 then

					self.blinktimer = 0
					self.blinkstatus = not self.blinkstatus

					if self.blinkstatus then
						self.object:set_texture_mod(self.texture_mods)
						self.object:set_properties({glow = (self.glow or 0)})
					else
						self.object:set_texture_mod(self.texture_mods .. "^[brighten")
						self.object:set_properties({glow = (self.glow or 0) + 3})
					end
				end

--print("=== explosion timer", self.explode_timer)

				if self.explode_timer > self.explosion_timer then

					-- dont damage anything if area protected or near water
					if core.find_node_near(s, 1, {"group:water"})
					or core.is_protected(s, "") then
						node_break_radius = 1
					end

					remove_mob(self, true)

					mobs:boom(self, s, node_break_radius, entity_damage_radius)

					return true
				end
			end

		elseif self.attack_type == "dogfight" or (self.attack_type == "dogshoot"
		and (ds_var == 2 or dist <= self.reach)) then

			-- make sure flying mobs are inside proper medium
			if self.fly and dist > self.reach and self:flight_check() then

				local s_y, p_y = floor(s.y), floor(p.y + 1) -- self, attacker
				local v = self.object:get_velocity()

				-- fly/swim up towards attacker
				if s_y < p_y then

					-- if correct medium above then move up
					if core.find_node_near({x = s.x, y = s.y + 1, z = s.z},
							0, self.fly_in, true) then

						self.object:set_velocity({
								x = v.x, y = self.walk_velocity, z = v.z})
					else
						self.object:set_velocity({x = v.x, y = 0, z = v.z}) -- stop
					end

				-- fly/swim down towards attacker
				elseif s_y > p_y then

					-- if correct medium below then move down
					if core.find_node_near({x = s.x, y = s.y - 1, z = s.z},
						0, self.fly_in, true) then

						self.object:set_velocity({
								x = v.x, y = -self.walk_velocity, z = v.z})
					else
						self.object:set_velocity({x = v.x, y = 0, z = v.z}) -- stop
					end
				end
			end

			-- rnd: new movement direction
			if self.path.following and self.path.way
			and self.attack_type ~= "dogshoot" then

				-- no paths longer than 60
				if #self.path.way > 60 or dist < self.reach then
					self.path.following = false ; return
				end

				local p1 = self.path.way[1]

				if not p1 then
					self.path.following = false ; return
				end

				if abs(p1.x - s.x) + abs(p1.z - s.z) < 0.6 then
					table_remove(self.path.way, 1) -- remove waypoint once reached
				end

				p = self.path.way[1] or p1 -- set to next position with fallback
			end

			self:yaw_to_pos(p)

			-- move towards enemy if beyond mob reach
			if dist > (self.reach + (self.reach_ext or 0)) then

				-- path finding by rnd (only when enabled in setting and mob)
				if self.pathfinding and pathfinding_enable then
					self:smart_mobs(s, p, dist, dtime)
				end

				-- distance padding to stop mob spinning
				local pad = abs(p.x - s.x) + abs(p.z - s.z)

				if self.at_cliff or pad < 0.2 then

					self.reach_ext = 0.8 -- extend reach when on top of player
					self:set_velocity(0)
					self:set_animation("stand")
				else
					self.reach_ext = 0 -- reset

					if self.path.stuck then
						self:set_velocity(self.walk_velocity)
					else
						self:set_velocity(self.run_velocity)
					end

					local anim = "walk"

					if self.order == "stand" then anim = "stand"
					elseif self.animation and self.animation.run_start then anim = "run"
					end

					self:set_animation(anim)
				end
			else -- rnd: if inside reach range

				self.path.stuck = false
				self.path.stuck_timer = 0
				self.path.following = false -- not stuck anymore

				self:set_velocity(0)

				self.punch_timer = (self.punch_timer or 0) + dtime

				if self.punch_timer >= self.punch_interval then

					self.punch_timer = 0

					-- no custom attack or custom attack returns true to continue
					if not self.custom_attack or self:custom_attack(self, p) then

						local p2, s2 = p, s

						-- approximate mob eye level
						local cbox = self.prop.collisionbox
						local offset = cbox[2] + ((cbox[5] - cbox[2]) * 0.9)
						s2.y = s2.y + offset

						-- approximate victim eye level
						cbox = self.attack:get_properties().collisionbox
						offset = cbox[2] + ((cbox[5] - cbox[2]) * 0.9)
						p2.y = p2.y + offset

						-- if we can see who we attack, then do so
						if self:line_of_sight(p2, s2) then

							self:set_animation("punch")

							if random(self.sounds.attack_chance or 1) == 1 then
								self:mob_sound(self.sounds.attack)
							end

							-- punch player (or what player is attached to)
							local target = self.attack:get_attach() or self.attack

							local dgroup = self.damage_group or "fleshy"

							target:punch(self.object, 1.0, {
								full_punch_interval = 1.0,
								damage_groups = {[dgroup] = self.damage}
							}, nil)
						end
					end
				end
			end

		elseif self.attack_type == "shoot"
		or (self.attack_type == "dogshoot" and ds_var == 1) then

			p.y = p.y - 0.5 ; s.y = s.y + 0.5

			local vec = {x = p.x - s.x, y = p.y - s.y, z = p.z - s.z}

			self:yaw_to_pos(p) ; self:set_velocity(0)

			self.shoot_timer = (self.shoot_timer or 0) + dtime

			if self.shoot_timer > self.shoot_interval then

				self.shoot_timer = 0

				if core.registered_entities[self.arrow]
				and random(100) <= self.shoot_chance then

					self:set_animation("shoot")
					self:mob_sound(self.sounds.shoot_attack)

					local p = self.object:get_pos()
					local cb = self.prop.collisionbox

					p.y = p.y + (cb[2] + cb[5]) / 2

					local obj = core.add_entity(p, self.arrow)
					local ent = obj:get_luaentity()
					local amount = (vec.x * vec.x + vec.y * vec.y + vec.z * vec.z) ^ 0.5

					-- check for arrow custom override
					if self.arrow_override then self.arrow_override(ent, self) end

					local v = ent.velocity or 1

					ent.owner_id = tostring(self.object) -- add unique owner id to arrow

					if self.homing then -- setup homing arrow and target
						ent._homing_target = self.attack
					end

					local scale = v / amount

					obj:set_velocity({
						x = vec.x * scale,
						y =  (vec.y + self.shoot_offset) * scale,
						z = vec.z * scale
					})
				end
			end
		end
	end
end

-- falling & fall damage

function mob_class:falling(pos)

	if self.fly or self.disable_falling then return end

	local v = self.object:get_velocity() ; if not v then return end
	local fall_speed = self.fall_speed

	-- use liquid viscosity for float/sink speed when in water
	if self.floats and registered_nodes[self.standing_in].groups.liquid then

		local visc = min(registered_nodes[self.standing_in].liquid_viscosity, 7) + 1

		self.object:set_velocity({x = v.x, y = 0.45, z = v.z}) -- slow ascent in water

		fall_speed = -1.2 / visc

	elseif self.fall_damage and v.y == 0 then

		local d = (self.old_y or v.y) - self.object:get_pos().y

		if d > 6 then -- stay consistent with player fall damage

			local damage = d - 6
			local y_level = self.prop.collisionbox[2]
			local pos = self.object:get_pos()

			-- get current block below mob to check for fall damage modifier
			self.standing_on = node_ok(
					{x = pos.x, y = pos.y + y_level - 0.25, z = pos.z}, "air").name

			local def = registered_nodes[self.standing_on]
			local add = def and def.groups.fall_damage_add_percent

			if add and add ~= 0 then
				damage = damage + damage * (add / 100)
			end

			self.health = self.health - ceil(damage)

			effect(pos, 5, "mobs_tnt_smoke.png", 1, 2, 2, nil)

			if self:check_for_death({type = "fall"}) then return true end
		end

		self.old_y = self.object:get_pos().y
	end

	self.object:set_acceleration({x = 0, y = fall_speed, z = 0}) -- fall at set speed
end

-- deal damage & effects when mob punched

local dis_damage_kb = settings:get_bool("mobs_disable_damage_kb")

function mob_class:on_punch(hitter, tflp, tool_caps, dir, damage)

	-- mob health and nil check
	if self.health <= 0 or not hitter then return true end

	-- error checking when mod profiling is enabled
	if not tool_caps then
		core.log("warning",	"[mobs] Mod profiling enabled, damage not enabled")
		return true
	end

	if self.protected then -- are we protected ?

		if is_player(hitter) then -- only protect from players

			local player_name = hitter:get_player_name()

			if player_name ~= self.owner
			and core.is_protected(self.object:get_pos(), player_name) then

				core.chat_send_player(hitter:get_player_name(),
						S("Mob has been protected!"))

				return true
			end

		-- if protection is on level 2 then dont let arrows harm mobs
		elseif self.protected == 2 then

			local ent = hitter and hitter:get_luaentity()

			if not ent or ent._is_arrow then return true end
		end
	end

	local weapon = hitter:get_wielded_item()
	local weapon_def = weapon:get_definition() or {}

	-- calculate mob damage
	local damage = 0
	local armor = self.object:get_armor_groups() or {}
	local punch_interval = tool_caps.full_punch_interval or 1.4
	local tmp

	-- quick error check incase it ends up 0
	if tflp == 0 then tflp = 0.2 end

	if use_cmi then
		damage = cmi.calculate_damage(self.object, hitter, tflp, tool_caps, dir)
	else

		for group,_ in pairs( (tool_caps.damage_groups or {}) ) do

			tmp = tflp / punch_interval

			if tmp < 0 then tmp = 0.0 elseif tmp > 1 then tmp = 1.0 end

			damage = damage + (tool_caps.damage_groups[group] or 0)
					* tmp * ((armor[group] or 0) / 100.0)
		end
	end

	-- check if hit by player item or entity
	local hit_item = weapon_def.name

	if not is_player(hitter) then
		hit_item = hitter:get_luaentity().name
	end

	for n = 1, #self.immune_to do -- check for tool immunity or special damage

		local immune = self.immune_to[n]

		-- if "all" then no tools deal damage unless it's specified in list
		if immune[1] == hit_item or immune[1] == "all" then
			damage = self.immune_to[n][2] or 0 ; break
		end
	end

	local enchants = {}

	if use_mc2 then

		-- get enchants from mineclonia or voxelibre
		enchants = core.deserialize(
				weapon:get_meta():get_string("mcl_enchanting:enchantments")) or {}

		-- check for damage increasing enchantments
		if enchants.sharpness then
			damage = damage + (0.5 * enchants.sharpness) + 0.5
		end
	end

	-- custom punch function (if false returned, do not continue)
	if self.do_punch and self:do_punch(hitter, tflp, tool_caps, dir, damage) == false then
		return true
	end

--print("Mob Damage is", damage)

	if damage <= -1 then -- healing

		self.health = self.health - floor(damage)

		if use_vh1 then VH1.update_bar(self.object, self.health) end

		return true
	end

	if use_cmi
	and cmi.notify_punch(self.object, hitter, tflp, tool_caps, dir, damage) then
		return true
	end

	-- toolrank support
	local wear = floor((punch_interval / 75) * 9000)

	-- check for punch_attack_uses being 0 to negate wear
	if tool_caps.punch_attack_uses == 0 then
		wear = 0
	elseif mobs.is_creative(hitter:get_player_name()) then
		wear = use_tr and 1 or 0
	end

	if use_tr and weapon_def.original_description then
		toolranks.new_afteruse(weapon, hitter, nil, {wear = wear})
	else
		weapon:add_wear(wear)
	end

	hitter:set_wielded_item(weapon)

	-- only play hit sound and show blood effects if damage is 1 or over
	if damage >= 1 then

		-- select tool use sound if found, or fallback to default
		local snd = weapon_def.sound and weapon_def.sound.use or "mobs_punch"

		core.sound_play(snd, {object = self.object, max_hear_distance = 8}, true)

		-- blood_particles
		if not disable_blood and self.blood_amount > 0 then

			local bpos = table.copy(self.object:get_pos())
			local blood = self.blood_texture
			local amount = damage > 10 and self.blood_amount * 2 or self.blood_amount

			bpos.y = bpos.y + (-self.prop.collisionbox[2] + self.prop.collisionbox[5]) * .5

			-- select blood texture
			if type(self.blood_texture) == "table" then
				blood = self.blood_texture[random(#self.blood_texture)]
			end

			effect(bpos, amount, blood, 1, 2, 1.75, nil, nil, true)
		end

		-- add healthy afterglow when hit (can cause lag with larger textures)
		if mob_hit_effect then

			self.old_texture_mods = self.texture_mods

			self.object:set_texture_mod(self.texture_mods
					.. self.prop.damage_texture_modifier)

			core.after(0.3, function()

				if self and self.object and self.object:get_pos() then

					self.texture_mods = self.old_texture_mods
					self.old_texture_mods = nil
					self.object:set_texture_mod(self.texture_mods)
				end
			end)
		end

		-- check for friendly fire (arrows from same mob)
		if self.friendly_fire then
			self.health = self.health - floor(damage) -- do damage regardless
		else
			local entity = hitter and hitter:get_luaentity()

			-- check if arrow from same mob, if so then do no damage
			if (entity and entity.name ~= self.arrow) or is_player(hitter) then
				self.health = self.health - floor(damage)
			end
		end

		-- exit here if dead, check for tools with fire damage
		local hot = tool_caps.damage_groups and tool_caps.damage_groups.fire

		-- check for any fire enchants also
		if use_mc2 and (enchants.flame or enchants.fire_aspect) then
			hot = true
		end

		if self:check_for_death({type = "punch", puncher = hitter, hot = hot}) then
			return true
		end
	end

	-- knock back effect (only on full punch)
	if self.knock_back and tflp >= punch_interval then

		local v = self.object:get_velocity()

		if v then

			local kb = dis_damage_kb and 1 or (damage or 1)

			kb = tool_caps.damage_groups["knockback"] or kb

			if use_mc2 and enchants.knockback then -- check for knockback enchantment
				kb = kb + 3 * enchants.knockback
			end

			local up = (v.y > 0 or self.fly) and 0 or 2

			dir = dir or {x = 0, y = 0, z = 0}

			self.object:set_velocity({x = dir.x * kb, y = up, z = dir.z * kb})

			-- turn mob on knockback
			self:set_yaw((self.object:get_yaw() or 0) - random(-0.9, 0.9), 6)

			if self.animation and self.animation.injured_end and damage >= 1 then
				self:set_animation("injured")
			else
				self:set_animation("walk")
			end

			self.pause_timer = 0.25
		end
	end

	-- if skittish then run away
	if self.runaway and self.order ~= "stand" then

		self:yaw_to_pos(hitter:get_pos(), 3, 4) -- opposite dir

		self.state = "runaway"
		self.runaway_timer = 3
		self.following = nil
	end

	local hitter_name = hitter:get_player_name() or ""

	-- call for help and attack puncher
	if not self.passive and self.state ~= "flop" and not self.child
	and not (is_player(hitter) and hitter_name == self.owner)
	and not is_invisible(self, hitter_name) and self.object ~= hitter then

		self.state = ""
		self:do_attack(hitter) -- attack whoever punched mob

		-- alert others to the attack
		local objs = core.get_objects_inside_radius(hitter:get_pos(), self.view_range)

		for n = 1, #objs do

			local ent = objs[n] and objs[n]:get_luaentity()

			if ent and ent._cmi_is_mob then

				-- only alert members of same mob or assigned helper
				if ent.group_attack and ent.state ~= "attack"
				and not (is_player(hitter) and ent.owner == hitter_name)
				and (ent.name == self.name or ent.name == self.group_helper) then
					ent:do_attack(hitter)
				end

				-- have owned mobs attack player threat
				if is_player(hitter) and ent.owner == hitter_name and ent.owner_loyal then
					ent:do_attack(self.object)
				end
			end
		end
	end

	return true
end

-- helper to clean mob staticdata

local function clean_staticdata(self)

	local tmp, t = {}

	for _,stat in pairs(self) do

		t = type(stat)

		if  t ~= "function" and t ~= "nil" and t ~= "userdata" and _ ~= "temp"
		and _ ~= "object" and _ ~= "_cmi_components" then tmp[_] = self[_] end
	end

	return tmp
end

-- get entity staticdata

function mob_class:mob_staticdata()

	-- this handles mob count for mobs activated, unloaded, reloaded
	if active_limit > 0 and self.active_toggle then
		active_mobs = active_mobs + self.active_toggle
		self.active_toggle = -self.active_toggle
--print("-- staticdata", active_mobs, active_limit, self.active_toggle)
	end

	-- remove mob when out of range unless tamed
	if remove_far and self.remove_ok
	and self.type ~= "npc" and self.state ~= "attack"
	and not self.tamed and self.lifetimer < 20000 then

--print("REMOVED " .. self.name)

		remove_mob(self, true)

		return core.serialize({remove_ok = true, static_save = true})
	end

	self.remove_ok = true
	self.attack = nil
	self.following = nil
	self.state = "stand"

	if use_cmi then
		self.serialized_cmi_components = cmi.serialize_components(self._cmi_components)
	end

	return core.serialize(clean_staticdata(self))
end

-- list of items used in initial_properties

local is_property_name = {
	hp_max = true, physical = true, collide_with_objects = true, collisionbox = true,
	selectionbox = true, pointable = true, visual_size = true, textures = true,
	is_visible = true, stepheight = true, glow = true, show_on_minimap = true
}

-- activate mob and reload settings

function mob_class:mob_activate(staticdata, def, dtime)

	-- if dtime == 0 then entity has just been created
	-- anything higher means it is respawning (thx SorceryKid)
	if dtime == 0 and active_limit > 0 then self.active_toggle = 1 end

	if at_limit() and not self.tamed then -- remove any mobs not tamed when total reached
--print("-- mob limit reached, removing " .. self.name)
		remove_mob(self) ; return
	end

	-- load entity variables from staticdata into self.*
	local tmp = core.deserialize(staticdata)

	if tmp then

		local t ; for _,stat in pairs(tmp) do

			t = type(stat)

			if t ~= "function" and t ~= "nil" and t ~= "userdata" then

				if is_property_name[_] then

					self.object:set_properties({[_] = stat})
				else
					self[_] = stat
				end
			end
		end
	end

	self.temp = {} -- temporary values stored here are never saved with mob

	self.prop = self.object:get_properties()

	if not self.base_texture then -- select random texture

		-- compatiblity with old simple mobs textures
		if def.textures and type(def.textures[1]) == "string" then
			def.textures = {def.textures}
		end

		-- backup to base settings
		self.base_texture = def.textures and def.textures[random(#def.textures)]
	end

	-- get texture, model and size
	local textures = self.base_texture
	local mesh, vis_size = self.base_mesh, self.base_size
	local colbox, selbox = self.base_colbox, self.base_selbox

	self.object:set_properties(
			{visual_size = vis_size, collisionbox = colbox, selectionbox = selbox})

	if self.gotten then
		textures = def.gotten_texture or textures
		mesh = def.gotten_mesh or mesh
	end

	-- set child objects to half size
	if self.child then

		mobs:scale_mob(self, .5, .5)

		if def.child_texture then textures = def.child_texture[1] end
	end

	-- set mob size and textures
	self.object:set_properties({textures = textures})

	if self.health == 0 then self.health = random(self.hp_min, self.prop.hp_max) end

	self.path = { -- pathfinding init
		way = {}, -- path to follow, table of positions
		lastpos = {x = 0, y = 0, z = 0},
		stuck = false,
		stuck_timer = 0, -- if stuck for too long search for path
		following = false -- currently following path?
	}

	local armor = type(self.armor) == "table" and table_copy(self.armor)
			or {fleshy = self.armor, immortal = 1} -- immortal for custom damage

	self.object:set_armor_groups(armor)

	self.old_y = self.object:get_pos().y -- var defaults
	self.old_health = self.health
	self.textures = textures
	self.standing_in = "air"
	self.standing_on = "air"
	self.looking_at = "air"
	self.looking_above = "air"
	self.state = self.state or "stand"

	self:set_yaw((random(0, 360) - 180) / 180 * pi, 6) -- stand at random yaw
	self:set_animation("stand")

	if type(self.texture_mods) ~= "string" then
		print("[Mobs Redo API] Error: self.texture_mods not a string")
		self.texture_mods = ""
	end

	self.object:set_texture_mod(self.texture_mods) -- apply texture mods

	-- set flag to remove monsters when map area unloaded
	if remove_far and self.type == "monster" and not self.tamed then
		self.object:set_properties({static_save = false})
	end

	-- run on_spawn function
	if self.on_spawn and not self.on_spawn_run and self.on_spawn(self) then
		self.on_spawn_run = true -- if true, set flag to run once only
	end

	-- run after_activate
	if def.after_activate then
		def.after_activate(self, staticdata, def, dtime)
	end

	if use_cmi then
		self._cmi_components = cmi.activate_components(self.serialized_cmi_components)
		cmi.notify_activate(self.object, dtime)
	end

	if use_vh1 then VH1.update_bar(self.object, self.health) end
end

-- handle mob lifetimer & expiration

function mob_class:mob_expire(pos, dtime)

	if self.type == "npc" or self.tamed or self.state == "attack"
	or remove_far or self.lifetimer >= 20000 then return end

	self.lifetimer = self.lifetimer - dtime

	if self.lifetimer > 0 then return end

	-- only despawn away from player
	for _, player in ipairs(player_list) do

		if player and get_distance(player:get_pos(), pos) <= 15 then
			self.lifetimer = 20 ; return
		end
	end

--	core.log("action", "lifetimer expired, removed " .. self.name)

	effect(pos, 15, "mobs_tnt_smoke.png", 2, 4, 2, 0)

	remove_mob(self, true) ; return true
end

-- get nodes mob is standing on, in, facing, facing above

function mob_class:get_nodes()

	local pos = self.object:get_pos()
	local yaw = self.object:get_yaw()
	local y_level = self.prop.collisionbox[2]

	self.standing_in = node_ok(
			{x = pos.x, y = pos.y + y_level + 0.1, z = pos.z}, "air").name

	self.standing_on = node_ok(
			{x = pos.x, y = pos.y + y_level - 0.1, z = pos.z}, "air").name

	-- find front position
	local dir_x = -sin(yaw) * (self.prop.collisionbox[4] + 0.5)
	local dir_z = cos(yaw) * (self.prop.collisionbox[4] + 0.5)

	-- nodes in front of mob and front/above
	self.looking_at = node_ok(
			{x = pos.x + dir_x, y = pos.y + y_level + 0.1, z = pos.z + dir_z}).name

	self.looking_above = node_ok(
			{x = pos.x + dir_x, y = pos.y + y_level + 1.1, z = pos.z + dir_z}).name

	-- are we facing a fence or wall
	self.facing_fence = self.looking_at:find("fence")
			or self.looking_at:find("gate") or self.looking_at:find("wall")
--[[
print("on: " .. self.standing_on
	.. ", front: " .. self.looking_at
	.. ", front above: " .. self.looking_above
	.. ", fence: " .. (self.facing_fence and "yes" or "no"))
]]
end

-- main mob function

function mob_class:on_step(dtime, moveresult)

	if self.state == "die" then return end

	if use_cmi then cmi.notify_step(self.object, dtime) end

	local pos = self.object:get_pos() ; if not pos then return end

	self.node_timer = (self.node_timer or 0) + dtime

	-- get nodes (every 1/4 second by default)
	if self.node_timer > node_timer_interval then

		self:get_nodes() -- get nodes above, below, in front and front-above

		self.node_timer = 0

		-- stop when facing cliff or for fear of heights
		self.at_cliff = self:is_at_cliff()

		if self.pause_timer <= 0 and self.at_cliff then self:set_velocity(0) end

		-- has mob expired (0.25 instead of dtime since were in a timer)
		if self:mob_expire(pos, node_timer_interval) then return end

		self:do_jump() -- jump if not blocked
	end

	-- falling check, return if dead
	if self:falling(pos) then return end

	-- smooth rotation
	if self.delay and self.delay > 0 then

		local yaw = self.object:get_rotation().y or 0
		local rotation = shortest_rotation(yaw, self.target_yaw) / self.delay

		self.delay = self.delay - 1

		self:set_yaw(yaw + rotation, 0)
	end

	-- environmental damage timer (every 1 second)
	self.env_damage_timer = (self.env_damage_timer or 0) + dtime

	if self.env_damage_timer > 1 then

		self.env_damage_timer = 0

		if self:do_env_damage() then return end -- check for damage

		self:replace(pos) -- node replacement (cows eat grass etc.)

		self:check_item_pickup(pos) -- look for dropped items
	end

	if self.pause_timer > 0 then -- knockback timer

		self.pause_timer = self.pause_timer - dtime

		if self.pause_timer <= 0 and (self.order == "stand" or self.state == "stand") then

			self:set_velocity(0)
			self:set_animation("stand", true)
		end

		return
	end

	-- run custom function (defined in mob lua file) - when false skip going any further
	if self.do_custom and self:do_custom(dtime, moveresult) == false then return end

	-- has no real use but kept for backwards compatibility
	self.timer = self.timer + dtime

	if self.timer > 100 then self.timer = 1 end -- never go over 100

	-- when attacking call do_states live (return if dead)
	if self.state == "attack" and self:do_states(dtime) then return end

	-- one second timed calls
	self.timer1 = (self.timer1 or 0) + dtime

	if self.timer1 >= main_timer_interval then

		self.timer1 = 0

		-- store get_properties() each second to save getting them every instance
		self.prop = self.object:get_properties()

		-- random mob sound
		if random(100) == 1 then self:mob_sound(self.sounds.random) end

		self:general_attack()
		self:breed()
		self:follow_flop(dtime)

		-- when not attacking call do_states every second (return if dead)
		if self.state ~= "attack" then
			if self:do_states(main_timer_interval) then return end
		end

		self:do_runaway_from()
		self:do_stay_near()
		self:follow_teleport()
	end
end

-- when mob ordered to follow player who is out of range, teleport to if not attacking

function mob_class:follow_teleport()

	if self.order == "follow" and self.state ~= "attack" and not self.following then

		if self.owner and self.owner ~= "" then

			local player = core.get_player_by_name(self.owner)

			if player then

				local pos = player:get_pos()

				if get_distance(self.object:get_pos(), pos) > (self.view_range * 2) then

					pos.y = pos.y - self.base_colbox[2] -- dont teleport into the ground

					self.object:move_to(pos, true)
					self:mob_sound("default_dirt_footstep")
				end
			end
		end
	end
end

-- default function when mobs are blown up with TNT

function mob_class:on_blast(damage)

--print("-- blast damage", damage)

	self.object:punch(self.object, 1.0,
			{full_punch_interval = 1.0, damage_groups = {fleshy = damage}}, nil)

	-- return no damage, no knockback, no item drops, mob api handles all
	return false, false, {}
end

-- register mob entity

function mobs:register_mob(name, def)

	mobs.spawning_mobs[name] = {}

	local collisionbox = table.copy(def.collisionbox or
			{-0.25, -0.25, -0.25, 0.25, 0.25, 0.25})

	-- quick fix to stop mobs glitching through nodes if too small
	if mob_height_fix and (collisionbox[5] - collisionbox[2]) < 1.01 then
		collisionbox[5] = collisionbox[2] + 0.99
	end

	local entity_def = {

		initial_properties = {
			hp_max = max(1, (def.hp_max or 10) * difficulty),
			physical = true,
			collisionbox = collisionbox,
			selectionbox = def.selectionbox or collisionbox,
			visual = def.visual,
			visual_size = def.visual_size or {x = 1, y = 1},
			mesh = def.mesh,
			textures = "",
			use_texture_alpha = def.use_texture_alpha,
			backface_culling = def.backface_culling,
			makes_footstep_sound = def.makes_footstep_sound,
			stepheight = def.stepheight or 1.1,
			glow = def.glow,
			damage_texture_modifier = def.damage_texture_modifier or "^[colorize:#c9900070",
		},
-- basics
		name = name,
		description = def.description or name,
		type = def.type,
		_nametag = def.nametag,
		owner = def.owner or "",
		order = def.order or "",
		lifetimer = def.lifetimer or 180, -- 3 minutes
		hp_min = max(1, (def.hp_min or 5) * difficulty),
		drops = def.drops or {},
-- model
		drawtype = def.drawtype, -- DEPRECATED, use rotate
		rotate = rad(def.rotate or 0), -- 0 = front 90, = side, 180 = back, 270 = side2
		base_mesh = def.mesh, -- backup entity model and size
		base_colbox = collisionbox,
		base_selbox = def.selectionbox or collisionbox,
		base_size = def.visual_size or {x = 1, y = 1},
		animation = def.animation,
		texture_list = def.textures,
		texture_mods = def.texture_mods or "",
		child_texture = def.child_texture,
-- behaviour
		jump_height = def.jump_height or 4,
		jump_chance = def.jump_chance,
		fly = def.fly,
		fly_in = def.fly_in or "air",
		keep_flying = def.keep_flying,
		can_leap = def.can_leap,
		view_range = def.view_range or 5,
		view_range_attacking = def.view_range_attacking or def.view_range or 6,
		walk_velocity = def.walk_velocity or 1,
		run_velocity = def.run_velocity or 2,
		sounds = def.sounds or {},
		replace_rate = def.replace_rate,
		replace_what = def.replace_what,
		replace_with = def.replace_with,
		replace_offset = def.replace_offset or 0,
		pick_up = def.pick_up,
		on_pick_up = def.on_pick_up,
		reach = def.reach or 3,
		docile_by_day = def.docile_by_day,
		fear_height = def.fear_height or (def.fly and 0 or 2),
		runaway = def.runaway,
		follow = def.follow,
		floats = def.floats,
		pathfinding = def.pathfinding,
		runaway_from = def.runaway_from,
		pushable = def.pushable,
		stay_near = def.stay_near,
		randomly_turn = def.randomly_turn ~= false,
		ignore_invisibility = def.ignore_invisibility,
		messages = def.messages, -- npc message table for idle chat
-- health
		armor = def.armor or 100,
		damage = max(0, (def.damage or 0) * difficulty),
		damage_group = def.damage_group,
		light_damage = def.light_damage or 0,
		light_damage_min = def.light_damage_min or 14,
		light_damage_max = def.light_damage_max or 15,
		water_damage = def.water_damage or 0,
		lava_damage = def.lava_damage or 4,
		fire_damage = def.fire_damage or 4,
		air_damage = def.air_damage or 0,
		node_damage = def.node_damage,
		suffocation = def.suffocation or 2,
		fall_damage = def.fall_damage,
		fall_speed = def.fall_speed or -gravity,
-- attack
		attack_type = def.attack_type,
		punch_interval = def.punch_interval or 1,
		arrow = def.arrow,
		arrow_override = def.arrow_override,
		shoot_interval = def.shoot_interval or 2,
		shoot_chance = def.shoot_chance or 80,
		shoot_offset = def.shoot_offset or 0,
		homing = def.homing,
		walk_chance = def.walk_chance or 50,
		stand_chance = def.stand_chance or 30,
		attack_chance = def.attack_chance or 5,
		attack_patience = def.attack_patience or 18,
		passive = def.passive,
		knock_back = def.knock_back,
		blood_amount = def.blood_amount or 5,
		blood_texture = def.blood_texture or "mobs_blood.png",
		immune_to = def.immune_to or {},
		explosion_radius = def.explosion_radius,
		explosion_damage_radius = def.explosion_damage_radius,
		explosion_timer = def.explosion_timer or 3,
		allow_fuse_reset = def.allow_fuse_reset,
		stop_to_explode = def.stop_to_explode,
		dogshoot_switch = def.dogshoot_switch,
		dogshoot_count_max = def.dogshoot_count_max or 5,
		dogshoot_count2_max = def.dogshoot_count2_max or def.dogshoot_count_max or 5,
		group_attack = def.group_attack,
		group_helper = def.group_helper,
		attack_monsters = def.attack_monsters,
		attack_animals = def.attack_animals,
		attack_players = def.attack_players,
		attack_npcs = def.attack_npcs,
		attack_ignore = def.attack_ignore,
		specific_attack = def.specific_attack,
		friendly_fire = def.friendly_fire,
		owner_loyal = def.owner_loyal,
-- functions
		on_rightclick = def.on_rightclick,
		on_die = def.on_die,
		on_death = def.on_death, -- engine function for entity death
		on_flop = def.on_flop,
		do_custom = def.do_custom,
		do_mount_action = def.do_mount_action,
		on_replace = def.on_replace,
		custom_attack = def.custom_attack,
		on_spawn = def.on_spawn,
		on_blast = def.on_blast,
		do_punch = def.do_punch,
		on_breed = def.on_breed,
		on_grown = def.on_grown,
		on_sound = def.on_sound,
		on_activate = function(self, staticdata, dtime)
			return self:mob_activate(staticdata, def, dtime)
		end,
		get_staticdata = function(self)
			return self:mob_staticdata(self)
		end
--		is_mob = true, _hittable_by_projectile = true, -- mineclone thing
	}

	core.register_entity(":" .. name, setmetatable(entity_def, mob_class_meta))

	-- older setting check for compatibility
	mobs.compatibility_check(core.registered_entities[name])
end

-- return <number of mobs of same type in area>, <player found>

local function count_mobs(pos, mob_name)

	local total = 0
	local objs = core.get_objects_inside_radius(pos, aoc_range * 2)
	local ent, players

	for n = 1, #objs do

		if is_player(objs[n]) then players = true
		else
			ent = objs[n]:get_luaentity()

			if ent and ent.name and ent.name == mob_name then total = total + 1 end
		end
	end

	return total, players
end

-- helper function for can_spawn

local function get_range(width)

	if width % 2 == 0 then -- even widths are slightly offset
		local max_offset = width / 2 ; return -max_offset + 1, max_offset
	end

	local max_offset = floor(width / 2) ; return -max_offset, max_offset
end

-- check if we have enough room to spawn a mob

local function can_spawn(pos, name)

	local ent = core.registered_entities[name] ; if not ent then return end
	local box = ent.base_colbox ; if not box then return end

	local width_x = max(1, ceil(box[4] - box[1]))
	local width_z = max(1, ceil(box[6] - box[3]))
	local height  = max(0, ceil(box[5] - box[2]) - 1)

	local min_x, max_x = get_range(width_x)
	local min_z, max_z = get_range(width_z)

	for y = 0, height do
		for x = min_x, max_x do
			for z = min_z, max_z do

				local def  = registered_nodes[node_ok(
						{x = pos.x + x, y = pos.y + y, z = pos.z + z}).name]

				if def and def.walkable then
					return -- blocked by solid node
				end
			end
		end
	end

	local pos2 = {x = pos.x, y = pos.y, z = pos.z}

	if width_x % 2 == 0 then pos2.x = pos2.x + 0.5 end -- centre even sized mobs
	if width_z % 2 == 0 then pos2.z = pos2.z + 0.5 end

	return pos2
end

function mobs:can_spawn(pos, name)
	return can_spawn(pos, name)
end

-- global functions

function mobs:add_mob(pos, def)

	if not pos or not def then
--print("--- no position or definition given")
		return
	end

	if not mobs.spawning_mobs[def.name] or not core.registered_entities[def.name] then
--print("--- mob doesn't exist", def.name)
		return
	end

	if at_limit() then
--print("--- active mob limit reached", active_mobs, active_limit)
		return
	end

	-- get total number of this mob in area
	local num_mob, is_pla = count_mobs(pos, def.name)

	if not is_pla then
--print("--- no players within active area, will not spawn " .. def.name)
		return
	end

	local aoc = mobs.spawning_mobs[def.name] and mobs.spawning_mobs[def.name].aoc or 1

	if def.ignore_count ~= true and num_mob >= aoc then
--print("--- too many " .. def.name .. " in area", num_mob .. "/" .. aoc)
		return
	end

	local mob = core.add_entity(pos, def.name)

--print("[mobs] Spawned " .. def.name .. " at " .. core.pos_to_string(pos))

	local ent = mob:get_luaentity()

	if not ent then
--print("[mobs] entity not found " .. def.name)
		return
	else
		effect(pos, 15, "mobs_tnt_smoke.png", 1, 2, 2, 15, 5)
	end

	-- use new texture if found
	local new_texture = def.texture or ent.base_texture

	if def.child then

		ent.mommy_tex = new_texture -- how baby looks when grown
		ent.base_texture = new_texture

		if ent.child_texture then -- using specific child texture (if found)
			new_texture = ent.child_texture[1]
		end

		ent.child = true ; mobs:scale_mob(ent, .5, .5)

	elseif def.texture then -- if not child set new texture

		ent.base_texture = new_texture

		mob:set_properties({textures = new_texture})
	end

	if def.owner then
		ent.tamed = true ; ent.owner = def.owner
	end

	if def.nametag then

		if def.nametag:len() > 64 then -- limit name entered to 64 characters
			def.nametag = def.nametag:sub(1, 64)
		end

		ent:update_tag(def.nametag)
	end

	return ent
end

-- global function to add additional spawn checks

function mobs:spawn_abm_check(pos, node, name)
	-- return true to stop spawning mob
end

-- older spawning function

function mobs:spawn_specific(name, nodes, neighbors, min_light, max_light, interval,
		chance, aoc, min_height, max_height, day_toggle, on_spawn, map_load)

	if not mobs_spawn or not mobs.spawning_mobs[name] then
--print ("--- spawning not registered for " .. name)
		return
	end

	-- remove monsters in peaceful mode
	local ent = core.registered_entities[name]

	if peaceful_only and ent and ent.type == "monster" then
--print ("--- peaceful mode so no spawning of " .. name)
		return
	end

	-- chance/spawn number override in core.conf
	local numbers = settings:get(name)

	if numbers then

		numbers = numbers:split(",")
		chance = tonumber(numbers[1]) or chance
		aoc = tonumber(numbers[2]) or aoc

		if chance == 0 then

			core.log("warning",
					string.format("[mobs] %s has spawning disabled", name))
			return
		end

		core.log("action", string.format(
				"[mobs] Chance setting for %s changed to %s (total: %s)",
				name, chance, aoc))
	end

	mobs.spawning_mobs[name].aoc = aoc

	local function spawn_action(pos, node, active_object_count, active_object_count_wider)

		if active_object_count_wider and active_object_count_wider >= max_per_block then
--print("--- too many entities in area", active_object_count_wider)
			return
		end

		if map_load and (random(max(1, (chance * mob_chance_multiplier))) > 1
		or not core.find_node_near(pos, 1, neighbors)) then
--print("-- lbm no chance or neighbor not found")
			return
		end

		local ent = core.registered_entities[name]

		if not mobs.spawning_mobs[name] or not ent then
--print("--- mob doesn't exist", name)
			return
		end

		if at_limit() then
--print("--- active mob limit reached", active_mobs, active_limit)
			return
		end

		-- custom checks for mob spawning
		if mobs:spawn_abm_check(pos, node, name) then
			return
		end

		local num_mob, is_pla = count_mobs(pos, name)

		if not is_pla then
--print("--- no players within active area, will not spawn " .. name)
			return
		end

		if num_mob >= aoc then
--print("--- too many " .. name .. " in area", num_mob .. "/" .. aoc)
			return
		end

		if day_toggle ~= nil then

			local tod = (core.get_timeofday() or 0) * 24000

			if tod > 4500 and tod < 19500 then

				if day_toggle == false then -- daylight, but mob wants night
--print("--- mob needs night", name)
					return
				end
			else
				if day_toggle then -- night time but mob wants day
--print("--- mob needs day", name)
					return
				end
			end
		end

		pos.y = pos.y + 1 -- change position to above node

		if pos.y > max_height or pos.y < min_height then
--print("--- height limits not met", name, pos.y)
			return
		end

		local light = core.get_node_light(pos)
		if not light or light > max_light or light < min_light then
--print("--- light limits not met", name, light)
			return
		end

		if #core.find_nodes_in_area(
				{x = pos.x - 16, y = pos.y - 16, z = pos.z - 16},
				{x = pos.x + 16, y = pos.y + 16, z = pos.z + 16},
				{"mobs:mob_repellent"}) > 0 then
--print("--- mob repellent nearby")
			return
		end

		-- check if mob/monster can be spawned inside protected areas
		if core.is_protected(pos, "") then

			if core.registered_entities[name].type == "monster"
			and spawn_monster_protected == false then
--print("--- monster inside protected area", name)
				return
			elseif spawn_protected == false then
--print("--- inside protected area", name)
				return
			end
		end

		for _, player in ipairs(player_list) do

			if player and get_distance(player:get_pos(), pos) <= mob_nospawn_range then
--print("--- player too close", name)
				return
			end
		end

		if mob_area_spawn ~= true and ent.base_colbox then

			-- do we have enough height clearance to spawn mob?
			local height = max(0, ent.base_colbox[5] - ent.base_colbox[2])

			for n = 0, floor(height) do

				local pos2 = {x = pos.x, y = pos.y + n, z = pos.z}

				if registered_nodes[node_ok(pos2).name].walkable then
--print ("--- inside block", name, node_ok(pos2).name)
					return
				end
			end
		else
			pos = can_spawn(pos, name) -- return position if enough space to spawn
		end

		if pos then

			-- get mob collisionbox and determine y_offset when spawning
			local _prop = ent and ent.initial_properties or {}
			local _y = _prop.collisionbox and -_prop.collisionbox[2] or 1

			pos.y = pos.y + _y

			local mob = core.add_entity(pos, name)

			if mob_log_spawn then

				core.log("action", string.format("[MOBS] Spawned %s at %s", name,
						core.pos_to_string(pos)))
			end

			if on_spawn and mob then on_spawn(mob:get_luaentity(), pos) end
		else
--print("--- not enough space to spawn", name)
		end
	end

	if map_load then

		core.register_lbm({ -- on map_load use lbm to spawn on generation
			name = name .. "_spawning",
			label = name .. " spawning",
			nodenames = nodes,
			run_at_every_load = false,
			min_y = min_height, max_y = max_height,
			action = spawn_action
		})
	else
		core.register_abm({ -- abm spawns at every interval/chance
			label = name .. " spawning",
			nodenames = nodes,
			neighbors = neighbors,
			interval = interval,
			chance = max(1, (chance * mob_chance_multiplier)),
			catch_up = false,
			min_y = min_height, max_y = max_height,
			action = spawn_action
		})
	end
end

-- MarkBu's newer spawn function (USE this one please modders)

function mobs:spawn(def)

	mobs:spawn_specific(
		def.name,
		def.nodes or {"group:soil", "group:stone"},
		def.neighbors or {"air"},
		def.min_light or 0, def.max_light or 15,
		def.interval or 30, def.chance or 5000,
		def.active_object_count or 1,
		def.min_height or -31000, def.max_height or 31000,
		def.day_toggle,
		def.on_spawn,
		def.on_map_load)
end

-- register arrow for shoot attack

function mobs:register_arrow(name, def)

	if not name or not def then return end

	core.register_entity(":" .. name, {

		initial_properties = {
			physical = def.physical ~= false,
			collide_with_objects = def.collide_with_objects ~= false,
			static_save = false,
			visual = def.visual,
			visual_size = def.visual_size,
			mesh = def.mesh,
			textures = def.textures,
			collisionbox = def.collisionbox or {-.1, -.1, -.1, .1, .1, .1},
			glow = def.glow,
			automatic_face_movement_dir = def.rotate
					and (def.rotate - (pi / 180)) or false,
		},

		velocity = def.velocity,
		hit_player = def.hit_player,
		hit_node = def.hit_node,
		hit_mob = def.hit_mob,
		hit_object = def.hit_object,
		drop = def.drop, -- chance of dropping arrow as registered item
		drop_item = def.drop_item, -- custom item drop
		timer = 0,
		lifetime = def.lifetime or 4.5,
		owner_id = def.owner_id,
		rotate = def.rotate,
		do_custom = def.do_custom,
		on_activate = def.on_activate,
		on_punch = def.on_punch,

		on_step = def.on_step or function(self, dtime, moveresult)

			self.timer = self.timer + dtime

			if self.timer > self.lifetime then
				self.object:remove() ; return -- remove arrow
			end

			local pos = self.object:get_pos() ; self.lastpos = pos

			-- does arrow have a tail?
			if def.tail and def.tail == 1 and def.tail_texture then

				core.add_particle({
					pos = pos,
					velocity = {x = 0, y = 0, z = 0},
					acceleration = {x = 0, y = 0, z = 0},
					expirationtime = def.expire or 0.25,
					collisiondetection = false,
					texture = def.tail_texture,
					size = def.tail_size or 5,
					glow = def.glow
				})
			end

			if self.do_custom and self:do_custom(dtime, moveresult) == false then
				return
			end

			if self._homing_target then -- follow target when in view

				local p = self._homing_target:get_pos()

				if p and core.line_of_sight(self.object:get_pos(), p) then

					self.object:set_velocity(vector.direction(
							self.object:get_pos(), p) * self.velocity)
				else
					self._homing_target = nil
				end
			end

			-- did a solid arrow hit a solid thing?
			if moveresult and moveresult.collides then

				local def = moveresult.collisions and moveresult.collisions[1] or {}

				self.moveresult = moveresult -- pass moveresult into arrow entity

				if def.type == "node" and self.hit_node then

					local node = node_ok(def.node_pos)

					self.node_pos = def.node_pos

					self:hit_node(pos, node) ; --print("-- hit node", node.name)

					if (type(self.drop) == "boolean" and self.drop)
					or (type(self.drop) == "number" and random(self.drop) == 1) then

						local drop = self.drop_item or self.object:get_luaentity().name

						core.add_item(pos, drop) ; --print("-- arrow drop", drop)
					end
				end

				if def.type == "object" then

					local obj = def.object

					if is_player(obj) and self.hit_player then
						self:hit_player(obj) ; --print("-- hit player", obj:get_player_name())
					else
						local entity = obj:get_luaentity()

						if entity then

							if entity._cmi_is_mob and self.hit_mob then

								self:hit_mob(obj) ; --print("-- hit mob", entity.name)

							elseif self.hit_object then

								self:hit_object(obj) ; --print("-- hit object", entity.name)
							end
						end
					end
				end

				self.object:remove() ; return -- remove arrow after hitting solid item
			end
		end
	})
end

-- explosion with no node damage

function mobs:safe_boom(self, pos, radius, texture)

	core.sound_play(self and self.sounds and self.sounds.explode or "tnt_explode", {
		pos = pos, max_hear_distance = (self.sounds and self.sounds.distance) or 32
	}, true)

	entity_physics(pos, radius)

	effect(pos, 32, texture, radius * 3, radius * 5, radius, 1, 0)
end

-- explosion with tnt mod checks

function mobs:boom(self, pos, node_damage_radius, entity_radius, texture)

	if not pos then return end

	texture = texture or "mobs_tnt_smoke.png"

	if mobs_griefing and not minetest.is_protected(pos, "") then

		if core.get_modpath("mcl_explosions") then

			mcl_explosions.explode(pos, node_damage_radius) ; return

		elseif core.get_modpath("tnt") and tnt and tnt.boom then

			tnt.boom(pos, {
				radius = node_damage_radius,
				damage_radius = entity_radius,
				sound = self and self.sounds and self.sounds.explode or "tnt_explode",
				explode_center = true,
				tiles = texture
			}) ; return
		end
	end

	mobs:safe_boom(self, pos, node_damage_radius, texture)
end

-- Register spawn eggs - This also introduces the “spawn_egg” group:
-- * spawn_egg=1: generic mob, no metadata
-- * spawn_egg=2: captured/tamed mob, metadata

function mobs:register_egg(mob, desc, background, addegg, no_creative, can_spawn_protect)

	local grp = {spawn_egg = 1}

	-- do NOT add this egg to creative inventory (e.g. dungeon master)
	if no_creative then grp.not_in_creative_inventory = 1 end

	local invimg = background

	if addegg == 1 then
		invimg = "mobs_chicken_egg.png^(" .. invimg
				.. "^[mask:mobs_chicken_egg_overlay.png)"
	end

	-- does mob/entity exist
	local is_mob = core.registered_entities[mob]

	if not is_mob then
		print("[Mobs Redo] Spawn Egg cannot be created for " .. mob) ; return
	end

	-- get mob collisionbox and determine y_offset when spawning
	local _prop = is_mob and is_mob.initial_properties or {}
	local _y = _prop.collisionbox and -_prop.collisionbox[2] or 1

	-- register new spawn egg containing mob information (cannot be stacked)
	-- these are only created for animals and npc's, not monsters
	if is_mob.type ~= "monster" then

		core.register_craftitem(":" .. mob .. "_set", {

			description = S("@1 (Tamed)", desc),
			inventory_image = invimg,
			groups = {spawn_egg = 2, not_in_creative_inventory = 1},
			stack_max = 1,

			on_place = function(itemstack, placer, pointed_thing)

				local pos = pointed_thing.above ; if not pos then return end

				-- does existing on_rightclick function exist?
				local under = get_node(pointed_thing.under)
				local def = under and registered_nodes[under.name]

				if def and def.on_rightclick then

					return def.on_rightclick(
							pointed_thing.under, under, placer, itemstack, pointed_thing)
				end

				-- can i spawn in protected areas?
				if not can_spawn_protect
				and core.is_protected(pos, placer:get_player_name()) then
					return
				end

				if at_limit() then -- have we reached active mob limit

					core.chat_send_player(placer:get_player_name(),
							S("Active Mob Limit Reached!")
							.. "  (" .. active_mobs
							.. " / " .. active_limit .. ")")
					return
				end

				pos.y = pos.y + _y

				-- copy egg data back into mob
				local data = itemstack:get_meta():get_string("")
				local smob = core.add_entity(pos, mob, data)
				local ent = smob and smob:get_luaentity()

				if not ent then return end -- sanity check

				if ent.type ~= "monster" then -- set owner if not a monster
					ent.owner = placer:get_player_name()
					ent.tamed = true
				end

				itemstack:take_item() -- since mob is unique, remove egg on spawn

				return itemstack
			end
		})
	end

	-- register old stackable mob egg
	core.register_craftitem(":" .. mob, {

		description = desc,
		inventory_image = invimg,
		groups = grp,

		on_place = function(itemstack, placer, pointed_thing)

			local pos = pointed_thing.above ; if not pos then return end

			-- does existing on_rightclick function exist?
			local under = get_node(pointed_thing.under)
			local def = under and registered_nodes[under.name]

			if def and def.on_rightclick then

				return def.on_rightclick(
						pointed_thing.under, under, placer, itemstack, pointed_thing)
			end

			-- can i spawn in protected areas?
			if not can_spawn_protect
			and core.is_protected(pos, placer:get_player_name()) then
				return
			end

			if at_limit() then -- have we reached active mob limit

				core.chat_send_player(placer:get_player_name(),
						S("Active Mob Limit Reached!")
						.. "  (" .. active_mobs
						.. " / " .. active_limit .. ")")
				return
			end

			pos.y = pos.y + _y

			local smob = core.add_entity(pos, mob)
			local ent = smob and smob:get_luaentity()

			if not ent then return end -- sanity check

			-- don't set owner if monster or sneak pressed
			if ent.type ~= "monster" and not placer:get_player_control().sneak then
				ent.owner = placer:get_player_name()
				ent.tamed = true
			end

			-- if not in creative then take item
			if not mobs.is_creative(placer:get_player_name()) then
				itemstack:take_item()
			end

			return itemstack
		end
	})
end

-- force capture a mob

function mobs:force_capture(self, clicker)

	-- add special mob egg with all mob information
	local new_stack = ItemStack(self.name .. "_set")

	local data_str = core.serialize(clean_staticdata(self))

	new_stack:get_meta():set_string("", data_str)

	local inv = clicker:get_inventory()

	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack) -- add to inventory if room found
	else
		core.add_item(clicker:get_pos(), new_stack) -- drop spawn egg
	end

	self:mob_sound("default_place_node_hard")

	remove_mob(self, true)
end

-- capture critter (thx blert2112 for idea)

function mobs:capture_mob(
		self, clicker, chance_hand, chance_net, chance_lasso, force_take, replacewith)

	local inv = is_player(clicker) and clicker:get_inventory()

	if not inv then return end

	local mobname = replacewith or self.name-- get name of mob
	local name = clicker:get_player_name()
	local tool = clicker:get_wielded_item()
	local item = tool:get_name() -- empty item is hand

	if item ~= "" and item ~= "mobs:net" and item ~= "mobs:lasso" then
		return
	end

	-- is mob tamed?
	if not self.tamed and not force_take then
		core.chat_send_player(name, S("Not tamed!")) ; return
	end

	-- cannot pick up if not owner, unless admin
	if not core.check_player_privs(name, "protection_bypass")
	and self.owner ~= name and not force_take then
		core.chat_send_player(name, S("@1 is owner!", self.owner)) ; return
	end

	local chance, wear

	if item == "" and chance_hand and chance_hand > 0 then

	chance = chance_hand

	elseif item == "mobs:net" and chance_net and chance_net > 0 then

		chance = chance_net ; wear = 4000 -- 17 uses

	elseif item == "mobs:lasso" and chance_lasso and chance_lasso > 0 then

		chance = chance_lasso ; wear = 650 -- 100 uses
	end

	if not chance or chance == 0 then return end

	if wear then
		tool:add_wear(wear) ; clicker:set_wielded_item(tool)
	end

	-- calculate chance, add to inventory if successful?
	if random(100) > chance then

		core.chat_send_player(name, S("Missed!"))

		self:mob_sound("mobs_swing") ; return
	end

	local new_stack = ItemStack(mobname)

	-- add special mob egg with all mob information
	-- unless 'replacewith' contains new item to use
	if not replacewith and registered_items[mobname .. "_set"] then

		new_stack = ItemStack(mobname .. "_set")

		local data_str = core.serialize(clean_staticdata(self))

		new_stack:get_meta():set_string("", data_str)
	end

	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
	else
		local pos = self.object:get_pos() or clicker:get_pos() ; pos.y = pos.y + 0.5

		core.add_item(pos, new_stack)
	end

	self:mob_sound("default_place_node_hard")

	remove_mob(self, true)

	return true
end

-- protect tamed mob with rune item

function mobs:protect(self, clicker)

	local name = clicker:get_player_name()
	local tool = clicker:get_wielded_item()
	local tool_name = tool:get_name()

	if tool_name ~= "mobs:protector" and tool_name ~= "mobs:protector2" then
		return
	end

	if not self.tamed then
		core.chat_send_player(name, S("Not tamed!")) ; return true
	end

	if (self.protected and tool_name == "mobs:protector")
	or (self.protected == 2 and tool_name == "mobs:protector2") then
		core.chat_send_player(name, S("Already protected!")) ; return true
	end

	if not mobs.is_creative(clicker:get_player_name()) then
		tool:take_item() -- take 1 protection rune
		clicker:set_wielded_item(tool)
	end

	-- set protection level
	if tool_name == "mobs:protector" then
		self.protected = true
	else
		self.protected = 2 ; self.fire_damage = 0
	end

	local pos = self.object:get_pos()

	pos.y = pos.y + self.prop.collisionbox[5]

	effect(pos, 25, "mobs_protect_particle.png", 0.5, 4, 2, 15)

	self:mob_sound("mobs_spell")

	return true
end

-- feeding, taming, breeding and naming (thx blert2112)

local mob_nametag = {}

function mobs:feed_tame(self, clicker, feed_count, breed, tame)

	local name = clicker:get_player_name()
	local item = clicker:get_wielded_item()

	-- rename tamed mob with nametag
	if item:get_name() == "mobs:nametag"
	and (name == self.owner or core.check_player_privs(name, "protection_bypass")) then

		mob_nametag[name] = self -- store mob in external table

		local tag = self._nametag or ""
		local esc = core.formspec_escape

		core.show_formspec(name, "mobs_nametag", "size[8,4]"
			.. "field[0.5,1;7.5,0;name;" .. esc(FS("Enter name:")) .. ";" .. esc(tag) .. "]"
			.. "button_exit[2.5,3.5;3,1;mob_rename;" .. esc(FS("Rename")) .. "]")

		return true
	end

	if not self.follow then return end

	-- sneak & right-click mob to show what it eats/follows
	if clicker:get_player_control().sneak then

		if type(self.follow) == "string" then
			self.follow = {self.follow}
		end

		core.chat_send_player(name, S("@1 follows:", self.name:split(":")[2])
			.. "\n- " .. table.concat(self.follow, "\n- "))

		return
	end

	-- can eat/tame with item in hand
	if self:follow_holding(clicker) then

		-- take item when not using creative
		if not mobs.is_creative(name) then

			local item = clicker:get_wielded_item()

			item:take_item()

			clicker:set_wielded_item(item)
		end

		self.health = min(self.health + 4, self.prop.hp_max) -- increase health

		self.object:set_hp(self.health)

		if self.child then -- make children grow quicker, deduct 10% of time to adulthood

			self.hornytimer = floor(self.hornytimer + (
					(CHILD_GROW_TIME - self.hornytimer) * 0.1))

			return true
		end

		-- feed and tame
		self.food = (self.food or 0) + 1
		self._breed_countdown = breed and (feed_count - self.food)
		self._tame_countdown = not self.tamed and tame and (feed_count - self.food)

		if self.food >= feed_count then

			self.food = 0
			self._breed_countdown = nil

			if breed and self.hornytimer == 0 then self.horny = true end

			if tame then

				if not self.tamed then

					core.chat_send_player(name,
							S("@1 has been tamed!", self.name:split(":")[2]))
				end

				self.tamed = true
				self.static_save = true

				if not self.owner or self.owner == "" then
					self.owner = name
				end
			end

			self:mob_sound(self.sounds.random) -- play sound when feed count hit
		end

		self:update_tag() ; return true
	end
end

-- inspired by blockmen's nametag mod

core.register_on_player_receive_fields(function(player, formname, fields)

	local name = player:get_player_name()

	if not mob_nametag[name] then return end

	if formname ~= "mobs_nametag" or not fields.name then
		mob_nametag[name] = nil ; return
	end

	-- consume only the live wielded stack
	local item = player:get_wielded_item()

	if item:get_name() ~= "mobs:nametag" then
		mob_nametag[name] = nil ; return
	end

	-- limit name entered to 64 characters
	if fields.name:len() > 64 then fields.name = fields.name:sub(1, 64) end

	mob_nametag[name]:update_tag(fields.name) -- update nametag

	if not mobs.is_creative(name) then -- take nametag if not using creative

		item:take_item()

		player:set_wielded_item(item)
	end

	mob_nametag[name] = nil
end)

-- compatibility function for mobs that have been renamed

function mobs:alias_mob(old_name, new_name)

	-- check old_name entity doesnt already exist
	if core.registered_entities[old_name] then return end

	core.register_alias(old_name, new_name) -- spawn egg

	core.register_entity(":" .. old_name, { -- entity

		initial_properties = {physical = false, static_save = false},

		on_activate = function(self, staticdata)

			if core.registered_entities[new_name] then
				core.add_entity(self.object:get_pos(), new_name, staticdata)
			end

			remove_mob(self)
		end,

		get_staticdata = function(self)
			return core.serialize(clean_staticdata(self))
		end
	})
end

-- admin command to remove untamed mobs around players

core.register_chatcommand("clear_mobs", {
	params = "",
	description = "Remove untamed mobs from around players.",
	privs = {server = true},

	func = function (name, param)

		local count = 0

		for _, player in ipairs(player_list) do

			if player then

				local pos = player:get_pos()
				local objs = core.get_objects_inside_radius(pos, 28)

				for _, obj in pairs(objs) do

					if obj then

						local ent = obj:get_luaentity()

						-- only remove mobs redo mobs that are not tamed
						if ent and ent._cmi_is_mob and ent.tamed ~= true then

							remove_mob(ent, true)

							count = count + 1
						end
					end
				end
			end
		end

		core.chat_send_player(name, S("@1 mobs removed.", count))
	end
})

-- Is mob hearing enabled, if so override core.sound_play with custom function

if settings:get_bool("mobs_can_hear") ~= false then

	local node_hear = settings:get_bool("mobs_can_hear_node")
	local old_sound_play = core.sound_play

	core.sound_play = function(spec, param, eph)

--		if type(spec) == "table" then return old_sound_play(spec, param, eph) end

		local def = {} ; param = param or {}

		-- store sound position (ignore player and object positioning as background)
		if param.pos then
			def.pos = param.pos
--		elseif param.object then
--			def.pos = param.object:get_pos()
--			def.object = param.object
--		elseif param.to_player then
--			local player = core.get_player_by_name(param.to_player)
--			def.pos = player and player:get_pos()
--			def.player = param.to_player
		end

		-- if no position found use default function
		if not def.pos then
			return old_sound_play(spec, param, eph)
		end

		-- store sound name and gain
		if type(spec) == "string" then
			def.sound = spec
			def.gain = param.gain or 1.0
		elseif type(spec) == "table" then
			def.sound = spec.name
			def.gain = spec.gain or param.gain or 1.0
		end

--print("==", def.sound)

		def.gain = def.gain or 1.0
		def.max_hear_distance = param.max_hear_distance or 32

		-- find mobs within sounds hearing range
		local objs = core.get_objects_inside_radius(def.pos, def.max_hear_distance)
		local bit = def.gain / def.max_hear_distance

		for n = 1, #objs do

			local obj = objs[n]

			if not obj:is_player() then

				local ent = obj:get_luaentity()

				if ent and ent._cmi_is_mob and ent.on_sound then

					-- calculate loudness of sound to mob
					def.distance = get_distance(def.pos, obj:get_pos())
					def.loudness = def.gain - (bit * def.distance)

					-- run custom on_sound function if heard
					if def.loudness > 0 then ent.on_sound(ent, def) end
				end
			end
		end

		-- find nodes that can hear up to 8 blocks away
		if node_hear then

			local dist = min(def.max_hear_distance, 8)
			local ps = core.find_nodes_in_area(
					vector.subtract(def.pos, dist),
					vector.add(def.pos, dist), {"group:on_sound"})

			for n = 1, #ps do

				local nod = get_node(ps[n])
				local ndef = nod and registered_nodes[nod.name]

				if ndef and ndef.on_sound then

					def.distance = get_distance(def.pos, ps[n])
					def.loudness = def.gain - (bit * def.distance)

					if def.loudness > 0 then
						ndef.on_sound(ps[n], def)
					end
				end
			end
		end

		return old_sound_play(spec, param, eph)
	end
end

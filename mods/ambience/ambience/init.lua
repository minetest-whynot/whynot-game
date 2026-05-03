
ambience = {}

-- settings

local SOUNDVOLUME = 1.0
local MUSICVOLUME = 0.6
local MUSICINTERVAL = tonumber(core.settings:get("ambience_music_interval")) or (60 * 20)
local radius = 6
local playing = {} -- user settings, timers and current set playing
local sound_sets = {} -- all the sounds and their settings
local sound_set_order = {} -- needed because pairs loops randomly through tables
local set_nodes = {} -- all the nodes needed for sets

-- translation and local

local S = core.get_translator("ambience")
local random = math.random
local get_id = core.get_node_raw
local get_id_name = core.get_name_from_content_id
local get_node = core.get_node

if get_id then get_node = function(pos)

		local id, p1, p2, pos_ok = get_id(pos.x, pos.y, pos.z)

		return {name = get_id_name(id), param1 = p1, param2 = p2, loaded = pos_ok}
	end
end

-- add set to list

function ambience.add_set(set_name, def)

	if not set_name or not def then return end

	sound_sets[set_name] = {
		frequency = def.frequency or 50,
		background = def.background or {},
		music = def.music or {},
		sounds = def.sounds or {},
		sound_check = def.sound_check,
		nodes = def.nodes
	}

	-- add set name to the sound_set_order table
	local can_add = true

	for i = 1, #sound_set_order do

		if sound_set_order[i] == set_name then can_add = false end
	end

	if can_add then table.insert(sound_set_order, set_name) end

	-- add any missing nodes to the set_nodes table
	if def.nodes then

		for i = 1, #def.nodes do

			can_add = def.nodes[i]

			for j = 1, #set_nodes do

				if def.nodes[i] == set_nodes[j] then can_add = false end
			end

			if can_add then table.insert(set_nodes, can_add) end
		end
	end
end

-- add sound to existing set

function ambience.add_to_set(set_name, def)

	if not set_name or not def or not sound_sets[set_name] then return end

	table.insert(sound_sets[set_name].sounds, def)
end

-- return set from list using name

function ambience.get_set(set_name)
	return sound_sets[set_name]
end

-- remove set from list

function ambience.del_set(set_name)

	sound_sets[set_name] = nil

	local can_del = false

	for i = 1, #sound_set_order do

		if sound_set_order[i] == set_name then can_del = i end
	end

	if can_del then table.remove(sound_set_order, can_del) end
end

-- return node total belonging to a specific group:

function ambience.group_total(nodelist, nodegroup)

	local total, def = 0

	for node, num in pairs(nodelist) do

		def = core.registered_nodes[node]

		if def and def.groups[nodegroup] then
			total = total + num
		end
	end

	return total
end

-- setup table when player joins

core.register_on_joinplayer(function(player)

	if player then

		local name = player:get_player_name()
		local meta = player:get_meta()

		playing[name] = {
			mvol = tonumber(meta:get_string("ambience.mvol")) or MUSICVOLUME,
			svol = tonumber(meta:get_string("ambience.svol")) or SOUNDVOLUME,
			timer = 0, music = 0, music_handler = nil, set = "nil"
		}
	end
end)

-- remove table when player leaves

core.register_on_leaveplayer(function(player)
	if player then playing[player:get_player_name()] = nil end
end)

-- plays music and selects sound set

local function get_ambience(player, tod, pname)

	local p = playing[pname]

	-- if enabled, play local/server music on interval check
	if MUSICINTERVAL > 0 and p and p.mvol > 0 then

		-- increase music time interval
		p.music = p.music + 1

		-- if not already playing, play music on interval check
		if p.music > MUSICINTERVAL and not p.music_handler then

			local song = "ambience_music" -- default

			-- if set contains a music list then select a song at random
			if p.music_list and #p.music_list > 0 then

				local select = p.music_list[random(#p.music_list)]

				-- if song chance met, replace default music
				if random((select.chance or 1)) == 1 then
					song = select.name
				end
			end

			p.music_handler = core.sound_play(song, {to_player = pname, gain = p.mvol})
			p.music = 0 -- reset interval

		-- after 5 minutes (a normal song length) reset music timers
		elseif p.music_handler and p.music > 300 then

			p.music = 0 ; p.music_handler = nil
--print("--- resetting music timers")
		end
--print("-- music timer", p.music .. "/" .. MUSICINTERVAL)
	end

	-- get foot and head level nodes at player position
	local pos = player:get_pos() ; if not pos then return end
	local eyeh = player:get_properties().eye_height or 1.47 -- eye level with fallback
	local nod_head = get_node({x = pos.x, y = pos.y + eyeh, z = pos.z}).name
	local nod_feet = get_node({x = pos.x, y = pos.y + 0.2, z = pos.z}).name

	-- get all set nodes around player
	local ps, cn = core.find_nodes_in_area(
			{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
			{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, set_nodes)

	-- get biome data
	local bdata = core.get_biome_data(pos)
	local biome = bdata and core.get_biome_name(bdata.biome) or ""

	-- loop through sets in order and choose first that meets conditions set
	for n = 1, #sound_set_order do

		local set = sound_sets[ sound_set_order[n] ]

		if set and set.sound_check then

			-- pass settings to set function for condition check
			local set_name, gain = set.sound_check({
				player = player,
				pos = pos,
				tod = tod,
				totals = cn,
				positions = ps,
				head_node = nod_head,
				feet_node = nod_feet,
				biome = biome
			})

			-- if conditions met return set name and gain value
			if set_name then return set_name, gain end
		end
	end
end

-- players routine

local timer = 0

core.register_globalstep(function(dtime)

	local players = core.get_connected_players()
	local pname

	-- reduce sound timer for each player and stop/reset when needed
	for _, player in pairs(players) do

		pname = player:get_player_name()

		local p = playing[pname]

		if p and p.timer and p.timer > 0 then

			p.timer = p.timer - dtime

			if p.timer <= 0 then

				if p.handler then
					core.sound_stop(p.handler)
				end

				p.set = nil ; p.gain = nil ; p.handler = nil
			end
		end
	end

	-- one second timer
	timer = timer + dtime ; if timer < 1 then return end ; timer = 0

	local tod = core.get_timeofday()

	-- loop through players
	for _, player in pairs(players) do

		pname = player:get_player_name()

		local p = playing[pname]
		local set_name, MORE_GAIN = get_ambience(player, tod, pname)
		local set_def = sound_sets[set_name]
		local ok = p and true -- everything starts off ok if player found

		-- store any set music found for later use
		p.music_list = set_def and set_def.music

		-- are we playing any available background sounds?
		if ok and not p.bg and set_def and #set_def.background > 0 then

			-- choose a random sound from the background set
			local bg_amb = set_def.background[random(#set_def.background)]

			-- only play sound if set differs from last one played
			if set_name ~= p.bg_set then

				p.bg = core.sound_play(bg_amb.name, {
					to_player = pname,
					gain = (bg_amb.gain or 0.3) * p.svol,
					pitch = bg_amb.pitch, fade = bg_amb.fade, loop = true
				})

--print("-- bg start", p.bg, set_name)

				p.bg_set = set_name
			end

		elseif ok and p.bg and set_name ~= p.bg_set then

--print("-- bg stop", p.bg, set_name, p.bg_set)

			core.sound_stop(p.bg)

			p.bg = nil ; p.bg_set = nil
		end

		if ok and p.handler then -- are we playing something already?

			-- stop current sound if another set active or gain changed
			if p.set ~= set_name or p.gain ~= MORE_GAIN then

--print ("-- change stop", set_name, p.handler)

				core.sound_stop(p.handler)

				p.set = nil ; p.gain = nil ; p.handler = nil ; p.timer = 0
			else
				ok = false -- sound set still playing, skip new sound
			end
		end

		local chance = random(1000)

		-- if chance is lower than frequency then use set
		if ok and set_name and chance < set_def.frequency
		and set_def.sounds and #set_def.sounds > 0 then

			local amb = set_def.sounds[random(#set_def.sounds)] -- choose random sound

			-- selected sound chance of playing from a set
			if random((amb.chance or 1)) == 1 then

				-- play sound
				p.handler = core.sound_play(amb.name, {
					to_player = pname,
					gain = ((amb.gain or 0.3) + (MORE_GAIN or 0)) * p.svol,
					pitch = amb.pitch or 1.0, fade = amb.fade
				}, amb.ephemeral)

--print ("playing... " .. amb.name .. " (" .. chance .. " < "
--		.. p.frequency .. ") @ ", MORE_GAIN, p.handler)
			end

			-- save what player is currently listening to if handler found
			if p.handler then
				p.set = set_name ; p.gain = MORE_GAIN ; p.timer = (amb.length or 5)
			end
		end
	end
end)

-- sound volume command

core.register_chatcommand("svol", {
	params = S("<svol>"),
	description = S("set sound volume (0.1 to 1.0)"),
	privs = {},

	func = function(name, param)

		local svol = tonumber(param) or playing[name].svol

		if svol < 0.1 then svol = 0.1 end
		if svol > 1.0 then svol = 1.0 end

		local player = core.get_player_by_name(name)
		local meta = player:get_meta()

		meta:set_string("ambience.svol", svol)

		playing[name].svol = svol

		return true, S("Sound volume set to @1", svol)
	end
})

-- music volume command (0 stops music)

core.register_chatcommand("mvol", {
	params = S("<mvol>"),
	description = S("set music volume (0.1 to 1.0, 0 to stop music)"),
	privs = {},

	func = function(name, param)

		local mvol = tonumber(param) or playing[name].mvol
		local p = playing[name]

		-- stop music currently playing by setting volume to 0
		if mvol == 0 and p.music_handler then

			core.sound_stop(p.music_handler)

			p.music_handler = nil

			core.chat_send_player(name, S("Music stopped!"))
		end

		if mvol < 0 then mvol = 0 end
		if mvol > 1.0 then mvol = 1.0 end

		local player = core.get_player_by_name(name)
		local meta = player:get_meta()

		meta:set_string("ambience.mvol", mvol)

		p.mvol = mvol

		return true, S("Music volume set to @1", mvol)
	end
})

-- load default sound sets

dofile(core.get_modpath("ambience") .. "/soundsets.lua")


print("[MOD] Ambience Lite loaded")

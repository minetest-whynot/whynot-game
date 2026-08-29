
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

	local can_add = not sound_sets[set_name]

	sound_sets[set_name] = {
		frequency = def.frequency or 50,
		background = def.background or {},
		music = def.music or {},
		sounds = def.sounds or {},
		sound_check = def.sound_check,
		nodes = def.nodes
	}

	-- add set name to the sound_set_order table
	if can_add then table.insert(sound_set_order, set_name) end

	-- add any missing nodes to the set_nodes table
	if def.nodes then

		for i = 1, #def.nodes do

			can_add = true

			for j = 1, #set_nodes do

				if def.nodes[i] == set_nodes[j] then can_add = false end
			end

			if can_add then table.insert(set_nodes, def.nodes[i]) end
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

	if not sound_sets[set_name] then return end

	sound_sets[set_name] = nil

	for i = 1, #sound_set_order do

		if sound_set_order[i] == set_name then
			table.remove(sound_set_order, i) ; break
		end
	end
end

-- return node total belonging to a specific group:

local registered_nodes = core.registered_nodes

function ambience.group_total(nodelist, nodegroup)

	if not nodegroup then return 0 end

	local total = 0

	for node, num in pairs(nodelist) do

		local def = registered_nodes[node]

		if def and def.groups[nodegroup] then
			total = total + num
		end
	end

	return total
end

-- setup table when player joins

core.register_on_joinplayer(function(player)

	local name = player:get_player_name()
	local meta = player:get_meta()

	playing[name] = {
		mvol = tonumber(meta:get_string("ambience.mvol")) or MUSICVOLUME,
		svol = tonumber(meta:get_string("ambience.svol")) or SOUNDVOLUME,
		timer = 0, music = 0, music_handler = nil, set = "nil"
	}
end)

-- remove table when player leaves

core.register_on_leaveplayer(function(player)
	playing[player:get_player_name()] = nil
end)

-- handle background music timer and selection

local function background_music(p, pname)

	-- if enabled, play local/server music on interval check
	if MUSICINTERVAL <= 0 and p.mvol <= 0 then return end

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

-- select sound set

local data = {} -- save recreating table for each time

local function get_ambience(player, tod, pname)

	local p = playing[pname] ; if not p then return end

	background_music(p, pname)

	-- get foot and head level nodes at player position
	local pos = player:get_pos() ; if not pos then return end

	-- save having to get eye level from player properties table each time
	if not p.eyeh then
		p.eyeh = player:get_properties().eye_height or 1.47
	end

	-- get all set nodes around player
	data.positions, data.totals = core.find_nodes_in_area(
			{x = pos.x - radius, y = pos.y - radius, z = pos.z - radius},
			{x = pos.x + radius, y = pos.y + radius, z = pos.z + radius}, set_nodes)

	-- get biome data
	local bdata = core.get_biome_data(pos)

	-- fill check table
	data.player = player
	data.pos = pos
	data.tod = tod
	data.head_node = get_node({x = pos.x, y = pos.y + p.eyeh, z = pos.z}).name
	data.feet_node = get_node({x = pos.x, y = pos.y + 0.2, z = pos.z}).name
	data.biome = bdata and core.get_biome_name(bdata.biome) or ""

	-- loop through sets in order and choose first that has its conditions met
	for n = 1, #sound_set_order do

		local set = sound_sets[ sound_set_order[n] ]

		if set and set.sound_check then

			-- pass data to set function for condition check
			local set_name, gain = set.sound_check(data)

			-- if conditions met return set name and gain value
			if set_name then return set_name, gain end
		end
	end
end

-- players routine

local timer = 0

local function clear_sound(p)

	core.sound_stop(p.handler)

	p.set = nil ; p.gain = nil ; p.handler = nil ; p.timer = 0
end

core.register_globalstep(function(dtime)

	local players = core.get_connected_players()
	local timer1sec, tod

	timer = timer + dtime

	-- every 1 second run the 1 second code within player loop
	if timer >= 1 then
		timer = 0
		timer1sec = true
		tod = core.get_timeofday()
	end

	-- reduce sound timer for each player and stop/reset when needed
	for num = 1, #players do

		local player = players[num]
		local pname = player:get_player_name()
		local p = playing[pname]

		if p and p.timer and p.timer > 0 then

			p.timer = p.timer - dtime

			if p.timer <= 0 and p.handler then
				clear_sound(p)
			end
		end

		-- one second timer actions
		if timer1sec and p then

			local set_name, MORE_GAIN = get_ambience(player, tod, pname)
			local set_def = sound_sets[set_name]

			-- store any set music found for later use
			p.music_list = set_def and set_def.music

			-- are we playing any available background sounds?
			if not p.bg and set_def and #set_def.background > 0 then

				-- only play if set differs from last one played
				if set_name ~= p.bg_set then

					-- choose a random sound from the background set
					local bg_amb = set_def.background[random(#set_def.background)]

					p.bg = core.sound_play(bg_amb.name, {
						to_player = pname,
						gain = (bg_amb.gain or 0.3) * p.svol,
						pitch = bg_amb.pitch, fade = bg_amb.fade, loop = true
					})

--print("-- bg start", p.bg, set_name)

					p.bg_set = set_name
				end

			elseif p.bg and set_name ~= p.bg_set then

--print("-- bg stop", p.bg, set_name, p.bg_set)

				core.sound_stop(p.bg)

				p.bg = nil ; p.bg_set = nil
			end

			local can_play = true

			if p.handler then -- are we playing something already?

				-- stop current sound if another set active or gain changed
				if p.set ~= set_name or p.gain ~= MORE_GAIN then
					clear_sound(p)
--print ("-- change stop", set_name, p.handler)
				else
					can_play = false -- sound set still playing, skip new sound
				end
			end

			if can_play and set_name then

				local chance = random(1000)

				-- if chance is lower than frequency then use set
				if chance < set_def.frequency
				and set_def.sounds and #set_def.sounds > 0 then

					-- choose random sound
					local amb = set_def.sounds[random(#set_def.sounds)]

					-- selected sound chance of playing from a set
					if random(amb.chance or 1) == 1 then

						-- play sound
						p.handler = core.sound_play(amb.name, {
							to_player = pname,
							gain = ((amb.gain or 0.3) + (MORE_GAIN or 0)) * p.svol,
							pitch = amb.pitch or 1.0, fade = amb.fade
						}, amb.ephemeral)

						-- save what player is currently listening to if handler found
						if p.handler then
							p.set = set_name ; p.gain = MORE_GAIN
							p.timer = (amb.length or 5)
						end
--print ("playing... " .. amb.name .. " (" .. chance .. "/1000" ..  ")", MORE_GAIN, p.handler)
					end
				end
			end
		end -- END timer1sec
	end -- END for loop
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

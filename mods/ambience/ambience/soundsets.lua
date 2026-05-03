--[[
	Default Sound Sets
	------------------

	Order is very important when adding a sound set so it will play
	certain sound sets before any another.
--]]

-- mod support

local mod_def = core.get_modpath("default")
local mod_mcl = core.get_modpath("mcl_core")

-- Big Splash jumping in water

if core.settings:get_bool("ambience_water_splash") == true then

	local players = {}

	core.register_on_joinplayer(function(player)
		players[player:get_player_name()] = {in_water = nil, old_pos = -31000}
	end)

	core.register_on_leaveplayer(function(player)
		players[player:get_player_name()] = nil
	end)

	ambience.add_set("big_splash", {

		frequency = 1000,

		sounds = {
			{name = "big_splash", gain = 0.3, length = 4, ephemeral = true},
			{name = "big_splash", gain = 0.3, length = 4, ephemeral = true, pitch = 0.9},
			{name = "big_splash", gain = 0.3, length = 4, ephemeral = true, pitch = 1.1}
		},

		sound_check = function(def)

			local hdef = core.registered_nodes[def.head_node]
			local fdef = core.registered_nodes[def.feet_node]
			local name = def.player:get_player_name()

			if hdef and hdef.groups.water and fdef and fdef.groups.water then

				local diff = players[name].old_pos - def.pos.y

				if not players[name].in_water and diff > 1 then

					players[name].in_water = 2

					return "big_splash"
				end

				players[name].in_water = 2
			else
				if fdef and fdef.groups.water then
					players[name].in_water = 1
				else
					players[name].in_water = nil
				end
			end

			players[name].old_pos = def.pos.y
		end
	})
end

-- Underwater sounds play when player head is submerged

ambience.add_set("underwater", {

	frequency = 1000,

-- This is an example of how it could be used as a background sound also
--	background = {
--		{name = "scuba", length = 8},
--		{name = "scuba", pitch = 1.2, length = 8}
--	},

	sounds = {
		{name = "scuba", length = 8, loop = true}
	},

	sound_check = function(def)

		local nodef = core.registered_nodes[def.head_node]

		if nodef and nodef.groups.water then
			return "underwater"
		end
	end
})

-- add new sound to above set

ambience.add_to_set("underwater", {name = "scuba", pitch = 1.2, length = 8, loop = true})

-- Splashing sound plays when player walks inside water nodes (if enabled)

if core.settings:get_bool("ambience_water_move") ~= false then

	-- override default water sounds

	if mod_def then
		core.override_item("default:water_source", { sounds = {} })
		core.override_item("default:water_flowing", { sounds = {} })
		core.override_item("default:river_water_source", { sounds = {} })
		core.override_item("default:river_water_flowing", { sounds = {} })
	elseif mod_mcl then
		core.override_item("mcl_core:water_source", { sounds = {} })
		core.override_item("mcl_core:water_flowing", { sounds = {} })
		core.override_item("mclx_core:river_water_source", { sounds = {} })
		core.override_item("mclx_core:river_water_flowing", { sounds = {} })
	end

	ambience.add_set("splash", {

		frequency = 1000,

		sounds = {
			{name = "default_water_footstep", length = 2}
		},

		sound_check = function(def)

			local nodef = core.registered_nodes[def.feet_node]

			if nodef and nodef.groups.water then

				local control = def.player:get_player_control()

				if control.up or control.down or control.left or control.right then
					return "splash"
				end
			end
		end
	})
end

-- check for env_sounds mod, if not found enable water flowing and lava sounds
if not core.get_modpath("env_sounds") then

	-- Water sound plays when near flowing water

	ambience.add_set("flowing_water", {

		frequency = 1000,

		sounds = {
			{name = "waterfall", length = 6}
		},

		nodes = {"group:water"},

		sound_check = function(def)

			local c = (def.totals["default:water_flowing"] or 0)
				+ (def.totals["mcl_core:water_flowing"] or 0)

			if c > 40 then return "flowing_water", 0.5

			elseif c > 5 then return "flowing_water" end
		end
	})

	-- River sound plays when near flowing river

	ambience.add_set("river", {

		frequency = 1000,

		sounds = {
			{name = "river", length = 4, gain = 0.1}
		},

		sound_check = function(def)

			local c = (def.totals["default:river_water_flowing"] or 0)
				+ (def.totals["mclx_core:river_water_flowing"] or 0)

			if c > 20 then return "river", 0.5

			elseif c > 5 then return "river" end
		end
	})

	-- Lava sound plays when near lava

	ambience.add_set("lava", {

		frequency = 1000,

		sounds = {
			{name = "lava", length = 7}
		},

		nodes = {"group:lava"},

		sound_check = function(def)

			local c = (def.totals["default:lava_source"] or 0)
				+ (def.totals["default:lava_flowing"] or 0)
				+ (def.totals["mcl_core:lava_source"] or 0)
				+ (def.totals["mcl_core:lava_flowing"] or 0)

			if c > 20 then return "lava", 0.5

			elseif c > 5 then return "lava" end
		end
	})
else
	print ("[MOD] Ambience - Using env_sounds for water and lava sounds.")
end

-- Beach sounds play when pos above 0 and below 6 and 100+ water source found

local water_level = tonumber(core.settings:get("water_level"))

ambience.add_set("beach", {

	background = {
		{name = "beach", length = 13, fade = 0.2}, -- length isnt needed, just info here
	},

	frequency = 40,

	sounds = {
		{name = "seagull", length = 4.5, ephemeral = true},
		{name = "seagull", length = 4.5, pitch = 1.2, ephemeral = true},
		--{name = "beach", length = 13},
		{name = "gull", length = 1, ephemeral = true},
		{name = "seagull_2", length = 4, ephemeral = true}
	},

	nodes = {"group:water"},

	sound_check = function(def)

		local c = (def.totals["default:water_source"] or 0)
			+ (def.totals["mcl_core:water_source"] or 0)

		if def.pos.y > water_level - 1 and def.pos.y < water_level + 5 and c > 100 then
			return "beach"
		end
	end
})

-- Ice sounds play when 100 or more ice are nearby

ambience.add_set("ice", {

	frequency = 80,

	sounds = {
		{name = "icecrack", length = 5, gain = 1.1},
		{name = "desertwind", length = 8},
		{name = "wind", length = 9}
	},

	nodes = (mod_mcl and {"mcl_core:ice", "mcl_core:packed_ice"} or {"default:ice"}),

	sound_check = function(def)

		local c = (def.totals["default:ice"] or 0)
			+(def.totals["mcl_core:ice"] or 0)
			+ (def.totals["mcl_core:packed_ice"] or 0)

		if c > 400 then return "ice" end
	end
})

-- Desert sounds play when near 150+ desert or normal sand

ambience.add_set("desert", {

	frequency = 20,

	sounds = {
		{name = "coyote", length = 2.5, ephemeral = true},
		{name = "wind", length = 9},
		{name = "desertwind", length = 8}
	},

	nodes = {
		(mod_mcl and "mcl_core:redsand" or "default:desert_sand"),
		(mod_mcl and "mcl_core:sand" or "default:sand")
	},

	sound_check = function(def)

		local c = (def.totals["default:desert_sand"] or 0)
			+ (def.totals["default:sand"] or 0)
			+ (def.totals["mcl_core:sand"] or 0)
			+ (def.totals["mcl_core:redsand"] or 0)

		if c > 150 and def.pos.y > 10 then return "desert" end
	end
})

-- Cave sounds play when below player position Y -25 and water nearby

ambience.add_set("cave", {

	frequency = 60,

	sounds = {
		{name = "drippingwater1", length = 1.5, ephemeral = true},
		{name = "drippingwater2", length = 1.5, ephemeral = true},
		{name = "drippingwater2", length = 1.5, pitch = 1.2, ephemeral = true},
		{name = "drippingwater2", length = 1.5, pitch = 1.4, ephemeral = true},
		{name = "bats", length = 5, ephemeral = true}
	},

	sound_check = function(def)

		local c = (def.totals["default:water_source"] or 0)
			+ (def.totals["mcl_core:water_source"] or 0)

		if c > 0 and def.pos.y < -25 then return "cave" end
	end
})

-- Jungle sounds play during day and when around 90 jungletree trunks

ambience.add_set("jungle", {

	frequency = 200,

	sounds = {
		{name = "jungle_day_1", length = 7},
		{name = "deer", length = 7, ephemeral = true},
		{name = "canadianloon2", length = 14},
		{name = "bird1", length = 11},
		{name = "peacock", length = 2, ephemeral = true},
		{name = "peacock", length = 2, pitch = 1.2, ephemeral = true},
		{name = "wooden_frog", length = 2, gain = 0.2, ephemeral = true}
	},

	nodes = {(mod_mcl and "mcl_trees:tree_jungle" or "default:jungletree")},

	sound_check = function(def)

		local c = (def.totals["default:jungletree"] or 0)
			+ (def.totals["mcl_trees:tree_jungle"] or 0)

		if def.pos.y > 0 and def.tod > 0.2 and def.tod < 0.8 and c > 79 then
			return "jungle"
		end
	end
})

-- Jungle sounds play during night and when around 90 jungletree trunks

ambience.add_set("jungle_night", {

	frequency = 200,

	sounds = {
		{name = "jungle_night_1", length = 4, ephemeral = true},
		{name = "jungle_night_2", length = 4, ephemeral = true},
		{name = "deer", length = 7, ephemeral = true},
		{name = "frog", length = 1, ephemeral = true},
		{name = "frog", length = 1, pitch = 1.3, ephemeral = true},
		{name = "wooden_frog", length = 2, gain = 0.2, ephemeral = true}
	},

	sound_check = function(def)

		-- jungle tree was added in last set, so doesnt need to be added in this one
		local c = (def.totals["default:jungletree"] or 0)
			+ (def.totals["mcl_trees:tree_jungle"] or 0)

		if def.pos.y > 0 and (def.tod < 0.2 or def.tod > 0.8) and c > 79 then
			return "jungle_night"
		end
	end
})

-- Daytime sounds play during day when around leaves and above ground

ambience.add_set("day", {

	frequency = 40,

	sounds = {
		{name = "cardinal", length = 3, ephemeral = true},
		{name = "craw", length = 3, ephemeral = true},
		{name = "bluejay", length = 6, ephemeral = true},
		{name = "robin", length = 4, ephemeral = true},
		{name = "robin", length = 4, pitch = 1.2, ephemeral = true},
		{name = "bird1", length = 11},
		{name = "bird2", length = 6, ephemeral = true},
		{name = "crestedlark", length = 6, ephemeral = true},
		{name = "crestedlark", length = 6, pitch = 1.1, ephemeral = true},
		{name = "peacock", length = 2, ephemeral = true},
		{name = "peacock", length = 2, pitch = 1.2, ephemeral = true},
		{name = "wind", length = 9}
	},

	nodes = {"group:leaves"},

	sound_check = function(def)

		-- use handy function to count all nodes in group:leaves
		local c = ambience.group_total(def.totals, "leaves")

		if (def.tod > 0.2 and def.tod < 0.8) and def.pos.y > 0 and c > 50 then
			return "day"
		end
	end
})

-- Nighttime sounds play at night when above ground near leaves

ambience.add_set("night", {

	frequency = 40,

	sounds = {
		{name = "hornedowl", length = 2, ephemeral = true},
		{name = "hornedowl", length = 2, pitch = 1.1, ephemeral = true},
		{name = "wolves", length = 4, gain = 0.4, ephemeral = true},
		{name = "cricket", length = 6, ephemeral = true},
		{name = "deer", length = 7, ephemeral = true},
		{name = "frog", length = 1, ephemeral = true},
		{name = "frog", length = 1, pitch = 1.2, ephemeral = true},
		{name = "wind", length = 9}
	},

	sound_check = function(def)

		-- use handy function to count all nodes in group:leaves
		local c = ambience.group_total(def.totals, "leaves")

		if (def.tod < 0.2 or def.tod > 0.8) and def.pos.y > 0 and c > 50 then
			return "night"
		end
	end
})

-- Winds play when player is above 50 y-pos or near 150+ snow blocks

ambience.add_set("high_up", {

	frequency = 40,

	sounds = {
		{name = "desertwind", length = 8},
		{name = "desertwind", length = 8, pitch = 1.3},
		{name = "wind", length = 9},
		{name = "wind", length = 9, pitch = 1.4}
	},

	nodes = {(mod_mcl and "mcl_core:snowblock" or "default:snowblock")},

	sound_check = function(def)

		local c = (def.totals["default:snowblock"] or 0)
			+ (def.totals["mcl_core:snowblock"] or 0)

		if def.pos.y > 50 or c > 100 then return "high_up" end
	end
})

-- caverealms sounds

if core.get_modpath("caverealms") then

	-- salt crystal biome

	ambience.add_set("caverealms_crystal", {

		frequency = 50,

		sounds = {
			{name = "caverealms_crystal", length = 3, ephemeral = true},
			{name = "caverealms_crystal", length = 3, pitch = 0.9, ephemeral = true},
			{name = "caverealms_crystal", length = 3, pitch = 1.2, ephemeral = true},
		},

		nodes = ({"caverealms:stone_with_salt"}),

		sound_check = function(def)

			local c = (def.totals["caverealms:stone_with_salt"] or 0)

			if c > 250 then return "caverealms_crystal" end
		end
	})

	-- moss, algae, lichen area rumble

	ambience.add_set("caverealms_rumble", {

		frequency = 50,

		sounds = {
			{name = "caverealms_deep_whoosh", length = 3, ephemeral = true},
			{name = "caverealms_deep_whoosh", length = 3, pitch = 0.6, ephemeral = true},
			{name = "caverealms_deep_whoosh", length = 3, pitch = 0.8, ephemeral = true},
		},

		nodes = ({"caverealms:stone_with_moss", "caverealms:stone_with_algae",
				"caverealms:stone_with_lichen"}),

		sound_check = function(def)

			local c = (def.totals["caverealms:stone_with_moss"] or 0) +
					(def.totals["caverealms:stone_with_algae"] or 0) +
					(def.totals["caverealms:stone_with_lichen"] or 0)

			if def.pos.y < -50 and c > 150 then return "caverealms_rumble" end
		end
	})
end

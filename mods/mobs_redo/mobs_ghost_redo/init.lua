
-- Translation and settings

local S = core.get_translator("mobs_ghost_redo")
local daytime_check = core.settings:get_bool("mobs_ghost_redo_daytime_check")
local bones_only = core.settings:get_bool("mobs_ghost_redo_bones_only")
local difficulty = core.settings:get_bool("mobs_ghost_redo_difficulty")

-- Mineclone check

local mod_mcl = core.get_modpath("mcl_core")

-- Spawn settings (default, bones only, mineclone)

local spawn_chance = 7500
local ghosts_active = 2
local spawn_nodes = {"group:cracky", "group:crumbly"}

if mod_mcl then
	spawn_nodes = {"group:pickaxey", "group:shovely"}
end

if bones_only then
	spawn_nodes = {"bones:bones", "mobs_humans:human_bones"}
	spawn_chance = 7
	ghosts_active = 1
end

-- Functions

local function is_daytime()
	local time = core.get_timeofday() ; return time > 0.19 and time < 0.8
end

-- Drops

local mob_drops = {{
	name = (mod_mcl and "mcl_raw_ores:raw_gold" or "default:gold_lump"),
	chance = 100, min = 1, max = 5
}}

-- Entity definition

mobs:register_mob("mobs_ghost_redo:ghost", {
	description = S("Ghost"),
	type = "monster",
	attack_type = "dogfight",
	group_attack = true,
	attack_animals = true,
	reach = 4,
	damage = 4,
	water_damage = 0,
	lava_damage = 0,
	fire_damage = 0,
	light_damage = 2,
	suffocation = false,
	blood_amount = 0,
	hp_min = 10,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 1.5, 0.3},
	visual = "mesh",
	mesh = "mobs_ghost_redo_ghost_1.b3d",
	visual_size = {x = 1, y = 1},
	textures = {
		{"mobs_ghost_redo_ghost.png"},
		{"mobs_ghost_redo_ghost2.png"}
	},
	glow = 5,
	walk_velocity = 1,
	run_velocity = 4,
	walk_chance = 25,
	fly = true,
	view_range = 15,
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_ghost_redo_ghost_1",
		war_cry = "mobs_ghost_redo_ghost_2",
		attack = "mobs_ghost_redo_ghost_2",
		damage = "mobs_ghost_redo_ghost_hit",
		death = "mobs_ghost_redo_ghost_death"
	},
	drops = mob_drops,
	animation = {
		stand_start = 0, stand_end = 80, stand_speed = 15,
		walk_start = 102, walk_end = 122, walk_speed = 12,
		run_start = 102, run_end = 122, run_speed = 10,
		fly_start = 102, fly_end = 122, fly_speed = 12,
		punch_start = 102, punch_end = 122, punch_speed = 25,
		die_start = 81, die_end = 101, die_speed = 28, die_loop = false
	},

	on_spawn = function(self, pos)

		if difficulty then

			self.immune_to = {
				{(mod_mcl and "mcl_tools:sword_iron" or "default:sword_steel"), 6},
				{"default:sword_bronze", 6},
				{(mod_mcl and "mcl_tools:sword_gold" or "default:sword_mese"), 7},
				{"mobs_others:sword_obsidian", 7},
				{(mod_mcl and "mcl_tools:sword_diamond" or "default:sword_diamond"), 8},
				{"moreores:sword_silver", 12},
				{"moreores:sword_mithril", 9},
				{"pigiron:sword_iron", 6},
				{"all"}
			}
		end

		self.mesh = "mobs_ghost_redo_ghost_" .. math.random(2) .. ".b3d"
		self.light_damage = daytime_check and 0 or 2

		self.object:set_properties({
			immune_to = self.immune_to,
			mesh = self.mesh,
			physical = false,
			collide_with_objects = false
		})

		return true
	end,

	do_custom = function(self, dtime)

		-- 5 second counter
		self.counter = (self.counter or 0) + dtime
		if self.counter < 5 then return end
		self.counter = 0

		-- when setting enabled and daytime remove ghost
		if daytime_check and is_daytime() then
			self.object:remove() ; return false
		end
	end
})

-- Ghost spawn - Check for custom spawn.lua

local MP = core.get_modpath(core.get_current_modname()) .. "/"
local input = io.open(MP .. "spawn.lua", "r")

if input then
	input:close() ; input = nil ; dofile(MP .. "spawn.lua")
else
	mobs:spawn({name = "mobs_ghost_redo:ghost",
		nodes = spawn_nodes,
		neighbors = {"air"},
		max_light = 4,
		interval = 60,
		chance = spawn_chance,
		active_object_count = ghosts_active,
		day_toggle = false
	})
end

-- Spawn egg

mobs:register_egg("mobs_ghost_redo:ghost", S("Ghost"), "mobs_ghost_redo_egg_ghost.png", 0)

-- Alias

mobs:alias_mob("mobs:ghost", "mobs_ghost_redo:ghost")

-- Lucky Blocks

if core.get_modpath("lucky_block") then
	lucky_block:add_blocks({ {"spw", "mobs_ghost_redo:ghost", 3} })
end

print("[MOD] Mobs Ghost Redo loaded.")

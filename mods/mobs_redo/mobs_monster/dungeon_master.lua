
local S = core.get_translator("mobs_monster")

-- custom dungeon master types

local master_types = {

	{	nodes = {"nether:rack"},
		skins = {"mobs_dungeon_master_nether.png"},
	},
	{	nodes = {"nether:rack_deep"},
		skins = {"mobs_dungeon_master_netherdeep.png"},
	}
}

-- Dungeon Master by PilzAdam

mobs:register_mob("mobs_monster:dungeon_master", {
	type = "monster",
	passive = false,
	damage = 6,
	attack_type = "dogshoot",
	dogshoot_switch = 1,
	dogshoot_count_max = 12, -- shoot for 10 seconds
	dogshoot_count2_max = 3, -- dogfight for 3 seconds
	reach = 3,
	shoot_interval = 2.2,
	arrow = "mobs_monster:fireball",
	friendly_fire = false,
	shoot_offset = 1,
	hp_min = 42,
	hp_max = 75,
	armor = 60,
	collisionbox = {-0.7, -1, -0.7, 0.7, 1.6, 0.7},
	visual = "mesh",
	mesh = "mobs_dungeon_master.b3d",
	textures = {
		{"mobs_dungeon_master.png"},
		{"mobs_dungeon_master2.png"},
		{"mobs_dungeon_master3.png"}
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_dungeonmaster",
		shoot_attack = "mobs_fireball"
	},
	walk_velocity = 1,
	run_velocity = 3,
	jump = true,
	view_range = 15,
	drops = {
		{name = "default:mese_crystal_fragment", chance = 1, min = 0, max = 2},
		{name = "mobs:leather", chance = 2, min = 0, max = 2},
		{name = "default:mese_crystal", chance = 3, min = 0, max = 2},
		{name = "default:diamond", chance = 4, min = 0, max = 1},
		{name = "default:diamondblock", chance = 30, min = 0, max = 1}
	},
	water_damage = 1,
	lava_damage = 1,
	light_damage = 0,
	fear_height = 3,
	animation = {
		stand_start = 0, stand_end = 19,
		walk_start = 20, walk_end = 35,
		punch_start = 36, punch_end = 48,
		shoot_start = 36, shoot_end = 48,
		speed_normal = 15, speed_run = 15
	},

	-- check surrounding nodes and spawn a specific monster
	on_spawn = function(self)

		local pos = self.object:get_pos() ; pos.y = pos.y - 1
		local tmp

		for n = 1, #master_types do

			tmp = master_types[n]

			if core.find_node_near(pos, 1, tmp.nodes) then

				self.base_texture = tmp.skins
				self.object:set_properties({textures = tmp.skins})

				if tmp.drops then self.drops = tmp.drops end

				return true
			end
		end

		return true -- run only once, false/nil runs every activation
	end
})

-- where to spawn

if not mobs.custom_spawn_monster then

	mobs:spawn({
		name = "mobs_monster:dungeon_master",
		nodes = {"default:stone", "nether:rack", "nether:rack_deep"},
		max_light = 5,
		chance = 9000,
		active_object_count = 1,
		max_height = -70
	})
end

-- spawn egg

mobs:register_egg("mobs_monster:dungeon_master", S("Dungeon Master"),
		"fire_basic_flame.png", 1, true)

-- old mobs mod compatibility

mobs:alias_mob("mobs:dungeon_master", "mobs_monster:dungeon_master")

-- fireball arrow

mobs:register_arrow("mobs_monster:fireball", {
	visual = "sprite",
	visual_size = {x = 1, y = 1},
	textures = {"mobs_fireball.png"},
	collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	velocity = 7,
	tail = 1,
	tail_texture = "mobs_fireball.png",
	tail_size = 10,
	glow = 5,
	expire = 0.1,

	on_activate = function(self, staticdata, dtime_s)
		-- make fireball indestructable
		self.object:set_armor_groups({immortal = 1, fleshy = 100})
	end,

	-- if player has a good weapon with 7+ damage it can deflect fireball
	on_punch = function(self, hitter, tflp, tool_capabilities, dir)

		if hitter and hitter:is_player() and tool_capabilities and dir then

			local damage = tool_capabilities.damage_groups and
				tool_capabilities.damage_groups.fleshy or 1

			local tmp = tflp / (tool_capabilities.full_punch_interval or 1.4)

			if damage > 6 and tmp < 4 then

				self.object:set_velocity({
					x = dir.x * self.velocity,
					y = dir.y * self.velocity,
					z = dir.z * self.velocity
				})
			end
		end
	end,

	-- direct hit, no fire... just plenty of pain
	hit_player = function(self, player)

		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 8}
		}, nil)
	end,

	hit_mob = function(self, player)

		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 8}
		}, nil)
	end,

	hit_object = function(self, player)
		mobs:explosion(self.object:get_pos(), 2, 1, 0)
	end,

	-- node hit
	hit_node = function(self, pos, node)
		mobs:boom(self, pos, 1)
	end
})

--core.override_item("default:obsidian", {on_blast = function() end})

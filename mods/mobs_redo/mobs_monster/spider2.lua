
local S = mobs.intllib


-- Spider by AspireMint (CC-BY-SA 3.0 license)

mobs:register_mob("mobs_monster:spider2", {
	--docile_by_day = true,
	group_attack = true,
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	reach = 2,
	damage = 3,
	hp_min = 10,
	hp_max = 30,
	armor = 200,
	collisionbox = {-0.8, -0.5, -0.8, 0.8, 0, 0.8},
	visual_size = {x = 1, y = 1},
	visual = "mesh",
	mesh = "mobs_spider2.b3d",
	textures = {
		{"mobs_spider_mese.png"},
		{"mobs_spider_orange.png"},
		{"mobs_spider_snowy.png"},
		{"mobs_spider_grey.png"},
	},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_spider",
		attack = "mobs_spider",
	},
	walk_velocity = 1,
	run_velocity = 3,
	jump = true,
	view_range = 15,
	floats = 0,
	drops = {
		{name = "farming:string", chance = 1, min = 1, max = 3},
	},
	water_damage = 5,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		speed_run = 20,--15,
		stand_start = 0,
		stand_end = 0,
		walk_start = 1,
		walk_end = 21,
		run_start = 1,
		run_end = 21,
		punch_start = 25,
		punch_end = 45,
	},
	-- what kind of spider are we spawning?
	on_spawn = function(self)

		local pos = self.object:get_pos() ; pos.y = pos.y - 1

		-- snowy spider
		if minetest.find_node_near(pos, 1,
				{"default:snow", "default:snowblock", "default:dirt_with_snow"}) then
			self.base_texture = {"mobs_spider_snowy.png"}
			self.object:set_properties({textures = self.base_texture})
		-- tarantula
		elseif minetest.find_node_near(pos, 1,
				{"default:dirt_with_rainforest_litter", "default:jungletree"}) then
			self.base_texture = {"mobs_spider_orange.png"}
			self.object:set_properties({textures = self.base_texture})
		-- grey spider
		elseif minetest.find_node_near(pos, 1,
				{"default:stone", "default:gravel"}) then
			self.base_texture = {"mobs_spider_grey.png"}
			self.object:set_properties({textures = self.base_texture})
		-- mese spider
		elseif minetest.find_node_near(pos, 1,
				{"default:mese", "default:stone_with_mese"}) then
			self.base_texture = {"mobs_spider_mese.png"}
			self.object:set_properties({textures = self.base_texture})
		end

		return true -- run only once, false/nil runs every activation
	end,
})


-- above ground spawn
mobs:spawn({
	name = "mobs_monster:spider2",
	nodes = {"default:dirt_with_rainforest_litter", "default:snowblock", "default:snow"},
	min_light = 0,
	max_light = 8,
	chance = 7000,
	active_object_count = 1,
	min_height = 25,
	max_height = 31000,
})

-- below ground spawn
mobs:spawn({
	name = "mobs_monster:spider2",
	nodes = {"default:stone_with_mese", "default:mese", "default:stone"},
	min_light = 0,
	max_light = 7,
	chance = 7000,
	active_object_count = 1,
	min_height = -31000,
	max_height = -40,
})


mobs:register_egg("mobs_monster:spider2", S("Spider2"), "mobs_cobweb.png", 1)

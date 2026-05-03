
-- web trap schematic

local web = {name = "mobs:cobweb"}
local web_trap = {
	size = {x = 3, y = 3, z = 3},
	data = {
		web, web, web,
		web, web, web,
		web, web, web,

		web, web, web,
		web, web, web,
		web, web, web,

		web, web, web,
		web, web, web,
		web, web, web
	}
}

lucky_block:add_schematics({
	{"webtrap", web_trap, {x = 1, y = 0, z = 1}},
})

-- add lucky blocks

lucky_block:add_blocks({
	{"sch", "webtrap", 1, true},
	{"spw", "mobs_monster:dungeon_master", 1, nil, nil, 3, "Billy"},
	{"spw", "mobs_monster:sand_monster", 3},
	{"spw", "mobs_monster:stone_monster", 3, nil, nil, 3, "Bob"},
	{"spw", "mobs_monster:dirt_monster", 3},
	{"spw", "mobs_monster:tree_monster", 3},
	{"spw", "mobs_monster:oerkki", 3},
	{"exp"},
	{"spw", "mobs_monster:spider", 5},
	{"spw", "mobs_monster:mese_monster", 2},
	{"spw", "mobs_monster:lava_flan", 3},
	{"spw", "mobs_monster:land_guard", 2},
	{"nod", "default:chest", 0, {
		{name = "mobs:lava_orb", max = 2},
		{name = "mobs:cobweb", max = 5}
	}},
})

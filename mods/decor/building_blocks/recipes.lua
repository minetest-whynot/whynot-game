local materials = homedecor.materials

if core.get_modpath("moreblocks") then
	core.register_craft({
		output = 'building_blocks:sticks 2',
		recipe = {
			{'group:stick', ''           , 'group:stick'},
			{'group:stick', 'group:stick', 'group:stick'},
			{'group:stick', 'group:stick', 'group:stick'},
		}
	})
else
	core.register_craft({
		output = 'building_blocks:sticks',
		recipe = {
			{'group:stick', 'group:stick'},
			{'group:stick', 'group:stick'},
		}
	})
end

core.register_craft({
	output = 'building_blocks:Adobe 3',
	recipe = {
		{materials.sand},
		{materials.clay_lump},
		{"group:stick"},
	}
})
core.register_craft({
	output = 'building_blocks:brobble_spread 4',
	recipe = {
		{materials.brick, materials.cobble, materials.brick},
	}
})
core.register_craft({
	output = 'building_blocks:BWtile 10',
	recipe = {
		{"group:marble", "group:tar_block"},
		{"group:tar_block", "group:marble"},
	}
})
core.register_craft({
	output = 'building_blocks:fakegrass 2',
	recipe = {
		{'group:leaves'},
		{materials.dirt},
	}
})
core.register_craft({
	output = 'building_blocks:Fireplace 1',
	recipe = {
		{materials.steel_ingot, "building_blocks:sticks", materials.steel_ingot},
	}
})
core.register_craft({
	output = 'building_blocks:grate 1',
	recipe = {
		{materials.steel_ingot, materials.steel_ingot},
		{materials.glass_block, materials.glass_block},
	}
})

if not core.get_modpath("moreblocks") or not core.get_modpath("gloopblocks") then
	core.register_craft({
		output = 'building_blocks:gravel_spread 4',
		recipe = {
			{materials.gravel, materials.gravel, materials.gravel},
		}
	})
end

if core.get_modpath("default") then
	core.register_craft({
		output = 'building_blocks:hardwood 2',
		recipe = {
			{"default:wood", "default:junglewood"},
			{"default:junglewood", "default:wood"},
		}
	})
	core.register_craft({
		output = 'building_blocks:hardwood 2',
		recipe = {
			{"default:junglewood", "default:wood"},
			{"default:wood", "default:junglewood"},
		}
	})
end
core.register_craft({
	output = 'building_blocks:knife 1',
	recipe = {
		{"group:tar_block"},
		{"group:stick"},
	}
})
core.register_craft({
	output = "building_blocks:Marble 9",
	recipe = {
		{materials.clay_lump, "group:tar_block", materials.clay_lump},
		{"group:tar_block",materials.clay_lump, "group:tar_block"},
		{materials.clay_lump, "group:tar_block",materials.clay_lump},
	}
})
core.register_craft({
	output = 'building_blocks:Roofing 10',
	recipe = {
		{"building_blocks:Adobe", "building_blocks:Adobe"},
		{"building_blocks:Adobe", "building_blocks:Adobe"},
	}
})
core.register_craft({
	output = 'default:stick 4',
	recipe = {
		{'building_blocks:sticks'},
	}
})
core.register_craft({
	output = 'building_blocks:tar_base 4',
	recipe = {
		{materials.coal_lump, materials.gravel},
		{materials.gravel, materials.coal_lump}
	}
})
core.register_craft({
	output = 'building_blocks:tar_base 4',
	recipe = {
		{materials.gravel, materials.coal_lump},
		{materials.coal_lump, materials.gravel}
	}
})
core.register_craft({
	output = 'building_blocks:Tarmac_spread 4',
	recipe = {
		{"group:tar_block", "group:tar_block"},
	}
})
core.register_craft({
	output = 'building_blocks:terrycloth_towel 2',
	recipe = {
		{"farming:string", "farming:string", "farming:string"},
	}
})
core.register_craft({
	output = 'building_blocks:woodglass 1',
	recipe = {
		{"group:wood"},
		{materials.glass_block},
	}
})

core.register_craft({
	type = "cooking",
	output = "building_blocks:smoothglass",
	recipe = materials.glass_block
})
core.register_craft({
	type = "cooking",
	output = "building_blocks:Tar",
	recipe = "building_blocks:tar_base",
})

core.register_craft({
	type = "fuel",
	recipe = "building_blocks:hardwood",
	burntime = 28,
})
core.register_craft({
	type = "fuel",
	recipe = "building_blocks:sticks",
	burntime = 5,
})
core.register_craft({
	type = "fuel",
	recipe = "building_blocks:Tar",
	burntime = 40,
})

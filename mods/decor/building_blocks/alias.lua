local S = core.get_translator("building_blocks")

if core.get_modpath("moreblocks") or core.get_modpath("stairs") then
	core.register_alias("building_blocks:slab_tar", "stairs:slab_Tar")
	core.register_alias("building_blocks:stair_tar", "stairs:stair_Tar")
	core.register_alias("building_blocks:slab_marble", "stairs:slab_Marble")
	core.register_alias("building_blocks:stair_marble", "stairs:stair_Marble")
end

if core.get_modpath("moreblocks") then
	core.register_alias_force("moreblocks:tar", "building_blocks:Tar")
	stairsplus:register_alias_all("building_blocks", "tar", "building_blocks", "Tar")
	stairsplus:register_alias_all("building_blocks", "marble", "building_blocks", "Marble")
	stairsplus:register_alias_all("moreblocks", "tar", "building_blocks", "Tar")

	if core.get_modpath("gloopblocks") then
		core.register_alias("building_blocks:gravel_spread", "gloopblocks:slab_gravel_1")
	end
end

core.register_alias("adobe", "building_blocks:Adobe")
core.register_alias("fakegrass", "building_blocks:fakegrass")
core.register_alias("hardwood", "building_blocks:hardwood")
core.register_alias("tar_knife", "building_blocks:knife")
core.register_alias("marble", "building_blocks:Marble")
core.register_alias("building_blocks_roofing", "building_blocks:Roofing")
core.register_alias("sticks", "building_blocks:sticks")
core.register_alias("building_blocks:faggot", "building_blocks:sticks")
core.register_alias("tar", "building_blocks:Tar")

if not core.get_modpath("technic") then
	core.register_node( ":technic:granite", {
		    description = S("Granite"),
		    tiles = { "technic_granite.png" },
		    is_ground_content = true,
		    groups = {cracky=1, dig_stone=2, pickaxey=5},
			_mcl_hardness=1.6,
		    _sound_def = {
				key = "node_sound_stone_defaults",
			},
	})
	core.register_craft({
		output = "technic:granite 9",
		recipe = {
			{ "group:tar_block", "group:marble", "group:tar_block" },
			{ "group:marble", "group:tar_block", "group:marble" },
			{ "group:tar_block", "group:marble", "group:tar_block" }
		},
	})
	if core.get_modpath("moreblocks") then
		stairsplus:register_all("technic", "granite", "technic:granite", {
				description=S("Granite"),
				groups={cracky=1, not_in_creative_inventory=1},
				tiles={"technic_granite.png"},
		})
	end
end

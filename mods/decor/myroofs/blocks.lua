local asphalt_shingles = { --desc, color, dye
	{"Grey",            "grey",           "grey"},
	{"Dark Grey",       "dark_grey",      "dark_grey"},
	{"Red",             "red",            "red"},
	{"Green",           "green",          "green"},
}
for i in ipairs (asphalt_shingles) do
	local desc = asphalt_shingles[i][1]
	local color = asphalt_shingles[i][2]
	local dyes = asphalt_shingles[i][3]


-- Asphalt Bundle
minetest.register_node("myroofs:asphalt_shingle_"..color.."_bundle", {
	description = desc.." Asphalt Shingle bundle",
	drawtype = "normal",
	tiles = {"myroofs_asphalt_shingle_"..color..".png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
})
--Craft
minetest.register_craft({
	output = "myroofs:asphalt_shingle_"..color.."_bundle 4",
	recipe = {
		{"default:gravel", "default:coal_lump","default:gravel"},
		{"default:coal_lump", "default:coal_lump","default:coal_lump"},
		{"default:gravel", "default:gravel","dye:"..dyes},
	}
})
end

--Grey Round Asphalt
minetest.register_node("myroofs:asphalt_shingle_grey_round_bundle", {
	description = "Grey Round Asphalt Shingle bundle",
	drawtype = "normal",
	tiles = {"myroofs_asphalt_shingle_grey_round.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
--	on_place = minetest.rotate_node,
})
--Craft
minetest.register_craft({
	output = "myroofs:asphalt_shingle_grey_round_bundle 4",
	recipe = {
		{"", "myroofs:asphalt_shingle_grey_bundle",""},
		{"myroofs:asphalt_shingle_grey_bundle", "","myroofs:asphalt_shingle_grey_bundle"},
		{"", "myroofs:asphalt_shingle_grey_bundle",""},
	}
})
--Dark Grey Round Asphalt
minetest.register_node("myroofs:asphalt_shingle_dark_grey_round_bundle", {
	description = "Dark Grey Round Asphalt Shingle bundle",
	drawtype = "normal",
	tiles = {"myroofs_asphalt_shingle_dark_grey_round.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
})
minetest.register_craft({
	output = "myroofs:asphalt_shingle_dark_grey_round_bundle 4",
	recipe = {
		{"", "myroofs:asphalt_shingle_dark_grey_bundle",""},
		{"myroofs:asphalt_shingle_dark_grey_bundle", "","myroofs:asphalt_shingle_dark_grey_bundle"},
		{"", "myroofs:asphalt_shingle_dark_grey_bundle",""},
	}
})
--Dark straw
minetest.register_node("myroofs:straw_dark", {
	description = "Dark Straw",
	drawtype = "normal",
	tiles = {"myroofs_straw_dark.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
})
--Craft
minetest.register_craft({
	output = "myroofs:straw_dark 1",
	recipe = {
		{"farming:straw", "dye:black",""},
		{"", "",""},
		{"", "",""},
	}
})
--Reet
minetest.register_node("myroofs:reet", {
	description = "Reet",
	drawtype = "normal",
	tiles = {"myroofs_reet.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
})
--Craft
minetest.register_craft({
	output = "myroofs:reet 1",
	recipe = {
		{"farming:straw", "dye:brown",""},
		{"", "",""},
		{"", "",""},
	}
})
minetest.register_node("myroofs:copper_roofing", {
	description = "Copper Roofing",
	drawtype = "normal",
	tiles = {"myroofs_copper.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
})
minetest.register_node("myroofs:green_copper_roofing", {
	description = "Green Copper Roofing",
	drawtype = "normal",
	tiles = {"myroofs_green_copper.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {choppy=2, oddly_breakable_by_hand=2},
	sounds = default.node_sound_wood_defaults(),
})
minetest.register_craft({
	output = "myroofs:copper_roofing",
	recipe = {
		{"default:copper_ingot", "",""},
		{"default:copper_ingot", "",""},
		{"default:copper_ingot", "",""},
	}
})
minetest.register_craft({
	output = "myroofs:green_copper_roofing",
	recipe = {
		{"default:copper_ingot", "dye:green",""},
		{"default:copper_ingot", "",""},
		{"default:copper_ingot", "",""},
	}
})

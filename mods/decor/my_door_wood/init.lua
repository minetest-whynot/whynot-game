local door_wood = { -- color, desc, image
	{"red", "Red Stained", "red"},
	{"grey", "Grey Stained", "grey"},
	{"dark_grey", "Dark Grey Stained", "dark_grey"},
	{"brown", "Brown Stained", "brown"},
	{"white", "White Stained", "white"},
	{"yellow", "Clear Stained", "yellow"},
	{"black", "Black", "black"},
}
local function my_door_wood_block_stairs(nodename, def)	
	local mod = string.match (nodename,"(.+):")
	local name = string.match (nodename,":(.+)")
	minetest.register_node(nodename,def)
	if minetest.get_modpath("moreblocks") then
		stairsplus:register_all(
			mod,
			name,
			nodename,
			{
				description = def.description,
				tiles = def.tiles,
				groups = def.groups,
				sounds = def.sounds,
			}
		)
	elseif minetest.get_modpath("stairs") then	
		stairs.register_stair_and_slab(name,nodename,
			def.groups,
			def.tiles,
			("%s Stair"):format(def.description),
			("%s Slab"):format(def.description),
			def.sounds
		)	
	end	
end
for i in ipairs(door_wood) do
	local color = door_wood[i][1]
	local desc = door_wood[i][2]
	local img = door_wood[i][3]

my_door_wood_block_stairs("my_door_wood:wood_"..color, {
	description = desc.." Wood",
	drawtype = "normal",
	paramtype = "light",
	tiles = {"mydoors_"..img.."_wood.png"},
	paramtype = "light",
	groups = {cracky = 2, choppy = 2},
	sounds = default.node_sound_wood_defaults(),

})

-- Crafts

minetest.register_craft({
	output = "my_door_wood:wood_"..color,
	recipe = {
		{"default:wood", "", ""},
		{"dye:"..color, "", ""},
		{"", "", ""}
	}
})
end

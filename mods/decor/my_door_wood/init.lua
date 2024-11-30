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
	local mod = string.match(nodename, "(.+):")
	local name = string.match(nodename, ":(.+)")
	minetest.register_node(nodename, def)
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

local function add_door(color, desc, img)
	my_door_wood_block_stairs("my_door_wood:wood_"..color, {
		description = desc.." Wood",
		drawtype = "normal",
		tiles = {"mydoors_"..img.."_wood.png"},
		paramtype = "light",
		groups = {cracky = 2, choppy = 2, wood = 1},
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

for _,door in ipairs(door_wood) do
	add_door(unpack(door))
end

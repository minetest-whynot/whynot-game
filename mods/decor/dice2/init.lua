-- Boilerplate to support localized strings if intllib mod is installed.
local S
if (minetest.get_modpath("intllib")) then
	S = intllib.Getter()
else
	S = function ( s ) return s end
end

local dice2 = {}
dice2.colors = { "white", "red" }
dice2.descriptions = { S("White dice"), S("Red dice") }

--[[ throw dice (randomly change facedir and play sound ]]
function dice2.throw(pos, node, clicker, itemstack, pointed_thing)
	local newnode = node

	--[[ Why math.random(0,23), you ask?
	This includes the facing direction (1 out of 6) and the rotation (1 out of 4).
	This is basically the same as
		math.random(0,5) + math.random(0,4)*6
	.
	Don’t worry, the probability is still 1/6 for each facing direction. ]]
	newnode.param2 = math.random(0,23)
	minetest.swap_node(pos,newnode)
	minetest.sound_play( {name="dice2_dice_throw", gain=1 }, {pos=pos, loop=false})
	return itemstack
end

--[[ place dice and use a random facedir ]]
function dice2.construct(pos) --, placer, itemstack, pointed_thing)
	local newnode = minetest.get_node(pos)
	newnode.param2 = math.random(0,23)
	minetest.swap_node(pos,newnode)
end

for i=1,#dice2.colors do
	local c = dice2.colors[i]
	minetest.register_node("dice2:dice_"..c,
		{
			description = dice2.descriptions[i],
			_doc_items_longdesc = S("A huge wooden dice with the numbers 1-6, just for fun."),
			_doc_items_usagehelp = S("Rightclick on a placed dice to “throw” it, which rotates it randomly."),
			tiles = {
				"dice2_dice_"..c.."_6.png", "dice2_dice_"..c.."_1.png",
				"dice2_dice_"..c.."_5.png", "dice2_dice_"..c.."_2.png",
				"dice2_dice_"..c.."_4.png", "dice2_dice_"..c.."_3.png" },
			groups = { choppy=2, flammable=1, dig_immediate=2 },
			paramtype2 = "facedir",
			sounds = {
				footstep = { name="dice2_dice_punchstep", gain = 0.75 },
				dig = { name="dice2_dice_punchstep", gain = 0.8325 },
				dug = { name="dice2_dice_punchstep", gain = 1 },
				place = { name="dice2_dice_place", gain = 1 }, },
			on_rightclick = dice2.throw,
			on_construct = dice2.construct,
			is_ground_content = false,
		}
	)

	minetest.register_craft({
		type = "fuel",
		recipe = "dice2:dice_"..c,
		burntime = 5,
	})
end

minetest.register_craft({
	output = "dice2:dice_white 5",
	recipe = {
		{ "group:wood", "", "group:wood" },
		{ "", "group:wood", ""} ,
		{ "group:wood", "", "group:wood" }
	}
})

if minetest.get_modpath("dye") ~= nil then
	minetest.register_craft({
		type = "shapeless",
		output = "dice2:dice_white",
		recipe = { "dice2:dice_red", "dye:white", "dye:black" }
	})
	minetest.register_craft({
		type = "shapeless",
		output = "dice2:dice_red",
		recipe = { "dice2:dice_white", "dye:red", "dye:white" }
	})
end


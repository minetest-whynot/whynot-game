
local S = core.get_translator("bonemeal")

-- helper function

local function growy(pos, player)

	local nods = core.find_nodes_in_area(
		{x = pos.x - 6, y = pos.y - 2, z = pos.z - 6},
		{x = pos.x + 6, y = pos.y + 2, z = pos.z + 6},
		{"group:soil", "group:sand", "group:plant", "group:seed", "group:sapling"})

	if nods and #nods > 0 then

		for n = 1, #nods do
			bonemeal:on_use(nods[n], 5)
		end
	end

	core.chat_send_player(player:get_player_name(),
			lucky_block.green .. S("Blooming Wonderful!"))
end

-- add lucky blocks

lucky_block:add_blocks({
	{"lig"},
	{"dro", {"bonemeal:mulch"}, 10},
	{"dro", {"bonemeal:bonemeal"}, 10},
	{"dro", {"bonemeal:fertiliser"}, 10},
	{"cus", growy},
	{"nod", "default:chest", 0, {
		{name = "bonemeal:mulch", max = 20},
		{name = "bonemeal:bonemeal", max = 15},
		{name = "bonemeal:fertiliser", max = 10}
	}}
})

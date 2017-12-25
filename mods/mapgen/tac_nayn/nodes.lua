minetest.register_node("tac_nayn:tacnayn", {
	description = "Tac Nayn",
	tiles = {"tac_nayn_side.png", "tac_nayn_side.png", "tac_nayn_side.png",
		"tac_nayn_side.png", "tac_nayn_back.png", "tac_nayn_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	is_ground_content = false,
	legacy_facedir_simple = true,
	sounds = default.node_sound_defaults(),
})

minetest.register_node("tac_nayn:tacnayn_rainbow", {
	description = "Tac Nayn Rainbow",
	tiles = {"tac_nayn_rb.png^[transformR90", "tac_nayn_rb.png^[transformR90",
		"tac_nayn_rb.png", "tac_nayn_rb.png"},
	paramtype2 = "facedir",
	groups = {cracky=2},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

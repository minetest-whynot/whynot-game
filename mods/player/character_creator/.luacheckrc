unused_args = false
max_line_length = 105
-- Allow shadowed variables (callbacks in callbacks)
redefined = false

globals = {
	"character_creator",
	"armor", "multiskin",
}

read_globals = {
	string = {fields = {"split", "trim"}},
	table = {fields = {"copy", "getn", "indexof"}},

	"core",
	"minetest", "vector",
	"ItemStack",
	"dump",

	"skins", "sfinv", "sfinv_buttons", "unified_inventory",
	"inventory_plus"
}

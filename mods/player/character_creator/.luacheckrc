unused_args = false
allow_defined_top = true
max_line_length = 999
-- Allow shadowed variables (callbacks in callbacks)
redefined = false

globals = {
	"character_creator",
	"armor", "multiskin"
}

read_globals = {
	string = {fields = {"split", "trim"}},
	table = {fields = {"copy", "getn", "indexof"}},

	"minetest", "vector",
	"ItemStack",
	
	"skins", "sfinv", "sfinv_buttons", "unified_inventory",
	"inventory_plus"
}

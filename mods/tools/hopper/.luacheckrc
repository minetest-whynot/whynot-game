std = "lua51c"

ignore = {
	"21[23]", -- unused argument
}

max_line_length = 250

read_globals = {
	"default",
	"ItemStack",
	"lucky_block",
	"minetest",
	"screwdriver",
	"vector",
}

globals = {"hopper"}

files["doc.lua"] = {
	max_line_length = 9999,
}

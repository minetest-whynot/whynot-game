-- Disable some (non critical) warnings
-- unused = false
unused_args = false
redefined = false

globals = {
	"airutils",
}

read_globals = {
	"DIR_DELIM",
	"ItemStack",
	"PseudoRandom",
	"basic_machines",
	"biomass",
	"climate_api",
	"core",
	"creative",
	"default",
	"dump",
	"emote",
	"math",
	"mcl_formspec",
	"mcl_player",
	"minetest",
	"player_api",
	"signs_lib",
	"skins",
	"string",
	"technic",
	"vector",
	"wardrobe",
}

-- Per file options
files["airutils_biofuel.lua"] = {
	globals = {"basic_machines.grinder_recipes"},
}

files["lib_planes/utilities.lua"] = {
	globals = {"player_api.player_attached.?", "mcl_player.player_attached.?"}
}

files["pilot_skin_manager.lua"] = {
	globals = {"skins.skin_class.apply_skin_to_player"}
}
local S = minetest.get_translator("mtg_plus")

local door_simple = S("A door covers a vertical area of two blocks to block the way. It can be opened and closed by any player.")
local door_simple_use = S("Use the use key on it to open or close it.")

local metal_sounds
if default.node_sound_metal_defaults then
	metal_sounds = default.node_sound_metal_defaults()
else
	metal_sounds = default.node_sound_stone_defaults()
end

-- Doors
doors.register("door_wood_bar", {
	tiles = {{ name = "mtg_plus_door_wood_bar.png", backface_culling = true }},
	description = S("Wooden Bar Door"),
	_doc_items_longdesc = door_simple,
	_doc_items_usagehelp = door_simple_use,
	_doc_items_image = "mtg_plus_door_wood_bar_item.png",
	inventory_image = "mtg_plus_door_wood_bar_item.png",
	sounds = default.node_sound_wood_defaults(),
	sound_open = "doors_fencegate_open",
	sound_close = "doors_fencegate_close",
	groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
	recipe = {
		{"xpanes:wood_flat",},
		{"xpanes:wood_flat",},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "doors:door_wood_bar",
	burntime = 4,
})

doors.register("door_papyrus", {
	tiles = {{ name = "mtg_plus_door_papyrus.png", backface_culling = true }},
	description = S("Papyrus Door"),
	_doc_items_longdesc = door_simple,
	_doc_items_usagehelp = door_simple_use,
	_doc_items_image = "mtg_plus_door_papyrus_item.png",
	inventory_image = "mtg_plus_door_papyrus_item.png",
	sounds = default.node_sound_leaves_defaults(),
	sound_open = "doors_fencegate_open",
	sound_close = "doors_fencegate_close",
	groups = { snappy = 2, choppy = 1, flammable = 2 },
	recipe = {
		{"default:papyrus", "default:papyrus"},
		{"farming:string", "farming:string"},
		{"default:papyrus", "default:papyrus"},
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "doors:door_papyrus",
	burntime = 4,
})

doors.register("door_ice", {
	tiles = {{ name = "mtg_plus_door_ice.png", backface_culling = true }},
	description = S("Ice Door"),
	_doc_items_longdesc = S("Ice doors can be opened and closed. They are solid, but some of the light hitting ice doors can still go through, making them an interesting decoration in icy areas."),
	_doc_items_usagehelp = door_simple_use,
	_doc_items_image = "mtg_plus_door_ice_item.png",
	inventory_image = "mtg_plus_door_ice_item.png",
	groups = { cracky = 3, slippery = 3, },
	sounds = default.node_sound_glass_defaults(),
	sound_open = "mtg_plus_door_ice_open",
	sound_close = "mtg_plus_door_ice_close",
	recipe = {
		{"default:ice", "default:ice"},
		{"default:ice", "default:ice"},
		{"default:ice", "default:ice"},
	}
})

doors.register("door_icesteel", {
	tiles = {{ name = "mtg_plus_door_icesteel.png", backface_culling = true }},
	description = S("Icy Steel Door"),
	_doc_items_longdesc = S("Icy steel doors are a combination of ice doors and steel doors which can only be opened and closed by their owners. They are solid, but some of the light hitting icy steel doors can still go through."),
	_doc_items_usagehelp = S("Point the door to see who owns it. Use the use key on the door to open or close it (if you own it)."),
	_doc_items_image = "mtg_plus_door_icesteel_item.png",
	protected = true,
	sound_open = "mtg_plus_door_icesteel_open",
	sound_close = "mtg_plus_door_icesteel_close",
	inventory_image = "mtg_plus_door_icesteel_item.png",
	sounds = metal_sounds,
	groups = { snappy = 1, bendy = 2, cracky = 3, melty = 3, level = 2, slippery = 1, },
})

minetest.register_craft({
	output = "doors:door_icesteel 2",
	type = "shapeless",
	recipe = {"doors:door_ice", "doors:door_steel"},
})

doors.register_fencegate("mtg_plus:gate_goldwood", {
	description = S("Goldwood Fence Gate"),
	material = "mtg_plus:goldwood",
	texture = "mtg_plus_goldwood.png",
	groups = {choppy=2, },
})

minetest.override_item("mtg_plus:gate_goldwood_closed", {
	_doc_items_longdesc = S("A fence gate made from precious goldwood. It blocks the path, but it can be opened and easily jumped over. Other fence posts will neatly connect to this fence gate."),
	_doc_items_usagehelp = S("Right-click the gate to open or close it."),
})
minetest.override_item("mtg_plus:gate_goldwood_open", {
	_doc_items_create_entry = false,
})
if minetest.get_modpath("doc") then
	doc.add_entry_alias("nodes", "mtg_plus:gate_goldwood_closed", "nodes", "mtg_plus:gate_goldwood_open")
end

doors.register_trapdoor("mtg_plus:trapdoor_ice", {
	description = S("Ice Trapdoor"),
	_doc_items_longdesc = S("An ice trapdoor covers the floor and can be opened and closed by anyone. Ice trapdoors are solid, but some light can pass through nonetheless."),
	_doc_items_usagehelp = door_simple_use,
	tile_front = "mtg_plus_trapdoor_ice.png",
	tile_side = "mtg_plus_trapdoor_ice_side.png",
	inventory_image = "mtg_plus_trapdoor_ice.png",
	wield_image = "mtg_plus_trapdoor_ice.png",
	sound_open = "mtg_plus_door_ice_open",
	sound_close = "mtg_plus_door_ice_close",
	sounds = default.node_sound_glass_defaults(),
	groups = { cracky = 3, slippery = 3, door = 1 },
})

minetest.register_craft({
	output = "mtg_plus:trapdoor_ice 2",
	recipe = { { "default:ice", "default:ice", "default:ice" },
	{ "default:ice", "default:ice", "default:ice" }, }
})

doors.register_trapdoor("mtg_plus:trapdoor_icesteel", {
	description = S("Icy Steel Trapdoor"),
	_doc_items_longdesc = S("An icy steel trapdoor is a combination of an ice trapdoor and a steel trapdoor. It covers the floor and can only be opened and closed by its placer. Icy steel trapdoors are solid, but some light can pass through nonetheless."),
	_doc_items_usagehelp = S("Point the icy steel trapdoor to see who owns it. Use the use key on it to open or close it (if you own it)."),
	protected = true,
	tile_front = "mtg_plus_trapdoor_icesteel.png",
	tile_side = "mtg_plus_trapdoor_icesteel_side.png",
	inventory_image = "mtg_plus_trapdoor_icesteel.png",
	wield_image = "mtg_plus_trapdoor_icesteel.png",
	sound_open = "mtg_plus_door_icesteel_open",
	sound_close = "mtg_plus_door_icesteel_close",
	sounds = metal_sounds,
	groups = { snappy = 1, bendy = 2, cracky = 3, melty = 3, level = 2, slippery = 1, door = 1 },
})

minetest.register_craft({
	type = "shapeless",
	output = "mtg_plus:trapdoor_icesteel 2",
	recipe = { "mtg_plus:trapdoor_ice", "doors:trapdoor_steel" },
})

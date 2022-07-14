local S = minetest.get_translator("home_workshop_machines")

-- "bedflinger" style 3D Printer (Prusa i3 or equivalent)

local cbox = {
	type = "fixed",
	fixed = {-0.25, -0.25, -0.5, 0.3, 0.3, 0.25 }
}

minetest.register_node("home_workshop_machines:3dprinter_bedflinger", {
	description = S('3D Printer ("bedflinger" design)'),
	inventory_image = "home_workshop_machines_3dprinter_bedflinger_inv.png",
	tiles = {
		{ name = "home_workshop_machines_3dprinter.png", color = 0xffffffff },
		"home_workshop_machines_3dprinter_filament.png"
	},
	paramtype = "light",
	walkable = true,
	groups = {snappy=3, ud_param2_colorable = 1},
	sound = default and default.node_sound_wood_defaults() or nil,
	drawtype = "mesh",
	mesh = "home_workshop_machines_3dprinter_bedflinger.obj",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	selection_box = cbox,
	collision_box = cbox,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end,
	on_dig = unifieddyes.on_dig,
	on_rotate = unifieddyes.fix_after_screwdriver_nsew,
})

-- COreXY style printer (Hypercube or similar)

cbox = {
	type = "fixed",
	fixed = {-0.4375, -0.5, -0.5, 0.4375, 0.5, 0.375 }
}

minetest.register_node("home_workshop_machines:3dprinter_corexy", {
	description = S('3D Printer (CoreXY design)'),
	tiles = {
		{ name = "home_workshop_machines_3dprinter.png", color = 0xffffffff },
		"home_workshop_machines_3dprinter_filament.png"
	},
	paramtype = "light",
	walkable = true,
	groups = {snappy=3, ud_param2_colorable = 1},
	sound = default and default.node_sound_wood_defaults() or nil,
	drawtype = "mesh",
	mesh = "home_workshop_machines_3dprinter_corexy.obj",
	paramtype2 = "colorwallmounted",
	palette = "unifieddyes_palette_colorwallmounted.png",
	selection_box = cbox,
	collision_box = cbox,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
	end,
	on_dig = unifieddyes.on_dig,
	on_rotate = unifieddyes.fix_after_screwdriver_nsew,
})

if minetest.get_modpath("basic_materials") then
	minetest.register_craft({
		output = "home_workshop_machines:3dprinter_bedflinger",
		recipe = {
			{"basic_materials:plastic_sheet", "dye:white", "basic_materials:plastic_sheet"},
			{"basic_materials:motor", "basic_materials:heating_element", "basic_materials:motor"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		},
	})
end

if minetest.get_modpath("basic_materials") then
	minetest.register_craft({
		output = "home_workshop_machines:3dprinter_corexy",
		recipe = {
			{"default:steel_ingot", "basic_materials:motor", "basic_materials:plastic_sheet"},
			{"default:glass", "basic_materials:heating_element", "default:glass"},
			{"default:steel_ingot", "basic_materials:motor", "default:steel_ingot"},
		},
	})
end

minetest.register_alias("computer:3dprinter_bedflinger",  "home_workshop_machines:3dprinter_bedflinger")
minetest.register_alias("computers:3dprinter_bedflinger", "home_workshop_machines:3dprinter_bedflinger")
minetest.register_alias("computer:3dprinter_corexy",      "home_workshop_machines:3dprinter_corexy")
minetest.register_alias("computers:3dprinter_corexy",     "home_workshop_machines:3dprinter_corexy")

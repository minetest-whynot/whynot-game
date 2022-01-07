-- This file supplies the majority of homedecor's lighting

local S = minetest.get_translator("homedecor_lighting")

homedecor_lighting = {}

local function is_protected(pos, clicker)
	if minetest.is_protected(pos, clicker:get_player_name()) then
		minetest.record_protection_violation(pos,
		clicker:get_player_name())
		return true
	end
	return false
end

local hd_mesecons = minetest.get_modpath("mesecons")

-- control and brightness for dimmable lamps

local word_to_bright = {
	["off"] = 0,
	["low"] = 3,
	["med"] = 7,
	["hi"]  = 11,
	["on"]  = 14,
	["max"] = 14,
}

local rules_alldir = {
	{x =  0, y =  0, z =  1},
	{x = -1, y =  0, z =  0},
	{x =  1, y =  0, z =  0},
	{x =  0, y =  0, z = -1},  -- borrowed from lightstones
	{x =  0, y =  1, z =  1},
	{x = -1, y =  1, z =  0},
	{x =  0, y =  1, z =  0},
	{x =  1, y =  1, z =  0},
	{x =  0, y =  1, z = -1},
	{x =  0, y = -1, z =  1},
	{x = -1, y = -1, z =  0},
	{x =  0, y = -1, z =  0},
	{x =  1, y = -1, z =  0},
	{x =  0, y = -1, z = -1},
}

-- mesecons compatibility

local actions

if hd_mesecons then

	actions = {
		action_off = function(pos, node)
			local sep = string.find(node.name, "_", -5)
			if minetest.get_meta(pos):get_int("toggled") > 0 then
				minetest.swap_node(pos, {
					name = string.sub(node.name, 1, sep - 1).."_off",
					param2 = node.param2
				})
			end
		end,
		action_on = function(pos, node)
			minetest.get_meta(pos):set_int("toggled", 1)
			local sep = string.find(node.name, "_", -5)
			minetest.swap_node(pos, {
				name = string.sub(node.name, 1, sep - 1).."_on",
				param2 = node.param2
			})
		end
	}

	homedecor_lighting.mesecon_wall_light = {
		effector = table.copy(actions)
	}
	homedecor_lighting.mesecon_wall_light.effector.rules = mesecon.rules.wallmounted_get

	homedecor_lighting.mesecon_alldir_light = {
		effector = table.copy(actions),
	}
	homedecor_lighting.mesecon_alldir_light.effector.rules = rules_alldir
end

-- digilines compatibility
-- this one is based on the so-named one in Jeija's digilines mod

local player_last_clicked = {}

local digiline_on_punch

if minetest.get_modpath("digilines") then

	local on_digiline_receive_string = function(pos, node, channel, msg)
		if not msg or not channel then return end
		local meta = minetest.get_meta(pos)
		local setchan = meta:get_string("channel")
		if setchan ~= channel then return end

		if msg ~= "" and (type(msg) == "string" or type(msg) == "number" ) then
			local n = tonumber(msg)
			local suff = word_to_bright[msg] or "invalid"

			local basename = string.sub(node.name, 1, string.find(node.name, "_", -5) - 1)

			if minetest.registered_nodes[basename.."_"..msg] then
				minetest.swap_node(pos, {name = basename.."_"..msg, param2 = node.param2})
			elseif minetest.registered_nodes[basename.."_"..suff] then
				minetest.swap_node(pos, {name = basename.."_"..suff, param2 = node.param2})
			elseif minetest.registered_nodes[basename.."_on"]
			  and (msg == "med" or msg == "hi" or msg == "max" or (n and n > 3)) then
				minetest.swap_node(pos, {name = basename.."_on", param2 = node.param2})
			elseif minetest.registered_nodes[basename.."_off"]
			  and (msg == "low" or (n and n < 4)) then
				minetest.swap_node(pos, {name = basename.."_off", param2 = node.param2})
			end
		end
	end

	minetest.register_on_player_receive_fields(function(player, formname, fields)
		local name = player:get_player_name()
		local pos = player_last_clicked[name]
		if pos and formname == "homedecor:lamp_set_channel" then
			if is_protected(pos, player) then return end
			if (fields.channel) then
				local meta = minetest.get_meta(pos)
				meta:set_string("channel", fields.channel)
			end
		end
	end)

	if hd_mesecons then
		homedecor_lighting.digiline_wall_light = {
			effector = {
				action = on_digiline_receive_string,
			},
			wire = {
				rules = mesecon.rules.wallmounted_get
			}
		}
	else
		homedecor_lighting.digiline_wall_light = {
			effector = {
				action = on_digiline_receive_string,
			},
			wire = {
				rules = rules_alldir
			}
		}
	end

	homedecor_lighting.digiline_alldir_light = {
		effector = {
			action = on_digiline_receive_string,
		},
		wire = {
			rules = rules_alldir
		}
	}

	function digiline_on_punch(pos, node, puncher, pointed_thing)
		if is_protected(pos, puncher) then return end

		if puncher:get_player_control().sneak then
			local name = puncher:get_player_name()
			player_last_clicked[name] = pos
			local form = "formspec_version[4]"..
					"size[8,4]"..
					"button_exit[3,2.5;2,0.5;proceed;Proceed]"..
					"field[1.75,1.5;4.5,0.5;channel;Channel;]"
			minetest.show_formspec(name, "homedecor:lamp_set_channel", form)
		end
	end
end

-- turn on/off, cycle brightness

function homedecor_lighting.toggle_light(pos, node, clicker, itemstack, pointed_thing)
	if is_protected(pos, clicker) then return end
	local sep = string.find(node.name, "_", -5)
	local level = string.sub(node.name, sep + 1)
	local n = tonumber(level) or 0

	local newsuff
	if level == "on" then
		newsuff = "_off"
	elseif level == "off" then
		newsuff = "_on"
	elseif n > 3 then
		newsuff = "_0"
	else
		newsuff = "_14"
	end

	minetest.swap_node(pos, {name = string.sub(node.name, 1, sep - 1)..newsuff, param2 = node.param2})
end

------------------
-- Dimmable lights

--for light_brightn_name in pairs(word_to_bright) do

for brightness_level = 0, 14 do

	local tiles
	local overlay

	local onflag = (brightness_level > 0)
	local nici = (brightness_level ~= 14) and 1 or nil

	local gen_ls_tex_white =           "homedecor_generic_light_source_off.png"
	if onflag then gen_ls_tex_white =  "homedecor_generic_light_source_white.png" end

	local gen_ls_tex_yellow =          "homedecor_generic_light_source_off.png"
	if onflag then gen_ls_tex_yellow = "homedecor_generic_light_source_yellow.png" end

	local h = (brightness_level == 0) and "0" or string.format("%x", brightness_level+1)
	local brightness_hex = tonumber("0xff"..string.rep(h, 6))

	local glowlight_nodebox = {
		half = homedecor.nodebox.slab_y(1/2),
		quarter = homedecor.nodebox.slab_y(1/4),
		small_cube = {
				type = "fixed",
				fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
		},
	}

	local base =        "homedecor_glowlight_base.png"

	local tb_edges =    "homedecor_glowlight_tb_edges.png"
	local sides_edges = "homedecor_glowlight_thick_sides_edges.png"
	local sides_glare = "homedecor_glowlight_thick_sides_glare.png"

	if onflag then
		tiles = {
			"("..base.."^"..tb_edges..")^[brighten",
			"("..base.."^"..tb_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
		}
		overlay = {
			{ name = "homedecor_glowlight_top_glare.png", color = "white"},
			"",
			{ name = sides_glare, color = "white"},
			{ name = sides_glare, color = "white"},
			{ name = sides_glare, color = "white"},
			{ name = sides_glare, color = "white"},
		}
	else
		tiles = {
			base.."^"..tb_edges,
			base.."^"..tb_edges,
			base.."^"..sides_edges,
			base.."^"..sides_edges,
			base.."^"..sides_edges,
			base.."^"..sides_edges,
		}
		overlay = nil
	end

	minetest.register_node(":homedecor:glowlight_half_"..brightness_level, {
		description = S("Thick Glowlight"),
		tiles = tiles,
		overlay_tiles = overlay,
		use_texture_alpha = true,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "colorwallmounted",
		palette = "unifieddyes_palette_colorwallmounted.png",
		selection_box = {
			type = "wallmounted",
			wall_top =    { -0.5,    0, -0.5, 0.5, 0.5, 0.5 },
			wall_bottom = { -0.5, -0.5, -0.5, 0.5,   0, 0.5 },
			wall_side =   { -0.5, -0.5, -0.5,   0, 0.5, 0.5 }
		},
		node_box = glowlight_nodebox.half,
		groups = { snappy = 3, ud_param2_colorable = 1, not_in_creative_inventory = nici },
		light_source = brightness_level,
		sounds = default.node_sound_glass_defaults(),
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			unifieddyes.fix_rotation(pos, placer, itemstack, pointed_thing)
		end,
		on_dig = unifieddyes.on_dig,
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:glowlight_half_on"}, inherit_color = true },
			}
		},
		mesecons = homedecor_lighting.mesecon_wall_light,
		digiline = homedecor_lighting.digiline_wall_light,
		on_punch = digiline_on_punch
	})

	sides_edges = "homedecor_glowlight_thin_sides_edges.png"
	sides_glare = "homedecor_glowlight_thin_sides_glare.png"

	if onflag then
		tiles = {
			"("..base.."^"..tb_edges..")^[brighten",
			"("..base.."^"..tb_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
		}
		overlay = {
			{ name = "homedecor_glowlight_top_glare.png", color = "white"},
			"",
			{ name = sides_glare, color = "white"},
			{ name = sides_glare, color = "white"},
			{ name = sides_glare, color = "white"},
			{ name = sides_glare, color = "white"},
		}
	else
		tiles = {
			base.."^"..tb_edges,
			base.."^"..tb_edges,
			base.."^"..sides_edges,
			base.."^"..sides_edges,
			base.."^"..sides_edges,
			base.."^"..sides_edges,
		}
		overlay = nil
	end

	minetest.register_node(":homedecor:glowlight_quarter_"..brightness_level, {
		description = S("Thin Glowlight"),
		tiles = tiles,
		overlay_tiles = overlay,
		use_texture_alpha = true,
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "colorwallmounted",
		palette = "unifieddyes_palette_colorwallmounted.png",
		selection_box = {
			type = "wallmounted",
			wall_top =    { -0.5, 0.25, -0.5,   0.5,   0.5, 0.5 },
			wall_bottom = { -0.5, -0.5, -0.5,   0.5, -0.25, 0.5 },
			wall_side =   { -0.5, -0.5, -0.5, -0.25,   0.5, 0.5 }
		},
		node_box = glowlight_nodebox.quarter,
		groups = { snappy = 3, ud_param2_colorable = 1, not_in_creative_inventory = nici },
		light_source = brightness_level,
		sounds = default.node_sound_glass_defaults(),
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			unifieddyes.fix_rotation(pos, placer, itemstack, pointed_thing)
		end,
		on_dig = unifieddyes.on_dig,
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:glowlight_quarter_on"}, inherit_color = true },
			}
		},
		mesecons = homedecor_lighting.mesecon_wall_light,
		digiline = homedecor_lighting.digiline_wall_light,
		on_punch = digiline_on_punch
	})

	tb_edges =    "homedecor_glowlight_cube_tb_edges.png"
	sides_edges = "homedecor_glowlight_cube_sides_edges.png"
	sides_glare = "homedecor_glowlight_cube_sides_glare.png"

	if onflag then
		tiles = {
			"("..base.."^"..tb_edges..")^[brighten",
			"("..base.."^"..tb_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
			"("..base.."^"..sides_edges..")^[brighten",
		}
		overlay = {
			{ name = "homedecor_glowlight_cube_top_glare.png", color = "white"},
			"",
			{ name = sides_glare, color = "white"},
			{ name = sides_glare, color = "white"},
			{ name = sides_glare, color = "white"},
			{ name = sides_glare, color = "white"},
		}
	else
		tiles = {
			base.."^"..tb_edges,
			base.."^"..tb_edges,
			base.."^"..sides_edges,
			base.."^"..sides_edges,
			base.."^"..sides_edges,
			base.."^"..sides_edges,
		}
		overlay = nil
	end

	minetest.register_node(":homedecor:glowlight_small_cube_"..brightness_level, {
		description = S("Small Glowlight Cube"),
		tiles = tiles,
		overlay_tiles = overlay,
		use_texture_alpha = true,
		paramtype = "light",
		paramtype2 = "colorwallmounted",
		drawtype = "nodebox",
		palette = "unifieddyes_palette_colorwallmounted.png",
		selection_box = {
			type = "wallmounted",
			wall_top =    { -0.25,    0,  -0.25, 0.25,  0.5, 0.25 },
			wall_bottom = { -0.25, -0.5,  -0.25, 0.25,    0, 0.25 },
			wall_side =   {  -0.5, -0.25, -0.25,    0, 0.25, 0.25 }
		},
		node_box = glowlight_nodebox.small_cube,
		groups = { snappy = 3, ud_param2_colorable = 1, not_in_creative_inventory = nici },
		light_source = brightness_level,
		sounds = default.node_sound_glass_defaults(),
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			unifieddyes.fix_rotation(pos, placer, itemstack, pointed_thing)
		end,
		on_dig = unifieddyes.on_dig,
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:glowlight_small_cube_on"}, inherit_color = true },
			}
		},
		mesecons = homedecor_lighting.mesecon_wall_light,
		digiline = homedecor_lighting.digiline_wall_light,
		on_punch = digiline_on_punch
	})

	local lighttex

	if onflag then
		local b = (brightness_level > 6) and brightness_level or 6
		local brightened = "^[multiply:#"..string.rep(string.format("%x", b), 6)

		lighttex = {
			name="homedecor_plasma_storm.png"..brightened,
			animation={type="vertical_frames", aspect_w=48, aspect_h=48, length=2.0},
		}
	else
		lighttex = "homedecor_plasma_lamp_off.png"
	end

	homedecor.register("plasma_lamp_"..brightness_level, {
		description = S("Plasma Lamp/Light"),
		drawtype = "mesh",
		mesh = "plasma_lamp.obj",
		tiles = {
			"default_gold_block.png",
			lighttex
		},
		use_texture_alpha = true,
		light_source = brightness_level,
		sunlight_propagates = true,
		groups = {cracky=3, oddly_breakable_by_hand=3, not_in_creative_inventory = nici},
		sounds = default.node_sound_glass_defaults(),
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:plasma_lamp_on"}},
			}
		},
		mesecons = homedecor_lighting.mesecon_alldir_light,
		digiline = homedecor_lighting.digiline_alldir_light,
		on_punch = digiline_on_punch
	})

	local gl_cbox = {
		type = "fixed",
		fixed = { -0.25, -0.5, -0.25, 0.25, 0.45, 0.25 },
	}

	homedecor.register("ground_lantern_"..brightness_level, {
		description = S("Ground Lantern/Light"),
		mesh = "homedecor_ground_lantern.obj",
		tiles = { gen_ls_tex_yellow, "homedecor_generic_metal_wrought_iron.png" },
		use_texture_alpha = true,
		inventory_image = "homedecor_ground_lantern_inv.png",
		wield_image = "homedecor_ground_lantern_inv.png",
		groups = {snappy=3, not_in_creative_inventory = nici},
		light_source = brightness_level,
		selection_box = gl_cbox,
		walkable = false,
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:ground_lantern_on"}},
			}
		},
		mesecons = homedecor_lighting.mesecon_alldir_light,
		digiline = homedecor_lighting.digiline_alldir_light,
		on_punch = digiline_on_punch
	})

	local hl_cbox = {
		type = "fixed",
		fixed = { -0.25, -0.5, -0.2, 0.25, 0.5, 0.5 },
	}

	homedecor.register("hanging_lantern_"..brightness_level, {
		description = S("Hanging Lantern/Light"),
		mesh = "homedecor_hanging_lantern.obj",
		tiles = { "homedecor_generic_metal_wrought_iron.png", gen_ls_tex_yellow },
		use_texture_alpha = true,
		inventory_image = "homedecor_hanging_lantern_inv.png",
		wield_image = "homedecor_hanging_lantern_inv.png",
		groups = {snappy=3, not_in_creative_inventory = nici},
		light_source = brightness_level,
		selection_box = hl_cbox,
		walkable = false,
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:hanging_lantern_on"}},
			}
		},
		mesecons = homedecor_lighting.mesecon_alldir_light,
		digiline = homedecor_lighting.digiline_alldir_light,
		on_punch = digiline_on_punch
	})

	local cl_cbox = {
		type = "fixed",
		fixed = { -0.35, -0.45, -0.35, 0.35, 0.5, 0.35 }
	}

	homedecor.register("ceiling_lantern_"..brightness_level, {
		drawtype = "mesh",
		mesh = "homedecor_ceiling_lantern.obj",
		tiles = { gen_ls_tex_yellow, "homedecor_generic_metal_wrought_iron.png" },
		use_texture_alpha = true,
		inventory_image = "homedecor_ceiling_lantern_inv.png",
		description = S("Ceiling Lantern/Light"),
		groups = {snappy=3, not_in_creative_inventory = nici},
		light_source = brightness_level,
		selection_box = cl_cbox,
		walkable = false,
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:ceiling_lantern_on"}},
			}
		},
		mesecons = homedecor_lighting.mesecon_alldir_light,
		digiline = homedecor_lighting.digiline_alldir_light,
		on_punch = digiline_on_punch
	})

	if not minetest.get_modpath("darkage") then
		homedecor.register("lattice_lantern_large_"..brightness_level, {
			description = S("Lattice lantern/Light (large)"),
			tiles = { gen_ls_tex_yellow.."^homedecor_lattice_lantern_large_overlay.png" },
			groups = { snappy = 3, not_in_creative_inventory = nici },
			light_source = brightness_level,
			sounds = default.node_sound_glass_defaults(),
			on_rightclick = homedecor_lighting.toggle_light,
			drop = {
				items = {
					{items = {"homedecor:lattice_lantern_large_on"}},
				}
			},
			mesecons = homedecor_lighting.mesecon_alldir_light,
			digiline = homedecor_lighting.digiline_alldir_light,
			on_punch = digiline_on_punch
		})
	end

	local lighttex_tb
	local lighttex_sides

	if onflag then
		lighttex_tb =    "homedecor_lattice_lantern_small_tb_light.png"
		lighttex_sides = "homedecor_lattice_lantern_small_sides_light.png"
	else
		lighttex_tb =    "homedecor_generic_light_source_off.png"
		lighttex_sides = "homedecor_generic_light_source_off.png"
	end

	homedecor.register("lattice_lantern_small_"..brightness_level, {
		description = S("Lattice lantern/light (small)"),
		tiles = {
			lighttex_tb.."^homedecor_lattice_lantern_small_tb_overlay.png",
			lighttex_tb.."^homedecor_lattice_lantern_small_tb_overlay.png",
			lighttex_sides.."^homedecor_lattice_lantern_small_sides_overlay.png"
		},
		selection_box = {
			type = "fixed",
			fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
		},
		node_box = {
			type = "fixed",
			fixed = { -0.25, -0.5, -0.25, 0.25, 0, 0.25 }
		},
		groups = { snappy = 3, not_in_creative_inventory = nici },
		light_source = brightness_level,
		sounds = default.node_sound_glass_defaults(),
		on_place = minetest.rotate_node,
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:lattice_lantern_small_on"}},
			}
		},
		mesecons = homedecor_lighting.mesecon_alldir_light,
		digiline = homedecor_lighting.digiline_alldir_light,
		on_punch = digiline_on_punch
	})

	-- "gooseneck" style desk lamps

	local dlamp_cbox = {
		type = "wallmounted",
		wall_side = { -0.2, -0.5, -0.15, 0.32, 0.12, 0.15 },
	}

	homedecor.register("desk_lamp_"..brightness_level, {
		description = S("Desk Lamp/Light"),
		mesh = "homedecor_desk_lamp.obj",
		tiles = {
			"homedecor_generic_metal.png",
			"homedecor_generic_metal.png",
			{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey },
			{ name = gen_ls_tex_white, color = brightness_hex },
		},
		inventory_image = "homedecor_desk_lamp_inv.png",
		paramtype = "light",
		paramtype2 = "colorwallmounted",
		palette = "unifieddyes_palette_colorwallmounted.png",
		selection_box = dlamp_cbox,
		node_box = dlamp_cbox,
		walkable = false,
		groups = {snappy=3, ud_param2_colorable = 1, not_in_creative_inventory = nici},
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			unifieddyes.fix_rotation_nsew(pos, placer, itemstack, pointed_thing)
		end,
		on_dig = unifieddyes.on_dig,
		on_rotate = unifieddyes.fix_after_screwdriver_nsew,
		light_source = brightness_level,
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:desk_lamp_on"}, inherit_color = true },
			}
		},
		mesecons = homedecor_lighting.mesecon_alldir_light,
		digiline = homedecor_lighting.digiline_alldir_light,
		on_punch = digiline_on_punch
	})

	-- "kitchen"/"dining room" ceiling lamp

	homedecor.register("ceiling_lamp_"..brightness_level, {
		description = S("Ceiling Lamp/Light"),
		mesh = "homedecor_ceiling_lamp.obj",
		tiles = {
			"homedecor_generic_metal_brass.png",
			"homedecor_ceiling_lamp_glass.png",
			gen_ls_tex_white,
			{ name = "homedecor_generic_plastic.png", color = 0xff442d04 },
		},
		inventory_image = "homedecor_ceiling_lamp_inv.png",
		light_source = brightness_level,
		groups = {snappy=3, not_in_creative_inventory = nici},
		walkable = false,
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:ceiling_lamp_on"}},
			}
		},
		mesecons = homedecor_lighting.mesecon_alldir_light,
		digiline = homedecor_lighting.digiline_alldir_light,
		on_punch = digiline_on_punch
	})

	local tlamp_cbox = {
		type = "fixed",
		fixed = { -0.25, -0.5, -0.25, 0.25, 0.5, 0.25 }
	}

	local slamp_cbox = {
		type = "fixed",
		fixed = { -0.25, -0.5, -0.25, 0.25, 1.5, 0.25 }
	}

	local wool_brightened = "wool_grey.png^[colorize:#ffffff:"..(brightness_level * 15)

	homedecor.register("table_lamp_"..brightness_level, {
		description = S("Table Lamp/Light"),
		mesh = "homedecor_table_lamp.obj",
		tiles = {
			wool_brightened,
			{ name = gen_ls_tex_white, color = brightness_hex },
			{ name = "homedecor_generic_wood_red.png", color = 0xffffffff },
			{ name = "homedecor_generic_metal.png", color = homedecor.color_black },
		},
		inventory_image = "homedecor_table_lamp_foot_inv.png^homedecor_table_lamp_top_inv.png",
		paramtype = "light",
		paramtype2 = "color",
		palette = "unifieddyes_palette_extended.png",
		walkable = false,
		light_source = brightness_level,
		selection_box = tlamp_cbox,
		sounds = default.node_sound_wood_defaults(),
		groups = {cracky=2,oddly_breakable_by_hand=1, ud_param2_colorable = 1, not_in_creative_inventory=nici },
		drop = {
			items = {
				{items = {"homedecor:table_lamp_hi"}, inherit_color = true },
			}
		},
		digiline =      homedecor_lighting.digiline_alldir_light,
		mesecons =      homedecor_lighting.mesecon_wall_light,
		on_rightclick = homedecor_lighting.toggle_light,
		on_punch =      digiline_on_punch,
		on_dig = unifieddyes.on_dig,
	})

	homedecor.register("standing_lamp_"..brightness_level, {
		description = S("Standing Lamp/Light"),
		mesh = "homedecor_standing_lamp.obj",
		tiles = {
			wool_brightened,
			{ name = gen_ls_tex_white, color = brightness_hex },
			{ name = "homedecor_generic_wood_red.png", color = 0xffffffff },
			{ name = "homedecor_generic_metal.png", color = homedecor.color_black },
		},
		inventory_image = "homedecor_standing_lamp_foot_inv.png^homedecor_standing_lamp_top_inv.png",
		paramtype = "light",
		paramtype2 = "color",
		palette = "unifieddyes_palette_extended.png",
		walkable = false,
		light_source = brightness_level,
		groups = {cracky=2,oddly_breakable_by_hand=1, ud_param2_colorable = 1, not_in_creative_inventory=nici },
		selection_box = slamp_cbox,
		sounds = default.node_sound_wood_defaults(),
		on_rotate = minetest.get_modpath("screwdriver") and screwdriver.rotate_simple or nil,
		--expand = { top="air" },
		drop = {
			items = {
				{items = {"homedecor:standing_lamp_hi"}, inherit_color = true },
			}
		},
		digiline =      homedecor_lighting.digiline_alldir_light,
		mesecons =      homedecor_lighting.mesecon_wall_light,
		on_rightclick = homedecor_lighting.toggle_light,
		on_punch =      digiline_on_punch,
		on_dig = unifieddyes.on_dig,
	})
end

------------------------------------------
-- Simple non-dimmable, on/off-only lights

for _, light_brightn_name in ipairs({"off", "on"}) do

	local onflag = (light_brightn_name == "on")
	local nici = (light_brightn_name == "off") and 1 or nil
	local nici_m = (light_brightn_name == "off") and 1 or nil
	local on_rc = homedecor_lighting.toggle_light
	local di = "on"

	if hd_mesecons then
		nici_m = (light_brightn_name ~= "off") and 1 or nil
		on_rc = nil
		di = "off"
	end

	local gen_ls_tex_white =           "homedecor_generic_light_source_off.png"
	if onflag then gen_ls_tex_white =  "homedecor_generic_light_source_white.png" end

	local gen_ls_tex_yellow =          "homedecor_generic_light_source_off.png"
	if onflag then gen_ls_tex_yellow = "homedecor_generic_light_source_yellow.png" end

	local lighttex = "homedecor_blanktile.png"
	if onflag then
		lighttex = {
			name = "homedecor_plasma_ball_streamers.png",
			animation={type="vertical_frames", aspect_w=48, aspect_h=48, length=2.0},
		}
	end

	homedecor.register("plasma_ball_"..light_brightn_name, {
		description = S("Plasma Ball/light"),
		mesh = "homedecor_plasma_ball.obj",
		tiles = {
			{ name = "homedecor_generic_plastic.png", color = homedecor.color_black },
			lighttex,
			"homedecor_plasma_ball_glass.png"
		},
		inventory_image = "homedecor_plasma_ball_inv.png",
		selection_box = {
			type = "fixed",
			fixed = { -0.1875, -0.5, -0.1875, 0.1875, 0, 0.1875 }
		},
		walkable = false,
		use_texture_alpha = true,
		light_source = onflag and (default.LIGHT_MAX - 5) or nil,
		sunlight_propagates = true,
		groups = {cracky=3, oddly_breakable_by_hand=3, not_in_creative_inventory = nici},
		sounds = default.node_sound_glass_defaults(),
		on_rightclick = homedecor_lighting.toggle_light,
		drop = {
			items = {
				{items = {"homedecor:plasma_ball_on"}},
			}
		},
		mesecons = homedecor_lighting.mesecon_alldir_light,
		digiline = homedecor_lighting.digiline_alldir_light,
		on_punch = digiline_on_punch
	})

	local wl_cbox = {
		type = "fixed",
		fixed = { -0.2, -0.5, 0, 0.2, 0.5, 0.5 },
	}

	-- rope lighting

	minetest.register_node(":homedecor:rope_light_on_floor_"..light_brightn_name, {
		description = S("Rope lighting (on floor)"),
		inventory_image =  "homedecor_rope_light_on_floor.png",
		paramtype = "light",
		light_source = word_to_bright[light_brightn_name],
		walkable = false,
		sunlight_propagates = true,
		tiles = { gen_ls_tex_white },
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {},
			connect_front = { -1/16, -8/16, -8/16, 1/16, -6/16, 1/16 },
			connect_left =  { -8/16, -8/16, -1/16, 1/16, -6/16, 1/16 },
			connect_back =  { -1/16, -8/16, -1/16, 1/16, -6/16, 8/16 },
			connect_right = { -1/16, -8/16, -1/16, 8/16, -6/16, 1/16 },
			disconnected_sides = {
				{ -6/16, -8/16, -6/16, -4/16, -6/16,  6/16 },
				{  4/16, -8/16, -6/16,  6/16, -6/16,  6/16 },
				{ -6/16, -8/16, -6/16,  6/16, -6/16, -4/16 },
				{ -6/16, -8/16,  4/16,  6/16, -6/16,  6/16 }
			},
		},
		connects_to = {
			"homedecor:rope_light_on_floor_on",
			"homedecor:rope_light_on_floor_off",
			"group:mesecon_conductor_craftable"
		},
		groups = {cracky=3, oddly_breakable_by_hand=3, not_in_creative_inventory = nici_m},
		sounds =  default.node_sound_stone_defaults(),
		drop = {
			items = {
				{items = {"homedecor:rope_light_on_floor_"..di} },
			}
		},
		on_rightclick = on_rc,
		mesecons = hd_mesecons and {
			conductor = {
				state = mesecon and (onflag and mesecon.state.on or mesecon.state.off),
				onstate =  "homedecor:rope_light_on_floor_on",
				offstate = "homedecor:rope_light_on_floor_off",
				rules = rules_alldir
			},
		} or nil,
	})

	minetest.register_node(":homedecor:rope_light_on_ceiling_"..light_brightn_name, {
		description = S("Rope lighting (on ceiling)"),
		inventory_image =  "homedecor_rope_light_on_ceiling.png",
		paramtype = "light",
		light_source = word_to_bright[light_brightn_name],
		walkable = false,
		sunlight_propagates = true,
		tiles = { gen_ls_tex_white },
		drawtype = "nodebox",
		node_box = {
			type = "connected",
			fixed = {},
			connect_front = { -1/16, 8/16, -8/16, 1/16, 6/16, 1/16 },
			connect_left =  { -8/16, 8/16, -1/16, 1/16, 6/16, 1/16 },
			connect_back =  { -1/16, 8/16, -1/16, 1/16, 6/16, 8/16 },
			connect_right = { -1/16, 8/16, -1/16, 8/16, 6/16, 1/16 },
			disconnected_sides = {
				{ -6/16, 8/16, -6/16, -4/16, 6/16,  6/16 },
				{  4/16, 8/16, -6/16,  6/16, 6/16,  6/16 },
				{ -6/16, 8/16, -6/16,  6/16, 6/16, -4/16 },
				{ -6/16, 8/16,  4/16,  6/16, 6/16,  6/16 }
			},
		},
		connects_to = {
			"homedecor:rope_light_on_ceiling_on",
			"homedecor:rope_light_on_ceiling_off",
			"group:mesecon_conductor_craftable"
		},
		groups = {cracky=3, oddly_breakable_by_hand=3, not_in_creative_inventory = nici_m},
		sounds =  default.node_sound_stone_defaults(),
		drop = {
			items = {
				{items = {"homedecor:rope_light_on_ceiling_"..di}},
			}
		},
		on_rightclick = on_rc,
		mesecons = hd_mesecons and {
			conductor = {
				state = mesecon and (onflag and mesecon.state.on or mesecon.state.off),
				onstate =  "homedecor:rope_light_on_ceiling_on",
				offstate = "homedecor:rope_light_on_ceiling_off",
				rules = rules_alldir
			},
		} or nil,
	})

	homedecor.register("wall_lamp_"..light_brightn_name, {
		description = S("Wall Lamp/light"),
		mesh = "homedecor_wall_lamp.obj",
		tiles = {
			{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey },
			homedecor.lux_wood,
			gen_ls_tex_yellow,
			"homedecor_generic_metal_wrought_iron.png"
		},
		use_texture_alpha = true,
		inventory_image = "homedecor_wall_lamp_inv.png",
		groups = {snappy=3, not_in_creative_inventory = nici},
		light_source = onflag and (default.LIGHT_MAX - 3) or nil,
		selection_box = wl_cbox,
		walkable = false,
		drop = {
			items = {
				{items = {"homedecor:wall_lamp_on"}},
			}
		},
		on_rightclick = homedecor_lighting.toggle_light,
		mesecons = homedecor_lighting.mesecon_alldir_light,
		digiline = homedecor_lighting.digiline_alldir_light,
		on_punch = digiline_on_punch
	})
end

-------------------------------------------------------
-- Light sources and other items that don't turn on/off

local tc_cbox = {
	type = "fixed",
	fixed = {
		{ -0.1875, -0.5, -0.1875, 0.1875, 0.375, 0.1875 },
	}
}

homedecor.register("candle", {
	description = S("Thick Candle"),
	mesh = "homedecor_candle_thick.obj",
	tiles = {
		'homedecor_candle_sides.png',
		{name="homedecor_candle_flame.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
	},
	inventory_image = "homedecor_candle_inv.png",
	selection_box = tc_cbox,
	walkable = false,
	groups = { snappy = 3 },
	light_source = default.LIGHT_MAX-4,
})

local c_cbox = {
	type = "fixed",
	fixed = {
		{ -0.125, -0.5, -0.125, 0.125, 0.05, 0.125 },
	}
}

homedecor.register("candle_thin", {
	description = S("Thin Candle"),
	mesh = "homedecor_candle_thin.obj",
	tiles = {
		'homedecor_candle_sides.png',
		{name="homedecor_candle_flame.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
	},
	inventory_image = "homedecor_candle_thin_inv.png",
	selection_box = c_cbox,
	walkable = false,
	groups = { snappy = 3 },
	light_source = default.LIGHT_MAX-4,
})

local cs_cbox = {
	type = "fixed",
	fixed = {
		{ -0.15625, -0.5, -0.15625, 0.15625, 0.3125, 0.15625 },
	}
}

homedecor.register("candlestick_wrought_iron", {
	description = S("Candlestick (wrought iron)"),
	mesh = "homedecor_candlestick.obj",
	tiles = {
		"homedecor_candle_sides.png",
		{name="homedecor_candle_flame.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		"homedecor_generic_metal_wrought_iron.png",
	},
	inventory_image = "homedecor_candlestick_wrought_iron_inv.png",
	selection_box = cs_cbox,
	walkable = false,
	groups = { snappy = 3 },
	light_source = default.LIGHT_MAX-4,
})

homedecor.register("candlestick_brass", {
	description = S("Candlestick (brass)"),
	mesh = "homedecor_candlestick.obj",
	tiles = {
		"homedecor_candle_sides.png",
		{name="homedecor_candle_flame.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		"homedecor_generic_metal_brass.png",
	},
	inventory_image = "homedecor_candlestick_brass_inv.png",
	selection_box = cs_cbox,
	walkable = false,
	groups = { snappy = 3 },
	light_source = default.LIGHT_MAX-4,
})

homedecor.register("wall_sconce", {
	description = S("Wall sconce"),
	mesh = "homedecor_wall_sconce.obj",
	tiles = {
		'homedecor_candle_sides.png',
		{name="homedecor_candle_flame.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}},
		'homedecor_wall_sconce_back.png',
		'homedecor_generic_metal_wrought_iron.png',
	},
	inventory_image = "homedecor_wall_sconce_inv.png",
	selection_box = {
		type = "fixed",
		fixed = { -0.1875, -0.25, 0.3125, 0.1875, 0.25, 0.5 }
	},
	walkable = false,
	groups = { snappy = 3 },
	light_source = default.LIGHT_MAX-4,
})

local ol_cbox = {
	type = "fixed",
	fixed = {
		{ -5/16, -8/16, -3/16, 5/16, 4/16, 3/16 },
	}
}

homedecor.register("oil_lamp", {
	description = S("Oil lamp/Light (hurricane)"),
	mesh = "homedecor_oil_lamp.obj",
	tiles = {
		"homedecor_generic_metal_brass.png",
		{ name = "homedecor_generic_metal.png", color = homedecor.color_black },
		{ name = "homedecor_generic_metal.png", color = 0xffa00000 },
		"homedecor_oil_lamp_wick.png",
		{ name = "homedecor_generic_metal.png", color = 0xffa00000 },
		"homedecor_oil_lamp_glass.png",
	},
	use_texture_alpha = true,
	inventory_image = "homedecor_oil_lamp_inv.png",
	selection_box = ol_cbox,
	walkable = false,
	groups = { snappy = 3 },
	light_source = default.LIGHT_MAX-3,
	sounds = default.node_sound_glass_defaults(),
})

homedecor.register("oil_lamp_tabletop", {
	description = S("Oil Lamp/Light (tabletop)"),
	mesh = "homedecor_oil_lamp_tabletop.obj",
	tiles = {"homedecor_oil_lamp_tabletop.png"},
	inventory_image = "homedecor_oil_lamp_tabletop_inv.png",
	selection_box = ol_cbox,
	collision_box = ol_cbox,
	groups = { snappy = 3 },
	light_source = default.LIGHT_MAX-3,
	sounds = default.node_sound_glass_defaults(),
})

local topchains_sbox = {
	type = "fixed",
	fixed = {
		{ -0.25, 0.35, -0.25, 0.25, 0.5, 0.25 },
		{ -0.1, -0.5, -0.1, 0.1, 0.4, 0.1 }
	}
}

minetest.register_node(":homedecor:chain_steel_top", {
	description = S("Hanging chain (ceiling mount, steel)"),
	drawtype = "mesh",
	mesh = "homedecor_chains_top.obj",
	tiles = {"basic_materials_chain_steel.png"},
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	paramtype = "light",
	inventory_image = "basic_materials_chain_steel_inv.png",
	groups = {cracky=3},
	selection_box = topchains_sbox,
})

minetest.register_node(":homedecor:chain_brass_top", {
	description = S("Hanging chain (ceiling mount, brass)"),
	drawtype = "mesh",
	mesh = "homedecor_chains_top.obj",
	tiles = {"basic_materials_chain_brass.png"},
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	paramtype = "light",
	inventory_image = "basic_materials_chain_brass_inv.png",
	groups = {cracky=3},
	selection_box = topchains_sbox,
})

minetest.register_node(":homedecor:chandelier_steel", {
	description = S("Chandelier (steel)"),
	paramtype = "light",
	light_source = 12,
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	tiles = {
		"basic_materials_chain_steel.png",
		"homedecor_candle_flat.png",
		{
			name="homedecor_candle_flame.png",
			animation={
				type="vertical_frames",
				aspect_w=16,
				aspect_h=16,
				length=3.0
			}
		}
	},
	drawtype = "mesh",
	mesh = "homedecor_chandelier.obj",
	groups = {cracky=3},
	sounds =  default.node_sound_stone_defaults(),
})

minetest.register_node(":homedecor:chandelier_brass", {
	description = S("Chandelier (brass)"),
	paramtype = "light",
	light_source = 12,
	walkable = false,
	climbable = true,
	sunlight_propagates = true,
	tiles = {
		"basic_materials_chain_brass.png",
		"homedecor_candle_flat.png",
		{
			name="homedecor_candle_flame.png",
			animation={
				type="vertical_frames",
				aspect_w=16,
				aspect_h=16,
				length=3.0
			}
		}
	},
	drawtype = "mesh",
	mesh = "homedecor_chandelier.obj",
	groups = {cracky=3},
	sounds =  default.node_sound_stone_defaults(),
})

homedecor.register("torch_wall", {
	description = S("Wall Torch"),
	mesh = "forniture_torch.obj",
	tiles = {
		{
			name="forniture_torch_flame.png",
			animation={
				type="vertical_frames",
				aspect_w=40,
				aspect_h=40,
				length=1.0,
			},
		},
		{ name = "homedecor_generic_metal.png", color = homedecor.color_black },
		{ name = "homedecor_generic_metal.png", color = homedecor.color_med_grey },
		"forniture_coal.png",
	},
	inventory_image="forniture_torch_inv.png",
	walkable = false,
	light_source = 14,
	selection_box = {
		type = "fixed",
		fixed = { -0.15, -0.45, 0.15, 0.15,0.35, 0.5 },
	},
	groups = {cracky=3},
})

-- table lamps and standing lamps

local lamp_colors = {
	"white",
	"blue",
	"green",
	"pink",
	"red",
	"violet",
}

-- conversion LBM for param2 coloring

homedecor_lighting.old_static_nodes = {
	"homedecor:glowlight_quarter_white",
	"homedecor:glowlight_quarter_yellow",
	"homedecor:glowlight_half_white",
	"homedecor:glowlight_half_yellow",
	"homedecor:glowlight_small_cube_white",
	"homedecor:glowlight_small_cube_yellow"
}

local lamp_power = {"off", "low", "med", "hi", "max"}

for _, power in ipairs(lamp_power) do
	for _, color in ipairs(lamp_colors) do
		table.insert(homedecor_lighting.old_static_nodes, "homedecor:table_lamp_"..color.."_"..power)
		table.insert(homedecor_lighting.old_static_nodes, "homedecor:standing_lamp_"..color.."_"..power)
	end
end

minetest.register_lbm({
	name = ":homedecor:convert_lighting",
	label = "Convert homedecor glowlights, table lamps, and standing lamps to use param2 color",
	run_at_every_load = false,
	nodenames = homedecor_lighting.old_static_nodes,
	action = function(pos, node)
		local name = node.name
		local newname
		local color

		if string.find(name, "small_cube") then
			newname = "homedecor:glowlight_small_cube"
		elseif string.find(name, "glowlight_half") then
			newname = "homedecor:glowlight_half"
		elseif string.find(name, "glowlight_quarter") then
			newname = "homedecor:glowlight_quarter"
		end

		local lampname
		if string.find(name, "standing_lamp") then
			lampname = "homedecor:standing_lamp"
		elseif string.find(name, "table_lamp") then
			lampname = "homedecor:table_lamp"
		end
		if lampname then
			newname = lampname
			if string.find(name, "_off") then
				newname = newname.."_off"
			elseif string.find(name, "_low") then
				newname = newname.."_low"
			elseif string.find(name, "_med") then
				newname = newname.."_med"
			elseif string.find(name, "_hi") then
				newname = newname.."_hi"
			elseif string.find(name, "_max") then
				newname = newname.."_max"
			end
		end

		if string.find(name, "red") then
			color = "red"
		elseif string.find(name, "pink") then
			color = "pink"
		elseif string.find(name, "green") then
			color = "green"
		elseif string.find(name, "blue") then
			color = "blue"
		elseif string.find(name, "yellow") then
			color = "yellow"
		elseif string.find(name, "violet") then
			color = "violet"
		else
			color = "white"
		end

		local paletteidx, _ = unifieddyes.getpaletteidx("unifieddyes:"..color, "extended")

		local old_fdir
		local new_node = newname
		local new_fdir = 1
		local param2

		if string.find(name, "glowlight") then
			paletteidx, _ = unifieddyes.getpaletteidx("unifieddyes:"..color, "wallmounted")

			old_fdir = math.floor(node.param2 / 4)

			if old_fdir == 5 then
				new_fdir = 0
			elseif old_fdir == 1 then
				new_fdir = 5
			elseif old_fdir == 2 then
				new_fdir = 4
			elseif old_fdir == 3 then
				new_fdir = 3
			elseif old_fdir == 4 then
				new_fdir = 2
			elseif old_fdir == 0 then
				new_fdir = 1
			end
			param2 = paletteidx + new_fdir
		else
			param2 = paletteidx
		end

		local meta = minetest.get_meta(pos)

		if string.find(name, "table_lamp") or string.find(name, "standing_lamp") then
			meta:set_string("palette", "ext")
		end

		minetest.set_node(pos, { name = new_node, param2 = param2 })
		meta:set_string("dye", "unifieddyes:"..color)
	end
})

-- this one's for the small "gooseneck" desk lamps

homedecor_lighting.old_static_desk_lamps = {
	"homedecor:desk_lamp_red",
	"homedecor:desk_lamp_blue",
	"homedecor:desk_lamp_green",
	"homedecor:desk_lamp_violet",
}

minetest.register_lbm({
	name = ":homedecor:convert_desk_lamps",
	label = "Convert homedecor desk lamps to use param2 color",
	run_at_every_load = false,
	nodenames = homedecor_lighting.old_static_desk_lamps,
	action = function(pos, node)
		local name = node.name
		local color = string.sub(name, string.find(name, "_", -8) + 1)

		if color == "green" then
			color = "medium_green"
		elseif color == "violet" then
			color = "magenta"
		end

		local paletteidx, _ = unifieddyes.getpaletteidx("unifieddyes:"..color, "wallmounted")
		local old_fdir = math.floor(node.param2 % 32)
		local new_fdir = 3

		if old_fdir == 0 then
			new_fdir = 3
		elseif old_fdir == 1 then
			new_fdir = 4
		elseif old_fdir == 2 then
			new_fdir = 2
		elseif old_fdir == 3 then
			new_fdir = 5
		end

		local param2 = paletteidx + new_fdir

		minetest.set_node(pos, { name = "homedecor:desk_lamp", param2 = param2 })
		local meta = minetest.get_meta(pos)
		meta:set_string("dye", "unifieddyes:"..color)
	end
})



-- crafting

minetest.register_craft({
	output = 'homedecor:chain_steel_top',
	recipe = {
		{'default:steel_ingot'},
		{'basic_materials:chainlink_steel'},
	},
})

minetest.register_craft({
	output = 'homedecor:chandelier_steel',
	recipe = {
		{'', 'basic_materials:chainlink_steel', ''},
		{'default:torch', 'basic_materials:chainlink_steel', 'default:torch'},
		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
	}
})

-- brass versions

minetest.register_craft({
	output = 'homedecor:chain_brass_top',
	recipe = {
		{'basic_materials:brass_ingot'},
		{'basic_materials:chainlink_brass'},
	},
})

minetest.register_craft({
	output = 'homedecor:chandelier_brass',
	recipe = {
		{'', 'basic_materials:chainlink_brass', ''},
		{'default:torch', 'basic_materials:chainlink_brass', 'default:torch'},
		{'basic_materials:brass_ingot', 'basic_materials:brass_ingot', 'basic_materials:brass_ingot'},
	}
})

-- candles

minetest.register_craft({
	output = "homedecor:candle_thin 4",
	recipe = {
		{"farming:string" },
		{"basic_materials:paraffin" }
	}
})

minetest.register_craft({
	output = "homedecor:candle 2",
	recipe = {
		{"farming:string" },
		{"basic_materials:paraffin" },
		{"basic_materials:paraffin" }
	}
})

minetest.register_craft({
	output = "homedecor:wall_sconce 2",
	recipe = {
		{"default:iron_lump", "", ""},
		{"default:iron_lump", "homedecor:candle", ""},
		{"default:iron_lump", "", ""},
	}
})

minetest.register_craft({
	output = "homedecor:candlestick_wrought_iron",
	recipe = {
		{""},
		{"homedecor:candle_thin"},
		{"default:iron_lump"},
	}
})

minetest.register_craft({
	output = "homedecor:candlestick_brass",
	recipe = {
		{""},
		{"homedecor:candle_thin"},
		{"basic_materials:brass_ingot"},
	}
})

minetest.register_craft({
	output = "homedecor:oil_lamp",
	recipe = {
		{ "", "vessels:glass_bottle", "" },
		{ "", "farming:string", "" },
		{ "default:steel_ingot", "basic_materials:oil_extract", "default:steel_ingot" }
	}
})

minetest.register_craft({
	output = "homedecor:oil_lamp_tabletop",
	recipe = {
		{ "", "vessels:glass_bottle", "" },
		{ "", "farming:string", "" },
		{ "default:iron_lump", "basic_materials:oil_extract", "default:iron_lump" }
	}
})

-- Wrought-iron wall latern

minetest.register_craft({
	output = "homedecor:ground_lantern",
	recipe = {
		{ "default:iron_lump", "default:iron_lump", "default:iron_lump" },
		{ "default:iron_lump", "default:torch", "default:iron_lump" },
		{ "", "default:iron_lump", "" }
	}
})

-- wood-lattice lamps

if minetest.get_modpath("darkage") then
	minetest.register_craft( {
		output = "homedecor:lattice_lantern_small 8",
		recipe = {
			{ "darkage:lamp" },
		},
	})

	minetest.register_craft( {
		output = "darkage:lamp",
		type = "shapeless",
		recipe = {
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
		},
	})
else
	minetest.register_craft( {
			output = "homedecor:lattice_lantern_large 2",
			recipe = {
				{ "dye:black", "dye:yellow", "dye:black" },
				{ "group:stick", "building_blocks:woodglass", "group:stick" },
				{ "group:stick", "basic_materials:energy_crystal_simple", "group:stick" }
			},
	})

	minetest.register_craft( {
		output = "homedecor:lattice_lantern_small 8",
		recipe = {
			{ "homedecor:lattice_lantern_large" },
		},
	})

	minetest.register_craft( {
		output = "homedecor:lattice_lantern_large",
		type = "shapeless",
		recipe = {
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
			"homedecor:lattice_lantern_small",
		},
	})
end

-- glowlights

minetest.register_craft({
	output = "homedecor:glowlight_half 6",
	recipe = {
		{ "default:glass", "basic_materials:energy_crystal_simple", "default:glass", },
	}
})

minetest.register_craft({
        output = "homedecor:glowlight_half 6",
        recipe = {
		{"moreblocks:super_glow_glass", "moreblocks:glow_glass", "moreblocks:super_glow_glass", },
	}
})

minetest.register_craft({
        output = "homedecor:glowlight_half",
        recipe = {
		{"homedecor:glowlight_small_cube","homedecor:glowlight_small_cube"},
		{"homedecor:glowlight_small_cube","homedecor:glowlight_small_cube"}
	}
})

minetest.register_craft({
		output = "homedecor:glowlight_half",
		type = "shapeless",
		recipe = {
		"homedecor:glowlight_quarter",
		"homedecor:glowlight_quarter"
	}
})

unifieddyes.register_color_craft({
	output = "homedecor:glowlight_half",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "homedecor:glowlight_half",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
        output = "homedecor:glowlight_quarter 6",
        recipe = {
		{"homedecor:glowlight_half", "homedecor:glowlight_half", "homedecor:glowlight_half", },
	}
})

unifieddyes.register_color_craft({
	output = "homedecor:glowlight_quarter",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "homedecor:glowlight_quarter",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
	output = "homedecor:glowlight_small_cube 8",
	recipe = {
		{ "dye:white" },
		{ "default:glass" },
		{ "basic_materials:energy_crystal_simple" },
	}
})

minetest.register_craft({
        output = "homedecor:glowlight_small_cube 8",
        recipe = {
		{"dye:white" },
		{"moreblocks:super_glow_glass" },
	}
})

minetest.register_craft({
        output = "homedecor:glowlight_small_cube 4",
        recipe = {
		{"homedecor:glowlight_half" },
	}
})

unifieddyes.register_color_craft({
	output = "homedecor:glowlight_small_cube",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "homedecor:glowlight_small_cube",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

----

minetest.register_craft({
    output = "homedecor:plasma_lamp",
    recipe = {
		{"", "default:glass", ""},
		{"default:glass", "basic_materials:energy_crystal_simple", "default:glass"},
		{"", "default:glass", ""}
	}
})

minetest.register_craft({
    output = "homedecor:plasma_ball 2",
    recipe = {
		{"", "default:glass", ""},
		{"default:glass", "default:copper_ingot", "default:glass"},
		{"basic_materials:plastic_sheet", "basic_materials:energy_crystal_simple", "basic_materials:plastic_sheet"}
	}
})


minetest.register_craft({
	output = "homedecor:desk_lamp 2",
	recipe = {
		{ "", "default:steel_ingot", "homedecor:glowlight_small_cube" },
		{ "", "basic_materials:steel_strip", "" },
		{ "basic_materials:plastic_sheet", "basic_materials:copper_wire", "basic_materials:plastic_sheet" },
	},
})

unifieddyes.register_color_craft({
	output = "homedecor:desk_lamp",
	palette = "wallmounted",
	type = "shapeless",
	neutral_node = "homedecor:desk_lamp",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
	output = "homedecor:hanging_lantern 2",
	recipe = {
		{ "default:iron_lump", "default:iron_lump", "" },
		{ "default:iron_lump", "homedecor:lattice_lantern_large", "" },
		{ "default:iron_lump", "", "" },
	},
})

minetest.register_craft({
	output = "homedecor:ceiling_lantern 2",
	recipe = {
		{ "default:iron_lump", "default:iron_lump", "default:iron_lump" },
		{ "default:iron_lump", "homedecor:lattice_lantern_large", "default:iron_lump" },
		{ "", "default:iron_lump", "" },
	},
})

minetest.register_craft({
	output = "homedecor:wall_lamp 2",
	recipe = {
		{ "", "homedecor:lattice_lantern_large", "" },
		{ "default:iron_lump", "group:stick", "" },
		{ "default:iron_lump", "group:stick", "" },
	},
})

minetest.register_craft({
	output = "homedecor:ceiling_lamp",
	recipe = {
		{ "", "basic_materials:brass_ingot", ""},
		{ "", "basic_materials:chainlink_brass", ""},
		{ "default:glass", "homedecor:glowlight_small_cube", "default:glass"}
	},
})

minetest.register_craft({
	output = "homedecor:ceiling_lamp",
	recipe = {
		{ "", "basic_materials:chain_steel_top_brass", ""},
		{ "default:glass", "homedecor:glowlight_small_cube", "default:glass"}
	},
})

minetest.register_craft({
	output = "homedecor:standing_lamp_hi",
	recipe = {
		{"homedecor:table_lamp_hi"},
		{"group:stick"},
		{"group:stick"},
	},
})

unifieddyes.register_color_craft({
	output = "homedecor:standing_lamp_hi",
	palette = "extended",
	type = "shapeless",
	neutral_node = "homedecor:standing_lamp_hi",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})

minetest.register_craft({
	type = "fuel",
	recipe = "homedecor:table_lamp_hi",
	burntime = 10,
})

minetest.register_craft({
	output = "homedecor:table_lamp_hi",
	recipe = {
		{ "wool:white", "default:torch", "wool:white"},
		{ "", "group:stick", ""},
		{ "", "stairs:slab_wood", "" },
	},
})

minetest.register_craft({
	output = "homedecor:table_lamp_hi",
	recipe = {
		{ "cottages:wool", "default:torch", "cottages:wool"},
		{ "", "group:stick", ""},
		{ "", "stairs:slab_wood", "" },
	},
})

minetest.register_craft({
	output = "homedecor:table_lamp_hi",
	recipe = {
		{ "wool:white", "default:torch", "wool:white"},
		{ "", "group:stick", ""},
		{ "", "moreblocks:slab_wood", "" },
	},
})

minetest.register_craft({
	output = "homedecor:table_lamp_hi",
	recipe = {
		{ "cottages:wool", "default:torch", "cottages:wool"},
		{ "", "group:stick", ""},
		{ "", "moreblocks:slab_wood", "" },
	},
})

unifieddyes.register_color_craft({
	output = "homedecor:table_lamp_hi",
	palette = "extended",
	type = "shapeless",
	neutral_node = "homedecor:table_lamp_hi",
	recipe = {
		"NEUTRAL_NODE",
		"MAIN_DYE"
	}
})


minetest.register_craft({
	output = "homedecor:torch_wall 10",
	recipe = {
		{ "default:coal_lump" },
		{ "default:steel_ingot" },
	},
})
-- aliases

minetest.register_alias("chains:chain_top",                    "homedecor:chain_steel_top")
minetest.register_alias("chains:chain_top_brass",              "homedecor:chain_brass_top")

minetest.register_alias("chains:chandelier",                   "homedecor:chandelier_steel")
minetest.register_alias("chains:chandelier_steel",             "homedecor:chandelier_steel")
minetest.register_alias("chains:chandelier_brass",             "homedecor:chandelier_brass")

minetest.register_alias("homedecor:glowlight_half",            "homedecor:glowlight_half_14")
minetest.register_alias("homedecor:glowlight_half_max",        "homedecor:glowlight_half_14")

minetest.register_alias("homedecor:glowlight_quarter",         "homedecor:glowlight_quarter_14")
minetest.register_alias("homedecor:glowlight_quarter_max",     "homedecor:glowlight_quarter_14")

minetest.register_alias("homedecor:glowlight_small_cube",      "homedecor:glowlight_small_cube_14")
minetest.register_alias("homedecor:glowlight_small_cube_max",  "homedecor:glowlight_small_cube_14")

minetest.register_alias("homedecor:plasma_lamp",               "homedecor:plasma_lamp_14")
minetest.register_alias("homedecor:plasma_lamp_max",           "homedecor:plasma_lamp_14")

minetest.register_alias("homedecor:ground_lantern",            "homedecor:ground_lantern_14")
minetest.register_alias("homedecor:ground_lantern_max",        "homedecor:ground_lantern_14")

minetest.register_alias("homedecor:hanging_lantern",           "homedecor:hanging_lantern_14")
minetest.register_alias("homedecor:hanging_lantern_max",       "homedecor:hanging_lantern_14")

minetest.register_alias("homedecor:ceiling_lantern",           "homedecor:ceiling_lantern_14")
minetest.register_alias("homedecor:ceiling_lantern_max",       "homedecor:ceiling_lantern_14")

minetest.register_alias("homedecor:lattice_lantern_large",     "homedecor:lattice_lantern_large_14")
minetest.register_alias("homedecor:lattice_lantern_large_max", "homedecor:lattice_lantern_large_14")

minetest.register_alias("homedecor:lattice_lantern_small",     "homedecor:lattice_lantern_small_14")
minetest.register_alias("homedecor:lattice_lantern_small_max", "homedecor:lattice_lantern_small_14")

minetest.register_alias("homedecor:desk_lamp",                 "homedecor:desk_lamp_14")
minetest.register_alias("homedecor:desk_lamp_max",             "homedecor:desk_lamp_14")

minetest.register_alias("homedecor:ceiling_lamp",              "homedecor:ceiling_lamp_14")
minetest.register_alias("homedecor:ceiling_lamp_max",          "homedecor:ceiling_lamp_14")

minetest.register_alias("homedecor:table_lamp",                "homedecor:table_lamp_14")
minetest.register_alias("homedecor:table_lamp_max",            "homedecor:table_lamp_14")

minetest.register_alias("homedecor:standing_lamp",             "homedecor:standing_lamp_14")
minetest.register_alias("homedecor:standing_lamp_max",         "homedecor:standing_lamp_14")

minetest.register_alias("3dforniture:table_lamp",              "homedecor:table_lamp_14")
minetest.register_alias("3dforniture:table_lamp_max",          "homedecor:table_lamp_14")

minetest.register_alias("3dforniture:torch_wall",              "homedecor:torch_wall")
minetest.register_alias("torch_wall",                          "homedecor:torch_wall")

minetest.register_alias("homedecor:plasma_ball",               "homedecor:plasma_ball_on")
minetest.register_alias("homedecor:wall_lamp",                 "homedecor:wall_lamp_on")

minetest.register_alias("homedecor:rope_light_on_floor_0",     "homedecor:rope_light_on_floor_off")
minetest.register_alias("homedecor:rope_light_on_floor_14",    "homedecor:rope_light_on_floor_on")

minetest.register_alias("homedecor:rope_light_on_ceiling_0",   "homedecor:rope_light_on_ceiling_off")
minetest.register_alias("homedecor:rope_light_on_ceiling_14",  "homedecor:rope_light_on_ceiling_on")

for name, level in pairs(word_to_bright) do
	minetest.register_alias("homedecor:glowlight_half_"..name,        "homedecor:glowlight_half_"..level)
	minetest.register_alias("homedecor:glowlight_quarter_"..name,     "homedecor:glowlight_quarter_"..level)
	minetest.register_alias("homedecor:glowlight_small_cube_"..name,  "homedecor:glowlight_small_cube_"..level)
	minetest.register_alias("homedecor:rope_light_on_floor_"..name,   "homedecor:rope_light_on_floor_"..level)
	minetest.register_alias("homedecor:rope_light_on_ceiling_"..name, "homedecor:rope_light_on_ceiling_"..level)
	minetest.register_alias("homedecor:plasma_lamp_"..name,           "homedecor:plasma_lamp_"..level)
	minetest.register_alias("homedecor:plasma_ball_"..name,           "homedecor:plasma_ball_"..level)
	minetest.register_alias("homedecor:ground_lantern_"..name,        "homedecor:ground_lantern_"..level)
	minetest.register_alias("homedecor:hanging_lantern_"..name,       "homedecor:hanging_lantern_"..level)
	minetest.register_alias("homedecor:ceiling_lantern_"..name,       "homedecor:ceiling_lantern_"..level)
	minetest.register_alias("homedecor:lattice_lantern_large_"..name, "homedecor:lattice_lantern_large_"..level)
	minetest.register_alias("homedecor:lattice_lantern_small_"..name, "homedecor:lattice_lantern_small_"..level)
	minetest.register_alias("homedecor:desk_lamp_"..name,             "homedecor:desk_lamp_"..level)
	minetest.register_alias("homedecor:ceiling_lamp_"..name,          "homedecor:ceiling_lamp_"..level)
	minetest.register_alias("homedecor:table_lamp_"..name,            "homedecor:table_lamp_"..level)
	minetest.register_alias("homedecor:standing_lamp_"..name,         "homedecor:standing_lamp_"..level)
	minetest.register_alias("3dforniture:table_lamp_"..name,          "homedecor:table_lamp_"..level)
end

if minetest.get_modpath("darkage") then
	minetest.register_alias("homedecor:lattice_lantern_large",        "darkage:lamp")
	for n = 0, 14 do
		minetest.register_alias("homedecor:lattice_lantern_large_"..n, "darkage:lamp")
	end
	for name, level in pairs(word_to_bright) do
		minetest.register_alias("homedecor:lattice_lantern_large_"..name, "darkage:lamp")
	end
end


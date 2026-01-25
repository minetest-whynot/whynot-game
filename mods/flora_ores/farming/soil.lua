
local S = core.get_translator("farming")

-- default dry soil node

local dry_soil = "farming:soil"

-- add soil types to existing dirt blocks

core.override_item("default:dirt", {
	soil = {
		base = "default:dirt", dry = "farming:soil", wet = "farming:soil_wet"
	}
})

core.override_item("default:dirt_with_grass", {
	soil = {
		base = "default:dirt_with_grass", dry = "farming:soil", wet = "farming:soil_wet"
	}
})

if core.registered_nodes["default:dirt_with_dry_grass"] then

	core.override_item("default:dirt_with_dry_grass", {
		soil = {
			base = "default:dirt_with_dry_grass", dry = "farming:soil",
			wet = "farming:soil_wet"
		}
	})
end

core.override_item("default:dirt_with_rainforest_litter", {
	soil = {
		base = "default:dirt_with_rainforest_litter", dry = "farming:soil",
		wet = "farming:soil_wet"
	}
})

if core.registered_nodes["default:dirt_with_coniferous_litter"] then

	core.override_item("default:dirt_with_coniferous_litter", {
		soil = {
			base = "default:dirt_with_coniferous_litter", dry = "farming:soil",
			wet = "farming:soil_wet"
		}
	})
end

-- savanna soil

if core.registered_nodes["default:dry_dirt"] then

	core.override_item("default:dry_dirt", {
		soil = {
			base = "default:dry_dirt", dry = "farming:dry_soil",
			wet = "farming:dry_soil_wet"
		}
	})

	core.override_item("default:dry_dirt_with_dry_grass", {
		soil = {
			base = "default:dry_dirt_with_dry_grass", dry = "farming:dry_soil",
			wet = "farming:dry_soil_wet"
		}
	})

	core.register_node("farming:dry_soil", {
		description = S("Savanna Soil"),
		tiles = {
			"default_dry_dirt.png^farming_soil.png",
			"default_dry_dirt.png"
		},
		drop = "default:dry_dirt",
		groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 2, grassland = 1,
				field = 1},
		is_ground_content = false,
		sounds = default.node_sound_dirt_defaults(),
		soil = {
			base = "default:dry_dirt", dry = "farming:dry_soil",
			wet = "farming:dry_soil_wet"
		}
	})

	core.register_node("farming:dry_soil_wet", {
		description = S("Wet Savanna Soil"),
		tiles = {
			"default_dry_dirt.png^farming_soil_wet.png",
			"default_dry_dirt.png^farming_soil_wet_side.png"
		},
		drop = "default:dry_dirt",
		groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 3, grassland = 1,
				field = 1},
		is_ground_content = false,
		sounds = default.node_sound_dirt_defaults(),
		soil = {
			base = "default:dry_dirt", dry = "farming:dry_soil",
			wet = "farming:dry_soil_wet"
		}
	})

	dry_soil = "farming:dry_soil"
end

-- normal soil

core.register_node("farming:soil", {
	description = S("Soil"),
	tiles = {"default_dirt.png^farming_soil.png", "default_dirt.png"},
	drop = "default:dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 2, grassland = 1,
			field = 1},
	is_ground_content = false,
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt", dry = "farming:soil", wet = "farming:soil_wet"
	}
})

-- wet soil

core.register_node("farming:soil_wet", {
	description = S("Wet Soil"),
	tiles = {
		"default_dirt.png^farming_soil_wet.png",
		"default_dirt.png^farming_soil_wet_side.png"
	},
	drop = "default:dirt",
	groups = {crumbly = 3, not_in_creative_inventory = 1, soil = 3, grassland = 1,
			field = 1},
	is_ground_content = false,
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "default:dirt", dry = "farming:soil", wet = "farming:soil_wet"
	}
})

-- sand is not soil, change existing sand-soil to use dry soil

core.register_alias("farming:desert_sand_soil", dry_soil)
core.register_alias("farming:desert_sand_soil_wet", dry_soil .. "_wet")

-- if water near soil then change to wet soil

core.register_abm({
	label = "Soil changes",
	nodenames = {"group:field"},
	interval = 15,
	chance = 4,
	catch_up = false,

	action = function(pos, node)

		local ndef = core.registered_nodes[node.name]
		if not ndef or not ndef.soil or not ndef.soil.wet
		or not ndef.soil.base or not ndef.soil.dry then return end

		pos.y = pos.y + 1
		local nn = core.get_node_or_nil(pos)
		pos.y = pos.y - 1

		if nn then nn = nn.name else return end

		-- what's on top of soil, if solid/not plant change soil to dirt
		if core.registered_nodes[nn]
		and core.registered_nodes[nn].walkable
		and core.get_item_group(nn, "plant") == 0
		and core.get_item_group(nn, "growing") == 0 then

			core.set_node(pos, {name = ndef.soil.base})

			return
		end

		-- check if water is within 3 nodes
		if core.find_node_near(pos, 3, {"group:water"}) then

			-- only change if it's not already wet soil
			if node.name ~= ndef.soil.wet then
				core.set_node(pos, {name = ndef.soil.wet})
			end

		-- only dry out soil if no unloaded blocks nearby, just incase
		elseif not core.find_node_near(pos, 3, {"ignore"}) then

			if node.name == ndef.soil.wet then
				core.set_node(pos, {name = ndef.soil.dry})

			-- if crop or seed found don't turn to dry soil
			elseif node.name == ndef.soil.dry
			and core.get_item_group(nn, "plant") == 0
			and core.get_item_group(nn, "growing") == 0 then
				core.set_node(pos, {name = ndef.soil.base})
			end
		end
	end
})

-- those darn weeds

if core.settings:get_bool("farming_disable_weeds") ~= true then

	core.register_abm({
		nodenames = {"group:field"},
		neighbors = {"air"},
		interval = 50,
		chance = 70,
		catch_up = false,

		action = function(pos, node)

			if core.find_node_near(pos, 8, {"farming:scarecrow_bottom"}) then
				return
			end

			pos.y = pos.y + 1

			if core.get_node(pos).name == "air" then
				core.set_node(pos, {name = "farming:weed", param2 = 10})
			end
		end
	})
end


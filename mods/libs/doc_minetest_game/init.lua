-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter(minetest.get_current_modname())
else
	S = function(s,a,...)a={a,...}return s:gsub("@(%d+)",function(n)return a[tonumber(n)]end)end
end

local groupdefs = {
	["book"] = S("Books"),
	["vessel"] = S("Vessels"),
	["dye"] = S("Dyes"),
	["stick"] = S("Sticks"),
	["wool"] = S("Wool"),
	["sand"] = S("Sand"),
	["wood"] = S("Wood"),
	["stone"] = S("Stones"),
	["metal"] = S("Metal"),
	["tree"] = S("Tree Trunks"),
	["fence"] = S("Fences"),
	["wall"] = S("Walls"),
	["leaves"] = S("Leaves and Needles"),
	["flower"] = S("Flowers"),
	["sapling"] = S("Saplings"),
	["water"] = S("Water"),
	["lava"] = S("Lava"),
	["coal"] = S("Coal"),
	["water_bucket"] = S("Water buckets"),
	["flora"] = S("Flora"),
	["snowy"] = S("Snowy"),

	["cracky"] = S("Cracky"),
	["crumbly"] = S("Crumbly"),
	["choppy"] = S("Choppy"),
	["snappy"] = S("Snappy"),
	["oddly_breakable_by_hand"] = S("Hand-breakable"),

	["fleshy"] = S("Flesh"),
}

local miscgroups = {
	"book",  -- for placing in bookshelf
	"vessel", -- for placing in vessels shelf
	"sand", -- for cactus growth ABM
	"flora", -- for the plant spreading ABM
	"sapling", -- for the sapling growth ABM
	"water", -- for the obsidian and farming ABMs
}

local forced_items = {
	"fire:basic_flame",
	"farming:wheat_8",
	"farming:cotton_8",
}

local suppressed_items = {
	"default:water_flowing",
	"default:river_water_flowing",
	"default:lava_flowing",
	"default:dry_grass_2",
	"default:dry_grass_3",
	"default:dry_grass_4",
	"default:dry_grass_5",
	"default:grass_2",
	"default:grass_3",
	"default:grass_4",
	"default:grass_5",
	"default:furnace_active",
	"doors:door_wood",
	"doors:door_steel",
	"doors:door_glass",
	"doors:door_obsidian_glass",
	"doors:door_wood_a",
	"doors:door_steel_a",
	"doors:door_glass_a",
	"doors:door_obsidian_glass_a",
	"doors:door_wood_b",
	"doors:door_steel_b",
	"doors:door_glass_b",
	"doors:door_obsidian_glass_b",
	"doors:gate_wood_open",
	"doors:gate_junglewood_open",
	"doors:gate_acacia_wood_open",
	"doors:gate_aspen_wood_open",
	"doors:gate_pine_wood_open",
	"doors:trapdoor_steel_open",
	"doors:trapdoor_open",
	"doors:hidden",
	"xpanes:pane",
	"xpanes:obsidian_pane",
	"xpanes:bar",
	"default:chest_open",
	"default:chest_locked_open",
}

local hidden_items = {
	"default:cloud",
	"default:dirt_with_grass_footsteps",
}

local item_name_overrides = {
	["screwdriver:screwdriver"] = S("Screwdriver"),
	["map:mapping_kit"] = S("Mapping Kit"),
	["binoculars:binoculars"] = S("Binoculars"),
	["carts:cart"] = S("Cart"),
	["fire:basic_flame"] = S("Basic Flame"),
	["farming:wheat_8"] = S("Wheat Plant"),
	["farming:cotton_8"] = S("Cotton Plant"),
	["default:lava_source"] = S("Lava"),
	["default:water_source"] = S("Water"),
	["default:river_water_source"] = S("River Water"),
	["doors:door_wood_a"] = minetest.registered_items["doors:door_wood"].description,
	["doors:door_steel_a"] = minetest.registered_items["doors:door_steel"].description,
	["doors:door_glass_a"] = minetest.registered_items["doors:door_glass"].description,
	["doors:door_obsidian_glass_a"] = minetest.registered_items["doors:door_obsidian_glass"].description,
}

local image_overrides = {
	["doors:door_wood_a"] = minetest.registered_items["doors:door_wood"].inventory_image,
	["doors:door_steel_a"] = minetest.registered_items["doors:door_steel"].inventory_image,
	["doors:door_glass_a"] = minetest.registered_items["doors:door_glass"].inventory_image,
	["doors:door_obsidian_glass_a"] = minetest.registered_items["doors:door_obsidian_glass"].inventory_image,
}

doc.sub.items.add_friendly_group_names(groupdefs)
doc.sub.items.add_notable_groups(miscgroups)

for i=1, #hidden_items do
	local item = minetest.registered_items[hidden_items[i]]
	if item then
		minetest.override_item(hidden_items[i], { _doc_items_hidden = true } )
	end
end
for i=1, #forced_items do
	local item = minetest.registered_items[forced_items[i]]
	if item then
		minetest.override_item(forced_items[i], { _doc_items_create_entry = true} )
	end
end
for i=1, #suppressed_items do
	local item = minetest.registered_items[suppressed_items[i]]
	if item then
		minetest.override_item(suppressed_items[i], { _doc_items_create_entry = false} )
	end
end
for itemstring, data in pairs(item_name_overrides) do
	if minetest.registered_items[itemstring] ~= nil then
		minetest.override_item(itemstring, { _doc_items_entry_name = data} )
	end
end
for itemstring, data in pairs(image_overrides) do
	if minetest.registered_items[itemstring] ~= nil then
		minetest.override_item(itemstring, { _doc_items_image = data} )
	end
end

-- Minetest Game Factoids

-- Lava cooling
local function f_cools_lava(itemstring, def)
	if def.groups.cools_lava ~= nil or def.groups.water ~= nil then
		return S("This block turns adjacent lava sources into obsidian and adjacent flowing lava into stone.")
	else
		return ""
	end
end

-- Groups flammable, puts_out_fire
local function f_fire(itemstring, def)
	local s = ""
	-- Fire
	if def.groups.flammable ~= nil then
		s = s .. S("This block is flammable.")
	end

	if def.groups.puts_out_fire ~= nil then
		if def.groups.flammable ~= nil then
			s = s .. "\n"
		end
		s = s .. S("This block will extinguish nearby fire.")
	end

	if def.groups.igniter ~= nil then
		if def.groups.flammable ~= nil or def.groups.puts_out_fire ~= nil then
			s = s .. "\n"
		end
		s = s .. S("This block will set flammable blocks within a radius of @1 on fire.", def.groups.igniter)
		if def.walkable == false then
			s = s .. S(" It also destroys flammable items which have been dropped inside.")
		end
	end
	return s
end

-- flora group
local function f_flora(itemstring, def)
	if def.groups.flora == 1 then
		local groupname = doc.sub.items.get_group_name("flora")
		-- Dry shrub rule not complete; flora dies on group:sand except default:sand. But that's okay.
		-- The missing nodes will be covered on their own entries by the f_and_dry_shrub factoid.
		return S("This block belongs to the @1 group. It a living organism which likes to grow and spread on dirt with grass and similar “soil”-type blocks when it is in light. Spreading will stop when the surrounding area is too crammed with @2 blocks. On silver sand and desert sand, it will wither and die and turn into a dry shrub.", groupname, groupname)
	else
		return ""
	end
end

-- sand nodes which turn flora blocks into dry shrub (e.g. silver sand, desert sand)
local function f_sand_dry_shrub(itemstring, def)
	if def.groups.sand == 1 and itemstring ~= "default:sand" then

		return S("Flowers and other blocks in the @1 group will slowly turn into dry shrubs when placed on this block.", doc.sub.items.get_group_name("flora"))
	else
		return ""
	end
end

-- soil group
local function f_soil(itemstring, def)
	if def.groups.soil == 1 then
		return S("This block serves as a soil for saplings and small plants. Blocks in the “@1” group will grow into trees. Blocks in the “@2” group will spread slowly.", doc.sub.items.get_group_name("sapling"), doc.sub.items.get_group_name("flora"))
	elseif def.groups.soil == 2 or def.groups.soil == 3 then
		return S("This block serves as a soil for saplings and other small plants as well as plants grown from seeds. It supports their growth.")
	else
		return ""
	end
end

local function f_leafdecay(itemstring, def)
	local formstring = ""
	if def.groups.leafdecay ~= nil then
		if def.groups.leafdecay_drop ~= nil then
			formstring = S("This block may drop as an item when there is no trunk or stem of its species within a distance of @1. Leaf decay does not occour when the block has been manually placed by a player.", def.groups.leafdecay)
		else
			if def.drop ~= "" and def.drop ~= nil and def.drop ~= itemstring then
				formstring = S("This block quickly decays when there is no trunk or stem block of its species within a distance of @1. When decaying, it disappears and may drop one of its mining drops (but not itself). The block does not decay when the block has been placed by a player.", def.groups.leafdecay)
			else
				formstring = S("This block quickly decays and disappears when there is no trunk or stem block of its species within a distance of @1. The block does not decay when the block has been placed by a player.", def.groups.leafdecay)
			end
		end
	end
	return formstring
end

local function f_spreading_dirt_type(itemstring, def)
	if def.groups.spreading_dirt_type then
		return S("Under sunlight, this block slowly spreads its dirt cover towards nearby dirt blocks. In the shadows, this block eventually loses its dirt cover and turns into plain dirt.")
	else
		return ""
	end
end

local function f_hoe_soil(itemstring, def)
	if def.soil then
		local name, node
		nodedef = minetest.registered_nodes[def.soil.dry]
		if nodedef then
			name = nodedef.description
		end
		if name then
			return S("This block can be turned into @1 with a hoe.", name)
		else
			return S("This block can be cultivated by a hoe.")
		end
	else
		return ""
	end
end

--[[ Node defines skeleton key and key callbacks which probably implies that
it can be unlocked by keys ]]
local function f_key(itemstring, def)
	if def.on_key_use and def.on_skeleton_key_use then
		return S("This block is compatible with keys.")
	else
		return ""
	end
end

doc.sub.items.register_factoid("nodes", "use", f_key)
doc.sub.items.register_factoid("nodes", "use", f_hoe_soil)
doc.sub.items.register_factoid("nodes", "groups", f_cools_lava)
doc.sub.items.register_factoid("nodes", "groups", f_fire)
doc.sub.items.register_factoid("nodes", "groups", f_flora)
doc.sub.items.register_factoid("nodes", "groups", f_sand_dry_shrub)
doc.sub.items.register_factoid("nodes", "groups", f_leafdecay)
doc.sub.items.register_factoid("nodes", "groups", f_soil)
doc.sub.items.register_factoid("nodes", "groups", f_spreading_dirt_type)

-- Add node aliases
for i=2,5 do
	doc.add_entry_alias("nodes", "default:grass_1", "nodes", "default:grass_"..i)
	doc.add_entry_alias("nodes", "default:dry_grass_1", "nodes", "default:dry_grass_"..i)
end
for i=1,7 do
	doc.add_entry_alias("nodes", "farming:wheat_8", "nodes", "farming:wheat_"..i)
	doc.add_entry_alias("nodes", "farming:cotton_8", "nodes", "farming:cotton_"..i)
end
doc.add_entry_alias("nodes", "default:lava_source", "nodes", "default:lava_flowing")
doc.add_entry_alias("nodes", "default:water_source", "nodes", "default:water_flowing")
doc.add_entry_alias("nodes", "default:river_water_source", "nodes", "default:river_water_flowing")
doc.add_entry_alias("nodes", "default:furnace", "nodes", "default:furnace_active")
doc.add_entry_alias("nodes", "default:torch", "nodes", "default:torch_wall")
doc.add_entry_alias("nodes", "default:torch", "nodes", "default:torch_ceiling")
doc.add_entry_alias("nodes", "doors:door_wood_fake", "craftitems", "doors:door_wood")
doc.add_entry_alias("nodes", "doors:door_steel_fake", "craftitems", "doors:door_steel")
doc.add_entry_alias("nodes", "doors:door_glass_fake", "craftitems", "doors:door_glass")
doc.add_entry_alias("nodes", "doors:door_obsidian_glass_fake", "craftitems", "doors:door_obsidian_glass")
doc.add_entry_alias("nodes", "doors:door_wood_fake", "nodes", "doors:door_wood_a")
doc.add_entry_alias("nodes", "doors:door_steel_fake", "nodes", "doors:door_steel_a")
doc.add_entry_alias("nodes", "doors:door_glass_fake", "nodes", "doors:door_glass_a")
doc.add_entry_alias("nodes", "doors:door_obsidian_glass_fake", "nodes", "doors:door_obsidian_glass_a")
doc.add_entry_alias("nodes", "doors:door_wood_fake", "nodes", "doors:door_wood_b")
doc.add_entry_alias("nodes", "doors:door_steel_fake", "nodes", "doors:door_steel_b")
doc.add_entry_alias("nodes", "doors:door_glass_fake", "nodes", "doors:door_glass_b")
doc.add_entry_alias("nodes", "doors:door_obsidian_glass_fake", "nodes", "doors:door_obsidian_glass_b")
doc.add_entry_alias("nodes", "doors:gate_wood_closed", "nodes", "doors:gate_wood_open")
doc.add_entry_alias("nodes", "doors:gate_junglewood_closed", "nodes", "doors:gate_junglewood_open")
doc.add_entry_alias("nodes", "doors:gate_acacia_wood_closed", "nodes", "doors:gate_acacia_wood_open")
doc.add_entry_alias("nodes", "doors:gate_aspen_wood_closed", "nodes", "doors:gate_aspen_wood_open")
doc.add_entry_alias("nodes", "doors:gate_pine_wood_closed", "nodes", "doors:gate_pine_wood_open")
doc.add_entry_alias("nodes", "doors:trapdoor", "nodes", "doors:trapdoor_open")
doc.add_entry_alias("nodes", "doors:trapdoor_steel", "nodes", "doors:trapdoor_steel_open")
doc.add_entry_alias("nodes", "tnt:tnt", "nodes", "tnt:tnt_burning")
doc.add_entry_alias("nodes", "tnt:gunpowder", "nodes", "tnt:gunpowder_burning")
doc.add_entry_alias("nodes", "xpanes:pane_flat", "nodes", "xpanes:pane")
doc.add_entry_alias("nodes", "xpanes:obsidian_pane_flat", "nodes", "xpanes:obsidian_pane")
doc.add_entry_alias("nodes", "xpanes:bar_flat", "nodes", "xpanes:bar")
doc.add_entry_alias("nodes", "default:chest", "nodes", "default:chest_open")
doc.add_entry_alias("nodes", "default:chest_locked", "nodes", "default:chest_locked_open")

-- Gather help texts
dofile(minetest.get_modpath("doc_minetest_game") .. "/helptexts.lua")

-- Register boat object for doc_identifier
if minetest.get_modpath("doc_identifier") ~= nil then
	doc.sub.identifier.register_object("boats:boat", "craftitems", "boats:boat")
	doc.sub.identifier.register_object("carts:cart", "craftitems", "carts:cart")
end


--[[ Completely create door entries from scratch. We suppressed all normal door entries
before. This is quite a hack, but required because of the weird way how door items are
implemented in Minetest Game.
CHECKME: As doors are sensitive, check this entire section after each Minetest Game release.
]]

local doors = { "doors:door_wood", "doors:door_steel", "doors:door_glass", "doors:door_obsidian_glass" }

for d=1, #doors do
	local door = doors[d]
	local def1 = table.copy(minetest.registered_items[door])
	local def2 = table.copy(minetest.registered_items[door.."_a"])

	def2._doc_items_image = def1.inventory_image
	def2.drop = nil
	def2.stack_max = def1.stack_max or minetest.nodedef_default.stack_max
	def2.liquidtype = "none"
	def2._doc_items_longdesc = def1._doc_items_longdesc
	def2._doc_items_usagehelp = def1._doc_items_usagehelp

	doc.add_entry("nodes", door.."_fake", {
		name = def2.description,
		hidden = def2._doc_items_hidden == true,
		data = {
			itemstring = door,
			longdesc = def2._doc_items_longdesc,
			usagehelp = def2._doc_items_usagehelp,
			def = def2
		}
	})
end

-- Remove the superficial “help” comment from screwdriver and cart description as redundant
minetest.override_item("screwdriver:screwdriver", {description = item_name_overrides["screwdriver:screwdriver"]})
minetest.override_item("carts:cart", {description = item_name_overrides["carts:cart"]})

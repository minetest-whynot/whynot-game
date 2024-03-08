
local S = mobs.translate
local FS = function(...) return minetest.formspec_escape(S(...)) end
local mc2 = minetest.get_modpath("mcl_core")

-- recipe items
local items = {
	paper = mc2 and "mcl_core:paper" or "default:paper",
	dye_black = mc2 and "mcl_dye:black" or "dye:black",
	string = mc2 and "mcl_mobitems:string" or "farming:string",
	stick = mc2 and "mcl_core:stick" or "default:stick",
	diamond = mc2 and "mcl_core:diamond" or "default:diamond",
	steel_ingot = mc2 and "mcl_core:iron_ingot" or "default:steel_ingot",
	gold_block = mc2 and "mcl_core:goldblock" or "default:goldblock",
	diamond_block = mc2 and "mcl_core:diamondblock" or "default:diamondblock",
	stone = mc2 and "mcl_core:stone" or "default:stone",
	mese_crystal = mc2 and "mcl_core:gold_ingot" or "default:mese_crystal",
	wood = mc2 and "mcl_core:wood" or "default:wood",
	fence_wood = mc2 and "group:fence_wood" or "default:fence_wood",
	meat_raw = mc2 and "mcl_mobitems:beef" or "group:food_meat_raw",
	meat_cooked = mc2 and "mcl_mobitems:cooked_beef" or "group:food_meat",
}

-- name tag
minetest.register_craftitem("mobs:nametag", {
	description = S("Name Tag"),
	inventory_image = "mobs_nametag.png",
	groups = {flammable = 2, nametag = 1}
})

minetest.register_craft({
	output = "mobs:nametag",
	recipe = {
		{ items.paper, items.dye_black, items.string }
	}
})

-- leather
minetest.register_craftitem("mobs:leather", {
	description = S("Leather"),
	inventory_image = "mobs_leather.png",
	groups = {flammable = 2, leather = 1}
})

-- raw meat
minetest.register_craftitem("mobs:meat_raw", {
	description = S("Raw Meat"),
	inventory_image = "mobs_meat_raw.png",
	on_use = minetest.item_eat(3),
	groups = {food_meat_raw = 1, flammable = 2}
})

-- cooked meat
minetest.register_craftitem("mobs:meat", {
	description = S("Meat"),
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(8),
	groups = {food_meat = 1, flammable = 2}
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:meat",
	recipe = "mobs:meat_raw",
	cooktime = 5
})

-- lasso
minetest.register_tool("mobs:lasso", {
	description = S("Lasso (right-click animal to put in inventory)"),
	inventory_image = "mobs_magic_lasso.png",
	groups = {flammable = 2}
})

minetest.register_craft({
	output = "mobs:lasso",
	recipe = {
		{ items.string, "", items.string},
		{ "", items.diamond, "" },
		{ items.string, "", items.string }
	}
})

minetest.register_alias("mobs:magic_lasso", "mobs:lasso")

-- net
minetest.register_tool("mobs:net", {
	description = S("Net (right-click animal to put in inventory)"),
	inventory_image = "mobs_net.png",
	groups = {flammable = 2}
})

minetest.register_craft({
	output = "mobs:net",
	recipe = {
		{ items.stick, "", items.stick },
		{ items.stick, "", items.stick },
		{ items.string, items.stick, items.string }
	}
})

-- shears (right click to shear animal)
minetest.register_tool("mobs:shears", {
	description = S("Steel Shears (right-click to shear)"),
	inventory_image = "mobs_shears.png",
	groups = {flammable = 2}
})

minetest.register_craft({
	output = "mobs:shears",
	recipe = {
		{ "", items.steel_ingot, "" },
		{ "", items.stick, items.steel_ingot }
	}
})

-- protection rune
minetest.register_craftitem("mobs:protector", {
	description = S("Mob Protection Rune"),
	inventory_image = "mobs_protector.png",
	groups = {flammable = 2}
})

minetest.register_craft({
	output = "mobs:protector",
	recipe = {
		{ items.stone, items.stone, items.stone },
		{ items.stone, items.gold_block, items.stone },
		{ items.stone, items.stone, items.stone }
	}
})

-- level 2 protection rune
minetest.register_craftitem("mobs:protector2", {
	description = S("Mob Protection Rune (Level 2)"),
	inventory_image = "mobs_protector2.png",
	groups = {flammable = 2}
})

minetest.register_craft({
	output = "mobs:protector2",
	recipe = {
		{ "mobs:protector", items.mese_crystal, "mobs:protector" },
		{ items.mese_crystal, items.diamond_block, items.mese_crystal },
		{ "mobs:protector", items.mese_crystal, "mobs:protector" }
	}
})

-- saddle
minetest.register_craftitem("mobs:saddle", {
	description = S("Saddle"),
	inventory_image = "mobs_saddle.png",
	groups = {flammable = 2, saddle = 1}
})

minetest.register_craft({
	output = "mobs:saddle",
	recipe = {
		{"mobs:leather", "mobs:leather", "mobs:leather"},
		{"mobs:leather", items.steel_ingot, "mobs:leather"},
		{"mobs:leather", items.steel_ingot, "mobs:leather"}
	}
})


-- make sure we can register fences
local mod_def = minetest.get_modpath("default")

if mod_def and default.register_fence then

-- mob fence (looks like normal fence but collision is 2 high)
default.register_fence("mobs:fence_wood", {
	description = S("Mob Fence"),
	texture = "default_wood.png",
	material = "default:fence_wood",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = mod_def and default.node_sound_wood_defaults(),
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 1.9, 0.5},
		}
	}
})
end

-- mob fence top (has enlarged collisionbox to stop mobs getting over)
minetest.register_node("mobs:fence_top", {
	description = S("Mob Fence Top"),
	drawtype = "nodebox",
	tiles = {"default_wood.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
	sounds = mod_def and default.node_sound_wood_defaults(),
	node_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.4, -1.5, -0.4, 0.4, 0, 0.4}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.4, -1.5, -0.4, 0.4, 0, 0.4}
	}
})

minetest.register_craft({
	output = "mobs:fence_top 12",
	recipe = {
		{"group:wood", "group:wood", "group:wood"},
		{"", items.fence_wood, ""}
	}
})


-- items that can be used as fuel
minetest.register_craft({
	type = "fuel",
	recipe = "mobs:nametag",
	burntime = 3
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:lasso",
	burntime = 7
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:net",
	burntime = 8
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:leather",
	burntime = 4
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:saddle",
	burntime = 7
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:fence_wood",
	burntime = 7
})

minetest.register_craft({
	type = "fuel",
	recipe = "mobs:fence_top",
	burntime = 2
})


-- this tool spawns same mob and adds owner, protected, nametag info
-- then removes original entity, this is used for fixing any issues.
-- also holding sneak while punching mob lets you change texture name.

local tex_obj

minetest.register_tool(":mobs:mob_reset_stick", {
	description = S("Mob Reset Stick"),
	inventory_image = "default_stick.png^[colorize:#ff000050",
	stack_max = 1,
	groups = {not_in_creative_inventory = 1},

	on_use = function(itemstack, user, pointed_thing)

		if pointed_thing.type ~= "object" then
			return
		end

		local obj = pointed_thing.ref

		local control = user:get_player_control()
		local sneak = control and control.sneak

		-- spawn same mob with saved stats, with random texture
		if obj and not sneak then

			local self = obj:get_luaentity()
			local obj2 = minetest.add_entity(obj:get_pos(), self.name)

			if obj2 then

				local ent2 = obj2:get_luaentity()

				ent2.protected = self.protected
				ent2.owner = self.owner
				ent2.nametag = self.nametag
				ent2.gotten = self.gotten
				ent2.tamed = self.tamed
				ent2.health = self.health
				ent2.order = self.order

				if self.child then
					obj2:set_velocity({x = 0, y = self.jump_height, z = 0})
				end

				obj2:set_properties({nametag = self.nametag})

				obj:remove()
			end
		end

		-- display form to enter texture name ending in .png
		if obj and sneak then

			tex_obj = obj

			-- get base texture
			local bt = tex_obj:get_luaentity().base_texture[1]

			if type(bt) ~= "string" then
				bt = ""
			end

			local name = user:get_player_name()

			minetest.show_formspec(name, "mobs_texture", "size[8,4]"
			.. "field[0.5,1;7.5,0;name;"
			.. FS("Enter texture:") .. ";" .. bt .. "]"
			.. "button_exit[2.5,3.5;3,1;mob_texture_change;"
			.. FS("Change") .. "]")
		end
	end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)

	-- right-clicked with nametag and name entered?
	if formname == "mobs_texture"
	and fields.name
	and fields.name ~= "" then

		-- does mob still exist?
		if not tex_obj
		or not tex_obj:get_luaentity() then
			return
		end

		-- make sure nametag is being used to name mob
		local item = player:get_wielded_item()

		if item:get_name() ~= "mobs:mob_reset_stick" then
			return
		end

		-- limit name entered to 64 characters long
		if fields.name:len() > 64 then
			fields.name = fields.name:sub(1, 64)
		end

		-- update texture
		local self = tex_obj:get_luaentity()

		self.base_texture = {fields.name}

		tex_obj:set_properties({textures = {fields.name}})

		-- reset external variable
		tex_obj = nil
	end
end)


-- Meat Block
minetest.register_node("mobs:meatblock", {
	description = S("Meat Block"),
	tiles = {"mobs_meat_top.png", "mobs_meat_bottom.png", "mobs_meat_side.png"},
	paramtype2 = "facedir",
	groups = {choppy = 1, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = mod_def and default.node_sound_leaves_defaults(),
	on_place = minetest.rotate_node,
	on_use = minetest.item_eat(20)
})

minetest.register_craft({
	output = "mobs:meatblock",
	recipe = {
		{ items.meat_cooked, items.meat_cooked, items.meat_cooked },
		{ items.meat_cooked, items.meat_cooked, items.meat_cooked },
		{ items.meat_cooked, items.meat_cooked, items.meat_cooked }
	}
})

-- Meat Block (raw)
minetest.register_node("mobs:meatblock_raw", {
	description = S("Raw Meat Block"),
	tiles = {"mobs_meat_raw_top.png", "mobs_meat_raw_bottom.png", "mobs_meat_raw_side.png"},
	paramtype2 = "facedir",
	groups = {choppy = 1, oddly_breakable_by_hand = 1, flammable = 2},
	sounds = mod_def and default.node_sound_leaves_defaults(),
	on_place = minetest.rotate_node,
	on_use = minetest.item_eat(20)
})

minetest.register_craft({
	output = "mobs:meatblock_raw",
	recipe = {
		{ items.meat_raw, items.meat_raw, items.meat_raw },
		{ items.meat_raw, items.meat_raw, items.meat_raw },
		{ items.meat_raw, items.meat_raw, items.meat_raw }
	}
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:meatblock",
	recipe = "mobs:meatblock_raw",
	cooktime = 30
})

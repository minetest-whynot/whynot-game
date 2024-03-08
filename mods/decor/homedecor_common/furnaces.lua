-- This code supplies an oven/stove. Basically it's just a copy of the default furnace with different textures.

local S = minetest.get_translator("homedecor_common")

local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then return end
	node.name = name
	minetest.swap_node(pos, node)
end

local function make_formspec(furnacedef, percent)
	local fire

	if percent and (percent > 0) then
		fire = ("%s^[lowpart:%d:%s"):format(
			furnacedef.fire_bg,
			(100-percent),
			furnacedef.fire_fg
		)
	else
		fire = "default_furnace_fire_bg.png"
	end

	local w = furnacedef.output_width
	local h = math.ceil(furnacedef.output_slots / furnacedef.output_width)

	return "size["..math.max(8, 6 + w)..",9]"..
		"image[2.75,1.5;1,1;"..fire.."]"..
		"list[current_name;fuel;2.75,2.5;1,1;]"..
		"list[current_name;src;2.75,0.5;1,1;]"..
		"list[current_name;dst;4.75,0.96;"..w..","..h..";]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"listring[current_name;dst]"..
		"listring[current_player;main]"..
		"listring[current_name;src]"..
		"listring[current_player;main]"
end

--[[
furnacedef = {
	description = "Oven",
	tiles = { ... },
	tiles_active = { ... },
	^ +Y -Y +X -X +Z -Z
	tile_format = "oven_%s%s.png",
	^ First '%s' replaced by one of "top", "bottom", "side", "front".
	^ Second '%s' replaced by "" for inactive, and "_active" for active "front"
	^ "side" is used for left, right and back.
	^ tiles_active for front is set
	output_slots = 4,
	output_width = 2,
	cook_speed = 1,
	^ Higher values cook stuff faster.
	extra_nodedef_fields = { ... },
	^ Stuff here is copied verbatim into both active and inactive nodedefs
	^ Useful for overriding drawtype, etc.
}
]]

local function make_tiles(tiles, fmt, active)
	if not fmt then return tiles end
	tiles = { }
	for i,side in ipairs{"top", "bottom", "side", "side", "side", "front"} do
		if active and (i == 6) then
			tiles[i] = fmt:format(side, "_active")
		else
			tiles[i] = fmt:format(side, "")
		end
	end
	return tiles
end

local furnace_can_dig = function(pos,player)
	local meta = minetest.get_meta(pos);
	local inv = meta:get_inventory()
	return inv:is_empty("fuel")
		and inv:is_empty("dst")
		and inv:is_empty("src")
end

function homedecor.register_furnace(name, furnacedef)
	furnacedef.fire_fg = furnacedef.fire_fg or "default_furnace_fire_fg.png"
	furnacedef.fire_bg = furnacedef.fire_bg or "default_furnace_fire_bg.png"

	furnacedef.output_slots = furnacedef.output_slots or 4
	furnacedef.output_width = furnacedef.output_width or 2

	furnacedef.cook_speed = furnacedef.cook_speed or 1

	local description = furnacedef.description or S("Furnace")

	local furnace_allow_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if listname == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext", S("@1 (empty)", description))
				end
				return stack:get_count()
			else
				return 0
			end
		elseif listname == "src" then
			return stack:get_count()
		elseif listname == "dst" then
			return 0
		end
	end
	local furnace_allow_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext", S("@1 (empty)", description))
				end
				return count
			else
				return 0
			end
		elseif to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end

	local n_active = name.."_active"
	local nname, name_active = "homedecor:"..name, "homedecor:"..n_active

	local function furnace_node_timer(pos, elapsed)
		--
		-- Initialize metadata
		--
		local meta = minetest.get_meta(pos)
		local fuel_time = meta:get_float("fuel_time") or 0
		local src_time = meta:get_float("src_time") or 0
		local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

		local inv = meta:get_inventory()
		local srclist, fuellist
		local dst_full = false

		local timer_elapsed = meta:get_int("timer_elapsed") or 0
		meta:set_int("timer_elapsed", timer_elapsed + 1)

		local cookable, cooked
		local fuel

		local update = true
		while elapsed > 0 and update do
			update = false

			srclist = inv:get_list("src")
			fuellist = inv:get_list("fuel")

			--
			-- Cooking
			--

			-- Check if we have cookable content
			local aftercooked
			cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
			cookable = cooked.time ~= 0

			local el = math.min(elapsed, fuel_totaltime - fuel_time)
			if cookable then -- fuel lasts long enough, adjust el to cooking duration
				el = math.min(el, cooked.time - src_time)
			end

			-- Check if we have enough fuel to burn
			if fuel_time < fuel_totaltime then
				-- The furnace is currently active and has enough fuel
				fuel_time = fuel_time + el
				-- If there is a cookable item then check if it is ready yet
				if cookable then
					src_time = src_time + el
					if src_time >= cooked.time then
						-- Place result in dst list if possible
						if inv:room_for_item("dst", cooked.item) then
							inv:add_item("dst", cooked.item)
							inv:set_stack("src", 1, aftercooked.items[1])
							src_time = src_time - cooked.time
							update = true
						else
							dst_full = true
						end
					else
						-- Item could not be cooked: probably missing fuel
						update = true
					end
				end
			else
				-- Furnace ran out of fuel
				if cookable then
					-- We need to get new fuel
					local afterfuel
					fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})

					if fuel.time == 0 then
						-- No valid fuel in fuel list
						fuel_totaltime = 0
						src_time = 0
					else
						-- prevent blocking of fuel inventory (for automatization mods)
						local is_fuel = minetest.get_craft_result({method = "fuel", width = 1, items = {afterfuel.items[1]:to_string()}})
						if is_fuel.time == 0 then
							table.insert(fuel.replacements, afterfuel.items[1])
							inv:set_stack("fuel", 1, "")
						else
							-- Take fuel from fuel list
							inv:set_stack("fuel", 1, afterfuel.items[1])
						end
						-- Put replacements in dst list or drop them on the furnace.
						local replacements = fuel.replacements
						if replacements[1] then
							local leftover = inv:add_item("dst", replacements[1])
							if not leftover:is_empty() then
								local above = vector.new(pos.x, pos.y + 1, pos.z)
								local drop_pos = minetest.find_node_near(above, 1, {"air"}) or above
								minetest.item_drop(replacements[1], nil, drop_pos)
							end
						end
						update = true
						fuel_totaltime = fuel.time + (fuel_totaltime - fuel_time)
					end
				else
					-- We don't need to get new fuel since there is no cookable item
					fuel_totaltime = 0
					src_time = 0
				end
				fuel_time = 0
			end

			elapsed = elapsed - el
		end

		if fuel and fuel_totaltime > fuel.time then
			fuel_totaltime = fuel.time
		end
		if srclist and srclist[1]:is_empty() then
			src_time = 0
		end

		--
		-- Update formspec, infotext and node
		--
		local formspec
		local infotext

		local percent = math.floor(fuel_time / fuel_totaltime * 100)

		local result = false

		local node = minetest.get_node(pos)
		local locked = node.name:find("_locked$") and "_locked" or ""
		local desc = minetest.registered_nodes[nname..locked].description

		if fuel_totaltime ~= 0 then
			formspec = make_formspec(furnacedef, percent)
			swap_node(pos, name_active .. locked)
			-- make sure timer restarts automatically
			result = true
		else
			formspec = make_formspec(furnacedef, 0)
			infotext = S("@1 (out of fuel)", desc)
			swap_node(pos, nname .. locked)
			-- stop timer on the inactive furnace
			minetest.get_node_timer(pos):stop()
			meta:set_int("timer_elapsed", 0)
		end

		if not cookable and fuellist and not fuellist[1]:is_empty() then
			infotext = S("@1 (empty)", desc)
		end

		if dst_full then
			infotext = S("@1 (output bins are full)", desc)
			result = false
			formspec = make_formspec(furnacedef, 0)
			swap_node(pos, nname .. locked)
			-- stop timer on the inactive furnace
			minetest.get_node_timer(pos):stop()
			meta:set_int("timer_elapsed", 0)
			fuel_totaltime, fuel_time, src_time = 0, 0, 0
		end

		if infotext == nil then
			infotext = S("@1 (active: @2%)", desc, percent)
		end

		--
		-- Set meta values
		--
		meta:set_float("fuel_totaltime", fuel_totaltime)
		meta:set_float("fuel_time", fuel_time)
		meta:set_float("src_time", src_time)
		meta:set_string("formspec", formspec)
		meta:set_string("infotext", infotext)

		return result
	end

	local furnace_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", furnacedef.output_slots)
		furnace_node_timer(pos, 0)
	end

	local def = {
		description = description,
		tiles = make_tiles(furnacedef.tiles, furnacedef.tile_format, false),
		groups = furnacedef.groups or {cracky=2},
		sounds = furnacedef.sounds,
		_sound_def = {
			key = "node_sound_wood_defaults",
		},
		on_construct = furnace_construct,
		can_dig = furnace_can_dig,
		allow_metadata_inventory_put = furnace_allow_put,
		allow_metadata_inventory_move = furnace_allow_move,
		inventory = { lockable = true },
		is_furnace = true,
		on_timer = furnace_node_timer,
		on_metadata_inventory_move = function(pos)
			minetest.get_node_timer(pos):start(1.0)
		end,
		on_metadata_inventory_put = function(pos)
			-- start timer function, it will sort out whether furnace can burn or not.
			minetest.get_node_timer(pos):start(1.0)
		end,
		on_metadata_inventory_take = function(pos)
			-- check whether the furnace is empty or not.
			minetest.get_node_timer(pos):start(1.0)
		end
	}

	local def_active = {
		description = S("@1 (active)", description),
		tiles = make_tiles(furnacedef.tiles_active, furnacedef.tile_format, true),
		light_source = 8,
		drop = "homedecor:" .. name,
		groups = furnacedef.groups or {cracky=2, not_in_creative_inventory=1},
		sounds = furnacedef.sounds,
		_sound_def = {
			key = "node_sound_stone_defaults",
		},
		on_construct = furnace_construct,
		can_dig = furnace_can_dig,
		allow_metadata_inventory_put = furnace_allow_put,
		allow_metadata_inventory_move = furnace_allow_move,
		inventory = { lockable = true },
		is_furnace = true,
		on_timer = furnace_node_timer,
		on_metadata_inventory_move = function(pos)
			minetest.get_node_timer(pos):start(1.0)
		end,
		on_metadata_inventory_put = function(pos)
			-- start timer function, it will sort out whether furnace can burn or not.
			minetest.get_node_timer(pos):start(1.0)
		end,
		on_metadata_inventory_take = function(pos)
			-- check whether the furnace is empty or not.
			minetest.get_node_timer(pos):start(1.0)
		end
	}

	if furnacedef.extra_nodedef_fields then
		for k, v in pairs(furnacedef.extra_nodedef_fields) do
			def[k] = v
			def_active[k] = v
		end
	end

	homedecor.register(name, def)
	homedecor.register(n_active, def_active)
end

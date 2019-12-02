--[[
CampFire mod by Doc
[modified by Napiophelios]
Depends: default, beds, fire, wool
For Minetest 0.5.0
-----------------------------------------------
Original CampFire mod by Doc
License of code : WTFPL
-----------------------------------------------
Node Swap ABM from NateS's More_fire mod
(solves the glitchy formspec transition)
More_fire mod
Licensed : CC by SA
-----------------------------------------------
Particle Functions from New Campfire mod by Pavel Litvinoff
License of code : GPLv2.1
Copyright (C) 2017 Pavel Litvinoff <googolgl@gmail.com>
<https://forum.minetest.net/viewtopic.php?f=9&t=16611>
--]]

campfire = {}


-- Used for localization

local S = minetest.get_translator("campfire")


---------------------
--Particle Functions
---------------------
local function fire_particles_on(pos) -- 3 layers of fire
    local meta = minetest.get_meta(pos)
    local id = minetest.add_particlespawner({ -- 1 layer big particles fire
        amount = 9,
        time = 3,
        minpos = {x = pos.x - 0.1, y = pos.y-0.5, z = pos.z - 0.1},
        maxpos = {x = pos.x + 0.1, y = pos.y-0.1, z = pos.z + 0.1},
        minvel = {x= 0, y= 0, z= 0},
        maxvel = {x= 0, y= 0, z= 0},
        minacc = {x= 0, y= 0, z= 0},
        maxacc = {x= 0, y= 0, z= 0},
        minexptime = 0.75,
        maxexptime = 1.25,
        minsize = 4,
        maxsize = 6,
        collisiondetection = false,
        vertical = true,
        texture = "fire_basic_flame_animated.png",
        animation = {type="vertical_frames", aspect_w=16, aspect_h=16, length = 1.15,},
         glow = 5,
    })
    meta:set_int("layer_1", id)

    local id = minetest.add_particlespawner({ -- 2 layer smol particles fire
        amount = 9,
        time = 1,
        minpos = {x = pos.x - 0.1, y = pos.y-0.5, z = pos.z - 0.1},
        maxpos = {x = pos.x + 0.1, y = pos.y-0.1, z = pos.z + 0.1},
        minvel = {x= 0, y= 0, z= 0},
        maxvel = {x= 0, y= 0, z= 0},
        minacc = {x= 0, y= 0, z= 0},
        maxacc = {x= 0, y= 0, z= 0},
        minexptime = 0.4,
        maxexptime = 1.1,
        minsize = 3,
        maxsize = 4,
        collisiondetection = false,
        vertical = true,
        texture = "fire_basic_flame_animated.png",
        animation = {type="vertical_frames", aspect_w=16, aspect_h=16, length = 1.25,},
         glow = 5,
    })
    meta:set_int("layer_2", id)

     local image_number = math.random(4)
    local id = minetest.add_particlespawner({ --3 layer embers
        amount = 1,
        time = 1,
        minpos = {x = pos.x - 0.1, y = pos.y - 0.05, z = pos.z - 0.1},
        maxpos = {x = pos.x + 0.2, y = pos.y + 0.2, z = pos.z + 0.2},
        minvel = {x= 0, y= 0.25, z= 0},
        maxvel = {x= 0, y= 0.75, z= 0},
        minacc = {x= 0, y= 0, z= 0},
        maxacc = {x= 0, y= 0.025, z= 0},
        minexptime = 0.5,
        maxexptime = 1.5,
        minsize = 0.05,
        maxsize = 0.25,
        collisiondetection = true,
        glow = 3,
        texture = "campfire_particle_"..image_number..".png",
    })
    meta:set_int("layer_3", id)
end

local function fire_particles_off(pos)
    local meta = minetest.get_meta(pos)
    local id_1 = meta:get_int("layer_1");
    local id_2 = meta:get_int("layer_2");
    local id_3 = meta:get_int("layer_3");
    minetest.delete_particlespawner(id_1)
    minetest.delete_particlespawner(id_2)
    minetest.delete_particlespawner(id_3)
end

local function effect(pos, texture, vlc, acc, time, size)
    local id = minetest.add_particle({
        pos = pos,
        velocity = vlc,
        acceleration = acc,
        expirationtime = time,
        size = size,
        collisiondetection = true,
        vertical = true,
        texture = texture,
    })
end

-- campfire progress / burning
local function check_and_burn(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	-- Get fuel status
	local fuel
	local fuellist = inv:get_list("fuel")
	if fuellist then
		fuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
	end
	local fuel_time = meta:get_float("fuel_time") or 0
	local fully_item_burn_time = 0
	fuel_time = fuel_time - 0.25

	-- Get cooking status
	local cooked
	local srclist = inv:get_list("src")
	if srclist then
		cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
	end
	local src_time = meta:get_float("src_time") or 0
	src_time = src_time + 0.25

--
--	local item_percent = 0
--	if cooked.time > 0 then
--		item_percent =  math.floor(src_time / cooked.time * 100)
--	end

	local is_burning
	if fuel_time > 0 then      -- still fuel in
		is_burning = true
		fully_item_burn_time = meta:get_float("fully_item_burn_time")
	elseif fuel.time == 0 then -- no fuel, but item not burneable
		is_burning = false
	else                       -- take the next item
		fuel_time = fuel.time
		fully_item_burn_time = fuel.time
		meta:set_float("fully_item_burn_time", fully_item_burn_time)
		is_burning = true
		local stack = inv:get_stack("fuel", 1)
		stack:take_item()
		inv:set_stack("fuel", 1, stack)
	end

	if not is_burning then
		meta:set_float("fuel_time", 0)
		minetest.swap_node(pos, {name = 'campfire:campfire', param1 = 0})
		meta:set_string("infotext", S("The campfire is out."))
--		meta:set_string("formspec", campfire.campfire_active_formspec(item_percent))
		return is_burning
	end

	meta:set_float("fuel_time", fuel_time)
	local node = minetest.get_node(pos)
	if node.name ~= "campfire:campfire_active" or math.random(2) == 1 then
		minetest.sound_play({name="campfire_small", pos = pos, max_hear_distance = 8, gain = 0.1})
		minetest.swap_node(pos, {name = 'campfire:campfire_active'})
	end
	fire_particles_on(pos)
	local percent = math.floor(fuel_time / fully_item_burn_time * 100)
	meta:set_string("infotext", S("Campfire active: ")..percent.."%")


	-- fire burns, check for cooking finished
	if cooked and cooked.item and src_time >= cooked.time then
		if inv:room_for_item("dst",cooked.item) then
			inv:add_item("dst", cooked.item)
			local srcstack = inv:get_stack("src", 1)
			srcstack:take_item()
			inv:set_stack("src", 1, srcstack)
		else
			print(S("Could not insert '")..cooked.item:to_string().."'")
		end
		meta:set_float("src_time", 0)
	else
		meta:set_float("src_time", src_time)
	end

	return is_burning
end

---------------
-- Formspecs
---------------

local s_FuelText = S(" < Add Fuel")

function campfire.campfire_active_formspec(pos)
local formspec =
   "size[8,6]"..
   default.gui_bg..
   default.gui_bg_img..
   default.gui_slots..
   "label[1,0.5;" .. s_FuelText .. "]"..
   "list[current_name;fuel;0,0.25;1,1;]"..
   "list[current_name;src;4,0.25;1,1;]"..
   "image[5,0.25;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
   "list[current_name;dst;6,0.25;2,1;]"..
   "list[current_player;main;0,2;8,1;]"..
   "list[current_player;main;0,3;8,3;8]"..
   "listring[current_name;dst]"..
   "listring[current_player;main]"..
   "listring[current_name;src]"..
   "listring[current_player;main]"..
   default.get_hotbar_bg(0,2)
	return formspec
	end

campfire.campfire_formspec =
   "size[8,6]"..
   default.gui_bg..
   default.gui_bg_img..
   default.gui_slots..
   "label[1,0.5;" .. s_FuelText .. "]"..
   "list[current_name;fuel;0,0.25;1,1;]"..
   "list[current_name;src;4,0.25;1,1;]"..
   "image[5,0.25;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
   "list[current_name;dst;6,0.25;2,1;]"..
   "list[current_player;main;0,2;8,1;]"..
   "list[current_player;main;0,3;8,3;8]"..
   "listring[current_name;dst]"..
   "listring[current_player;main]"..
   "listring[current_name;src]"..
   "listring[current_player;main]"..
   default.get_hotbar_bg(0,2)

---------
--Nodes
---------
minetest.register_node("campfire:campfire", {
	description = S("Campfire"),
	drawtype = "nodebox",
	tiles = {'default_gravel.png^[colorize:#1f1f1f:100'},
	inventory_image = "[combine:16x16:0,0=fire_basic_flame.png:0,12=default_gravel.png",
	wield_image = "[combine:16x16:0,0=fire_basic_flame.png:0,12=default_gravel.png",
	walkable = false,
	buildable_to = false,
	sunlight_propagates = true,
	groups = {oddly_breakable_by_hand=3, dig_immediate=2, attached_node=1},
	light_source =1,
	paramtype = 'light',
	sounds = default.node_sound_stone_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, 0.25, 0.25, -0.375, 0.375},
			{-0.3125, -0.5, 0.1875, -0.1875, -0.375, 0.3125},
			{-0.375, -0.5, -0.25, -0.25, -0.375, 0.25},
			{-0.3125, -0.5, -0.3125, -0.1875, -0.375, -0.1875},
			{-0.25, -0.5, -0.375, 0.25, -0.375, -0.25},
			{0.1875, -0.5, -0.3125, 0.3125, -0.375, -0.1875},
			{0.25, -0.5, -0.25, 0.375, -0.375, 0.25},
			{0.1875, -0.5, 0.1875, 0.3125, -0.375, 0.3125},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.4375, -0.5, -0.4375, 0.4375, -0.3125, 0.4375},
	},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string('formspec', campfire.campfire_formspec)
		meta:set_string('infotext', S('Campfire'));
		local inv = meta:get_inventory()
		inv:set_size('fuel', 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 2)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		if check_and_burn(pos) then
			minetest.get_node_timer(pos):start(1)
		end
	end
})

minetest.register_node("campfire:campfire_active", {
	drawtype = "nodebox",
	tiles = {'tnt_blast.png','default_gravel.png^[colorize:#1f1f1f:190'},
	walkable = false,
	buildable_to = true,
	sunlight_propagates = true,
	damage_per_second = 1,
	drop = "",
	paramtype = 'light',
	light_source =8,
	groups = {oddly_breakable_by_hand=1, dig_immediate=2, attached_node=1,not_in_creative_inventory =1},
	sounds = default.node_sound_stone_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, 0.25, 0.25, -0.375, 0.375},
			{-0.3125, -0.5, 0.1875, -0.1875, -0.375, 0.3125},
			{-0.375, -0.5, -0.25, -0.25, -0.375, 0.25},
			{-0.3125, -0.5, -0.3125, -0.1875, -0.375, -0.1875},
			{-0.25, -0.5, -0.375, 0.25, -0.375, -0.25},
			{0.1875, -0.5, -0.3125, 0.3125, -0.375, -0.1875},
			{0.25, -0.5, -0.25, 0.375, -0.375, 0.25},
			{0.1875, -0.5, 0.1875, 0.3125, -0.375, 0.3125},
		}
	},
	selection_box = {
		type = "fixed",
		fixed ={-0.4375, -0.5, -0.4375, 0.4375, -0.3125, 0.4375},
	},
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,

	on_destruct = function(pos, oldnode, digger)
        fire_particles_off(pos)
    end,
    on_timer = check_and_burn,
})

-- sleeping bag
if minetest.global_exists("beds") then
beds.register_bed("campfire:sleeping_mat", {
	description = S("Sleeping Bag"),
	 inventory_image = "[combine:16x16:0,0=wool_white.png:0,6=wool_brown.png",
	wield_image = "[combine:16x16:0,0=wool_white.png:0,6=wool_brown.png",
	tiles = {
		bottom = {"[combine:16x16:0,0=wool_brown.png:0,10=wool_brown.png"},
		top = { "[combine:16x16:0,0=wool_white.png:0,6=wool_brown.png" }
	},
	nodebox = {
		bottom = {
			{-0.48, -0.5,-0.5,  0.48, -0.45, 0.5},
		},
		top = {
			{-0.48, -0.5,-0.5,  0.48, -0.45, 0.5},
		}
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, -0.35, 1.5},
	recipe = {
		{"wool:white", "wool:brown", "wool:brown"},
	},
})
end


-----------------
-- craft recipes
-----------------
minetest.register_craft({
	output = 'campfire:campfire',
	recipe = {
		{'', 'group:stone', ''},
		{'group:stone','default:stick', 'group:stone'},
		{'', 'group:stone', ''},
	}
})

--[[ Helpers ]]--

-- Skin mod detection
local skin_mod

local skin_mods = {"skinsdb", "skins", "u_skins", "simple_skins", "wardrobe"}

-- local settings
local setting_max_speed = tonumber(minetest.settings:get("bike_max_speed")) or 6.9
local setting_acceleration = tonumber(minetest.settings:get("bike_acceleration")) or 3.16
local setting_decceleration = tonumber(minetest.settings:get("bike_decceleration")) or 7.9
local setting_friction = tonumber(minetest.settings:get("bike_friction")) or 0.79
local setting_turn_speed = tonumber(minetest.settings:get("bike_turn_speed")) or 1.58
local setting_friction_cone = tonumber(minetest.settings:get("bike_friction_cone")) or 0.4
local agility_factor = 1/math.sqrt(setting_friction_cone)
local setting_wheely_factor = tonumber(minetest.settings:get("bike_wheely_factor")) or 2.0
local setting_stepheight = tonumber(minetest.settings:get("bike_stepheight")) or 0.6
local setting_wheely_stepheight = tonumber(minetest.settings:get("bike_wheely_stepheight")) or 0.6
local setting_water_friction = tonumber(minetest.settings:get("bike_water_friction")) or 13.8
local setting_offroad_friction = tonumber(minetest.settings:get("bike_offroad_friction")) or 1.62

-- general settings
local setting_turn_look = minetest.settings:get_bool("mount_turn_player_look", false)
local setting_ownable = minetest.settings:get_bool("mount_ownable", false)

--[[ Crafts ]]--

minetest.register_craftitem("bike:wheel", {
	description = "Bike Wheel",
	inventory_image = "bike_wheel.png",
})

minetest.register_craftitem("bike:handles", {
	description = "Bike Handles",
	inventory_image = "bike_handles.png",
})

-- Set item names according to installed mods
local rubber = "group:wood"
local iron = "default:steel_ingot"
local red_dye = "dye:red"
local green_dye = "dye:green"
local blue_dye = "dye:blue"
local container = "default:glass"

if minetest.get_modpath("technic") ~= nil then
	rubber = "technic:rubber"
end

if minetest.get_modpath("vessels") ~= nil then
	container = "vessels:glass_bottle"
end

if minetest.get_modpath("mcl_core") ~= nil then
	iron = "mcl_core:iron_ingot"
	container = "mcl_core:glass"
end

if minetest.get_modpath("mcl_dye") ~= nil then
	red_dye = "mcl_dye:red"
	green_dye = "mcl_dye:green"
	blue_dye = "mcl_dye:blue"
end

if minetest.get_modpath("mcl_potions") ~= nil then
	container = "mcl_potions:glass_bottle"
end

for _, mod in pairs(skin_mods) do
	local path = minetest.get_modpath(mod)
	if path then
		skin_mod = mod
	end
end

local function get_player_skin(player)
	local name = player:get_player_name()
	local armor_tex = ""
	if minetest.global_exists("armor") then
		-- Filter out helmet (for bike helmet) and boots/shield (to not mess up UV mapping)
		local function filter(str, find)
			for _,f in pairs(find) do
				str = str:gsub("%^"..f.."_(.-.png)", "")
			end
			return str
		end
		armor_tex = filter("^"..armor.textures[name].armor, {"shields_shield", "3d_armor_boots", "3d_armor_helmet"})
	end
	-- Return the skin with armor (if applicable)
	if skin_mod == "skinsdb" then
		return "[combine:64x32:0,0="..skins.get_player_skin(player)["_texture"]..armor_tex
	elseif (skin_mod == "skins" or skin_mod == "simple_skins") and skins.skins[name] then
		return skins.skins[name]..".png"..armor_tex
	elseif skin_mod == "u_skins" and u_skins.u_skins[name] then
		return u_skins.u_skins[name]..".png"..armor_tex
	elseif skin_mod == "wardrobe" and wardrobe.playerSkins and wardrobe.playerSkins[name] then
		return wardrobe.playerSkins[name]..armor_tex
	end
	local skin = player:get_properties().textures[1]
	-- If we just have 3d_armor enabled make sure we get the player skin properly
	if minetest.global_exists("armor") and armor.get_player_skin then
		skin = armor:get_player_skin(name)
	end
	return skin..armor_tex
end

-- Bike metal texture handling
local function is_hex(color)
	if color:len() ~= 7 then return nil end
	return color:match("#%x%x%x%x%x%x")
end

local function colormetal(color, alpha)
	return "bike_metal_base.png^[colorize:"..(color)..":"..tostring(alpha)
end

-- Terrain checkers
local function is_water(pos)
	local nn = minetest.get_node(pos).name
	return minetest.get_item_group(nn, "liquid") ~= 0
end

local function is_bike_friendly(pos)
	local nn = minetest.get_node(pos).name
	return minetest.get_item_group(nn, "crumbly") == 0 or minetest.get_item_group(nn, "bike_friendly") ~= 0
end

-- Maths
local function get_sign(i)
	if i == 0 then
		return 0
	else
		return i / math.abs(i)
	end
end

local function get_velocity(v, yaw, y)
	local x = -math.sin(yaw) * v
	local z =  math.cos(yaw) * v
	return {x = x, y = y, z = z}
end

local function get_v(v)
	return math.sqrt(v.x ^ 2 + v.z ^ 2)
end

-- Custom hand
minetest.register_node("bike:hand", {
	description = "",
	-- No interaction on a bike :)
	range = 0,
	on_place = function(itemstack, placer, pointed_thing)
		return ItemStack("bike:hand "..itemstack:get_count())
	end,
	-- Copy default:hand looks so it doesnt look as weird when the hands are switched
	wield_image = minetest.registered_items[""].wield_image,
	wield_scale = minetest.registered_items[""].wield_scale,
	node_placement_prediction = "",
})

--[[ Bike ]]--

-- Default textures (overidden when mounted or colored)
local function default_tex(metaltex, alpha)
	return {
		"bike_metal_grey.png",
		"bike_gear.png",
		colormetal(metaltex, alpha),
		"bike_leather.png",
		"bike_chain.png",
		"bike_metal_grey.png",
		"bike_leather.png",
		"bike_metal_black.png",
		"bike_metal_black.png",
		"bike_blank.png",
		"bike_tread.png",
		"bike_gear.png",
		"bike_spokes.png",
		"bike_tread.png",
		"bike_spokes.png",
	}
end

-- Entity
local bike = {
	physical = true,
	-- Warning: Do not change the position of the collisionbox top surface,
	-- lowering it causes the bike to fall through the world if underwater
	collisionbox = {-0.5, -0.4, -0.5, 0.5, 0.8, 0.5},
	collide_with_objects = false,
	visual = "mesh",
	mesh = "bike.b3d",
	textures = default_tex("#FFFFFF", 150),
	stepheight = setting_stepheight,
	driver = nil,
	color = "#FFFFFF",
	alpha = 150,
	old_driver = {},
	v = 0,		  -- Current velocity
	last_v = 0,   -- Last velocity
	max_v = setting_max_speed,  -- Max velocity
	fast_v = 0,   -- Fast adder
	f_speed = 30, -- Frame speed
	last_y = 0,	  -- Last height
	up = false,	  -- Are we going up?
	timer = 0,
	removed = false,
	__is_bike__ = true,
}

-- Dismont the player
local function dismount_player(bike, exit)
	bike.object:set_velocity({x = 0, y = 0, z = 0})
	-- Make the bike empty again
	bike.object:set_properties({textures = default_tex(bike.color, bike.alpha)})
	bike.v = 0

	if bike.driver then
		bike.driver:set_detach()
		-- Reset original player properties
		bike.driver:set_properties({visual_size=bike.old_driver["vsize"]})
		bike.driver:set_eye_offset(bike.old_driver.eye_offset.offset_first,
									bike.old_driver.eye_offset.offset_third)
		bike.driver:hud_set_flags(bike.old_driver["hud"])
		local pinv = bike.driver:get_inventory()
		if pinv then
			pinv:set_stack("hand", 1, pinv:get_stack("old_hand", 1))
		end
		-- Is the player leaving? If so, dont do this stuff or Minetest will have a fit
		if not exit then
			local pos = bike.driver:get_pos()
			pos = {x = pos.x, y = pos.y + 0.2, z = pos.z}
			bike.driver:set_pos(pos)
		end
		bike.driver = nil
	end
end

-- Mounting
function bike.on_rightclick(self, clicker)
	if not clicker or not clicker:is_player() or clicker:get_attach() ~= nil then
		return
	end
	if not self.driver then
		local pname = clicker:get_player_name()
		if setting_ownable and self.owner and pname ~= self.owner then
			minetest.chat_send_player(pname, "You cannot ride " .. self.owner .. "'s bike.")
			return
		end

		-- Make integrated player appear
		self.object:set_properties({
			textures = {
				"bike_metal_grey.png",
				"bike_gear.png",
				colormetal(self.color, self.alpha),
				"bike_leather.png",
				"bike_chain.png",
				"bike_metal_grey.png",
				"bike_leather.png",
				"bike_metal_black.png",
				"bike_metal_black.png",
				get_player_skin(clicker).."^bike_helmet.png",
				"bike_tread.png",
				"bike_gear.png",
				"bike_spokes.png",
				"bike_tread.png",
				"bike_spokes.png",
			},
		})
		-- Save the player's properties that we need to change
		self.old_driver["vsize"] = clicker:get_properties().visual_size
		local offset_first, offset_third = clicker:get_eye_offset()
		self.old_driver.eye_offset = {
			offset_first = offset_first,
			offset_third = offset_third
		}
		self.old_driver["hud"] = clicker:hud_get_flags()
		clicker:get_inventory():set_stack("old_hand", 1, clicker:get_inventory():get_stack("hand", 1))
		-- Change the hand
		clicker:get_inventory():set_stack("hand", 1, "bike:hand")
		local attach = clicker:get_attach()
		if attach and attach:get_luaentity() then
			local luaentity = attach:get_luaentity()
			if luaentity.driver then
				luaentity.driver = nil
			end
			clicker:set_detach()
		end
		self.driver = clicker
		-- Set new properties and hide HUD
		clicker:set_properties({visual_size = {x=0,y=0}})
		clicker:set_attach(self.object, "body", {x = 0, y = 10, z = 5}, {x = 0, y = 0, z = 0})
		clicker:set_eye_offset({x=0,y=-3,z=10},{x=0,y=0,z=5})
		clicker:hud_set_flags({
			hotbar = false,
			wielditem = false,
		})
		-- Look forward initially
		clicker:set_look_horizontal(self.object:get_yaw())
	end
end

function bike.on_activate(self, staticdata, dtime_s)
	self.object:set_acceleration({x = 0, y = -9.8, z = 0})
	self.object:set_armor_groups({immortal = 1})
	if staticdata ~= "" then
		local data = minetest.deserialize(staticdata)
		if data ~= nil then
			self.v = data.v
			self.color = data.color
			self.alpha = data.alpha
			self.owner = data.owner
		end
	end
	self.object:set_properties({textures=default_tex(self.color, self.alpha)})
	self.last_v = self.v
end

-- Save velocity and color data for reload
function bike.get_staticdata(self)
	local data = {
		v = self.v,
		color = self.color,
		alpha = self.alpha,
		owner = self.owner,
	}
	return minetest.serialize(data)
end

-- Pick up/color
function bike.on_punch(self, puncher)
	local itemstack = puncher:get_wielded_item()
	-- Bike painting
	if itemstack:get_name() == "bike:painter" then
		-- No painting while someone is riding :P
		if self.driver then
			return
		end
		-- Get color data
		local meta = itemstack:get_meta()
		self.color = meta:get_string("paint_color")
		self.alpha = meta:get_string("alpha")
		self.object:set_properties({
			textures = {
				"bike_metal_grey.png",
				"bike_gear.png",
				colormetal(self.color, self.alpha),
				"bike_leather.png",
				"bike_chain.png",
				"bike_metal_grey.png",
				"bike_leather.png",
				"bike_metal_black.png",
				"bike_metal_black.png",
				"bike_blank.png",
				"bike_tread.png",
				"bike_gear.png",
				"bike_spokes.png",
				"bike_tread.png",
				"bike_spokes.png",
			},
		})
		return
	end
	if not puncher or not puncher:is_player() or self.removed then
		return
	end
	-- Make sure no one is riding
	if not self.driver then
		local pname = puncher:get_player_name()
		if setting_ownable and self.owner and pname ~= self.owner then
			minetest.chat_send_player(pname, "You cannot take " .. self.owner .. "'s bike.")
			return
		end

		local inv = puncher:get_inventory()
		-- We can only carry one bike
		if not inv:contains_item("main", "bike:bike") then
			local stack = ItemStack({name="bike:bike", count=1, wear=0})
			local meta = stack:get_meta()
			-- Set the stack to the bike color
			meta:set_string("color", self.color)
			meta:set_string("alpha", self.alpha)
			local leftover = inv:add_item("main", stack)
			-- If no room in inventory add the bike to the world
			if not leftover:is_empty() then
				minetest.add_item(self.object:get_pos(), leftover)
			end
		else
			-- Turn it into raw materials
			if not (creative and creative.is_enabled_for(pname)) then
				local ctrl = puncher:get_player_control()
				if not ctrl.sneak then
					minetest.chat_send_player(pname, "Warning: Destroying the bike gives you only some resources back. If you are sure, hold sneak while destroying the bike.")
					return
				end
				local leftover = inv:add_item("main", iron .. " 6")
				-- If no room in inventory add the iron to the world
				if not leftover:is_empty() then
					minetest.add_item(self.object:get_pos(), leftover)
				end
			end
		end
		self.removed = true
		-- Delay remove to ensure player is detached
		minetest.after(0.1, function()
			self.object:remove()
		end)
	end
end

-- Animations
local function bike_anim(self)
	-- The `self.object:get_animation().y ~= <frame>` is to check if the animation is already running
	if self.driver then
		local ctrl = self.driver:get_player_control()
		-- Wheely
		if ctrl.jump then
			-- We are moving
			if self.v > 0 then
				if self.object:get_animation().y ~= 79 then
					self.object:set_animation({x=59,y=79}, self.f_speed + self.fast_v, 0, true)
				end
				return
			-- Else we are not
			else
				if self.object:get_animation().y ~= 59 then
					self.object:set_animation({x=59,y=59}, self.f_speed + self.fast_v, 0, true)
				end
				return
			end
		end

		-- Left or right tilt, but only if we arent doing a wheely
		local t_left = false
		local t_right = false

		if not setting_turn_look then
			t_left = ctrl.left
			t_right = ctrl.right
		else
			local turning = math.floor(self.driver:get_look_horizontal() * 100)
				- math.floor(self.object:get_yaw() * 100)

			-- use threshold of 1 to determine if animation should be updated
			t_left = turning > 1
			t_right = turning < -1
		end

		if t_left then
			if self.object:get_animation().y ~= 58 then
				self.object:set_animation({x=39,y=58}, self.f_speed + self.fast_v, 0, true)
			end
			return
		elseif t_right then
			if self.object:get_animation().y ~= 38 then
				self.object:set_animation({x=19,y=38}, self.f_speed + self.fast_v, 0, true)
			end
			return
		end
	end
	-- If none of that, then we are just moving forward
	if self.v > 0 then
		if self.object:get_animation().y ~= 18 then
			self.object:set_animation({x=0,y=18}, 30, 0, true)
		end
		return
	-- Or not
	else
		if self.object:get_animation().y ~= 0 then
			self.object:set_animation({x=0,y=0}, 0, 0, false)
		end
	end
end

-- Run every tick
function bike.on_step(self, dtime, moveresult)
	-- Player checks
	if self.driver then
		-- Is the actual player somehow still visible?
		local p_prop = self.driver:get_properties()
		if p_prop and p_prop.visual_size ~= {x=0,y=0} then
			self.driver:set_properties({visual_size = {x=0,y=0}})
		end

		-- Has the player left?
		if self.driver:get_attach() == nil then
			dismount_player(self, true)
			return
		end
	end

	-- Have we come to a sudden stop?
	if math.abs(self.last_v - self.v) > 3 then
		-- And is Minetest not being dumb
		if not self.up then
			minetest.log("info", "[bike] forcing stop")
			self.v = 0
		end
	end

	self.last_v = self.v

	self.timer = self.timer + dtime;
	if self.timer >= 0.5 then
		-- Recording y values to check if we are going up
		self.last_y = self.object:get_pos().y
		self.timer = 0
	end

	-- Are we going up?
	if self.last_y < self.object:get_pos().y then
		self.up = true
	else
		self.up = false
	end

	-- Run animations
	bike_anim(self)

	-- Are we falling?
	if self.object:get_velocity().y < -10 and self.driver ~= nil then
		-- If so, dismount
		dismount_player(self)
		return
	end

	local current_v = get_v(self.object:get_velocity()) * get_sign(self.v)
	self.v = (current_v + self.v*3) / 4
	if self.driver then
		local ctrl = self.driver:get_player_control()
		local yaw = self.object:get_yaw()
		local agility = 0

		-- Sneak dismount
		if ctrl.sneak then
			dismount_player(self)
			return
		end

		if self.v > setting_friction_cone then
			agility = 1/math.sqrt(self.v)/agility_factor
		else
			agility = 1.0
		end

		-- Forward
		if ctrl.up then
			-- Are we going fast?
			if ctrl.aux1 then
				if self.fast_v ~= 5 then
					self.fast_v = 5
				end
			else
				if self.fast_v > 0 then
					self.fast_v = self.fast_v - 0.05 * agility
				end
			end
			self.v = self.v + dtime*setting_acceleration + (self.fast_v*0.1) * agility
		-- Brakes
		elseif ctrl.down then
			self.v = self.v - dtime*setting_decceleration * agility
			if self.fast_v > 0 then
				self.fast_v = self.fast_v - dtime*setting_friction * agility
			end
		-- Nothin'
		else
			self.v = self.v - dtime*setting_friction * agility
			if self.fast_v > 0 then
				self.fast_v = self.fast_v - dtime*setting_friction * agility
			end
		end

		-- Wheely will change turning speed
		local turn_speed = setting_turn_speed

		-- Are we doing a wheely?
		if ctrl.jump then
			turn_speed = setting_wheely_factor * setting_turn_speed

			if self.stepheight ~= setting_wheely_stepheight then
				self.object:set_properties({stepheight=setting_wheely_stepheight})
				self.stepheight = setting_wheely_stepheight
			end
		elseif self.stepheight ~= setting_stepheight then
			self.object:set_properties({stepheight=setting_stepheight})
			self.stepheight = setting_stepheight
		end

		-- Turning
		if not setting_turn_look then
			if ctrl.left then
				self.object:set_yaw(yaw + turn_speed*dtime * agility)
			elseif ctrl.right then
				self.object:set_yaw(yaw - turn_speed*dtime * agility)
			end
		else
			self.object:set_yaw(self.driver:get_look_horizontal())
		end
	end
	-- Movement
	local velo = self.object:get_velocity()
	if self.v == 0 and velo.x == 0 and velo.y == 0 and velo.z == 0 then
		self.object:move_to(self.object:get_pos())
		return
	end
	local s = get_sign(self.v)
	if s ~= get_sign(self.v) then
		self.object:set_velocity({x = 0, y = 0, z = 0})
		self.v = 0
		return
	end
	if self.v > self.max_v + self.fast_v then
		self.v = self.max_v + self.fast_v
	elseif self.v < 0 then
		self.v = 0
	end

	local p = self.object:get_pos()
	if is_water(p) then
		self.v = self.v / math.pow(setting_water_friction, dtime)
	end

	-- Can we ride good here?
	local bike_friendly = true
	for _, collision in ipairs(moveresult.collisions) do
		if collision.type == "node" and collision.axis == "y" then
			if not is_bike_friendly(collision.node_pos) then
				bike_friendly = false
				break
			end
		end
	end
	if not bike_friendly then
		self.v = self.v / math.pow(setting_offroad_friction, dtime)
	end

	local new_velo
	new_velo = get_velocity(self.v, self.object:get_yaw(), self.object:get_velocity().y)
	self.object:move_to(self.object:get_pos())
	self.object:set_velocity(new_velo)
end

-- Check for stray bike hand
minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	if inv:get_stack("hand", 1):get_name() == "bike:hand" then
		inv:set_stack("hand", 1, inv:get_stack("old_hand", 1))
	end
end)

-- Dismount all players on server shutdown
minetest.register_on_shutdown(function()
	for _, e in pairs(minetest.luaentities) do
		if (e.__is_bike__ and e.driver ~= nil) then
			dismount_player(e, true)
		end
	end
end)

-- Register the entity
minetest.register_entity("bike:bike", bike)

-- Bike craftitem
minetest.register_craftitem("bike:bike", {
	description = "Bike",
	inventory_image = "bike_inventory.png",
	wield_scale = {x = 3, y = 3, z = 2},
	groups = {flammable = 2},
	stack_max = 1,
	on_place = function(itemstack, placer, pointed_thing)
		local under = pointed_thing.under
		local node = minetest.get_node(under)
		local udef = minetest.registered_nodes[node.name]
		if udef and udef.on_rightclick and
				not (placer and placer:is_player() and
				placer:get_player_control().sneak) then
			return udef.on_rightclick(under, node, placer, itemstack,
				pointed_thing) or itemstack
		end

		if pointed_thing.type ~= "node" then
			return itemstack
		end

		local meta = itemstack:get_meta()
		local sdata = {
			v = 0,
			-- Place bike with saved color
			color = meta:get_string("color"),
			alpha = tonumber(meta:get_string("alpha")),
			-- Store owner
			owner = placer:get_player_name(),
		}

		-- If it's a new bike, give it default colors
		if sdata.alpha == nil then
			sdata.color, sdata.alpha = "#FFFFFF", 150
		end

		local bike_pos = placer:get_pos()
		bike_pos.y = bike_pos.y + 0.5
		-- Use the saved attributes data and place the bike
		bike = minetest.add_entity(bike_pos, "bike:bike", minetest.serialize(sdata))

		-- Point it the right direction
		if bike then
			if placer then
				bike:set_yaw(placer:get_look_horizontal())
			end
			local player_name = placer and placer:get_player_name() or ""
			if not (creative and creative.is_enabled_for and
					creative.is_enabled_for(player_name)) then
				itemstack:take_item()
			end
		end
		return itemstack
	end,
})

--[[ Painter ]]--

-- Helpers
local function rgb_to_hex(r, g, b)
	return string.format("#%02X%02X%02X", r, g, b)
end

local function hex_to_rgb(hex)
	hex = hex:gsub("#","")
	local rgb = {
		r = tonumber("0x"..hex:sub(1,2)),
		g = tonumber("0x"..hex:sub(3,4)),
		b = tonumber("0x"..hex:sub(5,6)),
	}
	return rgb
end

-- Need to convert between 1000 units and 256
local function from_slider_rgb(value)
	value = tonumber(value)
	return math.floor((255/1000*value)+0.5)
end

-- ...and back
local function to_slider_rgb(value)
	return 1000/255*value
end

-- Painter formspec
local function show_painter_form(itemstack, player)
	local meta = itemstack:get_meta()
	local color = meta:get_string("paint_color")
	local alpha = tonumber(meta:get_string("alpha"))
	if alpha == nil then
		color, alpha = "#FFFFFF", 128
	end
	local rgba = hex_to_rgb(color)
	rgba.a = alpha
	minetest.show_formspec(player:get_player_name(), "bike:painter",
		-- Init formspec
		"size[6,6;true]"..
		"position[0.5, 0.45]"..
		-- Hex/Alpha fields
		"button[1.6,5.5;2,1;set;Set paint color]"..
		"field[0.9,5;2,0.8;hex;Hex Color;"..color.."]"..
		"field[2.9,5;2,0.8;alpha;Alpha (0-255);"..tostring(alpha).."]"..
		-- RGBA sliders
		"scrollbar[0,2;5,0.3;horizontal;r;"..tostring(to_slider_rgb(rgba.r)).."]"..
		"label[5.1,1.9;R: "..tostring(rgba.r).."]"..
		"scrollbar[0,2.6;5,0.3;horizontal;g;"..tostring(to_slider_rgb(rgba.g)).."]"..
		"label[5.1,2.5;G: "..tostring(rgba.g).."]"..
		"scrollbar[0,3.2;5,0.3;horizontal;b;"..tostring(to_slider_rgb(rgba.b)).."]"..
		"label[5.1,3.1;B: "..tostring(rgba.b).."]"..
		"scrollbar[0,3.8;5,0.3;horizontal;a;"..tostring(to_slider_rgb(rgba.a)).."]"..
		"label[5.1,3.7;A: "..tostring(rgba.a).."]"..
		-- Preview
		"label[1,0;Preview:]"..
		"image[2,0;2,2;bike_metal_base.png^[colorize:"..color..":"..tostring(rgba.a).."]"
	)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "bike:painter" then
		local itemstack = player:get_wielded_item()
		if fields.set then
			if itemstack:get_name() == "bike:painter" then
				local meta = itemstack:get_meta()
				local hex = fields.hex
				local alpha = tonumber(fields.alpha)
				if is_hex(hex) == nil then
					hex = "#FFFFFF"
				end
				if alpha == nil or alpha < 0 or alpha > 255 then
					alpha = 128
				end
				-- Save color data to painter (rgba sliders will adjust to hex/alpha too!)
				meta:set_string("paint_color", hex)
				meta:set_string("alpha", tostring(alpha))
				meta:set_string("description", "Bike Painter ("..hex:upper()..", A: "..tostring(alpha)..")")
				player:set_wielded_item(itemstack)
				show_painter_form(itemstack, player)
				return
			end
		end
		if fields.r or fields.g or fields.b or fields.a then
			if itemstack:get_name() == "bike:painter" then
				-- Save on slider adjustment (hex/alpha will adjust to match the rgba!)
				local meta = itemstack:get_meta()
				local function sval(value)
					return from_slider_rgb(value:gsub(".*:", ""))
				end
				meta:set_string("paint_color", rgb_to_hex(sval(fields.r),sval(fields.g),sval(fields.b)))
				meta:set_string("alpha", sval(fields.a))
				-- Keep track of what this painter is painting
				meta:set_string("description", "Bike Painter ("..meta:get_string("paint_color"):upper()..", A: "..meta:get_string("alpha")..")")
				player:set_wielded_item(itemstack)
				show_painter_form(itemstack, player)
			end
		end
	end
end)

-- Make the actual thingy
minetest.register_tool("bike:painter", {
	description = "Bike Painter",
	inventory_image = "bike_painter.png",
	wield_scale = {x = 2, y = 2, z = 1},
	on_place = show_painter_form,
	on_secondary_use = show_painter_form,
})

minetest.register_craft({
	output = "bike:wheel 2",
	recipe = {
		{"", rubber, ""},
		{rubber, iron, rubber},
		{"", rubber, ""},
	},
})

minetest.register_craft({
	output = "bike:handles",
	recipe = {
		{iron, iron, iron},
		{rubber, "", rubber},
	},
})

minetest.register_craft({
	output = "bike:bike",
	recipe = {
		{"bike:handles", "", rubber},
		{iron, iron, iron},
		{"bike:wheel", "", "bike:wheel"},
	},
})

minetest.register_craft({
	output = "bike:painter",
	recipe = {
		{"", container, ""},
		{iron, red_dye, green_dye},
		{"", rubber, blue_dye},
	},
})

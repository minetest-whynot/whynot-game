-- when using the latest dev minetest server, attaching a player to an object that is attached to a moving object has issues 
-- 	when the object moves past 200 in any direction.  because of this I am attaching the player directly to the object if dofancy = false
local dofancy = false

-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.global_exists('intllib') then
	if intllib.make_gettext_pair then
		S = intllib.make_gettext_pair()
	else
		S = intllib.Getter()
	end
else
	S = function(s) return s end
end

--
-- Helper functions
--
local function get_sign(i)
	if i == 0 then
		return 0
	else
		return i/math.abs(i)
	end
end

--
-- Heli entity
--
local heli = {
	physical = true,
	collisionbox = {-0.4,-0.5,-0.4, 0.4,0.6,0.4},
	makes_footstep_sound = false,
	collide_with_objects = true,
	
	visual = "mesh",
	mesh = "root.x",
	--Player
	driver = nil,
	
	pas1 = nil,
	pas2 = nil,
	
	named = nil, -- name of driver (used for when they disconnect)
	name1 = nil, -- name of passenger 1
	name2 = nil, -- name of passenger 2

	inactives = nil, -- list of players that disconnected while riding the helicopter (names)
	
	running = false, -- true if animation and sound should be playing	
	
	--Heli mesh
	model = nil,
	--Rotation
	yaw=0,
	--Speeds
	vx=0,
	vy=0,
	vz=0,
	soundHandle=nil
}

local heliModel = {
	visual = "mesh",
	mesh = "heli.x",
	textures = {"blades.png","blades.png","heli.png","Glass.png"},
}	

--
-- Heli methods
--

-- add disconnected player to inactives list
function heli:addinactive(name)

	if self.inactives then

		self.inactives = {n = self.inactives, v = name}
	else
		self.inactives = {n = nil, v = name}
	end
end


-- get reconnected player who was riding
function heli:getreactive()
	local l = self.inactives
	local p = nil
	local pl = nil

	while l do
		pl = minetest.get_player_by_name(l.v)
		if pl then
			if p then
				p.n = l.n
			else
				self.inactives = l.n
			end

			return pl
		end

		p = l
		l = l.n	
	end

	return nil
end

function heli:setdriver(player, special)
	local object = self.object
	local bone = ""

    local yoffset=0
	if dofancy then
		object = self.model
		yoffset=5
	end

	local refresh = false

	if special and special == "refresh" then
		refresh = true
	end

	if refresh == false then
		self.driver = player
		self.named = player:get_player_name()
	elseif not player then
		return
	end
	
	if not self.running then
		self.soundHandle=minetest.sound_play({name="helicopter_motor"},{object = self.object, gain = 0.2, max_hear_distance = 32, loop = true,})
		self.model:set_animation({x=0,y=11},30, 0)
		self.running = true
	end

	player:set_attach(object, bone, {x=0,y=9+yoffset,z=0}, {x=0,y=0,z=0})
	player:set_eye_offset({x=0,y=-5,z=0},{x=0,y=0,z=0})
end


function heli:setpas1(player, special)
	local object = self.object
	local bone = ""

    local yoffset=0
	if dofancy then
		object = self.model
	end
	
	local refresh = false
	if special and special == "refresh" then
		refresh = true
	end

	if refresh == false then
		local swap = false
		local seattaken = false

		if special and special == "swap" then
			swap = true

		end
		if self.pas1 and self.pas1:is_player() then
			seattaken = true
		end
	
		if swap == true and seattaken == false then
			return
		end
		if swap == false and seattaken == true then
			return
		end

		if swap == true then
			self:setdriver(self.pas1)
		end
	
		self.pas1 = player
		self.name1 = player:get_player_name()
	elseif not player then
		return
	end

	player:set_attach(object, bone, {x=-10,y=9+yoffset,z=-9}, {x=0,y=0,z=0})
end

function heli:setpas2(player, special)
	local object = self.object
	local bone = ""

    local yoffset=0
	if dofancy then
		object = self.model
	end
	
	local refresh = false
	if special and special == "refresh" then
		refresh = true
	end
	if refresh == false then
		local swap = false
		local seattaken = false

		if special and special == "swap" then
			swap = true

		end
		if self.pas2 and self.pas2:is_player() then
			seattaken = true
		end
	
		if swap == true and seattaken == false then
			return
		end
		if swap == false and seattaken == true then
			return
		end

		if swap == true then
			self:setdriver(self.pas2)
		end

		self.pas2 = player
		self.name2 = player:get_player_name()
	elseif not player then
		return
	end
	
	player:set_attach(object, bone, {x=10,y=9+yoffset,z=-9}, {x=0,y=0,z=0})
end

function heli:removedriver()
	if self.driver:is_player() then
		self.driver:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
		self.driver:set_detach()
	end

	self.driver = nil
	self.named = nil
	
	if self.pas1 then
		local newdriver = self.pas1
		self:removepas1()
		self:setdriver(newdriver)
	else
		self.model:set_animation({x=0,y=1},0, 0)
		minetest.sound_stop(self.soundHandle)
		self.running = false
	end
end

function heli:removepas1()
	if self.pas1:is_player() then

		self.pas1:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
		self.pas1:set_detach()
	end
	self.pas1 = nil
	self.name1 = nil
	if self.pas2 then
		local newpas1 = self.pas2
		self:removepas2()
		self:setpas1(newpas1)
	end
end

function heli:removepas2()
	if self.pas2:is_player() then
		self.pas2:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
		self.pas2:set_detach()
	end
	self.pas2 = nil
	self.name2 = nil
end

function heli:on_rightclick(clicker)
	local ctrl = clicker:get_player_control()
	
	if not clicker or not clicker:is_player() then
		return
	end
	
	-- Hold "e" and right-click to dismount
	if self.driver and clicker == self.driver and ctrl.aux1 then
		self:removedriver()
		return
	elseif self.pas1 and clicker == self.pas1 then
		return
	elseif self.pas2 and clicker == self.pas2 then	
		return
	elseif not self.driver then
		self:setdriver(clicker)
	elseif not self.pas1 then
		self:setpas1(clicker)
	elseif not self.pas2 then
		self:setpas2(clicker)
	end
end

function heliModel:on_activate(staticdata, dtime_s)
	self.object:set_armor_groups({immortal=1})
	local is_attached = false
	for _,object in ipairs(minetest.get_objects_inside_radius(self.object:getpos(), 2)) do
		if object and object:get_luaentity() and object:get_luaentity().name=="helicopter:heli" then
			if object:get_luaentity().model == nil then
				object:get_luaentity().model = self
			end
			if object:get_luaentity().model == self then
				is_attached = true
			end
		end
	end
	if is_attached == false then
		self.object:remove()
	end
end

function heli:on_activate(staticdata, dtime_s)
	local split = string.split(staticdata)
	for i,word in ipairs(split) do
		self:addinactive(word)
	end
	self.object:set_armor_groups({immortal=1})
	self.object:set_hp(30)
	self.prev_y=self.object:getpos()
	if self.model == nil then
		self.model = minetest.add_entity(self.object:getpos(), "helicopter:heliModel")
		self.model:set_attach(self.object, "", {x=0,y=-5,z=0}, {x=0,y=0,z=0})	
	end
end

function heli:get_staticdata( )
	local l = self.inactives
	local i = ""
	while l do
		i = i ..  l.v .. ","
		l = l.n
	end
	if (self.named) then
		i = i .. self.named .. ","
	end
	if (self.name1) then
		i = i .. self.name1 .. ","
	end
	if (self.name2) then
		i = i .. self.name2 .. ","
	end
	return i
end

function heli:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	if puncher and puncher:is_player() then
		if not self.driver and not self.pas1 and not self.pas2 then
			if self.model ~= nil then
				self.model:remove()
			end
			if self.soundHandle then
				minetest.sound_stop(self.soundHandle)
			end
			self.object:remove()
			puncher:get_inventory():add_item("main", "helicopter:heli")
		end
	end
end

function heliModel:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	self.object:remove()
end

function heli:on_step(dtime)
	-- check if passenger #2 disconnected from the game
	if self.pas2 and self.pas2:get_player_name() == "" then
		self:addinactive(self.name2)
		self:removepas2()
	end
	-- check if passenger #1 disconnected from the game
	if self.pas1 and self.pas1:get_player_name() == "" then
		self:addinactive(self.name1)
		self:removepas1()
	end
	-- check if driver disconnected from the game
	if self.driver and self.driver:get_player_name() == "" then
		self:addinactive( self.named)
		self:removedriver()
	end

	--Prevent multi heli control bug, seems buggy so commented out 
	--if self.driver and ( math.abs(self.driver:getpos().x-self.object:getpos().x)>10*dtime or math.abs(self.driver:getpos().y-self.object:getpos().y)>10*dtime or math.abs(self.driver:getpos().z-self.object:getpos().z)>10*dtime) then
	--	print("ejecting driver")
	--	self:removedriver()
	--end

	local hasdriver = false
	local haspas1 = false
	local haspas2 = false

	if self.driver then
		hasdriver = true
	end
	if self.pas1 then
		haspas1 = true
	end
	if self.pas2 then
		haspas2 = true
	end
	
	-- if theres an empty spot for a driver or passenger, check if a player reconnected that disconnected while driving
	if not hasdriver or not haspas1 or not haspas2 then
		local rp = self:getreactive()
		if rp then
			
			if not hasdriver then
				self:setdriver(rp)
			elseif not haspas1 then
				self:setpas1(rp)
			elseif not haspas2 then
				self:setpas2(rp)
			
			end

		end
	end

	-- workaround for bouncing off of air... make sure the block we hit is not air
	-- for now we just count the air... but it should probably only check the colliding side of the heli
	local air_count = 0
    local driver_pos = self.object:getpos()

	local pos_tbl = {
		vector.new(driver_pos.x - 1, driver_pos.y, driver_pos.z),
		vector.new(driver_pos.x + 1, driver_pos.y, driver_pos.z),
		vector.new(driver_pos.x, driver_pos.y - 1, driver_pos.z),
		vector.new(driver_pos.x, driver_pos.y + 1, driver_pos.z),
		vector.new(driver_pos.x, driver_pos.y, driver_pos.z - 1),
		vector.new(driver_pos.x, driver_pos.y, driver_pos.z + 1),
	}
	for i, pos in pairs(pos_tbl) do
		local object = minetest.get_node_or_nil(pos)
		-- TODO: instead of looking for air, look at the collides property
		if object then
			--if self.driver then
			--	minetest.chat_send_player(self.driver:get_player_name(), "pos = (" .. pos.x .. "," .. pos.y .. "," .. pos.z .. "), name = " .. object.name)
			--end
			if object.name == "air" or object.name == "walking_light:light" then
				air_count = air_count + 1
			end
		end
	end
    --if self.driver then
	--	minetest.chat_send_player(self.driver:get_player_name(), "air_count = " .. air_count)
	--end

	if air_count ~= 6 then
		-- if object is stopped it hit something, bounce unless landing	
		local vel = self.object:getvelocity()
		if vel.x == 0 then
			self.vx = -0.3 * self.vx
		end
		if vel.y == 0 then
			if self.vy <0 then
				-- stop when trying to land
				self.vy = 0 
			else
				self.vy = -0.3 * self.vy	
			end
		end
		if vel.z == 0 then
			self.vz = -0.3 * self.vz
		end
	end
	
	if self.driver then
		--self.driver:set_animation({ x= 81, y=160, },10,0)
		self.yaw = self.driver:get_look_horizontal() + math.pi / 2
		local ctrl = self.driver:get_player_control()
		
		--Forward/backward
		if ctrl.up then
			self.vx = self.vx + math.cos(self.yaw)*0.1
			self.vz = self.vz + math.sin(self.yaw)*0.1
		end
		
		if ctrl.down and ctrl.aux1 then -- use key (e) + down key (s) = player gets out
			self:removedriver()
		elseif ctrl.down then
			self.vx = self.vx-math.cos(self.yaw)*0.1
			self.vz = self.vz-math.sin(self.yaw)*0.1
		end
		--Left/right
		
		if ctrl.left and ctrl.aux1 then -- use key + left key switches places with the left passenger
			self:setpas1(self.driver,"swap")
		elseif ctrl.left then
			self.vz = self.vz+math.cos(self.yaw)*0.1
			self.vx = self.vx+math.sin(math.pi+self.yaw)*0.1
		end
		
		if ctrl.right and ctrl.aux1 then -- use key + right key switches places with the right passenger
			self:setpas2(self.driver,"swap")
		elseif ctrl.right then
			self.vz = self.vz-math.cos(self.yaw)*0.1
			self.vx = self.vx-math.sin(math.pi+self.yaw)*0.1
		end
		--up/down
		if ctrl.jump then
			if self.vy<3 then
				self.vy = self.vy+0.2
			end
		end
		if ctrl.sneak then
			if self.vy>-10 then
				self.vy = self.vy-0.2
			end
		end
		--
	end
	
	if self.pas1 then
		local ctrl1 = self.pas1:get_player_control()
		if ctrl1.aux1 and ctrl1.down then
		
			self:removepas1()
		end
	end
	if self.pas2 then
		local ctrl2 = self.pas2:get_player_control()
		if ctrl2.aux1 and ctrl2.down then
			self:removepas2()
		end
	end
	if self.vx==0 and self.vz==0 and self.vy==0 then
		
	else
		--Decelerating
		local sx=get_sign(self.vx)
		self.vx = self.vx - 0.02*sx
		local sz=get_sign(self.vz)
		self.vz = self.vz - 0.02*sz
		local sy=get_sign(self.vy)
		self.vy = self.vy-0.01*sy
		
		--Stop
		if sx ~= get_sign(self.vx) then
			self.vx = 0
		end
		if sz ~= get_sign(self.vz) then
			self.vz = 0
		end
		if sy ~= get_sign(self.vy) then
			self.vy = 0
		end
	
		local maxspeed = 30
	
		--Speed limit
		if math.abs(self.vx) > maxspeed then
			self.vx = maxspeed*get_sign(self.vx)
		end
		if math.abs(self.vz) > maxspeed then
			self.vz = maxspeed*get_sign(self.vz)
		end
		if math.abs(self.vy) > maxspeed then
			self.vz = maxspeed*get_sign(self.vy)
		end
	end
	--if in water and going down, stop going down
	
	local pos = self.object:getpos()
	if (pos) then
		local block_at_pos = minetest.get_node(pos)
		if minetest.get_item_group(block_at_pos.name,"water") ~= 0 and self.vy < 0 then
			self.vy = 0
		end
	end

	--Set speed to entity
	self.object:setvelocity({x=self.vx, y=self.vy,z=self.vz})
	
	if self.model or self.driver then
		local xr=-90+self.vx*3*math.cos(self.yaw)+self.vz*3*math.sin(self.yaw)
		local yr =0-self.vx*3*math.sin(self.yaw)+self.vz*3*math.cos(self.yaw)
		local zr=(self.yaw-math.pi/2)*57
	
		if self.model then
			self.model:set_attach(self.object,"Root", {x=0,y=0,z=5}, {x=xr,y=yr,z=0})
		end
		if self.driver then
			self.object:setyaw(self.yaw-math.pi/2)
			-- reattach passengers so that players just entering the area or logging in will see the passengers
			self:setdriver(self.driver,"refresh")
			self:setpas1(self.pas1,"refresh")
			self:setpas2(self.pas2,"refresh")	
		end
	end
end

--
--Registration
--

minetest.register_entity("helicopter:heli", heli)
minetest.register_entity("helicopter:heliModel", heliModel)

--
--Craft items
--

--Blades
minetest.register_craftitem("helicopter:blades",{
	description = S("Blades"),
	inventory_image = "blades_inv.png",
	wield_image = "blades_inv.png",
})
--Cabin
minetest.register_craftitem("helicopter:cabin",{
	description = S("Cabin for heli"),
	inventory_image = "cabin_inv.png",
	wield_image = "cabin_inv.png",
})
--Heli
minetest.register_craftitem("helicopter:heli", {
	description = S("Helicopter"),
	inventory_image = "heli_inv.png",
	wield_image = "heli_inv.png",
	wield_scale = {x=1, y=1, z=1},
	liquids_pointable = false,
	
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		if minetest.get_node(pointed_thing.above).name ~= "air" then
			return
		end
		minetest.add_entity(pointed_thing.above, "helicopter:heli")
		itemstack:take_item()
		return itemstack
	end,
})

--
--Craft
--

minetest.register_craft({
	output = 'helicopter:blades',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'default:steel_ingot', 'group:stick', 'default:steel_ingot'},
		{'', 'default:steel_ingot', ''},
	}
})
minetest.register_craft({
	output = 'helicopter:cabin',
	recipe = {
		{'', 'group:wood', ''},
		{'group:wood', 'default:mese_crystal','default:glass'},
		{'group:wood','group:wood','group:wood'},		
	}
})		
minetest.register_craft({
	output = 'helicopter:heli',
	recipe = {
		{'', 'helicopter:blades', ''},
		{'helicopter:blades', 'helicopter:cabin',''},	
	}
})	

-- vim: ts=4 sw=4 softtabstop=4 smarttab noet:

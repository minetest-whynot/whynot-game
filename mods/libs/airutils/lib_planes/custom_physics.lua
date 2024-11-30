function airutils.physics(self)
    local friction = self._ground_friction or 0.99
	local vel=self.object:get_velocity()
    local new_velocity = vector.new()

	--buoyancy
	local surface = nil
	local surfnodename = nil
	local spos = airutils.get_stand_pos(self)
    if not spos then return end
	spos.y = spos.y+0.01
	-- get surface height
	local snodepos = airutils.get_node_pos(spos)
	local surfnode = airutils.nodeatpos(spos)
	while surfnode and (surfnode.drawtype == 'liquid' or surfnode.drawtype == 'flowingliquid') do
		surfnodename = surfnode.name
		surface = snodepos.y +0.5
		if surface > spos.y+self.height then break end
		snodepos.y = snodepos.y+1
		surfnode = airutils.nodeatpos(snodepos)
	end

	self.isinliquid = surfnodename
	if surface then				-- standing in liquid
        self.isinliquid = true
    end
    local last_accel = vector.new()
    if self._last_accel then
        last_accel = vector.new(self._last_accel)
    end

    if self.isinliquid then
        self.water_drag = 0.2
        self.isinliquid = true
        local height = self.height
		local submergence = math.min(surface-spos.y,height)/height
--		local balance = self.buoyancy*self.height
        local buoyacc = airutils.gravity*(self.buoyancy-submergence)
        --local buoyacc = self._baloon_buoyancy*(self.buoyancy-submergence)
        local accell = {
                    x=-vel.x*self.water_drag,
                    y=buoyacc-(vel.y*math.abs(vel.y)*0.4),
                    z=-vel.z*self.water_drag
                }
        if self.buoyancy >= 1 then self._engine_running = false end
        if last_accel then
            accell = vector.add(accell,last_accel)
        end
        new_velocity = vector.multiply(accell,self.dtime)
        --airutils.set_acceleration(self.object,accell)
        --self.object:move_to(self.object:get_pos())
	else
        --airutils.set_acceleration(self.object,{x=0,y=airutils.gravity,z=0})
		self.isinliquid = false

        if last_accel then
            last_accel.y = last_accel.y + airutils.gravity --gravity here

            new_velocity = vector.multiply(last_accel,self.dtime)
        end
        --self.object:set_acceleration({x=0,y=new_accel.y, z=0})
	end

    if self.isonground and not self.isinliquid then
        --dumb friction
        new_velocity = {x=new_velocity.x*friction,
							    y=new_velocity.y,
							    z=new_velocity.z*friction}

        -- bounciness
        if self.springiness and self.springiness > 0 and self.buoyancy >= 1 then
            local vnew = vector.new(new_velocity)

            if not self.collided then						-- ugly workaround for inconsistent collisions
	            for _,k in ipairs({'y','z','x'}) do
		            if new_velocity[k]==0 and math.abs(self.lastvelocity[k])> 0.1 then
			            vnew[k]=-self.lastvelocity[k]*self.springiness
		            end
	            end
            end

            if not vector.equals(new_velocity,vnew) then
	            self.collided = true
            else
	            if self.collided then
		            vnew = vector.new(self.lastvelocity)
	            end
	            self.collided = false
            end
            new_velocity = vnew
        end

        --damage if the friction is below .97
        if self._last_longit_speed then
            if friction <= 0.97 and self._last_longit_speed > 0 then
                self.hp_max = self.hp_max - 0.001
                airutils.setText(self, self._vehicle_name)
            end --damage the plane if it have hard friction
        end

        --self.object:set_velocity(new_velocity)
        --new_velocity = vector.subtract(new_velocity,vel)

        --fix bug with unexpe3cted moving
        if not self.driver_name and math.abs(vel.x) < 0.2 and math.abs(vel.z) < 0.2 then
            self.object:set_velocity({x=0,y=airutils.gravity*self.dtime,z=0})
            if self.wheels then self.wheels:set_animation_frame_speed(0) end
            return
        end
    end

    self.object:add_velocity(new_velocity)
end


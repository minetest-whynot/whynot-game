function airutils.contains(table, val)
    for k,v in pairs(table) do
        if k == val then
            return v
        end
    end
    return false
end

function airutils.loadFuel(self, player_name)
    local player = minetest.get_player_by_name(player_name)
    local inv = player:get_inventory()
    local itmstck=player:get_wielded_item()

    local item_name = ""
    if itmstck then item_name = itmstck:get_name() end

    local fuel = airutils.contains(airutils.fuel, item_name)
    if fuel then
        --local stack = ItemStack(item_name .. " 1")

        if self._energy < self._max_fuel then
            itmstck:set_count(1)
            inv:remove_item("main", itmstck)
            self._energy = self._energy + fuel
            if self._energy > self._max_fuel then self._energy = self._max_fuel end

            --local energy_indicator_angle = airutils.get_gauge_angle(self._energy)
            --self.fuel_gauge:set_attach(self.object,'',self._gauge_fuel_position,{x=0,y=0,z=energy_indicator_angle})
        end

        return true
    end

    return false
end

function airutils.consumptionCalc(self, accel)
    if accel == nil then return end
    if self._energy > 0 and self._engine_running and accel ~= nil then
        local divisor = 700000
        if self._fuel_consumption_divisor then divisor = self._fuel_consumption_divisor end
        local consumed_power = 0
        local parent_obj = self.object:get_attach()
        if not parent_obj then
            if self._rotor_speed then
                --is an helicopter
                consumed_power = 50/divisor --fixed rpm
            else
                --is a normal plane
                consumed_power = self._power_lever/divisor
            end
        end
        --minetest.chat_send_all('consumed: '.. consumed_power)
        self._energy = self._energy - consumed_power;

        local energy_indicator_angle = airutils.get_gauge_angle(self._energy)
        if self.fuel_gauge then
            if self.fuel_gauge:get_luaentity() then
                self.fuel_gauge:set_attach(self.object,'',self._gauge_fuel_position,{x=0,y=0,z=energy_indicator_angle})
            end
        end
    end
    if self._energy <= 0 and self._engine_running and accel ~= nil then
        self._engine_running = false
        self._autopilot = false
        if self.sound_handle then minetest.sound_stop(self.sound_handle) end
	    self.object:set_animation_frame_speed(0)
    end
end

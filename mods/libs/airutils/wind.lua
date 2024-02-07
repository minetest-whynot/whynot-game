--[[
MIT License

Copyright (c) 2019 TheTermos, TestificateMods

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local get_wind

if minetest.get_modpath("climate_api") then
	get_wind = function(pos, multiplier)
        multiplier = multiplier or 0.1
		local wind = climate_api.environment.get_wind({x=0,y=0,z=0})
		return vector.multiply(wind, multiplier)
	end

else
	local yaw = math.random()*math.pi*2-math.pi
    local speed = math.random()*4.0
	airutils.wind={}
	airutils.wind.wind = vector.multiply(minetest.yaw_to_dir(yaw),speed)
	airutils.wind.timer = 0
	airutils.wind.ttime = math.random()*5*60+1*60

	get_wind = function(pos, multiplier)
        local retVal = vector.multiply(airutils.wind.wind, multiplier)
		return retVal
	end

	minetest.register_globalstep(
	function(dtime)
		airutils.wind.timer=airutils.wind.timer+dtime
		if airutils.wind.timer >= airutils.wind.ttime then
			local yaw = minetest.dir_to_yaw(airutils.wind.wind)
			yaw = yaw+math.random()-0.5
            local speed = math.random()*4.0
			airutils.wind.wind = vector.multiply(minetest.yaw_to_dir(yaw),speed)
			airutils.wind.ttime = airutils.wind.timer+math.random()*5*60+1*60
		end
	end)
end

return get_wind

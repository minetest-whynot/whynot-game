--------------------------------
-- Happy Weather: ABM registers

-- License: MIT

-- Credits: xeranas
--------------------------------

-- ABM for extinguish fire
minetest.register_abm({
	nodenames = {"fire:basic_flame"},
	interval = 4.0,
	chance = 2,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if happy_weather.is_weather_active("heavy_rain") or happy_weather.is_weather_active("rain") then
			if hw_utils.is_outdoor(pos) then
				minetest.remove_node(pos)
			end
		end
	end
})
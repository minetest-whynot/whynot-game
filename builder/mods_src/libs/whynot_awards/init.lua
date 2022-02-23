-- Set builtin awards to hidden
-- 4 awards are registered with minetest.after() so these cannot be hidden

for name, award in pairs(awards.registered_awards) do
	award.secret = true
end


awards.register_award("whynot_spawnpoint", {
	title = "Find your new home",
	description = "Your home is the place with your bed. If you sleep once in bed, you always respawn at this position in case of death",
	icon = "beds_bed.png",
--	prices = { }, -- Price is a new home ;-)
--	on_unlock = function(name, def) end

})

local orig_beds_on_rgihtclick = beds.on_rightclick
function beds.on_rightclick(pos, player)
	orig_beds_on_rgihtclick(pos, player)
	local player_name = player:get_player_name()
	if beds.player[player_name] then
		awards.unlock(player_name, "whynot_spawnpoint")
	end
end

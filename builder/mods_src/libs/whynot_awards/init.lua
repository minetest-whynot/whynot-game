-- Set builtin awards to hidden
-- 4 awards are registered with minetest.after() so these cannot be hidden

awards.registered_awards = {}


awards.register_award("whynot_spawnpoint", {
	title = "Find your new home",
	description = "Your home is the place with your bed. If you sleep once in bed, you always respawn at this position in case of death",
	icon = "beds_bed.png",
--	prices = { }, -- Price is a new home ;-)
--	on_unlock = function(name, def) end

})

local orig_beds_on_rightclick = beds.on_rightclick
function beds.on_rightclick(pos, player)
	orig_beds_on_rightclick(pos, player)
	local player_name = player:get_player_name()
	if beds.player[player_name] then
		awards.unlock(player_name, "whynot_spawnpoint")
	end
end


awards.register_award("whynot_welcome", {
	title = "Welcome to the WhyNot? game",
	icon = "beds_bed.png",
	description = "You are embarking on a Minetest journey. Whether it's for the thrill of survival, the satisfaction of exploration, or the arts of crafting and creative designs, we hope you will find it enjoyable.",
	trigger = {
		type   = "join",
		target = 2,
	},
})

awards.register_award("whynot_tree",{
	title = "Lumberjack",
	description = "Chop some wood, karate-style",
	trigger = {
		type = "dig",
		node = "group:tree",
		target = 2,
	},
})

awards.register_award("whynot_planks",{
	title = "Woody",
	description = "Chop some wood, karate-style",
	trigger = {
		type = "craft",
		item = "group:plank",
		target = 2,
	},
})
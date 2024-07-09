local functions = {}

function functions.can_interact_with_node(player, pos)
	--if we have default, use it
	if default then return default.can_interact_with_node(player, pos) end

	local owner = minetest.get_meta(pos):get_string("owner") or ""

	--check that we have a valid player
	if not player or not player:is_player() then return false end
	--check there privs for compat with areas
	if minetest.check_player_privs(player, "protection_bypass") then return true end
	--if a normal player, check if they are the owner
	if owner == "" or owner == player:get_player_name() then return true end

	return false
end

return functions
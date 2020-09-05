-- Tool capabilities from default mod
local tool_capabilities = minetest.registered_items[":"] and
		minetest.registered_items[":"].tool_capabilities


local function register_hand_node(skin)
 -- If hand_node already given, assume the hand is already provided
	if skin.hand_node then
		return
	end

	local clean_name = skin.name:gsub('[%p%c%s]', '')
	local prefix = minetest.get_current_modname()
	if not prefix then -- At runtime node registrations are not allowed
		return
	end
	skin.hand_node = prefix..':'..clean_name

	minetest.register_node(skin.hand_node, {
		tiles = skin.textures,
		visual_scale = 1,
		wield_scale = {x=1,y=1,z=1},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "hand.b3d",
		node_placement_prediction = "",
		groups = { not_in_creative_inventory = 1 },
		tool_capabilities = tool_capabilities
	})
end

-- Process already registered skins
for _, skin in pairs(player_api.registered_skins) do
	register_hand_node(skin)
end

-- Process Skins registered in feature
local old_register_skin = player_api.register_skin
function player_api.register_skin(name, skin)
	old_register_skin(name, skin)
	register_hand_node(skin)
end

-- Change the hand on skin change
player_api.register_on_skin_change(function(player, player_model, skin_name)
	local skin = player_api.registered_skins[skin_name]
	if skin and skin.hand_node then
		player:get_inventory():set_size("hand", 1)
		player:get_inventory():set_stack("hand", 1, skin.hand_node)
	else
		player:get_inventory():set_stack("hand", 1, "")
	end
end)

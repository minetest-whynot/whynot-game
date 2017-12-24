local smartfs = smart_inventory.smartfs

local function on_rightclick(pos, node, player, itemstack, pointed_thing)
	smartfs.get("smart_inventory:main"):show(player:get_player_name())
end

local sound = nil
if minetest.global_exists("default") then
	sound = default.node_sound_wood_defaults()
end

-- Return smart inventory workbench definition if enabled
minetest.register_node("smart_inventory:workbench", {
	description = "Smart inventory workbench",
	groups = {cracky=2, choppy=2, oddly_breakable_by_hand=1},
	sounds = sound,
	tiles = {
			"smart_inventory_workbench_top.png",
			"smart_inventory_workbench_top.png",
			"smart_inventory_workbench_sides.png",
			"smart_inventory_workbench_sides.png",
			"smart_inventory_workbench_front.png",
			"smart_inventory_workbench_front.png"
		},
	on_rightclick = on_rightclick
})

minetest.register_craft({
output = "smart_inventory:workbench",
	recipe = {
		{"default:coral_skeleton", "default:coral_skeleton"},
		{"default:coral_skeleton", "default:coral_skeleton"}
	}
})

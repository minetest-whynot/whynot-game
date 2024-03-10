local S = minetest.get_translator("airutils")

-- trike repair
minetest.register_craftitem("airutils:repair_tool",{
	description = "Repair Tool",
	inventory_image = "airutils_repair_tool.png",
})

minetest.register_craft({
    output = "airutils:repair_tool",
    recipe = {
	    {"", "default:steel_ingot", ""},
	    {"", "default:steel_ingot", ""},
	    {"default:steel_ingot", "", "default:steel_ingot"},
    },
})


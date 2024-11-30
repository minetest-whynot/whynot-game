local S = airutils.S

-- trike repair
core.register_craftitem("airutils:repair_tool",{
	description = S("Repair Tool"),
	inventory_image = "airutils_repair_tool.png",
})

core.register_craft({
    output = "airutils:repair_tool",
    recipe = {
	    {"", "default:steel_ingot", ""},
	    {"", "default:steel_ingot", ""},
	    {"default:steel_ingot", "", "default:steel_ingot"},
    },
})

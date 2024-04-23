local materials = xcompat.materials

minetest.register_craft({
    output = "home_workshop_misc:soda_machine",
    recipe = {
        {materials.steel_ingot, materials.steel_ingot, materials.steel_ingot},
        {materials.steel_ingot, materials.dye_red, materials.steel_ingot},
        {materials.steel_ingot, materials.copper_block, materials.steel_ingot},
    },
})
minetest.register_craft({
    output = "home_vending_machines:drink_machine",
    recipe = {
        {materials.steel_ingot, "group:vessel", materials.steel_ingot},
        {materials.steel_ingot, materials.steel_ingot, materials.steel_ingot},
        {materials.steel_ingot, materials.copper_block, materials.steel_ingot},
    },
})
minetest.register_craft({
    output = "home_vending_machines:sweet_machine",
    recipe = {
        {materials.steel_ingot, "group:food_sugar",    materials.steel_ingot},
        {materials.steel_ingot, materials.steel_ingot, materials.steel_ingot},
        {materials.steel_ingot, materials.copper_block, materials.steel_ingot},
    },
})
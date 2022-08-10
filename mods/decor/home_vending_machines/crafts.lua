if minetest.get_modpath("default") then
    if minetest.get_modpath("dye") then
        minetest.register_craft({
            output = "home_workshop_misc:soda_machine",
            recipe = {
                {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
                {"default:steel_ingot", "dye:red",             "default:steel_ingot"},
                {"default:steel_ingot", "default:copperblock", "default:steel_ingot"},
            },
        })
    end
    if minetest.get_modpath("vessels") then
        minetest.register_craft({
            output = "home_vending_machines:drink_machine",
            recipe = {
                {"default:steel_ingot", "group:vessel", "default:steel_ingot"},
                {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
                {"default:steel_ingot", "default:copperblock", "default:steel_ingot"},
            },
        })
    end
    if minetest.global_exists("farming") and farming.mod == "redo" then
        minetest.register_craft({
            output = "home_vending_machines:sweet_machine",
            recipe = {
                {"default:steel_ingot", "group:food_sugar",    "default:steel_ingot"},
                {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
                {"default:steel_ingot", "default:copperblock", "default:steel_ingot"},
            },
        })
    end
end

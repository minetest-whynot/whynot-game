local function reg_item(name, evalue)
    minetest.register_craftitem("home_vending_machines:" .. name, {
        description = string.gsub(name, "_", " "),
        inventory_image = "home_vending_machines_" .. name .. ".png",
        on_use = minetest.item_eat(evalue),
    })
end

reg_item("soda_can", 2)
minetest.register_alias("home_workshop_misc:soda_can", "home_vending_machines:soda_can")

reg_item("water_bottle", 3)
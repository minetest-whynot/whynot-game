home_vending_machines.register_currency("default:gold_ingot", 1)
home_vending_machines.register_currency("currency:minegeld_cent_25", 1)

home_vending_machines.register_machine("simple", "home_workshop_misc:soda_machine", {
    description = "Soda vending machine",
    tiles = {"home_vending_machines_soda_machine.png"},
    sounds = nil,
    _vmachine = {
        item = "home_vending_machines:soda_can"
    }
})

home_vending_machines.register_machine("simple", "home_vending_machines:drink_machine", {
    description = "Drinks vending machine",
    tiles = {"home_vending_machines_drink_machine.png"},
    sounds = nil,
    _vmachine = {
        item = {"home_vending_machines:soda_can", "home_vending_machines:water_bottle"}
    }
})

home_vending_machines.register_machine("simple", "home_vending_machines:sweet_machine", {
    description = "Sweets vending machine",
    tiles = {"home_vending_machines_sweet_machine.png"},
    sounds = nil,
    _vmachine = {
        item = "home_vending_machines:soda_can"
    }
})
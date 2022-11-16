-- Load support for MT game translation.
local S = minetest.get_translator("biofuel")


--Biofuel:
----------


--Vial of Biofuel
minetest.register_craftitem("biofuel:phial_fuel", {
	description = S("Vial of Biofuel"),
	inventory_image = "biofuel_phial_fuel.png"
})

minetest.register_craft({
	type = "fuel",
	recipe = "biofuel:phial_fuel",
	burntime = 10,
})


--Bottle of Biofuel

minetest.register_craftitem("biofuel:bottle_fuel", {
	description = S("Bottle of Biofuel"),
	inventory_image = "biofuel_bottle_fuel.png",
	groups = {biofuel = 1}
})

minetest.register_craft({
    type = "shapeless",
    output = "biofuel:bottle_fuel",
    recipe = {"biofuel:phial_fuel", "biofuel:phial_fuel", "biofuel:phial_fuel", "biofuel:phial_fuel"}
})


minetest.register_craft({
	type = "fuel",
	recipe = "biofuel:bottle_fuel",
	burntime = 40,
})


--Canister of Biofuel

minetest.register_craftitem("biofuel:fuel_can", {
	description = S("Canister of Biofuel"),
	inventory_image = "biofuel_fuel_can.png"
})

minetest.register_craft({
	type = "fuel",
	recipe = "biofuel:fuel_can",
	burntime = 370,
})

minetest.register_craft({
	output = "biofuel:fuel_can",
	recipe = {
			{"group:biofuel", "group:biofuel", "group:biofuel"},
			{"group:biofuel", "group:biofuel", "group:biofuel"},
			{"group:biofuel", "group:biofuel", "group:biofuel"}
		 }
})


--Mod compatibility:
--------------------

local register_biofuel = function(name, burntime)
	if not minetest.registered_items[name] then
		return;
	end
	local groups = table.copy(minetest.registered_items[name].groups)
	groups.biofuel = 1
	minetest.override_item(name, { groups = groups })
	if burntime and burntime >= 0 then
		minetest.register_craft({
			type = "fuel",
			recipe = name,
			burntime = burntime,
		})
	end
end


--Wine 
register_biofuel("wine:bottle_rum", 40)
register_biofuel("wine:bottle_tequila", 40)
register_biofuel("wine:bottle_bourbon", 40)
register_biofuel("wine:bottle_sake", 40)
register_biofuel("wine:bottle_vodka", 40)

--Basic Materials
register_biofuel("basic_materials:oil_extract")


--Cucina_Vegana
register_biofuel("cucina_vegana:sunflower_seeds_oil")
register_biofuel("cucina_vegana:flax_seed_oil")
register_biofuel("cucina_vegana:lettuce_oil")
register_biofuel("cucina_vegana:peanut_oil")

--Farming_Redo
register_biofuel("farming:bottle_ethanol")
register_biofuel("farming:hemp_oil")

ediblestuff = {}
ediblestuff.logcount = 0
ediblestuff.logdelay = 5
ediblestuff.hunger_threshold = minetest.settings:get("ediblestuff_api.hunger_threshold") or 0.5

-- How much does an arbirary item satiate when equipped?
-- This is only needed because calling on_use is much more expensive and might have side effects
ediblestuff.satiates = {}

-- Used only if the `3d_armor` mod is present.
ediblestuff.equipped = {}
ediblestuff.edible_while_wearing = {}

ediblestuff.make_thing_edible = function(item,amount)
	minetest.override_item(item, {
		on_use=minetest.item_eat(amount)
	})
	ediblestuff.satiates[item] = amount
	if minetest.get_modpath("hunger_ng") ~= nil then
		hunger_ng.add_hunger_data(item, {
			satiates = amount,
		})
	elseif minetest.get_modpath("hunger") and hunger.register_food then
		hunger.register_food(item,amount)
	end
end
ediblestuff.make_things_edible = function(mod,name,scale,items)
	local result = {}
	for typ,amount in pairs(items) do
		local scaled = scale*amount
		result[typ]=scaled
		ediblestuff.make_thing_edible(mod..":"..typ.."_"..name,scaled)
	end
	return result
end
ediblestuff.make_tools_edible = function (mod,name,scale,is_flat_rate)
	local numbers={
		pick=3,
		shovel=1,
		axe=3,
		sword=2,
	}
	if minetest.get_modpath("farming") ~= nil then numbers.hoe=2 end
	if is_flat_rate == true then
		for typ,_ in pairs(numbers) do
			numbers[typ] = 1
		end
	end
	return ediblestuff.make_things_edible(mod,name,scale,numbers)
end
ediblestuff.make_armor_edible = function(mod,name,scale,is_flat_rate)
	if minetest.get_modpath("3d_armor") == nil then return {} end
	local numbers = {
		helmet=5,
		chestplate=8,
		leggings=7,
		boots=4,
	}
	if minetest.get_modpath("shields") ~= nil then
		numbers.shield=7
	end
	if is_flat_rate == true then
		for typ,_ in pairs(numbers) do
			numbers[typ] = 1
		end
	end
	return ediblestuff.make_things_edible(mod,name,scale,numbers)
end
ediblestuff.make_armor_edible_while_wearing = function (mod,name,scale,is_flat_rate)
	local result = ediblestuff.make_armor_edible(mod,name,scale,is_flat_rate)
	for typ,_ in pairs(result) do
		ediblestuff.edible_while_wearing[mod..":"..typ.."_"..name] = true
	end
	return result
end
-- These functions all make calls to `minetest.override_item`, which should only
-- be used at load-time, according to the MT API doc
minetest.register_on_mods_loaded(function()
	ediblestuff.make_thing_edible = nil
	ediblestuff.make_things_edible = nil
	ediblestuff.make_tools_edible = nil
	ediblestuff.make_armor_edible = nil
	ediblestuff.make_armor_edible_while_wearing = nil
end)

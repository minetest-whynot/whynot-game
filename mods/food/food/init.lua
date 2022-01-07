-- FOOD MOD
-- A mod written by rubenwardy that adds
-- food to the minetest game
-- =====================================
-- >> food/api.lua
-- The supporting api for the mod
-- =====================================

food = {
	modules = {},
	disabled_modules = {},
	debug = false,
	version = 2.3,
	disable_fallbacks =
		minetest.setting_getbool("food.disable_fallbacks")
}

-- Checks for external content, and adds support
function food.support(group, item)
	if type(group) == "table" then
		for i = 1, #group do
			food.support(group[i], item)
		end
		return
	end
	if type(item) == "table" then
		for i = 1, #item do
			food.support(group, item[i])
		end
		return
	end

	local idx = string.find(item, ":")
	if idx <= 1 then
		error("[Food Error] food.support - error in item name ('" .. item .. "')")
	end
	local mod = string.sub(item, 1, idx - 1)

	if not minetest.get_modpath(mod) then
		if food.debug then
			print("[Food Debug] Mod '"..mod.."' is not installed")
		end
		return
	end

	local data = minetest.registered_items[item]
	if not data then
		print("[Food Warning] Item '"..item.."' not found")
		return
	end


	food.disable(group)

	-- Add group
	local g = {}
	if data.groups then
		for k, v in pairs(data.groups) do
			g[k] = v
		end
	end
	g["food_"..group] = 1
	minetest.override_item(item, {groups = g})
end

function food.disable(name)
	if type(name) == "table" then
		for i = 1, #name do
			food.disable(name[i])
		end
		return
	end
	food.disabled_modules[name] = true
end

function food.disable_if(mod, name)
	if minetest.get_modpath(mod) then
		food.disable(name)
	end
end

local mtreg_item = minetest.register_item
function minetest.register_item(name, def)
	if food._reg_items then
		local iname = food.strip_name(name)
		food._reg_items[iname] = true
	end
	return mtreg_item(name, def)
end

local mtreg_node = minetest.register_node
function minetest.register_node(name, def)
	if food._reg_items then
		local iname = food.strip_name(name)
		food._reg_items[iname] = true
	end
	return mtreg_node(name, def)
end

function food.strip_name(name)
	local res = name:gsub('%"', '')
	if res:sub(1, 1) == ":" then
		res = res:sub(2, #res)
		--table.concat{res:sub(1, 1-1), "", res:sub(1+1)}
	end
	for str in string.gmatch(res, "([^ ]+)") do
		if str ~= " " and str ~= nil then
			res = str
			break
		end
	end
	if not res then
		res = ""
	end
	return res
end

local mtreg_craft = minetest.register_craft
function minetest.register_craft(def)
	if food._reg_items and food._cur_module and def.output then
		local name = food.strip_name(def.output)
		if not food._reg_items[name] then
			print("[Food] (Error) Modules should only define recipes for the items they create!")
			print("Output: " .. name .. " in module " .. food._cur_module)
		end
	end

	return mtreg_craft(def)
end

-- Adds a module
function food.module(name, func, ingred)
	if food.disabled_modules[name] then
		return
	end

	if ingred then
		for name, def in pairs(minetest.registered_items) do
			local g = def.groups and def.groups["food_"..name] or 0
			if g > 0 then
				return
			end
		end

		if food.disable_fallbacks then
			print("Warning: Fallbacks are disabled, and no item for " .. name .. " registered!")
			return
		end

		if food.debug then
			print("[Food Debug] Registering " .. name .. " fallback definition")
		end
	elseif food.debug then
		print("[Food Debug] Module " .. name)
	end

	food._cur_module = name
	food._reg_items = {}

	func()

	food._reg_items = nil
	food._cur_module = nil
end

local global_exists = minetest.global_exists or function(name)
	return (_G[name] ~= nil)
end

-- Checks for hunger mods to register food on
function food.item_eat(amt)
	if minetest.get_modpath("diet") and global_exists("diet") and diet.item_eat then
		return diet.item_eat(amt)
	elseif minetest.get_modpath("hud") and global_exists("hud") and hud.item_eat then
		return hud.item_eat(amt)
	elseif minetest.get_modpath("hbhunger") then
		if global_exists("hbhunger") and hbhunger.item_eat then
			return hbhunger.item_eat(amt)
		elseif global_exists("hunger") and hunger.item_eat then
			-- For backwards compatibility
			-- It used to be called `hunger` rather than `hbhunger`
			return hunger.item_eat(amt)
		end
	else
		return minetest.item_eat(amt)
	end
end

-- Registers craft item or node depending on settings
function food.register(name, data, mod)
	if (minetest.setting_getbool("food_use_2d") or (mod ~= nil and minetest.setting_getbool("food_"..mod.."_use_2d"))) then
		minetest.register_craftitem(name,{
			description = data.description,
			inventory_image = data.inventory_image,
			groups = data.groups,
			on_use = data.on_use
		})
	else
		local newdata = {
			description = data.description,
			tiles = data.tiles,
			groups = data.groups,
			on_use = data.on_use,
			walkable = false,
			sunlight_propagates = true,
			drawtype = "nodebox",
			paramtype = "light",
			node_box = data.node_box
		}
		if (minetest.setting_getbool("food_2d_inv_image")) then
			newdata.inventory_image = data.inventory_image
		end
		minetest.register_node(name,newdata)
	end
end

-- Allows for overriding in the future
function food.craft(craft)
	minetest.register_craft(craft)
end

local filter = smart_inventory.filter

local cache = {}
cache.cgroups = {}    -- cache groups
cache.itemgroups = {} -- raw item groups for recipe checks
cache.citems = {}

-----------------------------------------------------
-- Add an Item to the cache
-----------------------------------------------------
function cache.add_item(def)

	-- special handling for doors. In inventory the item should be displayed instead of the node_a/node_b
	local item_def
	if def.groups.door then
		if def.door then
			item_def = minetest.registered_items[def.door.name]
		elseif def.drop and type(def.drop) == "string" then
			item_def = minetest.registered_items[def.drop]
		else
			item_def = def
		end
		if not item_def then
			minetest.log("[smart_inventory] Buggy door found: "..def.name)
			item_def = def
		end
	else
		item_def = def
	end

	-- already in cache. Skip duplicate processing
	if cache.citems[item_def.name] then
		return
	end

	-- fill raw groups cache for recipes
	for group, value in pairs(item_def.groups) do
		cache.itemgroups[group] = cache.itemgroups[group] or {}
		cache.itemgroups[group][item_def.name] = item_def
	end

	local entry = {
		name = item_def.name,
		in_output_recipe = {},
		in_craft_recipe = {},
		cgroups = {}
	}
	cache.citems[item_def.name] = entry
	-- classify the item
	for _, flt in pairs(filter.registered_filter) do
		local filter_result = flt:check_item_by_def(def)
		if filter_result then
			if filter_result == true then
				cache.assign_to_group(flt.name, item_def, flt)
			else
				if type(filter_result) ~= "table" then
					if tonumber(filter_result) ~= nil then
						filter_result = {[flt.name..":"..filter_result] = true}
					else
						filter_result = {[filter_result] = true}
					end
				end
				for key, val in pairs(filter_result) do
					local filter_entry = tostring(key)
					if val ~= true then
						filter_entry = filter_entry..":"..tostring(val)
					end
					cache.assign_to_group(filter_entry, item_def, flt)
				end
			end
		end
	end
end


-----------------------------------------------------
-- Add a item to cache group
-----------------------------------------------------
function cache.assign_to_group(group_name, itemdef, flt)

-- check and build filter chain
	local abs_group
	local parent_ref
	local parent_stringpos

	for rel_group in group_name:gmatch("[^:]+") do
		-- get parent relation and absolute path
		if abs_group then
			parent_ref = cache.cgroups[abs_group]
			parent_stringpos = string.len(abs_group)+2
			abs_group = abs_group..":"..rel_group
		else
			abs_group = rel_group
		end

		-- check if group is new, create it
		if not cache.cgroups[abs_group] then
			if parent_ref then
				parent_ref.childs[abs_group] = string.sub(group_name, parent_stringpos)
			end
			local group = {
					name = abs_group,
					items = {},
					parent = parent_ref,
					childs = {},
				}
			group.group_desc = flt:get_description(group)
			group.keyword = flt:get_keyword(group)
			cache.cgroups[abs_group] = group
		end

		-- set relation
		cache.cgroups[abs_group].items[itemdef.name] = itemdef
		cache.citems[itemdef.name].cgroups[abs_group] = cache.cgroups[abs_group]
	end
end

-----------------------------------------------------
-- Hook / Event for further initializations of the cache is filled
-----------------------------------------------------
cache.registered_on_cache_filled = {}
function cache.register_on_cache_filled(func, ...)
	assert(type(func) == "function", "register_on_cache_filled needs a function")
	table.insert(cache.registered_on_cache_filled, { func = func, opt = {...}})
end

local function process_on_cache_filled()
	for _, hook in ipairs(cache.registered_on_cache_filled) do
		hook.func(unpack(hook.opt))
	end
end


-----------------------------------------------------
-- Fill the cache at init
-----------------------------------------------------
local function fill_cache()
	local shape_filter = filter.get("shape")
	for _, def in pairs(minetest.registered_items) do

		-- build groups and items cache
		if def.description and def.description ~= "" and
				(not def.groups.not_in_creative_inventory or shape_filter:check_item_by_def(def)) then
			cache.add_item(def)
		end
	end

	-- call hooks
	minetest.after(0, process_on_cache_filled)
end
minetest.after(0, fill_cache)

-----------------------------------------------------
-- return the reference to the mod
-----------------------------------------------------
return cache

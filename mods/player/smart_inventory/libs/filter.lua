local txt = smart_inventory.txt

--------------------------------------------------------------
-- Filter class
--------------------------------------------------------------
local filter_class = {}
filter_class.__index = filter_class

function filter_class:check_item_by_name(itemname)
	if minetest.registered_items[itemname] then
		return self:check_item_by_def(minetest.registered_items[itemname])
	end
end

function filter_class:check_item_by_def(def)
	error("check_item_by_def needs redefinition:"..debug.traceback())
end

function filter_class:_get_description(group)
	if txt then
		if txt[group.name] then
			return txt[group.name].." ("..group.name..")"
		elseif group.parent and group.parent.childs[group.name] and txt[group.parent.name] then
			return txt[group.parent.name].." "..group.parent.childs[group.name].." ("..group.name..")"
		else
			return group.name
		end
	else
		return group.name
	end
end
filter_class.get_description = filter_class._get_description

function filter_class:_get_keyword(group)
	return group.group_desc
end

filter_class.get_keyword = filter_class._get_keyword

function filter_class:is_valid(group)
	return true
end

local filter = {}
filter.registered_filter = {}

function filter.get(name)
	return filter.registered_filter[name]
end

function filter.register_filter(def)
	assert(def.name, "filter needs a name")
	assert(def.check_item_by_def, "filter function check_item_by_def required")
	assert(not filter.registered_filter[def.name], "filter already exists")
	setmetatable(def, filter_class)
	def.__index = filter_class
	filter.registered_filter[def.name] = def
end


-- rename groups for beter consistency
filter.group_rename = {
	customnode_default = "customnode",
}

-- group configurations per basename
--   true means is dimension
--   1 means replace the base only ("food_choco_powder" => food:choco_powder")
filter.base_group_config = {
	armor = true,
	physics = true,
	basecolor = true,
	excolor = true,
	color = true,
	unicolor = true,
	food = 1,
	customnode = true,
}

-- hide this groups
filter.group_hide_config = {
	armor_count = true,
	not_in_creative_inventory = false,
}

-- value of this group will be recalculated to %
filter.group_wear_config = {
	armor_use = true,
}

-- Ususally 1 means true for group values. This is an exceptions table for this rule
filter.group_with_value_1_config = {
	oddly_breakable_by_hand = true,
}

--------------------------------------------------------------
-- Filter group
--------------------------------------------------------------
filter.register_filter({
		name = "group",
		check_item_by_def = function(self, def)
			local ret = {}
			for k_orig, v in pairs(def.groups) do
				local k = filter.group_rename[k_orig] or k_orig
				local mk, mv

				-- Check group base
				local basename
				for z in k:gmatch("[^_]+") do
					basename = z
					break
				end
				local basegroup_config = filter.base_group_config[basename]
				if basegroup_config == true then
					mk = string.gsub(k, "_", ":")
				elseif basegroup_config == 1 then
					mk = string.gsub(k, "^"..basename.."_", basename..":")
				else
					mk = k
				end

				-- stack wear related value
				if filter.group_wear_config[k] then
					mv = tostring(math.floor(v / 65535 * 10000 + 0.5)/100).." %"
				-- value-expandable groups
				elseif v ~= 1 or k == filter.group_with_value_1_config[k] then
					mv = v
				else
					mv = true
				end

				if v ~= 0 and mk and not filter.group_hide_config[k] then
					ret[mk] = mv
				end
			end
			return ret
		end,
	})

filter.register_filter({
		name = "type",
		check_item_by_def = function(self, def)
			return self.name..":"..def.type
		end,
		get_keyword = function(self, group)
			if group.name ~= self.name then
				return group.parent.childs[group.name]
			end
		end
	})

filter.register_filter({
		name = "mod",
		check_item_by_def = function(self, def)
			if def.mod_origin then
				return self.name..":"..def.mod_origin
			end
		end,
		get_keyword = function(self, group)
			if group.name ~= self.name then
				return group.parent.childs[group.name]
			end
		end
	})

filter.register_filter({
		name = "translucent",
		check_item_by_def = function(self, def)
			if def.sunlight_propagates ~= 0 then
				return def.sunlight_propagates
			end
		end,
	})

filter.register_filter({
		name = "light",
		check_item_by_def = function(self, def)
			if def.light_source ~= 0 then
				return def.light_source
			end
		end,
	})

filter.register_filter({
		name = "metainv",
		check_item_by_def = function(self, def)
			if def.allow_metadata_inventory_move or
					def.allow_metadata_inventory_take or
					def.allow_metadata_inventory_put or
					def.on_metadata_inventory_move or
					def.on_metadata_inventory_take or
					def.on_metadata_inventory_put then
				return true
			end
		end,
	})

--[[ does it sense to filter them? I cannot define the human readable groups for them
filter.register_filter({
		name = "drawtype",
		check_item_by_def = function(self, def)
			if def.drawtype ~= "normal" then
				return def.drawtype
			end
		end,
	})
]]

local shaped_groups = {}
local shaped_list = minetest.setting_get("smart_inventory_shaped_groups") or "carpet,door,fence,stair,slab,wall,micro,panel,slope"
if shaped_list then
	for z in shaped_list:gmatch("[^,]+") do
		shaped_groups[z] = true
	end
end

filter.register_filter({
		name = "shape",
		check_item_by_def = function(self, def)
			for k, v in pairs(def.groups) do
				if shaped_groups[k] then
					return true
				end
			end
		end,
	})

--[[ disabled since debug.getupvalue is not usable to secure environment
filter.register_filter({
		name = "food",
		check_item_by_def = function(self, def)
			if def.on_use then
				local name,change=debug.getupvalue(def.on_use, 1)
				if name~=nil and name=="hp_change" and change > 0 then
					return tostring(change)
				end
			end
		end,
	})

filter.register_filter({
		name = "toxic",
		check_item_by_def = function(self, def)
			if def.on_use then
				local name,change=debug.getupvalue(def.on_use, 1)
				if name~=nil and name=="hp_change" and change < 0 then
					return tostring(change)
				end
			end
		end,
	})
]]

filter.register_filter({
		name = "tool",
		check_item_by_def = function(self, def)
			if not def.tool_capabilities then
				return
			end
			local rettab = {}
			for k, v in pairs(def.tool_capabilities) do
				if type(v) ~= "table" and v ~= 0 then
					rettab["tool:"..k] = v
				end
			end
			if def.tool_capabilities.damage_groups then
				for k, v in pairs(def.tool_capabilities.damage_groups) do
					if v ~= 0 then
						rettab["damage:"..k] = v
					end
				end
			end
--[[ disabled, I cannot find right human readable interpretation for this
			if def.tool_capabilities.groupcaps then
				for groupcap, gdef in pairs(def.tool_capabilities.groupcaps) do
					for k, v in pairs(gdef) do
						if type(v) ~= "table" then
							rettab["groupcaps:"..groupcap..":"..k] = v
						end
					end
				end
			end
]]
			return rettab
		end,
		get_keyword = function(self, group)
			if group.name == "tool" or group.name == "damage" then
				return nil
			else
				return self:_get_keyword(group)
			end
		end
	})

filter.register_filter({
		name = "armor",
		check_item_by_def = function(self, def)
			return def.armor_groups
		end,
	})

-- Burn times
filter.register_filter({
		name = "fuel",
		check_item_by_def = function(self, def)
			local burntime = minetest.get_craft_result({method="fuel",width=1,items={def.name}}).time
			if burntime > 0 then
				return "fuel:"..burntime
			end
		end
})


-- Group assignment done in cache framework internally
filter.register_filter({
		name = "recipetype",
		check_item_by_def = function(self, def) end,
		get_keyword = function(self, group)
			if group.name ~= self.name then
				return group.parent.childs[group.name]
			end
		end
})

-- Group assignment done in cache framework internally
filter.register_filter({
		name = "ingredient",
		check_item_by_def = function(self, def) end,
		get_description = function(self, group)
			local itemname = group.name:sub(12)
			if txt and txt["ingredient"] and
					minetest.registered_items[itemname] and minetest.registered_items[itemname].description then
				return txt["ingredient"] .." "..minetest.registered_items[itemname].description.." ("..group.name..")"
			else
				return group.name
			end
		end,
		get_keyword = function(self, group)
			-- not searchable by ingedient
			return nil
		end,
		is_valid = function(self, groupname)
			local itemname = groupname:sub(12)
			if itemname ~= "" and minetest.registered_items[itemname] then
				return true
			end
		end
})

----------------
return filter


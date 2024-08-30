hopper.containers = {}
hopper.groups = {}
hopper.neighbors = {}

local function parse_group(target_node)
	local number
	local identifier

	local equals_index = string.find(target_node, "=")
	if equals_index ~= nil then
		identifier = string.sub(target_node, 7, equals_index-1)
		-- it's possible that the string was of the form "group:blah = 1", in which case we want to trim spaces off the end of the group identifier
		local space_index = string.find(identifier, " ")
		if space_index ~= nil then
			identifier = string.sub(identifier, 1, space_index-1)
		end
		number = tonumber(string.sub(target_node, equals_index+1, -1))
	else
		identifier = string.sub(target_node, 7, -1)
		number = "all" -- special value to indicate no number was provided
	end

	return identifier, number
end

local function is_already_in_neighbors(neighbor_node)
	for _, value in pairs(hopper.neighbors) do
		if value == neighbor_node then
			return true
		end
	end
	return false
end

-- global function to add new containers
function hopper:add_container(list)
	for _, entry in pairs(list) do

		local relative_position = entry[1]
		local target_node = entry[2]

		local inventory_info = entry
		inventory_info.inventory_name = entry[3]
		table.remove(inventory_info, 1)
		table.remove(inventory_info, 1)
		table.remove(inventory_info, 1)

		local neighbor_node
		if string.sub(target_node, 1, 6) == "group:" then
			local group_identifier, group_number = parse_group(target_node)

			if hopper.groups[group_identifier] == nil then
				hopper.groups[group_identifier] = {}
			end
			if hopper.groups[group_identifier][group_number] == nil then
				hopper.groups[group_identifier][group_number] = {}
			end
			if hopper.groups[group_identifier][group_number].extra == nil then
				hopper.groups[group_identifier][group_number].extra = {}
			end

			hopper.groups[group_identifier][group_number][relative_position] = inventory_info
			neighbor_node = "group:"..group_identifier
		else
			if hopper.containers[target_node] == nil then
				hopper.containers[target_node] = {}
			end
			if hopper.containers[target_node].extra == nil then
				hopper.containers[target_node].extra = {}
			end

			hopper.containers[target_node][relative_position] = inventory_info
			neighbor_node = target_node
		end

		if not is_already_in_neighbors(neighbor_node) then
			table.insert(hopper.neighbors, neighbor_node)
		end
	end
end

-- global function for additional information about containers
function hopper:set_extra_container_info(list)
	for _, entry in pairs(list) do
		local target_node = entry[1]
		table.remove(entry, 1) -- only extra information
		if string.sub(target_node, 1, 6) == "group:" then
			local group_identifier, group_number = parse_group(target_node)
			if not is_already_in_neighbors("group:" .. group_identifier) then
				minetest.log("error","An attempt to add extra information for " ..
					target_node .. " in the absence of the main one")
				break
			end
			hopper.groups[group_identifier][group_number].extra = entry
			-- result is a table of the form:
			-- groups[group_identifier][group_number]["extra"][list of extra information]
		else
			if not is_already_in_neighbors(target_node) then
				minetest.log("error","An attempt to add extra information for " ..
					target_node .. " in the absence of the main one")
				break
			end
			hopper.containers[target_node].extra = entry
			-- result is a table of the form:
			-- containers[target_node_name]["extra"][list of extra information]
		end
	end
end

-- "top" indicates what inventory the hopper will take items from if this node is located at the hopper's wide end
-- "side" indicates what inventory the hopper will put items into if this node is located at the hopper's narrow end and at the same height as the hopper
-- "bottom" indicates what inventory the hopper will put items into if this node is located at the hopper's narrow end and either above or below the hopper.

hopper:add_container({
	{"top", "hopper:hopper", "main"},
	{"bottom", "hopper:hopper", "main"},
	{"side", "hopper:hopper", "main"},
	{"side", "hopper:hopper_side", "main"},

	{"bottom", "hopper:chute", "main"},
	{"side", "hopper:chute", "main"},

	{"bottom", "hopper:sorter", "main"},
	{"side", "hopper:sorter", "main"},
})

if minetest.get_modpath("default") then
	hopper:add_container({
		{"top", "default:chest", "main"},
		{"bottom", "default:chest", "main"},
		{"side", "default:chest", "main"},

		{"top", "default:furnace", "dst"},
		{"bottom", "default:furnace", "src"},
		{"side", "default:furnace", "fuel"},

		{"top", "default:furnace_active", "dst"},
		{"bottom", "default:furnace_active", "src"},
		{"side", "default:furnace_active", "fuel"},

		{"top", "default:chest_locked", "main"},
		{"bottom", "default:chest_locked", "main"},
		{"side", "default:chest_locked", "main"},
	})
end

-- protector redo mod support
if minetest.get_modpath("protector") then
	hopper:add_container({
		{"top", "protector:chest", "main"},
		{"bottom", "protector:chest", "main"},
		{"side", "protector:chest", "main"},
	})
end

-- wine mod support
if minetest.get_modpath("wine") then
	hopper:add_container({
		{"top", "wine:wine_barrel", "dst"},
		{"bottom", "wine:wine_barrel", "src"},
		{"side", "wine:wine_barrel", "src"},
	})
end


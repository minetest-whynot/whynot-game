local S = maple.get_translator;
local random = math.random


-- I don't remember if snow function is needed.
local function is_snow_nearby(pos)
  return minetest.find_node_near(pos, 1,
    {"default:snow", "default:snowblock", "default:dirt_with_snow"})
end


-- Sapling ABM

function maple.grow_sapling(pos)
  if not default.can_grow(pos) then
    -- Can't grow yet, try later.
    minetest.get_node_timer(pos):start(math.random(240, 600))
    return
  end

  local mg_name = minetest.get_mapgen_setting("mg_name")
  local node = minetest.get_node(pos)

  if node.name == "maple:maple_sapling" then
    minetest.log("action", "An maple sapling grows into a tree at "..
      minetest.pos_to_string(pos))
    minetest.remove_node(pos)
    maple.grow_new_maple_tree(pos)
  end
end

minetest.register_lbm({
  name = "maple:convert_saplings_to_node_timer",
  nodenames = {"maple:maple_sapling"},
  action = function(pos)
    minetest.get_node_timer(pos):start(math.random(1200, 2400))
  end
})

--
-- Tree generation
--

-- New maple tree

function maple.grow_new_maple_tree(pos)
  local path = maple.path .. "/schematics/maple_tree.mts"
  minetest.place_schematic({x = pos.x - 3, y = pos.y, z = pos.z - 3},
    path, "0", nil, false)
end




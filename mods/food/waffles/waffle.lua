local waffles = ...

local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator(MODNAME)

-- Waffle
local box_waffle = {
    type = "fixed",
    fixed = {-5 / 16, -8 / 16, -5 / 16, 5 / 16, - 7 / 16, 5 / 16},
}

minetest.register_node(MODNAME .. ":waffle", {
    description = S("Waffle"),
    drawtype = "mesh",
    mesh = "waffles_waffle.obj",
    tiles = {"waffles_waffle.png"},
    use_texture_alpha = "clip",
    inventory_image = "waffles_waffle_inv.png",
    wield_image = "waffles_waffle_inv.png",
    paramtype = "light",
    sunlight_propagates = true,
    paramtype2 = "facedir",
    groups = {snappy = 3, oddly_breakable_by_hand = 1},
    selection_box = box_waffle,
    collision_box = box_waffle,
    on_use = minetest.item_eat(8),
    on_place = minetest.rotate_and_place,
})

minetest.register_craftitem(MODNAME .. ":waffle_quarter", {
    description = S("Quarter of Waffle"),
    inventory_image = "waffles_waffle_quarter.png",
    on_use = minetest.item_eat(2)
})

minetest.register_craft({
    output = MODNAME .. ":waffle_quarter 4",
    type = "shapeless",
    recipe = {MODNAME .. ":waffle"},
})

-- Waffle stacks
minetest.register_node(MODNAME .. ":waffle_stack", {
    description = S("Stack of Waffles"),
    tiles = {"waffles_waffle_block_top.png", "waffles_waffle_block_top.png", "waffles_waffle_block_side.png"},
    paramtype2 = "facedir",
    groups = {snappy = 3, oddly_breakable_by_hand = 1},
    on_place = minetest.rotate_and_place,
})

minetest.register_node(MODNAME .. ":waffle_stack_short", {
    description = S("Short Stack of Waffles"),
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
    },
    tiles = {"waffles_waffle_block_top.png", "waffles_waffle_block_top.png", "waffles_waffle_block_side.png"},
    paramtype2 = "facedir",
    paramtype =  "light",
    groups = {snappy = 3, oddly_breakable_by_hand = 1},
    on_place = minetest.rotate_and_place,
})

local craftitem = MODNAME .. ":waffle"
minetest.register_craft({
    output = MODNAME .. ":waffle_stack",
    type = "shapeless",
    recipe = {craftitem, craftitem, craftitem, craftitem, craftitem, craftitem, craftitem, craftitem},
})

minetest.register_craft({
    output = MODNAME .. ":waffle_stack_short",
    type = "shapeless",
    recipe = {craftitem, craftitem, craftitem, craftitem},
})

minetest.register_craft({
    output = MODNAME .. ":waffle 8",
    type = "shapeless",
    recipe = {MODNAME .. ":waffle_stack"}
})

minetest.register_craft({
    output = MODNAME .. ":waffle 4",
    type = "shapeless",
    recipe = {MODNAME .. ":waffle_stack_short"}
})

-- Batter
minetest.register_craftitem(MODNAME .. ":waffle_batter", {
    description = S("Waffle Batter"),
    inventory_image = "waffles_waffle_batter_inv.png",
    use_texture_alpha = true,
})

local craftitems = waffles.setting_or("waffle_batter_recipe", "farming:flour farming:flour bucket:bucket_water=bucket:bucket_empty")
local recipe = {}
local replacements = {}

for _, item in pairs(craftitems:split("[, ]", false, -1, true)) do
    local set = item:split("=")
    table.insert(recipe, set[1])

    if set[2] then
        table.insert(replacements, {set[1], set[2]})
    end
end

minetest.register_craft({
	output = MODNAME .. ":waffle_batter 3",
    type = "shapeless",
	recipe = recipe,
    replacements = #replacements > 0 and replacements or nil,
})

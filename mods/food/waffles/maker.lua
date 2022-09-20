local waffles = ...

local COOK_TIME = 6
local MODNAME = minetest.get_current_modname()
local S = minetest.get_translator(MODNAME)

-- Batter visual
local batters = {}
minetest.register_entity(MODNAME .. ":batter", {
    visual = "mesh",
    mesh = "waffles_waffle.obj",
    textures = {"waffles_waffle_batter.png"},
    visual_size = vector.new(10, 10, 10),
    pointable = false,
    physical = false,
    on_activate = function(self, parent)
        if parent == "" then return self.object:remove() end
        self._parent = minetest.string_to_pos(parent)

        -- Interpolate between batter and waffle
        local cooked = minetest.get_meta(self._parent):get_float("cooked")
        self.object:set_properties({textures = {
            "waffles_waffle_batter.png^(waffles_waffle.png^[opacity:" .. cooked * 255 .. ")"
        }})

        self.object:set_pos(vector.add(self._parent, {x = 0, y = 4 / 16, z = 0}))
        self.object:set_armor_groups({immortal = 1})

        batters[minetest.hash_node_position(self._parent)] = self
    end,
    get_staticdata = function(self)
        return minetest.pos_to_string(self._parent)
    end,
})

local function remove_batter(pos)
    local hash = minetest.hash_node_position(pos)
    if batters[hash] then
        batters[hash].object:remove()
        batters[hash] = nil
    end
end

-- Waffle maker base definition
local def_base = {
    description = S("Waffle Maker"),
    drawtype = "mesh",
    tiles = {"waffles_waffle_maker.png"},
    use_texture_alpha = "clip",
    paramtype = "light",
    sunlight_propagates = true,
    paramtype2 = "facedir",
    groups = {snappy = 3, oddly_breakable_by_hand = 1},
    sounds = waffles.default_sounds("node_sound_metal_defaults"),
    on_construct = function(pos)
        minetest.get_meta(pos):set_float("cooked", -1)
    end,
    on_rightclick = function(pos, node, _, stack)
        local meta = minetest.get_meta(pos)
        local cooked = meta:get_float("cooked")

        local open = node.name:sub(-4) == "open"
        local battering = stack:get_name():match(MODNAME .. ":waffle_batter$")

        -- Add batter if open and empty
        if open and battering and cooked < 0 then
            cooked = 0
            meta:set_float("cooked", cooked)
            stack:take_item()
        end

        -- Toggle as long as not placing batter on open maker
        if not (open and battering) then
            minetest.swap_node(pos, {
                name = node.name:sub(1, open and -6 or -1) .. (open and "" or "_open"),
                param2 = node.param2,
            })

            open = not open
        end

        -- Handle batter
        if open then
            if cooked > -1 and not batters[minetest.hash_node_position(pos)] then
                minetest.add_entity(pos, MODNAME .. ":batter", minetest.pos_to_string(pos))
            end
        else
            remove_batter(pos)
            minetest.get_node_timer(pos):start(0.5)
        end

        return stack
    end,
    on_punch = function(pos, node, puncher, ...)
        local meta = minetest.get_meta(pos)
        local cooked = meta:get_float("cooked")

        if cooked > -1 then
            local inv = puncher:get_inventory()

            if cooked <= 0.2 or cooked >= 0.8 then
                local stack = ItemStack(MODNAME .. (cooked <= 0.2 and ":waffle_batter" or ":waffle"))

                if inv:room_for_item("main", stack) then
                    inv:add_item("main", stack)
                    cooked = -1
                end
            end

            if cooked < 0 then remove_batter(pos) end
            meta:set_float("cooked", cooked)
        end

        return minetest.node_punch(pos, node, puncher, ...)
    end,
    on_timer = function(pos)
        if minetest.get_node(pos).name:sub(-4) == "open" then return end

        local meta = minetest.get_meta(pos)
        local cooked = meta:get_float("cooked")

        if cooked > -1 and cooked < 1 then
            meta:set_float("cooked", math.min(cooked + 0.5 / COOK_TIME, 1))
            minetest.get_node_timer(pos):start(0.5)

            if meta:get_float("cooked") == 1 then
                minetest.add_particlespawner({
                    amount = math.random(6, 10),
                    time = 3,

                    minpos = vector.add(pos, {x = -0.5, y = 0, z = -0.5}),
                    maxpos = vector.add(pos, {x =  0.5, y = 0, z =  0.5}),

                    minvel = {x = 0, y = 0.5, z = 0},
                    maxvel = {x = 0, y = 0.5, z = 0},

                    minacc = {x = 0, y = 0, z = 0},
                    maxacc = {x = 0, y = 0, z = 0},

                    minexptime = 2,
                    maxexptime = 2,

                    minsize = 2,
                    maxsize = 6,

                    texture = "waffles_steam.png",
                })

                minetest.registered_nodes[MODNAME .. ":waffle_maker"].on_rightclick(pos, minetest.get_node(pos), nil, ItemStack(""))
            end
        end
    end,
    can_dig = function(pos)
        return minetest.get_meta(pos):get_float("cooked") == -1
    end,
    on_destruct = remove_batter,
}

minetest.register_lbm({
    label = "Start waffle maker timers",
    name = MODNAME .. ":waffle_timers",
    nodnames = {MODNAME .. ":waffle_maker"},
    run_at_every_load = true,
    action = function(pos)
        minetest.get_node_timer(pos):start(0.5)
    end
})

-- Open and closed defs
local def_closed = table.copy(def_base)
local box_closed = {
    type = "fixed",
    fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
}

def_closed.selection_box = box_closed
def_closed.collision_box = box_closed

def_closed.mesh = "waffles_waffle_maker_closed.obj"

local def_open = table.copy(def_base)
local box_open = {
    type = "fixed",
    fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
            {-0.5,  0.0,  0.0, 0.5, 0.5, 0.5},
    },
}

def_open.selection_box = box_open
def_open.collision_box = box_open

def_open.mesh = "waffles_waffle_maker_open.obj"

def_open.description = S("Waffle Maker (Open)")
def_open.drop = MODNAME .. ":waffle_maker"
def_open.groups.not_in_creative_inventory = 1

minetest.register_node(MODNAME .. ":waffle_maker", def_closed)
minetest.register_node(MODNAME .. ":waffle_maker_open", def_open)

-- Crafting recipe
local craftitems = {
    casing = waffles.setting_or("crafitem_maker_casing", "default:tin_ingot"),
    wiring = waffles.setting_or("crafitem_maker_wiring", "default:steel_ingot"),
    heating = waffles.setting_or("crafitem_maker_heating", "default:copper_ingot"),
}

minetest.register_craft({
    output = MODNAME .. ":waffle_maker",
    recipe = {
        {craftitems.casing, craftitems.casing, craftitems.casing},
        {craftitems.wiring, "", craftitems.wiring},
        {craftitems.casing, craftitems.heating, craftitems.casing},
    }
})

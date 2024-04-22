local registered_currency = {}

function home_vending_machines.register_currency(name, worth)
    registered_currency[name] = worth
end

local function reg_simple(name, def)
    minetest.register_node(":" .. name, {
        description = def.description,
        drawtype = "mesh",
        mesh = "home_vending_machines_machine.obj",
        tiles = def.tiles,
        paramtype = "light",
        paramtype2 = "facedir",
        groups = def.groups or {snappy=3, dig_tree=2},
        is_ground_content = false,
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}
        },
        collision_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, 0.5}
        },
        sounds = def.sounds,
        on_rotate = function(pos, node, user, mode, new_param2)
            if minetest.get_modpath("screwdriver") then
                return screwdriver.rotate_simple(pos, node, user, mode, new_param2)
            end
        end,
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            if not itemstack then return end
            local pname = clicker:get_player_name()
            local iname = itemstack:get_name()
            local dpos = vector.add((vector.multiply(minetest.facedir_to_dir(node.param2), -1)), pos)

            if registered_currency[iname] and registered_currency[iname] == 1 then
                local item = def._vmachine.item
                if type(item) == "table" then
                    item = item[math.random(#item)]
                end

                minetest.add_item(dpos, item)

                if not minetest.is_creative_enabled(pname) then
                    itemstack:take_item()
                    return itemstack
                end
            else
                minetest.chat_send_player(pname, "Please insert valid currency.")
            end
        end
    })
end

function home_vending_machines.register_machine(type, name, def)
    if type == "simple" then
        reg_simple(name, def)
    end
    --TODO: add more complex machine type with formspec and selections
end

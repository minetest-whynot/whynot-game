local modpath = minetest.get_modpath("sound_api")

sound_api = dofile(modpath .. "/sound_api_core/init.lua")

minetest.register_on_mods_loaded(function()
    for name, def in pairs(minetest.registered_nodes) do
        if def._sound_def and def._sound_def.key then
            minetest.override_item(name, {
                sounds = sound_api[def._sound_def.key](def._sound_def.input)
            })
        end
    end

    local old_reg_node = minetest.register_node
    function minetest.register_node(name, def)
        if def._sound_def and def._sound_def.key then
            def.sounds = sound_api[def._sound_def.key](def._sound_def.input)
        end

        old_reg_node(name, def)
    end
end)
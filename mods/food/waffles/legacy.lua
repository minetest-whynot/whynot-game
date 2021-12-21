local MODNAME = minetest.get_current_modname()

local aliases = {
    ["wafflemaker"] = "waffle_maker",
    ["wafflemaker_open_empty"] = "waffle_maker_open",
    ["wafflemaker_open_full"] = "waffle_maker_open",
    ["wafflemaker_closed_full"] = "waffle_maker",
    ["wafflemaker_open_done"] = "waffle_maker_open",
    ["large_waffle"] = "waffle",
    ["small_waffle"] = "waffle_quarter",
    ["toaster"] = "waffle_maker",
    ["breadslice"] = "waffle_quarter",
    ["toast"] = "waffle_quarter",
    ["toaster_with_breadslice"] = "waffle_maker",
    ["toaster_toasting_breadslice"] = "waffle_maker",
    ["toaster_with_toast"] = "waffle_maker",
    ["toaster_waffle"] = "waffle_quarter",
    ["toaster_waffle_pack"] = "waffle",
    ["toaster_waffle_pack_4"] = "waffle",
    ["toaster_waffle_pack_2"] = "waffle_quarter",
    ["toaster_with_waffle"] = "waffle_maker",
    ["toaster_toasting_waffle"] = "waffle_maker",
    ["toaster_with_toasted_waffle"] = "waffle_maker",
}

for old, new in pairs(aliases) do
    minetest.register_alias(MODNAME .. ":" .. old, MODNAME .. ":" .. new)
end

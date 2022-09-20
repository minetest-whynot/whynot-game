local MODNAME = minetest.get_current_modname()
local MODPATH = minetest.get_modpath(MODNAME)
local function include(filename, ...) return assert(loadfile(MODPATH .. "/" .. filename))(...) end

local waffles = {}

-- Return default sounds if available
waffles.default_sounds = function(name)
    if minetest.global_exists("default") and default[name] then return default[name]() end
end

waffles.setting_or = function(name, default)
    local set = minetest.settings:get(MODNAME .. "." .. name)
    return set ~= "" and set or default
end

include("waffle.lua", waffles)
include("maker.lua", waffles)

include("legacy.lua")

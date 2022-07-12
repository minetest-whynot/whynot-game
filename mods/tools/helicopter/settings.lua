
--- Determines gravity force on helicopter.
helicopter.gravity = tonumber(minetest.settings:get("movement_gravity") or 9.8)

--- Determines handling of punched helicopter.
--
--  If `false`, helicopter is destroyed. Otherwise, it is added to inventory.
--    - Default: false
helicopter.punch_inv = minetest.settings:get_bool("mount_punch_inv", false)

--- Determines default control of helicopter.
--
--  Use facing direction to turn instead of a/d keys by default.
--    - Default: false
helicopter.turn_player_look = minetest.settings:get_bool("mount_turn_player_look", false)

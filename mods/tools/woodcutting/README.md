# Woodcutting

This mod is an asynchrounus tree cutter for minetest. Mine the first tree node from a tree while the sneak key is pressed, then wait till the whole tree is breaked down and in your inventory.

Forum: https://forum.minetest.net/viewtopic.php?f=9&t=18023

![Screenshot](https://github.com/bell07/minetest-woodcutting/raw/master/screenshot.png)

## Highlights / Features
  - Lag-free because the work is not done at once. You can observe the woodcutting.
  - You can stop the woodcutting by press sneak key second time
  - You can add additional trees to process by digging other tree nodes manually
  - The distance to the player is used to prefer next node so the player can partially influence the work direction on big areas
  - The auto-mining speed is dependent on wielded tool, so the diamond axe is still advantageously than empty hand
  - All checks and functionalities are processed (like hunger damage and tool wear) as if the player did the mining manually
  - Really nice effect in combination with item_drop mod
  - Does work with all trees in Item group "tree" and "leafdecay" leaves and fruits
  - Simple HUD message about woodcutting process status if active
  - For developers - an enhancement API

## Develper notes
The mod does have some settings, hooks and an objects style API for game- or other-mods related enhancements.

### (default) Settings
```
woodcutting.settings = {
	tree_distance = 1,    -- Apply tree nodes with this distance to the queue. 1 means touching tree nodes only
	leaves_distance = 2,  -- do not touch leaves around the not removed trees with this distance
	player_distance = 80, -- Allow cutting tree nodes with this maximum distance away from player
	dig_leaves = true,    -- Dig dacayable leaves after tree node is digged - can be changed trough woodcutting_dig_leaves in minetest.conf
	wear_limit = 65535,   -- Maximum tool wear that allows cutting
}
```

### Hooks
```
woodcutting.settings = {
	on_new_process_hook = function(process) return true end, -- do not start the process if set to nil or return false
	on_step_hook = function(process) return true end,        -- if false is returned finish the process
	on_before_dig_hook = function(process, pos) return true end, -- if false is returned the node is not digged
	on_after_dig_hook = function(process, pos, oldnode) return true end, -- if false is returned do nothing after digging node
  ```
  
 ### Process object
 The hooks get an lua-objects in interface that means a lua-table with functions and setting attributes. The methods could be redefined in on_new_process_hook() function. That means it is possible to use different implemntations by different users at the same time.

#### Attributes
See (default) Settings
  - process.tree_distance   - used in process:add_tree_neighbors(pos) - can be adjusted each step in on_after_dig_hook()
  - process.leaves_distance - used in process:process_leaves(pos) - can be adjusted each step in on_after_dig_hook()
  - process.player_distance - used in process:check_processing_allowed(pos) - can be adjusted each step in on_step_hook()
  - process.dig_leaves      - used at end of on_dignode function - can be adjusted each step in on_after_dig_hook()
  - process.wear_limit      - used in process:check_processing_allowed(pos) - can be adjusted each step in on_step_hook()

#### Methods
Note:this methods could be redefined in on_new_process_hook, in a different way for each new process
  - process:stop_process()          - Finish the process
  - process:add_tree_neighbors(pos) - Add nearly tree nodes to the processing list
  - process:get_delay_time(pos)     - Get delay time to dig the node at pos
  - process:check_processing_allowed(pos) - Check if tree cut is allowed at pos
  - process:select_next_tree_node() - Get the next node from processing list
  - process:process_woodcut_step()  - Processing step. Should not be redefined - use on_step_hook instead
  - process:woodcut_node(pos, delay) - Cut a tree or leaves node - Should not be redefined - on_before_dig_hook instead
  - process:process_leaves(pos)     - Process leaves around the digged pos
  - process:get_hud_message(pos)    - Get the HUD message
  - process:show_hud(pos)           - Create and update players HUD using the get_hud_messgae() method (HUD is disabled in stop_process)


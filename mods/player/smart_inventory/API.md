# API definition to working together with smart_inventory

## Pages framework

### Register page
To get own page in smart_inventory the next register method should be used
```
smart_inventory.register_page({
                name             = string,
                icon             = string,
                label            = string,
                tooltip          = string,
                smartfs_callback = function,
                sequence         = number,
                on_button_click  = function,
        })
```
- name - unique short name, used for identification
- icon - Image displayed on page button. Optional
- label - Label displayed on page button. Optional
- tooltip - Text displayed at mouseover on the page button. Optional
- smartfs_callback(state) - smartfs callback function See [smartfs documentation](https://github.com/minetest-mods/smartfs/blob/master/docs) and existing pages implementations for reference.
- sequence - The buttons are sorted by this number (crafting=10, creative=15, player=20)
- on_button_click(state) - function called each page button click

### Get the definition for registered smart_inventory page
```smart_inventory.get_registered_page(pagename)```

### Get smartfs state for players inventory
```smart_inventory.get_player_state(playername)```
Get the root smartfs state for players inventory. Note: In workbench mode the function return nil if the player does not have the form open

### Get smartfs state for a registered page in players inventory
```smart_inventory.get_page_state(pagename, playername)```

## Filter framework
Smart_inventory uses a filter-framework for dynamic grouping in creative and crafting page. The filter framework allow to register additional classify filters for beter dynamic grouping results.
Maybe the framework will be moved to own mod in the feature if needed. Please note the smart_inventory caches all results at init time so static groups only allowed. The groups will not be re-checked at runtime.

### Register new filter
```
smart_inventory.filter.register_filter({
                name             = string,
                check_item_by_def      = function,
                get_description   = function,
                get_keyword       = function,
        })
```
  - name - unique filter name
  - check_item_by_def(fltobj, itemdef) - function to check the item classify by item definition. Item definition is the reference to minetest.registered_items[item] entry
    next return values allowed:
    - true -> direct (belongs to) assignment to the classify group named by filtername
    - string -> dimension, steps splitted by ":" (`a:b:c:d results in filtername, filtername:a, filtername:a:b, filtername:a:b:c, filtername:a:b:c:d`)
    - key/value table -> multiple groups assignment. Values could be dimensions as above (`{a,b} results in filtername, filtername:a, filtername:b`)
    - nil -> no group assingment by this filter
  - get_description(fltobj, group) - optional - get human readable description for the dimension string (`filtername:a:b:c`)
  - get_keyword(fltobj, group) - get string that should be used for searches or nil if the group should not be matched

 
### Filter Object methods

smart_inventory.filter.get(name)       get filter object by registered name. Returns filter object fltobj
  - fltobj:check_item_by_name(itemname)   classify by itemname (wrapper for check_item_by_def)
  - fltobj:check_item_by_def(def)         classify by item definition
  - fltobj:get_description(group)         get group description
  - fltobj:get_keyword(group)             get string that should be used for searches

## Cache framework
cache.register_on_cache_filled(function, parameter) - hook to call additional initializations after the cache is filled


## Crecipes framework
The should be used trough cache.register_on_cache_filled to be sure all items are already known
crecipes.add_recipes_from_list(recipeslist) - Add Custom-Type Recipes to the smart inventory database

## Example usage for cache and crecipe
```
if minetest.global_exists("smart_inventory") then
	-- add grinder recipes to smart inventory database
	local crecipes = smart_inventory.crecipes
	local cache = smart_inventory.cache
	local function fill_citem_recipes()
		local recipelist = {}
		for _, e in ipairs(crushingfurnace_receipes) do
			table.insert(recipelist, {
					output = e[2],
					items = {e[1]},
					type = "grinding"
				})
		end
		crecipes.add_recipes_from_list(recipelist)
	end
	 cache.register_on_cache_filled(fill_citem_recipes)
end
```

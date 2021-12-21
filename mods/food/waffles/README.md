# Waffles
_"And in the mornin', I'm makin' waffles!" - Donkey, Shrek 2001_

![screenshot.png](screenshot.png)

### _Waffles for Dummies:_
1. Obtain a waffle maker.
2. Place the waffle maker.
3. Obtain batter.
4. Open the waffle maker.
5. Place some batter in the waffle maker.
6. Close the waffle maker.
7. Wait for the waffle maker to open.
8. Take the cooked waffle.
9. Consume the cooked waffle.
10. Repeat from step 5.

### Recipes
_All listed items are configurable. See [Configuration](#configuration)_.

`waffles:waffle_maker`:
```
C = casing (default:tin_ingot)
W = wiring (default:steel_ingot)
H = heating (default:copper_ingot)

+-+-+-+
|C|C|C|
+-+-+-+
|W| |W|
+-+-+-+
|C|H|C|
+-+-+-+
```

`waffles:waffle_batter_3`:
```
(Shapeless)
farming:flour, farming:flour, bucket:bucket_water

This recipe is completely configurable.
```

`waffles:waffle_stack`: 8 `waffles:waffle` (Shapeless)

`waffles:waffle_stack_short`: 4 `waffles:waffle` (Shapeless)

### Configuration

* `waffles.craftitem_maker_casing`: Waffle maker casing craftitem.
* `waffles.craftitem_maker_wiring`: Waffle maker wiring craftitem.
* `waffles.craftitem_maker_heating`: Waffle maker heating craftitem.
* `waffles.waffle_batter_recipe`: Waffle batter recipe craftitems. See `settingtypes.txt`.

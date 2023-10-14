Pie mod [pie]

Pie mod for minetest adds six cakes to the game which can be crafted using items
from farming redo, mobs redo and Ethereal foods and then placed as a block or
punched to eat a slice (or three).

Adds normal cake, chocolate cake, coffee cake, red velvet cake,
strawberry cheesecake, meat cake and banana cake.

Support for hud/hunger, hbhunger and stamina has been added.

https://forum.minetest.net/viewtopic.php?f=9&t=13285


API
---

pie.register_pie(name, description)

e.g.

pie.register_pie("choc", "Chocolate Cake") -- creates full "pie:choc_0" to last slice "pie:choc_3"


Change log:

- 0.1 - Initial release
- 0.2 - Added meat pie
- 0.3 - Fix cake inside - Added banana cake
- 0.4 - Added support for stamina mod
- 0.5 - Added Orange and Bread cake (thanks to CalebDavis)
- 0.6 - Now uses food_ groups to craft cakes easier
- 0.7 - Added aliases for older pie mod by Mitroman
- 0.8 - Redo textures, make default optional, initial mineclone2 support
- 0.9 - Added API for mods to create their own cakes, added more milk replacements
- 1.0 - Added 'pie.quarters' setting to show pie quarters while eating instead of slices (thanks Slightly)

Lucky Blocks: 12

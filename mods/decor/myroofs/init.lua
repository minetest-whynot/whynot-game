
dofile(minetest.get_modpath("myroofs").."/asphault.lua")
dofile(minetest.get_modpath("myroofs").."/straw.lua")
dofile(minetest.get_modpath("myroofs").."/blocks.lua")
dofile(minetest.get_modpath("myroofs").."/chimney.lua")

minetest.register_alias("myroofs:asphalt_shingle_hd_asphalt", "homedecor:shingles_asphalt")
minetest.register_alias("myroofs:asphalt_shingle_hd_terracotta", "homedecor:shingles_terracotta")
minetest.register_alias("myroofs:asphalt_shingle_hd_wood", "homedecor:shingles_wood")

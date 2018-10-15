--[[
	Developer note:
	- All areas marked with “CHECKME” are places which should be reviewed carefully
	  for every release of Minetest Game.
]]

-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s,a,...)a={a,...}return s:gsub("@(%d+)",function(n)return a[tonumber(n)]end)end
end

local v6 = minetest.get_mapgen_setting("mg_name") == "v6"

local basicflametext, permaflametext
if minetest.setting_getbool("enable_fire") == false then
	basicflametext = S("The basic flame is a damaging but short-lived kind of block. This particular world is rather hostile to fire, so basic flames won't spread and destroy other blocks. They will quickly disappear. A basic flame is also destroyed by nearby water or punching. It hurts you when you stand directly inside a basic flame, but punching it is safe.")
	permaflametext = S("The permanent flame is a damaging block. Other than the basic flame, the permanent flame will not go away by time alone. A permanent flame is extinguished by punching it, by nearby water or similar blocks, or by removing a coal block below it. Punching is is safe, but it hurts if you stand inside. As this world is hostile to fire, it won't spread.")
else
	basicflametext = S("The basic flame is a damaging and destructive but short-lived kind of block. It will destroy and spread towards near flammable blocks, but fire will disappear if there is nothing to burn left. It will be extinguished by water and other blocks if it is next to it. A single basic flame block can be destroyed safely by punching it, but it is hurtful if you stand directly in it.")
	permaflametext = S("The permanent flame is a damaging and destructive block. It will create basic flames next to it if flammable blocks are nearby. Other than the basic flame, the permanent flame will not go away by time alone. A permanent flame is extinguished by punching it, by nearby water or similar blocks, or by removing a coal block below it. Punching is is safe, but it hurts if you stand inside.")

end

local flowertext = S("Flowers of this species have their natural habitat in grasslands and forests and are important for the production of dyes.")
local ladderdesc =  S("A piece of ladder which allows you to move vertically.")
local fencedesc = S("A fence post. When multiple of these are placed to next to each other, they will automatically build a nice fence structure. You can easily jump over a low fence.")
local fenceraildesc = S("A floating fence rail, without the fence post. When multiple of these are placed to next to each other, they will automatically build a nice fence rail structure. You can easily jump over a low fence.")
local fencegatedesc = S("Fence gates can be opened or closed and can be easily jumped over. Other fence posts will connect nicely to fence gates.")
local fencegateuse = S("Right-click the gate to open or close it.")
local walldesc = S("A piece of wall. When multiple of these are placed to next to each other, they will automatically build a nice wall structure. You can easily jump over a low wall.")
local slabdesc = S("A slab is half as high as their full block counterparts and can occupy either the lower or upper half of a block. Low slabs can be easily stepped on without needing to jump.")
local slabuse = S("To place a low slab, place it on the floor or the bottom half of the side of a block. To place a high slab, place it on the ceiling or the upper half of the side of a block.")

local stairdesc = S("Stairs are useful to reach higher places by walking over them; jumping is not required. Stairs can be placed upside-down, too.")
local stairuse = S("To place this block normally, place it on the floor or at the lower half of the side of a block. To place it upside-down, place it at a ceiling or the upper half of the side of a block.")
local innerstairdesc = S("Inner stairs are useful to reach higher places by walking without jumping. They are most useful to complement normal stairs at inner corners. They can be placed upside-down, too.")
local outerstairdesc = S("Outer stairs are useful to reach higher places by walking without jumping. They are most useful to complement normal stairs at outer corners. They can be placed upside-down, too.")

local signdesc = S("A sign is placed at walls. Players can write something on it.")
local signuse = S("Point to the sign to reveal its message. Right-click the sign to edit the text.")

local beddesc = S("Beds allow you to sleep at night and waste some time. Survival in this world does not demand sleep, but sleeping might have some other uses. ")
local beduse = S("Right-click on the bed to try to sleep in it. This only works at night. While being in it, you can right-click the bed again to get up early.")
if minetest.setting_getbool("enable_bed_respawn") == false then
	beddesc = beddesc .. S("In local folklore, legends are told of other worlds where setting the start point for your next would be possible. But this world is not one of them. ")
else
	beddesc = beddesc .. S("By sleeping in a bed, you set the starting point for your next life. ")
end
if minetest.setting_getbool("enable_bed_night_skip") == false then
	beddesc = beddesc .. S("In this strange world, the time will not pass faster for you when you sleep.")
else
	beddesc = beddesc .. S("Going into bed seems to make time pass faster: The night will be skipped when you go sleep and you are the only human being in this world. If you are not alone, the night will be skipped as soon the majority of all humans went to bed.")
end

local hoedesc = S("Hoes are essential tools for growing crops. They are used to create farming soil in order to plant seeds on it.")
local hoeuse = S("Punch a cultivatable block with a hoe to turn it into soil. Dirt, dirt with grass, dirt with dry grass and desert sand are cultivatable blocks.")
local axedesc = S("An axe is your tool of choice to cut down blocks which are affected by brute force, especially trees and wood. It also serves as a weapon in a pinch, although not as efficient as swords, but still acceptable.")
local sworddesc = S("Swords are great in melee combat, as they are fast, deal high damage and can endure countless battles. Swords are also surprisingly useful in cutting “snappy” plants and blocks, like grass, wheat and leaves, but this will wear them out.")
local shoveldesc = S("Shovels are mining tools to mine “crumbly” blocks, such as sand, dirt, gravel, and so on. Technically, they can also be used as weapons, but they are not much better than hand-to-hand combat.")
local pickaxedesc = S("Pickaxes are mining tools to mine hard, “cracky” blocks, such as stone. If you are desperate, you can use a pickaxe as an inefficient weapon.")

local dyedesc = S("Dyes are primarily used for crafting other items, especially for colorizing them. Dyes can also be used to obtain new dyes by using two dyes in crafting.")

local wooldesc = S("Wool is a soft decorative block which comes in different colors. Walking on wool is completely silent.")

local butterflydesc = S("Butterflies are peaceful insencts that hover in the air. They can be catched with a bugnet.")

local lavaheight
-- CHECKME: Height at which lava spawns
if v6 then
	lavaheight = -32
else
	lavaheight = -273
end

local deconode = doc.sub.items.temp.deco
local buildnode = doc.sub.items.temp.build
local craftitemdesc = doc.sub.items.temp.craftitem
local eat = doc.sub.items.temp.eat
local eat_bad = doc.sub.items.temp.eat_bad
local placerotateuse = doc.sub.items.temp.rotate_node

local tnt_radius = tonumber(minetest.setting_get("tnt_radius"))
-- CHECKME: Default TNT radius
if tnt_radius == nil then
	tnt_radius = 3
end

local tntdesc = S("An explosive device. When it explodes, it will hurt living beings, destroy blocks around it, throw blocks affected by gravity all over the place and set flammable blocks on fire. A single TNT has an explosion radius of @1. The explosion radius increases if multiple TNT blocks are close to each other. With a small chance, blocks may drop as an item (as if being mined) rather than being destroyed. TNT can be ignited by tools, explosions, igniter blocks. Initially, TNT is not affected by gravity, but as soon it has been ignited, it is.", tnt_radius)
if minetest.get_modpath("mesecons") then
	tntdesc = tntdesc .. "\n" .. S("This is a mesecon effector. If TNT receives a mesecon signal, it explodes immediately.")
end

local nyandesc = S("A weird creature with a cat face, cat extremities and a strawberry-flavored pop-tart body. It has been trapped in a block and cannot move and can thus be dug easily by simple tools. Nyan cats are usually followed by nyan cat rainbows. Legends say that in ancient times, long before the creation of our world, there were many of the Nyan Cats which were free and flew through space and sang the \"Nya-nya\" song. Nowadays, nyan cats serve as a fancy collector's item and are traded as souvenirs. Apart from that, nyan cats have no intrinsic value.")
local rainbowdesc = S("A rainbow made by a real nyan cat, ancient creatures which once flew through space. It has gone inert and can be dug by simple tools. Like nyan cats, nyan cat rainbows have no intrinsic value.")

local railuse = S("Place them on the ground to build your railway, the rails will automatically connect to each other and will turn into curves, T-junctions, crossings and slopes as needed.")

local coral_living = S("Corals are plants naturally found in shallow water of warm climates. Corals are rather delicate. When exposed to air, they will die off to become coral skeletons.")

local groupname_sand = doc.sub.items.get_group_name("sand")
local groupname_water = doc.sub.items.get_group_name("water")
local groupname_flora = doc.sub.items.get_group_name("flora")
local groupname_book = doc.sub.items.get_group_name("book")
local groupname_vessel = doc.sub.items.get_group_name("vessel")

local export_longdesc = {
	[""] = S("You use your bare hand whenever you are not wielding any item. With your hand you can mine the weakest blocks and deal minor damage by punching. Using the hand is often a last resort, as proper mining tools and weapons are usually better than the hand. When you are wielding an item which is not a mining tool or a weapon it will behave as if it were the hand when you start mining or punching. In Creative Mode, the mining capabilities, range and damage of the hand are greatly enhanced."),
	["default:apple"] = S("Apples can be eaten to restore 2 hit points. Apples are sometimes grown from saplings."),
	["default:blueberries"] = S("Blueberries can be eaten to restore 2 hit points. They can be collected from blueberry bushes."),
	["default:furnace"] = S("Cooks or smelts several items, using a furnace fuel, into something else."),
	["default:chest"] = S("Provides 32 slots of inventory space."),
	["default:chest_locked"] = S("Provides 32 slots of inventory space, is accessible only to the player who placed it. Locked chests are also immune to explosions."),

	["default:coral_skeleton"] = S("A coral skeleton once was a living colorful coral but now has died. Coral skeletons can be found naturally in shallow water of warm climates."),
	["default:coral_brown"] = coral_living,
	["default:coral_orange"] = coral_living,
	["default:sand_with_kelp"] = S("Kelp is an ocean plant which grows several blocks high and only grows in water on top of a sand block. The sand block is part of the plant and behaves differently from normal sand. It does not fall. The kelp itself is part of the same block, it can not be separated."),

	["default:stone"] = S("A very common block in the world of Minetest Game, almost the entire underground consists of stone. It sometimes contains ores. Stone may be created when water meets lava."),
	["default:desert_stone"] = S("Desert stone is less common than stone and is found in large quantities near the surface of deserts. Desert stone doesn't go very deep."),
	["default:stone_with_coal"] = S("Some coal contained in stone, it is very common and can be found in stones as large clusters at a height of +64 or lower."),
	["default:stone_with_iron"] = S("This stone contains pure iron, which is very common. It is found in small clusters at a height between +2 and -15, in clusters of 5 at a height of -16 or lower and in large clusters of up to 27 iron ores at a height of -64 or lower."),
	["default:stone_with_copper"] = S("This stone contains pure copper. Copper is found in stone in clusters of 4-5 at a height of -16 or lower and is more common at a height of -64 or lower."),
	["default:stone_with_tin"] = S("This stone contains pure tin. Tin slightly less common than copper and is found in stone in clusters of 4-5 at a height of -32 or lower and is more common at a height of -128 or lower."),
	["default:stone_with_mese"] = S("This stone contains a small amount of mese, a rare mineral of alien origin. It can be found in clusters of 3-5 at a height of -64 lower. Mese ore is more common at -256 or lower."),
	["default:stone_with_gold"] = S("This stone contains pure gold, a rare metal. It can be found in clusters of about 3 blocks at a height of -64 or lower and in clusters of about 5 blocks at a height of -256 or lower."),
	["default:stone_with_diamond"] = S("Diamonds are very rare and hard and can be found in clusters deep in the underground. They appear inside stone in clusters of about 4 blocks at a height of -128 or lower and are more common at a height of -256 or lower."),
	["default:stonebrick"] = buildnode,
	["default:desert_stonebrick"] = buildnode,
	["default:dirt_with_grass"] = S("Very common on the surface, found in grasslands and forests. It is a resourceful block which supports the growth and spreading of many small plants and trees. Dirt with grass turns into dirt with snow when a snow block is placed on top of it."),
	["default:dirt_with_rainforest_litter"] = S("This block is found on the surface of rainforests. It is a resourceful block which supports the growth and spreading of many small plants and trees."),
	["default:dirt_with_coniferous_litter"] = S("This block is found on the surface of coniferous forests. It is a resourceful block which supports the growth and spreading of many small plants and trees."),
	["default:dirt_with_grass_footsteps"] = S("A decorational variant of dirt with grass, it looks like someone has stepped on the grass. Unlike dirt with grass, it doesn't change on its own and doesn't spread its grass on other dirt blocks."),
	["default:dirt_with_dry_grass"] = S("Common on the surface, found in savannahs."),
	["default:dirt_with_snow"] = S("Dirt with snow is a cold block of frozen dirt which doesn't support the growth of any plants. Plants won't die on it, but they don't grow or spread either."),
	["default:snow"] = S("A thin layer of snow. When it it on top of dirt, the dirt will slowly turn into dirt with snow. When snow lands on dirt with grass, it immediately turns into dirt with snow."),
	["default:snowblock"] = S("A very thick layer of snow, filling an entire block. Snow this thick can usually only be found in arctic regions. When this block is placed on top of dirt with grass, the dirt with grass turns into dirt with snow."),
	["default:ice"] = S("Ice is found in arctic regions. It can appear either in huge glacier formations below snow blocks, or above water. Ice will not naturally contain tunnels and caves."),
	["default:cave_ice"] = S("Cave ice is a type of ice which might naturally have tunnels and caves inside. It might be found in ice sheet biomes."),
	["default:dirt"] = S("Dirt is found often directly under the surface and very common in many regions of the world. When exposed to sunlight, the surface of dirt may change, depending on its neighbors."),
	["default:sand"] = S("Sand is found in large quantities at beaches, but it occasionally appears in small chunks around the world."),
	["default:desert_sand"] = S("Usually found in huge quantities at the surface of deserts."),
	["default:silver_sand"] = S("Silver sand can be found in cold biomes in the form of so-called cold deserts."),
	["default:gravel"] = S("This block consists of a couple of loose stones and can't support itself. It is common only at the beaches of very cold regions, but it can be found in small quantities on the surface and underground."),
	["default:clay"] = S("Clay is a rather soft material and it sometimes found in sand beaches."),
	["default:sandstone"] = S("A pretty soft kind of stone, a compressed form of sand. It is common in sandstone deserts."),
	["default:silver_sandstone"] = S("A pretty soft kind of stone, a compressed form of silver sand."),
	["default:desert_sandstone"] = S("A pretty soft kind of stone, a compressed form of desert sand."),
	["default:sandstonebrick"] = buildnode,
	["default:desert_sandstone_brick"] = buildnode,
	["default:silver_sandstone_brick"] = buildnode,
	["default:brick"] = buildnode,
	["default:stone_block"] = buildnode,
	["default:desert_stone_block"] = buildnode,
	["default:sandstone_block"] = buildnode,
	["default:desert_sandstone_block"] = buildnode,
	["default:silver_sandstone_block"] = buildnode,
	["default:obsidian_block"] = buildnode,
	["default:cloud"] = S("A decorational block. It can be destroyed by explosions."),
	["default:tree"] = S("A trunk of a regular tree. This species of tree sometimes bears apples and is home in deciduous forests in mild climates."),
	["default:jungletree"] = S("A trunk of a jungle tree. Jungle trees can be found in jungles, which are in hot and wet climates."),
	["default:pine_tree"] = S("A trunk of a pine tree. The natural habitat of pine trees are coniferous forests which can be found in cold climates."),
	["default:aspen_tree"] = S("A trunk of an aspen tree. The natural habitat of aspen trees are deciduous forests which can be found in mild climates."),
	["default:acacia_tree"] = S("A trunk of an acacia tree. The natural habitat of acacia trees are savannahs, which can be found in hot and dry climates."),
	["default:bush_stem"] = S("The stem of a bush. Bushes can be found in grasslands, snowy grasslands and deciduous forests."),
	["default:acacia_bush_stem"] = S("The stem of an acacia bush. Acacia bushes can be found in savannahs."),
	["default:wood"] = buildnode,
	["default:junglewood"] = buildnode,
	["default:pine_wood"] = buildnode,
	["default:acacia_wood"] = buildnode,
	["default:aspen_wood"] = buildnode,
	["default:sapling"] = S("When placed on natural soil (such as dirt) and exposed to sunlight, a sapling will grow into a tree after some time. There's a chance that this tree bears apples."),
	["default:junglesapling"] = S("When placed on natural soil (such as dirt) and exposed to sunlight, a jungle sapling will grow into a large jungle tree after some time."),
	["default:emergent_jungle_sapling"] = S("When placed on natural soil (such as dirt) and exposed to sunlight, an emergent jungle sapling will grow into an emergent jungle tree (a taller subspecies of the jungle tree) after some time."),
	["default:acacia_sapling"] = S("When placed on natural soil (such as dirt) and exposed to sunlight, an acacia sapling will grow into an acacia tree after some time."),
	["default:aspen_sapling"] = S("When placed on natural soil (such as dirt) and exposed to sunlight, an aspen sapling will grow into an aspen tree after some time."),
	["default:pine_sapling"] = S("When placed on natural soil (such as dirt) and exposed to sunlight, a pine sapling will grow into a pine tree after some time. If the pine sapling was next to any “snowy” block (e.g. “Snow Block”), the pine tree will be covered with snow."),
	["default:bush_sapling"] = S("When placed on natural soil (such as dirt) and exposed to sunlight, a bush sapling will grow into a bush after some time."),
	["default:acacia_bush_sapling"] = S("When placed on natural soil (such as dirt) and exposed to sunlight, an acacia bush sapling will grow into an acacia bush after some time."),
	["default:blueberry_bush_sapling"] = S("When placed on natural soil (such as dirt) and exposed to sunlight, an blueberry bush sapling will grow into a blueberry bush after some time."),
	["default:leaves"] = S("Leaves are grown from trees—which sometimes bear apples—found in deciduous forests."),
	["default:jungleleaves"] = S("Jungle leaves are grown from jungle trees found in jungles."),
	["default:acacia_leaves"] = S("Acacia leaves are grown from acacia trees found in savannahs."),
	["default:aspen_leaves"] = S("Aspen leaves are grown from aspen trees found in deciduous forests."),
	["default:pine_needles"] = S("Pine needles are grown from pine trees found in coniferous forests."),
	["default:bush_leaves"] = S("Bush leaves are grown from bushes found in grasslands, snowy grasslands and deciduous forests."),
	["default:acacia_bush_leaves"] = S("Acacia bush leaves are grown from acacia bushes found in savannahs."),
	["default:blueberry_bush_leaves"] = S("Blueberry bush leaves are grown from blueberry bushes found in grasslands."),
	["default:blueberry_bush_leaves_with_berries"] = S("These blueberry bush leaves carry some tasty blueberries! They can be found in grasslands."),
	["default:cactus"] = S("A piece of cactus usually found in deserts. Cacti grow on sand, desert sand and other blocks belonging to the “@1” group at a light level of 13 or higher. They can reach a height of up to 4 cactus blocks.", groupname_sand),
	["default:papyrus"] = S("A papyrus piece usually found near shallow water. Papyrus grows vertically up to a height of 4 blocks on dirt and dirt with grass near a water source (or another block belonging to the @1 group) and requires a light level of 13 or higher. When dug, all papyrus blocks directly connected above it will also be dug.", groupname_water),
	["default:bookshelf"] = S("A bookshelf provides 16 inventory slots for books."),
	["default:glass"] = S("A decorational and mostly transparent block which is rather easy to break."),
	["default:fence_wood"] = fencedesc,
	["default:fence_junglewood"] = fencedesc,
	["default:fence_pine_wood"] = fencedesc,
	["default:fence_acacia_wood"] = fencedesc,
	["default:fence_aspen_wood"] = fencedesc,
	["default:fence_rail_wood"] = fenceraildesc,
	["default:fence_rail_junglewood"] = fenceraildesc,
	["default:fence_rail_pine_wood"] = fenceraildesc,
	["default:fence_rail_acacia_wood"] = fenceraildesc,
	["default:fence_rail_aspen_wood"] = fenceraildesc,
	["doors:gate_wood_closed"] = fencegatedesc,
	["doors:gate_junglewood_closed"] = fencegatedesc,
	["doors:gate_acacia_wood_closed"] = fencegatedesc,
	["doors:gate_pine_wood_closed"] = fencegatedesc,
	["doors:gate_aspen_wood_closed"] = fencegatedesc,

	["default:dry_shrub"] = S("An unremarkable dead plant which is common in deserts and snowy biomes. Small plants which are members of the @1 group placed on silver sand or desert sand will sooner or later turn into dry shrubs.", groupname_flora),
	["default:rail"] = S("Rails can be used to build transport tracks for carts. Normal rails slightly slow down carts due to friction."),
	["carts:powerrail"] = S("Rails can be used to build transport tracks for carts. Powered rails will accelerate moving carts, up to a maximum speed."),
	["carts:brakerail"] = S("Rails can be used to build transport tracks for carts. Brake rails will heavily slow down carts, much more than normal rails."),
	["default:ladder_wood"] = ladderdesc,
	["default:ladder_steel"] = ladderdesc,
	["default:water_source"] = S("Water is abundant in oceans and may also appear in small quantities in underground water pockets. You can swim easily in water, but you need to catch your breath from time to time. Water will turn nearby lava into obsidian or stone."),
	["default:river_water_source"] = S("You can swim easily in river water, but you need to catch your breath from time to time. Unlike (normal) water, it appears in rivers only. River water will turn nearby lava into obsidian or stone."),
	["default:lava_source"] = S("Lava is found deep underground (@1 and below) and rather dangerous. Don't touch it, it will hurt you a lot and once you're in, it is hard to get out. When a lava source meets water or river water (or another block in the @2 group), it turns into obsidian. Flowing lava turns into stone instead.", lavaheight, groupname_water),
	["default:torch"] = S("Provides some light. It can be placed on almost any block facing any direction. It can also be used to ignite gunpowder and TNT by punching."),
	["default:sign_wall_wood"] = signdesc,
	["default:sign_wall_steel"] = signdesc,
	["default:cobble"] = S("A building block used to create houses, dungeons and other buildings. It is obtained after mining stone. If it is near water (or any other block in the @1 group), it might turn into mossy cobblestone.", groupname_water),
	["default:desert_cobble"] = buildnode,
	["default:coal_lump"] = S("Coal lumps are your standard furnace fuel, but they are also used to make torches and a few other things."),
	["default:mossycobble"] = S("A decorational block. It is found in underground dungeons and is the product of cobblestone near water."),
	["default:coalblock"] = S("Coal blocks are useful as compact storage of coal lumps and notable for exceptional burning capabilities. As a furnace fuel, it is slightly more efficient than 9 coal lumps. Coal blocks can also be used to start permanent flames with a flint and steel. If you remove the coal block, the permanent flame is destroyed as well."),
	["default:steelblock"] = deconode,
	["default:copperblock"] = deconode,
	["default:bronzeblock"] = deconode,
	["default:goldblock"] = deconode,
	["default:tinblock"] = deconode,
	["default:diamondblock"] = S("A very hard decorational block."),
	["default:obsidian_glass"] = S("Obsidian glass is transparent, has a very clean surface and is rather hard to break."),
	["default:obsidian"] = S("A hard mineral which is created from a lava source when it meets water (any block in the @1 group).", groupname_water),
	["default:obsidianbrick"] = buildnode,
	["default:key"] = S("A key grants you to access to a thing with a lock (e.g. steel door, steel trapdoor, locked chest), even if you don't own it. Each key is unique and only fits into one lock. If the locked thing has been removed, the key won't unlock anything."),
	["default:skeleton_key"] = S("A skeleton key can be used to share access to a locked thing you own (e.g. steel door, steel trapdoor, locked chest) with other players."),

	-- 0.4.14 Nyan Cats (for compability)
	["default:nyancat"] = nyandesc,
	["default:nyancat_rainbow"] = rainbowdesc,
	-- New Nyan cats
	["nyancat:nyancat"] = nyandesc,
	["nyancat:nyancat_rainbow"] = rainbowdesc,

	["default:book"] = S("A book is used to store notes and to make bookshelves."),
	["default:book_written"] = S("A book with text contains notes which can be rewritten and copied to books. In the inventory, both title and author of the book are shown."),
	["default:grass_1"] = S("Grass can be found in large quantities in open plains. It comes in 5 different sizes, but its size never changes."),
	["default:marram_grass_1"] = S("Marram grass can be in beaches on top of sand. It comes in 3 different sizes but its size never changes."),
	["default:junglegrass"] = S("This plant is common in jungles."),
	["default:dry_grass_1"] = S("Dry grass is very common in savannahs and comes in 5 different sizes but its size never changes."),
	["default:fern_1"] = S("Ferns can be found in large quantities in coniferous forests. It comes in 3 different sizes but its size never changes."),
	["default:meselamp"] = S("A bright light source powered by mese crystals. It is brighter than a torch."),
	["default:mese_post_light"] = S("A bright light source powered by mese crystals. This is a more compact version of the mese lamp. It is brighter than a torch."),
	["default:mese"] = S("Mese is a rare mineral of alien origin; mese blocks are a highly concentrated form of mese. At extreme depths (-1024 or lower), mese blocks rarely occour naturally in stone as clusters of about 3 mese blocks."),
	["bucket:bucket_empty"] = S("A bucket can be used to collect and release liquids."),
	["bucket:bucket_water"] = S("A bucket can be used to collect and release liquids. This one is filled with water."),
	["bucket:bucket_river_water"] = S("A bucket can be used to collect and release liquids. This one is filled with river water."),
	["bucket:bucket_lava"] = S("A bucket can be used to collect and release liquids. This one is filled with hot lava, safely contained inside. Use with caution."),

	["bones:bones"] = S("These are the remains of a deceased player. It may contain the player's former inventory which can be looted. Fresh bones are bones of a player who has deceased recently and can only be looted by the same player. Old bones can be looted by everyone. Once collected, bones can be placed like any other block."),
	["doors:door_wood"] = S("A door covers a vertical area of two blocks to block the way. It can be opened and closed by any player."),
	["doors:door_glass"] = S("A door covers a vertical area of two blocks to block the way. It can be opened and closed by any player."),
	["doors:door_obsidian_glass"] = S("A door covers a vertical area of two blocks to block the way. It can be opened and closed by any player."),
	["doors:door_steel"] = S("Steel doors are owned by the player who placed them, only their owner can open, close or mine them. Steel doors are also immune to explosions."),
	["farming:straw"] = deconode,
	["farming:bread"] = S("A nutritious food. Eat it to restore 5 hit points."),
	["farming:seed_wheat"] = S("Grows into a wheat plant."),
	["farming:seed_cotton"] = S("Grows into a cotton plant."),
	["farming:soil"] = S("Dry soil for farming, a necessary surface to plant crops. It is created when a hoe is used on dirt or a similar block. Dry soil will become wet soil when a water source is nearby. Soil might turn back into dirt if nothing is planted on it and it is not made wet for a while."),
	["farming:soil_wet"] = S("Wet soil for farming, this is where you can plant and grow crops on. Wet soil is created when water is near soil. Wet soil will become (dry) soil again when there is no water nearby."),
	["farming:desert_sand_soil"] = S("Dry desert sand soil for farming, a necessary surface to plant crops. It is created when a hoe is used on desert sand. Desert sand soil will become wet desert sand soil if a water source is near. Desert sand soil might turn back into desert sand if nothing is planted on it and it is not made wet for a while."),
	["farming:desert_sand_soil_wet"] = S("Wet desert sand soil for farming, this is where you can plant and grow crops on. Wet desert sand soil is created when water is near (dry) desert sand soil. Wet desert sand soil will become (dry) desert sand soil again when there is no water nearby."),
	["farming:wheat_8"] = S("The wheat plant is a plant grown from wheat seed. It grows on wet soil in direct sunlight. It will grow through 8 stages and stops growing at its final stage. Digging it will yield up to 2 wheat seeds and 2 wheat. The drop probabilities are much lower if the plant is dug at an early stage with the risk to even get nothing at all; only at its final stage you are guaranteed to get at least 1 wheat seed and 1 wheat."),
	["farming:cotton_8"] = S("The cotton plant is a plant grown from wheat seed. It grows on wet soil or wet desert sand soil in direct sunlight. It will grow through 8 stages and stops growing at its final stage. Digging it will yield up to 2 cotton seeds and 2 cottons. The drop probabilities are much lower if the plant is dug at an early stage with the risk to even get nothing at all; only at its final stage you are guaranteed to get at least 1 cotton seed and 1 cotton."),
	["flowers:mushroom_brown"] = S("An edible mushroom. Eat it to restore 1 hit point. Brown mushrooms like to grow and spread on natural soil (like dirt) and sometimes on fallen tree trunks. They need darkness to spread and survive and die off in direct sunlight."),
	["flowers:mushroom_red"] = S("A poisonous mushroom, don't eat it. If you eat it, you lose 5 hit points. Red mushrooms like to grow and spread on natural dirt (like dirt) and sometimes on fallen tree trunks. They need darkness to spread and survive and die off in direct sunlight."),
	["flowers:geranium"] = flowertext,
	["flowers:dandelion_yellow"] = flowertext,
	["flowers:dandelion_white"] = flowertext,
	["flowers:tulip"] = flowertext,
	["flowers:rose"] = flowertext,
	["flowers:viola"] = flowertext,
	["flowers:tulip_black"] = flowertext,
	["flowers:chrysanthemum_green"] = flowertext,
	["flowers:waterlily"] = S("Waterlilies are sometimes found on shallow water. They can't survive on anything but water."),

	["tnt:tnt"] = tntdesc,
	["tnt:gunpowder"] = S("Gunpowder is used to craft TNT and to create gunpowder trails which can be ignited."),

	["fire:basic_flame"] = basicflametext,
	["fire:permanent_flame"] = permaflametext,
	["fire:flint_and_steel"] = S("Flint and steel is a tool to start fires and ignite blocks."),


	["doors:trapdoor"] = S("A trapdoor covers a hole in the floor and can be opened manually to access the area below it."),
	["doors:trapdoor_steel"] = S("A steel trapdoor covers a hole in the floor and can be opened manually only by the placer to access the area below it. Steel trapdoors are immune to explosions."),

	["screwdriver:screwdriver"] = S("A screwdriver can be used to rotate blocks."),

	["boats:boat"] = S("A simple boat which allows you to float on the surface of large water bodies. Travelling by boat is a bit faster than swimming."),
	["carts:cart"] =
		S("A cart which you can use for quick transport of yourself and items on rails.") .. "\n" ..
		S("Carts only ride on rails and always follow the tracks. At a T-junction with no straight way ahead, the cart normally turns left. There are multiple rail types which affect the cart speed."),
	["vessels:glass_bottle"] = S("A decorational item which can be placed."),
	["vessels:drinking_glass"] = S("A decorational item which can be placed."),
	["vessels:steel_bottle"] = S("A decorational item which can be placed."),
	["vessels:shelf"] = S("A vessels shelf provides 16 inventory slots for vessels (like glass bottles)."),
	["fireflies:firefly"] = S("Fireflies hover in the air and illuminate the surroundings. They like to appear in the night and disappear in sunlight. They can be catched with a bugnet."),
	["butterflies:butterfly_white"] = butterflydesc,
	["butterflies:butterfly_red"] = butterflydesc,
	["butterflies:butterfly_violet"] = butterflydesc,
	["fireflies:firefly_bottle"] = S("A firefly which has been captured in a bottle. It's a simple decoration which illuminates the surroundings."),
	["xpanes:pane_1"] = S("Glass panes are thin layers of glass which neatly connect to their neighbors as you build them."),
	["xpanes:obsidian_pane_1"] = S("Obsidian glass panes are thin layers of obsidian glass which neatly connect to their neighbors as you build them."),
	["xpanes:bar_1"] = S("Iron bars neatly connect to their neighbors as you build them."),
	["beds:bed_bottom"] = beddesc,
	["beds:fancy_bed_bottom"] = beddesc,
	["walls:cobble"] = walldesc .. "\n" .. S("Cobblestone walls will slowly turn into mossy cobblestone walls when they're near water (or any other block in the @1 group).", groupname_water),
	["walls:desertcobble"] = walldesc,
	["walls:mossycobble"] = walldesc .. "\n" .. S("A mossy cobblestone wall is created when a cobblestone wall is near water (or any other block in the @1 group) for a while.", groupname_water),
	["stairs:slab_cobble"] = slabdesc .. "\n" .. S("A cobblestone slab will slowly turn into a mossy cobblestone slab when it is near water (or any other block in the @1 group).", groupname_water),
	["stairs:slab_mossycobble"] = slabdesc .. "\n" .. S("A mossy cobblestone slab is created when a cobblestone slab is near water (or any other block in the @1 group) for a while.", groupname_water),
	["stairs:stair_cobble"] = stairdesc .. "\n" .. S("A cobblestone stair will slowly turn into a mossy cobblestone stair when it is near water or any other block in the @1 group.", groupname_water),
	["stairs:stair_mossycobble"] = stairdesc .. "\n" .. S("A mossy cobblestone stair is created when a cobblestone stair is near water (or any other block in the @1 group) for a while.", groupname_water),
	["stairs:stair_inner_cobble"] = innerstairdesc .. "\n" .. S("An inner cobblestone stair will slowly turn into an inner mossy cobblestone stair when it is near water or any other block in the @1 group.", groupname_water),
	["stairs:stair_inner_mossycobble"] = innerstairdesc .. "\n" .. S("An inner mossy cobblestone stair is created when an inner cobblestone stair is near water (or any other block in the @1 group) for a while.", groupname_water),
	["stairs:stair_outer_cobble"] = outerstairdesc .. "\n" .. S("An outer cobblestone stair will slowly turn into an outer mossy cobblestone stair when it is near water or any other block in the @1 group.", groupname_water),
	["stairs:stair_outer_mossycobble"] = outerstairdesc .. "\n" .. S("An outer mossy cobblestone stair is created when an outer cobblestone stair is near water (or any other block in the @1 group) for a while.", groupname_water),
	["farming:hoe_wood"] = hoedesc,
	["farming:hoe_stone"] = hoedesc,
	["farming:hoe_steel"] = hoedesc,
	["farming:hoe_bronze"] = hoedesc,
	["farming:hoe_mese"] = hoedesc,
	["farming:hoe_diamond"] = hoedesc,
	["default:pick_wood"] = pickaxedesc,
	["default:pick_stone"] = pickaxedesc,
	["default:pick_steel"] = pickaxedesc,
	["default:pick_bronze"] = pickaxedesc,
	["default:pick_mese"] = pickaxedesc,
	["default:pick_diamond"] = pickaxedesc,
	["default:shovel_wood"] = shoveldesc,
	["default:shovel_stone"] = shoveldesc,
	["default:shovel_steel"] = shoveldesc,
	["default:shovel_bronze"] = shoveldesc,
	["default:shovel_mese"] = shoveldesc,
	["default:shovel_diamond"] = shoveldesc,
	["default:axe_wood"] = axedesc,
	["default:axe_stone"] = axedesc,
	["default:axe_steel"] = axedesc,
	["default:axe_bronze"] = axedesc,
	["default:axe_mese"] = axedesc,
	["default:axe_diamond"] = axedesc,
	["default:sword_wood"] = sworddesc,
	["default:sword_stone"] = sworddesc,
	["default:sword_steel"] = sworddesc,
	["default:sword_bronze"] = sworddesc,
	["default:sword_mese"] = sworddesc,
	["default:sword_diamond"] = sworddesc,
	["dye:black"] = dyedesc,
	["dye:white"] = dyedesc,
	["dye:blue"] = dyedesc,
	["dye:green"] = dyedesc,
	["dye:dark_green"] = dyedesc,
	["dye:grey"] = dyedesc,
	["dye:dark_grey"] = dyedesc,
	["dye:yellow"] = dyedesc,
	["dye:orange"] = dyedesc,
	["dye:brown"] = dyedesc,
	["dye:violet"] = dyedesc,
	["dye:cyan"] = dyedesc,
	["dye:red"] = dyedesc,
	["dye:magenta"] = dyedesc,
	["dye:pink"] = dyedesc,
	["wool:black"] = deconode,
	["wool:white"] = deconode,
	["wool:blue"] = deconode,
	["wool:green"] = deconode,
	["wool:dark_green"] = deconode,
	["wool:grey"] = deconode,
	["wool:dark_grey"] = deconode,
	["wool:yellow"] = deconode,
	["wool:orange"] = deconode,
	["wool:brown"] = deconode,
	["wool:violet"] = deconode,
	["wool:cyan"] = deconode,
	["wool:red"] = deconode,
	["wool:magenta"] = deconode,
	["wool:pink"] = deconode,

	["default:bronze_ingot"] = craftitemdesc,
	["default:gold_ingot"] = craftitemdesc,
	["default:steel_ingot"] = S("Molten iron. It is the element of numerous crafting recipes."),
	["default:copper_ingot"] = craftitemdesc,
	["default:tin_ingot"] = craftitemdesc,
	["default:clay_brick"] = craftitemdesc,
	["default:clay_lump"] = S("A clay lump can be burnt in the furnace to make a clay brick."),
	["default:paper"] = craftitemdesc,
	["vessels:glass_fragments"] = craftitemdesc,
	["default:diamond"] = craftitemdesc,
	["default:flint"] = craftitemdesc,
	["default:gold_lump"] = S("A gold lump can be smelt in a furnace to make a gold ingot."),
	["default:copper_lump"] = S("A copper lump can be smelt in a furnace to make a copper ingot."),
	["default:tin_lump"] = S("A tin lump can be smelt in a furnace to make a tin ingot."),
	["default:iron_lump"] = S("An iron lump can be smelt in a furnace to make a steel ingot."),
	["default:obsidian_shard"] = S("Obsidian shards can be smelt in a furnace to create obsidian glass."),
	["default:mese_crystal"] = craftitemdesc,
	["default:mese_crystal_fragment"] = S("It can be used to craft a full mese crystal and possibly other things, too (if you use mods)."),
	["default:stick"] = S("Wooden sticks are used as a vital element in countless crafting recipes."),
	["farming:cotton"] = craftitemdesc,
	["farming:string"] = craftitemdesc,
	["farming:wheat"] = craftitemdesc,
	["farming:flour"] = craftitemdesc,

	["binoculars:binoculars"] = S("Binoculars allow you to zoom."),
	["map:mapping_kit"] = S("A mapping kit allows you to use the minimap (but not the radar mode)."),
	["fireflies:bug_net"] = S("A bug net allows you to catch small insects, such as fireflies."),
}

local bonestime = tonumber(minetest.setting_get("share_bones_time"))
local bonestime2 = tonumber(minetest.setting_get("share_bones_time_early"))
local bonesstring, bonesstring2, bonestime_s, bonestime2_s
if bonestime == nil then bonestime = 1200 end
if bonestime2 == nil then bonestime2 = math.floor(bonestime / 4) end

if bonestime == 0 then
	bonesstring = S("In this world this can be done without any delay as the bones instantly become old. ")
elseif bonestime % 60 == 0 then
	bonestime_s = S("@1 min", bonestime/60)
else
	bonestime_s = S("@1 min @2 s", bonestime/60, bonestime%60)
end
if bonestime2 == 0 then
	bonesstring2 = ""
elseif bonestime2 % 60 == 0 then
	bonestime2_s = S("@1 min", bonestime2/60)
else
	bonestime2_s = S("@1 min @2 s", bonestime2/60, bonestime2 % 60)
end

if bonestime ~= 0 then
	bonesstring = S("If these are not your bones, you have to wait @1 before you can do this. ", bonestime_s)
end
if bonestime2 ~= 0 then
	bonesstring2 = S("If the player died in a protected area of someone else, the bones can be dug after @1.", bonestime2_s)
end

local export_usagehelp = {
	["default:apple"] = eat,
	["default:blueberries"] = eat,
	["doors:gate_wood_closed"] = fencegateuse,
	["doors:gate_junglewood_closed"] = fencegateuse,
	["doors:gate_acacia_wood_closed"] = fencegateuse,
	["doors:gate_pine_wood_closed"] = fencegateuse,
	["doors:gate_aspen_wood_closed"] = fencegateuse,

	["default:tree"] = placerotateuse,
	["default:jungletree"] = placerotateuse,
	["default:pine_tree"] = placerotateuse,
	["default:aspen_tree"] = placerotateuse,
	["default:acacia_tree"] = placerotateuse,
	["default:cactus"] = placerotateuse,
	
	["flowers:mushroom_brown"] = eat,
	["flowers:mushroom_red"] = eat_bad,
	["farming:bread"] = eat,
	["default:furnace"] = S("Right-click the furnace to view it. Place a furnace fuel in the lower slot and the source material in the upper slot. The furnace will slowly use its fuel to smelt the item. The result will be placed into the 4 slots at the right side."),
	["default:chest"] = S("Right-click the chest to open it and to exchange items. You can only mine it when the chest is empty."),
	["default:chest_locked"] = S("Point it to reveal the name of its owner. Right-click the chest to open it and to exchange items. This is only possible if you own the chest. You also can only mine the chest when you own it and it is empty."),
	["default:sand_with_kelp"] = S("To mine this block/plant, mine the sand block on which the kelp grows. The kelp itself can not be pointed.").."\n"..S("This block can only be placed deep in the water (at least 5 blocks deep). Placement may randomly fail if the water is not deep enough."),
	["default:book"] = S("Hold the book in hand and left-click to write some notes. You have to provide both a title and contents. Doing so will turn the book into a new item (see “Book With Text”)."),
	["default:book_written"] = S("Hold the book with text in hand and left-click to read or rewrite the notes. To copy the text, combine the book with text together with a book (without text) in the crafting grid."),
	["default:sign_wall_wood"] = signuse,
	["default:sign_wall_steel"] = signuse,
	["default:bookshelf"] = S("Right-click to open the bookshelf. You can only store books and other items belonging to the @1 group into the bookshelf. To collect the bookshelf, you must make sure it does not contain anything.", groupname_book),
	["default:blueberry_bush_leaves_with_berries"] = S("Punch it to obtain the blueberries."),
	["vessels:shelf"] = S("Right-click to open the vessels shelf. You can only store items which belong to the @1 group (glass bottle, drinking glass, heavy steel bottle). To collect the vessels shelf, it must be empty.", groupname_vessel),
	["bucket:bucket_empty"] = S("Punch a liquid source to collect the liquid. With the filled bucket, you can right-click somewhere to empty the bucket which will create a liquid source at the position you've clicked at."),
	["bucket:bucket_water"] = S("Right-click on any block to empty the bucket and put a water source on this spot."),
	["bucket:bucket_river_water"] = S("Right-click on any block to empty the bucket and put a river water source on this spot."),
	["bucket:bucket_lava"] = S("Choose a place where you want to empty the bucket, then get in a safe spot somewhere above it. Be prepared to run away when something goes wrong as the lava will soon start to flow after placing. To empty the bucket (which places a lava source), right-click on your chosen place."),

	["bones:bones"] = S("Point to the bones to see to whom they belong to. If nothing is displayed, they belong to nobody and are empty; they behave any other block in this case. Otherwise, right-click on the bones to access the inventory, punch it to obtain all items and the bones immediately, or at least as many items as you can carry. ") .. bonesstring .. bonesstring2 .. S(" It is only possible to take from this inventory, nothing can be stored into it."),

	["tnt:gunpowder"] = S("Place gunpowder on the ground to create gunpowder trails. Punch it with a torch or a flint and steel to light the gunpowder. Gunpowder is also ignited by igniter blocks (like fire or lava). Lit gunpowder will ignite all neighbor (including diagonals) gunpowder tiles and TNTs."),
	["tnt:tnt"] = S("Place the TNT on the ground and punch it with a torch or a flint and steel to light it and quickly get in a safe distance before it explodes. Nearby burning gunpowder trails and igniter blocks will also ignite the TNT."),

	["doors:trapdoor"] = S("Right-click the trapdoor to open or close it."),
	["doors:trapdoor_steel"] = S("Point the steel trapdoor to see who owns it. Right-click it to open or close it (if you own it)."),

	["doors:door_wood"] = S("Right-click the door to open or close it."),
	["doors:door_steel"] = S("Point the door to see who owns it. Right-click the door to open or close it (if you own it)."),
	["doors:door_glass"] = S("Right-click the door to open or close it."),
	["doors:door_obsidian_glass"] = S("Right-click the door to open or close it."),

	["screwdriver:screwdriver"] = S("Left-click on a block to rotate it around its current axis. Right-click on a block to rotate its axis. Note that not all blocks can be rotated."),

	["boats:boat"] = S("Place the boat on water (any block belonging to the @1 group) to set it up. Right-click the boat to enter it. When you are on the boat, use the forward key to speed up, the backward key to slow down and the left and right keys to turn the boat. Right-click on the boat again to leave it. Left-click the placed boat to collect it.", groupname_water),
	["carts:cart"] =
		S("You can place the cart on rails. Right-click it to enter it. Punch the cart to get it moving.") .. "\n" ..
		S("When you sit inside, you can control the cart: Hold [Down] to slow down. Hold down [Left] or [Right] to turn the cart at crossings and T-junctions.") .. "\n" ..
		S("To transport items, just drop them inside and punch the cart. To obtain the cart and the items, punch it while holding down the sneak key."),

	["default:rail"] = railuse,
	["carts:powerrail"] = railuse,
	["carts:brakerail"] = railuse,

	["beds:bed_bottom"] = beduse,
	["beds:fancy_bed_bottom"] = beduse,
	["farming:seed_wheat"] = S("Place the wheat seed on soil or wet soil. Use a hoe to create soil. The plant will only grow in sunlight and as long as the soil is wet. Watch the wheat plant grow and mine it at its full size."),
	["farming:seed_cotton"] = S("Place the cotton seed on soil, wet soil, desert sand soil or wet desert sand soil. Use a hoe to create soil. The plant will only grow in sunlight and as long as the soil is wet. Watch the cotton plant grow and mine it at its full size."),
	["fire:flint_and_steel"] = S("Punch with it on the surface of a block to attempt to ignite it. This creates a basic flame in front of flammable blocks. When used on a coal block, a permanent flame is created on top of it. TNT and gunpowder get ignited. On other non-flammable blocks, this tool generally has no effect."),

	["flowers:waterlily"] = S("Waterlilies can only be placed on water sources (and other members of the @1 group).", groupname_water),
	["farming:hoe_wood"] = hoeuse,
	["farming:hoe_stone"] = hoeuse,
	["farming:hoe_steel"] = hoeuse,
	["farming:hoe_bronze"] = hoeuse,
	["farming:hoe_mese"] = hoeuse,
	["farming:hoe_diamond"] = hoeuse,

	["default:key"] = S("Wield the key and right-click on a locked thing to attempt to access it. If the key fits, you perform the action (e.g. you open a door). If it doesn't fit, the key does nothing."),
	["default:skeleton_key"] = S("Go to the locked thing you own to match the key for. Punch it to turn the skeleton key into a key and permanently match it to the locked thing. Any player who possesses this key can now access the locked thing you have selected—but only this! Note that you don't need keys for the things you own. If the locked thing has been removed, the key will stop working."),

	["stairs:slab_cobble"] = slabuse .. "\n" .. S("A cobblestone slab will slowly turn into a mossy cobblestone slab when it is near water (or any other block in the @1 group).", groupname_water),
	["stairs:slab_mossycobble"] = slabuse .. "\n" .. S("A mossy cobblestone slab is created when a cobblestone slab is near water (or any other block in the @1 group) for a while.", groupname_water),

	["binoculars:binoculars"] = S("Before you can zoom, this item must be activated. To activate it, hold it in your hand, then use the attack key. Now you can zoom with the zoom key (Z by default) until you lose this item. Alternatively, the binoculars get activated ca. 5 seconds after putting them into your inventory."),
	["map:mapping_kit"] = S("Before you can use the minimap, this item must be activated. To activate it, hold it in your hand, then use the attack key. Now you can cycle through the minimap modes (surface mode only) with the minimap key (F9 by default) until you lose this item. Alternatively, the mapping kit is activated automatically ca. 5 seconds after putting them into your inventory."),
	["fireflies:bug_net"] = S("Point an insect and use the attack key to try to capture it."),
	["fireflies:firefly_bottle"] = S("Rightclick the bottle to release the firefly."),
}

local export_uses = {
	-- CHECKME: Use count
	["farming:hoe_wood"] = 30,
	["farming:hoe_stone"] = 90,
	["farming:hoe_steel"] = 200,
	["farming:hoe_bronze"] = 220,
	["farming:hoe_mese"] = 350,
	["farming:hoe_diamond"] = 500,
	["screwdriver:screwdriver"] = 200,
	["fire:flint_and_steel"] = 66,
}

-- Stair/slab help texts
local stairslab_materials = {
	"wood",
	"junglewood",
	"pine_wood",
	"acacia_wood",
	"aspen_wood",
	"stone",
	"stone_block",
	"cobble",
	"mossycobble",
	"desert_cobble",
	"desert_stone",
	"desert_stone_block",
	"stonebrick",
	"sandstone",
	"sandstonebrick",
	"sandstone_block",
	"desert_sandstone",
	"desert_sandstone_block",
	"desert_sandstone_brick",
	"silver_sandstone",
	"silver_sandstone_block",
	"silver_sandstone_brick",
	"ice",
	"snowblock",
	"desert_stonebrick",
	"obsidian",
	"obsidianbrick",
	"obsidian_block",
	"brick",
	"straw",
	"steelblock",
	"tinblock",
	"copperblock",
	"bronzeblock",
	"goldblock",
	"glass",
	"obsidian_glass",
}
for m=1, #stairslab_materials do
	local mat = stairslab_materials[m]
	local stair = "stairs:stair_"..mat
	local stair_inner = "stairs:stair_inner_"..mat
	local stair_outer = "stairs:stair_outer_"..mat
	local slab = "stairs:slab_"..mat
	if not export_longdesc[stair] then
		export_longdesc[stair] = stairdesc
	end
	if not export_longdesc[stair_inner] then
		export_longdesc[stair_inner] = innerstairdesc
	end
	if not export_longdesc[stair_outer] then
		export_longdesc[stair_outer] = outerstairdesc
	end
	if not export_longdesc[slab] then
		export_longdesc[slab] = slabdesc
	end

	if not export_usagehelp[stair] then
		export_usagehelp[stair] = stairuse
	end
	if not export_usagehelp[stair_inner] then
		export_usagehelp[stair_inner] = stairuse
	end
	if not export_usagehelp[stair_outer] then
		export_usagehelp[stair_outer] = stairuse
	end
	if not export_usagehelp[slab] then
		export_usagehelp[slab] = slabuse
	end
end

for itemstring, longdesc in pairs(export_longdesc) do
	if minetest.registered_items[itemstring] ~= nil then
		minetest.override_item(itemstring, { _doc_items_longdesc = longdesc } )
	end
end
for itemstring, usagehelp in pairs(export_usagehelp) do
	if minetest.registered_items[itemstring] ~= nil then
		minetest.override_item(itemstring, { _doc_items_usagehelp = usagehelp} )
	end
end
for itemstring, uses in pairs(export_uses) do
	if minetest.registered_items[itemstring] ~= nil then
		minetest.override_item(itemstring, { _doc_items_durability = uses } )
	end
end

if minetest.get_modpath("doc_basics") then
	doc.add_entry("advanced", "creative", {
		name = S("Creative Mode"),
		data = { text =
S([=[Enabling Creative Mode in Minetest Game applies the following changes:

• You keep the things you've placed
• Creative inventory is available to obtain most items easily
• Hand breaks all default blocks
• Greatly reduced hand digging time
• Greatly increased hand damage
• Increased pointing range of hand
• Tools don't wear off
• You can always zoom and use the minimap
• When you die, you keep your items and no bones appear]=])
	}})
end

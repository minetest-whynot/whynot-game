
-- mod check and sound settings

local def = core.get_modpath("default")
local mcl = core.get_modpath("mcl_core")
local snd = mcl and mcl_sounds.node_sound_glass_defaults() or default.node_sound_glass_defaults()

-- PB&J Pup node

core.register_node("pbj_pup:pbj_pup", {
	description = "PB&J Pup",
	tiles = {
		"pbj_pup_sides.png", "pbj_pup_jelly.png", "pbj_pup_sides.png",
		"pbj_pup_sides.png", "pbj_pup_back.png", "pbj_pup_front.png"
	},
	paramtype = "light",
	light_source = 15,
	paramtype2 = "facedir",
	groups = {cracky = 2, handy = 1},
	is_ground_content = false,
	sounds = snd,
	_mcl_hardness = 1,
})

-- Nyan Cat node

core.register_node(":nyancat:nyancat", {
	description = "Nyan Cat",
	tiles = {
		"nyancat_side.png", "nyancat_side.png", "nyancat_side.png",
		"nyancat_side.png", "nyancat_back.png", "nyancat_front.png"
	},
	paramtype = "light",
	light_source = 15,
	paramtype2 = "facedir",
	groups = {cracky = 2, handy = 1},
	is_ground_content = false,
	sounds = snd,
	_mcl_hardness = 1,
})

-- MooGNU node

core.register_node(":moognu:moognu", {
	description = "MooGNU",
	tiles = {
		"moognu_side.png", "moognu_side.png", "moognu_side.png",
		"moognu_side.png", "moognu_back.png", "moognu_front.png"
	},
	paramtype = "light",
	light_source = 15,
	paramtype2 = "facedir",
	groups = {cracky = 2, handy = 1},
	is_ground_content = false,
	sounds = snd,
	_mcl_hardness = 1,
})

-- Rainbow node

core.register_node(":nyancat:nyancat_rainbow", {
	description = "Rainbow",
	tiles = {
		"nyancat_rainbow.png^[transformR90",
		"nyancat_rainbow.png^[transformR90",
		"nyancat_rainbow.png"
	},
	paramtype = "light",
	light_source = 15,
	paramtype2 = "facedir",
	groups = {cracky = 2, handy = 1},
	is_ground_content = false,
	sounds = snd,
	_mcl_hardness = 1,
})

-- Fuels

core.register_craft({
	type = "fuel",
	recipe = "pbj_pup:pbj_pup",
	burntime = 10
})

core.register_craft({
	type = "fuel",
	recipe = "nyancat:nyancat",
	burntime = 10
})

core.register_craft({
	type = "fuel",
	recipe = "moognu:moognu",
	burntime = 10
})

core.register_craft({
	type = "fuel",
	recipe = "nyancat:nyancat_rainbow",
	burntime = 10
})

-- helper function to place Nyan/Pup/Moo with rainbow tail

local types = {"pbj_pup:pbj_pup", "nyancat:nyancat", "moognu:moognu"}

local function place(pos, facedir, length)

	if facedir > 3 then facedir = 0 end

	local tailvec = core.facedir_to_dir(facedir)
	local p = {x = pos.x, y = pos.y, z = pos.z}
	local num = math.random(#types)

	core.swap_node(p, {name = types[num], param2 = facedir})

	for i = 1, length do

		p.x = p.x + tailvec.x
		p.z = p.z + tailvec.z

		core.swap_node(p, {name = "nyancat:nyancat_rainbow", param2 = facedir})
	end
end

-- Do we generate PB&J Pup and Nyan Cat's in world?

if core.settings:get_bool("pbj_pup_generate") ~= false then

	local function generate(minp, maxp, seed)

		local height_min = -31000
		local height_max = -32
		local chance = 1000

		if maxp.y < height_min or minp.y > height_max then return end

		local y_min = math.max(minp.y, height_min)
		local y_max = math.min(maxp.y, height_max)
		local pr = PseudoRandom(seed + 9324342)

		if pr:next(0, chance) == 0 then

			local x0 = pr:next(minp.x, maxp.x)
			local y0 = pr:next(minp.y, maxp.y)
			local z0 = pr:next(minp.z, maxp.z)
			local p0 = {x = x0, y = y0, z = z0}

			place(p0, pr:next(0, 3), pr:next(3, 15))
		end
	end

	core.register_on_generated(generate)

	if def then default.generate_nyancats = generate end --Legacy
end

-- Legacy

core.register_alias("default:nyancat", "nyancat:nyancat")
core.register_alias("default:nyancat_rainbow", "nyancat:nyancat_rainbow")
core.register_alias("pbj_pup:pbj_pup_candies", "nyancat:nyancat_rainbow")

if def then default.make_nyancat = place end

print("[MOD] PB&J Pup loaded")

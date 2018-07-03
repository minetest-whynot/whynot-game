
minetest.register_node("pbj_pup:pbj_pup", {
	description = "PB&J Pup",
	tiles = {
		"pbj_pup_sides.png",
		"pbj_pup_jelly.png",
		"pbj_pup_sides.png",
		"pbj_pup_sides.png",
		"pbj_pup_back.png",
		"pbj_pup_front.png"
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX,
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	legacy_facedir_simple = true,
	sounds = default.node_sound_defaults(),
})

minetest.register_craft({
	type = "fuel",
	recipe = "pbj_pup:pbj_pup",
	burntime = 1,
})

minetest.register_node(":nyancat:nyancat", {
	description = "Nyan Cat",
	tiles = {
		"nyancat_side.png",
		"nyancat_side.png",
		"nyancat_side.png",
		"nyancat_side.png",
		"nyancat_back.png",
		"nyancat_front.png"
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX,
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	legacy_facedir_simple = true,
	sounds = default.node_sound_defaults(),
})

minetest.register_craft({
	type = "fuel",
	recipe = "nyancat:nyancat",
	burntime = 1,
})

minetest.register_node(":nyancat:nyancat_rainbow", {
	description = "Rainbow",
	tiles = {
		"nyancat_rainbow.png^[transformR90",
		"nyancat_rainbow.png^[transformR90",
		"nyancat_rainbow.png"
	},
	paramtype = "light",
	light_source = default.LIGHT_MAX,
	paramtype2 = "facedir",
	groups = {cracky = 2},
	is_ground_content = false,
	sounds = default.node_sound_defaults(),
})

minetest.register_craft({
	type = "fuel",
	recipe = "nyancat:nyancat_rainbow",
	burntime = 1,
})

-- Place Nyan or Pup with Rainbow
local function place(pos, facedir, length)

	if facedir > 3 then
		facedir = 0
	end

	local tailvec = minetest.facedir_to_dir(facedir)
	local p = {x = pos.x, y = pos.y, z = pos.z}

	if math.random(1, 2) == 1 then
		minetest.set_node(p, {name = "pbj_pup:pbj_pup", param2 = facedir})
	else
		minetest.set_node(p, {name = "nyancat:nyancat", param2 = facedir})
	end

	for i = 1, length do
		p.x = p.x + tailvec.x
		p.z = p.z + tailvec.z
		minetest.set_node(p, {name = "nyancat:nyancat_rainbow", param2 = facedir})
	end
end

-- Do we generate PB&J Pup and Nyan Cat's in world?
if minetest.settings:get_bool("pbj_pup_generate") ~= false then

	local function generate(minp, maxp, seed)

		local height_min = -31000
		local height_max = -32
		local chance = 1000

		if maxp.y < height_min or minp.y > height_max then
			return
		end

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

	minetest.register_on_generated(generate)

	default.generate_nyancats = generate --Legacy
end

-- Legacy
minetest.register_alias("default:nyancat", "nyancat:nyancat")
minetest.register_alias("default:nyancat_rainbow", "nyancat:nyancat_rainbow")
minetest.register_alias("pbj_pup:pbj_pup_candies", "nyancat:nyancat_rainbow")
minetest.register_alias("nyancat", "nyancat:nyancat")
minetest.register_alias("nyancat_rainbow", "nyancat:nyancat_rainbow")
default.make_nyancat = place

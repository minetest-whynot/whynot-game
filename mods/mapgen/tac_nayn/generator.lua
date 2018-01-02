
-- facedir: 0/1/2/3 (head node facedir value)
-- length: length of rainbow tail
function tac_nayn.make_tacnayn(pos, facedir, length)
	local tailvec = {x=0, y=0, z=0}
	if facedir == 0 then
		tailvec.z = 1
	elseif facedir == 1 then
		tailvec.x = 1
	elseif facedir == 2 then
		tailvec.z = -1
	elseif facedir == 3 then
		tailvec.x = -1
	else
		--print("tac_nayn.make_tacnayn(): Invalid facedir: "+dump(facedir))
		facedir = 0
		tailvec.z = 1
	end
	local p = {x=pos.x, y=pos.y, z=pos.z}
	minetest.set_node(p, {name="tac_nayn:tacnayn", param2=facedir})
	for i=1,length do
		p.x = p.x + tailvec.x
		p.z = p.z + tailvec.z
		minetest.set_node(p, {name="tac_nayn:tacnayn_rainbow", param2=facedir})
	end
end
                         
local function generate_tacnayns(seed, minp, maxp)
	local height_min = -31000
	local height_max = -32
	if maxp.y < height_min or minp.y > height_max then
		return
	end
	local y_min = math.max(minp.y, height_min)
	local y_max = math.min(maxp.y, height_max)
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed + 9324342)
	local max_num_tacnayns = math.floor(volume / (16*16*16))
	for i=1,max_num_tacnayns do
		if pr:next(0, 1000) == 0 then
			local x0 = pr:next(minp.x, maxp.x)
			local y0 = pr:next(minp.y, maxp.y)
			local z0 = pr:next(minp.z, maxp.z)
			local p0 = {x=x0, y=y0, z=z0}
			tac_nayn.make_tacnayn(p0, pr:next(0,3), pr:next(3,15))
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	-- Generate tac nayns
	generate_tacnayns(seed, minp, maxp)
end)

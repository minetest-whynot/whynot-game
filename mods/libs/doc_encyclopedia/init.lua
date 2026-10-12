local S = minetest.get_translator("doc_encyclopedia")

minetest.register_craftitem("doc_encyclopedia:encyclopedia", {
	description = S("Encyclopedia"),
	_doc_items_longdesc = S("Allows you to access the help."),
	_doc_items_usagehelp = S("Use the punch key to access the help."),
	_doc_items_hidden = false,
	stack_max = 1,
	inventory_image = "doc_encyclopedia_encyclopedia.png",
	wield_image = "doc_encyclopedia_encyclopedia.png",
	wield_scale = { x=1, y=1, z=2.25 },
	on_use = function(itemstack, user)
		doc.show_doc(user:get_player_name())
	end,
	groups = { book=1 },
})

minetest.register_craft({
	output = "doc_encyclopedia:encyclopedia",
	recipe = {
		{"group:stick", "group:stick", ""},
		{"group:stick", "", "group:stick"},
		{"group:stick", "group:stick", ""},
	}
})

-- Bonus recipe for Minetest Game
if minetest.get_modpath("default") then
	minetest.register_craft({
		output = "doc_encyclopedia:encyclopedia",
		recipe = {
			{ "default:book" },
			{ "default:book" },
			{ "default:book" },
		}
	})
end

minetest.register_craft({
	type = "fuel",
	recipe = "doc_encyclopedia:encyclopedia",
	burntime = 6,
})

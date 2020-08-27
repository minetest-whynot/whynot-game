local maininv = dofile(minetest.get_modpath(minetest.get_current_modname()).."/maininv.lua")


sfinv_buttons.register_button('compress', {
	image = "smart_sfinv_tweaks_compress_button.png",
	tooltip = "Compress stacks",
	position = 7,
	action = function(player)
		maininv.get(player):compress()
	end,
	show = function(player, context, content, show_inv)
		return show_inv
	end
})

sfinv_buttons.register_button('rotate', {
	image = "smart_sfinv_tweaks_rotate.png",
	tooltip = "Rotate inventory rows",
	position = 7,
	action = function(player)
		maininv.get(player):rotate_rows()
	end,
	show = function(player, context, content, show_inv)
		return show_inv
	end
})

local crafting_enhance = 'image_button[0.5,1.6;0.8,0.8;smart_sfinv_tweaks_sweep_button.png;sfinv_tweaks_sweep;]' ..
		'tooltip[sfinv_tweaks_sweep;Sweep crafting area]'

smart_sfinv_api.register_enhancement({
	make_formspec = function(handler, player, context, content, show_inv)
		if context.page == "sfinv:crafting" then
			handler.formspec_after_navfs = handler.formspec_after_navfs..crafting_enhance
		end
	end,
	receive_fields = function(handler, player, context, fields)
		if fields.sfinv_tweaks_sweep then
			context.tweaks_inv = context.tweaks_inv or maininv.get(player)
			context.tweaks_inv:sweep_crafting_inventory()
		end
	end
})


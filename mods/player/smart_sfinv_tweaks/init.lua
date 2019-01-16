local maininv = dofile(minetest.get_modpath(minetest.get_current_modname()).."/maininv.lua")

smart_sfinv_api.defaults.theme_inv = smart_sfinv_api.defaults.theme_inv ..
		'image_button[0.1,3.97;0.8,0.8;smart_sfinv_tweaks_compress_button.png;sfinv_tweaks_compress;]' ..
		'tooltip[sfinv_tweaks_compress;Compress stacks]'..
		'image_button[1.1,3.97;0.8,0.8;smart_sfinv_tweaks_rotate.png;sfinv_tweaks_rotate;]' ..
		'tooltip[sfinv_tweaks_rotate;Rotate rows]'


local crafting_enhance = 'image_button[0.5,1.6;0.8,0.8;smart_sfinv_tweaks_sweep_button.png;sfinv_tweaks_sweep;]' ..
		'tooltip[sfinv_tweaks_sweep;Sweep crafting area]'

smart_sfinv_api.register_enhancement({
	make_formspec = function(handler, player, context, content, show_inv)
		if context.page == "sfinv:crafting" then
			handler.formspec_after_navfs = handler.formspec_after_navfs..crafting_enhance
		end
	end,
	receive_fields = function(handler, player, context, fields)
		if fields.sfinv_tweaks_compress then
			context.tweaks_inv = context.tweaks_inv or maininv.get(player)
			context.tweaks_inv:compress()
		end
		if fields.sfinv_tweaks_rotate then
			context.tweaks_inv = context.tweaks_inv or maininv.get(player)
			context.tweaks_inv:rotate_rows()
		end
		if fields.sfinv_tweaks_sweep then
			context.tweaks_inv = context.tweaks_inv or maininv.get(player)
			context.tweaks_inv:sweep_crafting_inventory()
		end
	end
})


if minetest.global_exists("multiskin_model") then
	player_api.read_textures_and_meta(function(filename, skin)
		if not skin.format then
			local file = io.open(filename, "r")
			skin.format = multiskin_model.get_skin_format(file)
			file:close()
		end
	end)
else
	player_api.read_textures_and_meta()
end

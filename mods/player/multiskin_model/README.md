# Minetest multiskin_model mod

Replace the default model by extended one in minetest game trough player_api.

The model does support Skins-Format 1.0 and 1.8. 
To get the 1.8er skins working the skins needs to have the format attribute set to "1.8".
To check the format before skin registration the provided function can be used:
```
	local file = io.open(modpath.."/textures/"..filename, "r")
	skin.format = multiskin_model.get_skin_format(file)
	file:close()
```

The model does support additional skin modifiers also
```
player_api.register_skin_modifier(function(textures, player, player_model, player_skin)
	textures.cape = "cape.png"
	textures.clothing = "clothing.png"
	textures.armor    = "armor.png"
	textures.wielditem = "wielded_item.png"
end
```

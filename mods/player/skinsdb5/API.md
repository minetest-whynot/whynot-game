# Skinsdb Interface

## skinsdb5.read_textures_and_meta()
Read the textures folder and register all files found as skins. Include corresponding metadata from meta folder
- Use the same functionaltiy as in skinsdb5 for other mods providing skins

## skinsdb5.get_skinlist_for_player(playername)
Get all allowed skins for player. All public and all player's private skins. If playername not given only public skins returned

## skinsdb5.get_skinlist_with_meta(key, value)
Get all skins with metadata key is set to value. Example:
skinsdb5.get_skinlist_with_meta("playername", playername) - Get all private skins (w.o. public) for playername

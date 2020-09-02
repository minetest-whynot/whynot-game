# Mod place_your_skins_here

This mod allow to register own player skin textures for player_api based skinning system.
So you do not need to guess which mod should take up your skins, just use this one!

Place your skin textures to the textures subfolder of this mod.

Supported names are
- character_<skinname>.png  - Visible for all users
- player_<playername>_<skinname>.png Visible only for user <playername>

For additional skins informations the "meta" subfolder can be used. 
The Metadata file needs to be named like the .png file but with .txt suffix, character_1.txt for character_1.png for example.

The file syntax is for example

skinname = "Alex",
author = "bell07",
license = "CC-BY-SA 4.0",

For file content see player_api/skin_api.txt for reference.

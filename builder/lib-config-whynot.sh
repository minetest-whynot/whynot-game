  #
  # Modify as needed
  # ================
  # Associative list of repositories that point to non-default branch
  #
  declare -Ag BRANCHES=(
    [minetest_game/minetest_game]=origin/stable-5 # Stay on stable version
    [flora_ores/farming]=0b06c7cd450c5ec9a76b3c22a9c57f06e4f8a7c2 # freeze due to incompatibility with milk buckets
    [player/3d_armor]=e1a262ba20e4bf0a1046ca06d83953ae0983f621 # freeze due to 3d_armor mod split for each armor type
  )

  #
  # Modify as needed
  # ================
  # Associative list of modpacks with excluded modules
  #
  declare -Ag EXCLUDED=(
    [minetest_game/minetest_game]='--exclude=farming --exclude=env_sounds --exclude=mtg_craftguide'
    [player/3d_armor]='--exclude=3d_armor_ip --exclude=3d_armor_ui'
    [mesecons/mesecons]='--exclude=mesecons_lucacontroller --exclude=mesecons_commandblock --exclude=mesecons_detector --exclude=mesecons_fpga --exclude=mesecons_gates --exclude=mesecons_hydroturbine --exclude=mesecons_luacontroller --exclude=mesecons_microcontroller --exclude=mesecons_stickyblocks'
    [tools/flight]='--exclude=jetpack --exclude=wings'
    [decor/homedecor_modpack]='--exclude=itemframes --exclude=homedecor_3d_extras --exclude=homedecor_inbox'
    [decor/home_workshop_modpack]='--exclude=computers --exclude=home_workshop_machines'
    [decor/mydoors]='--exclude=my_garage_door --exclude=my_saloon_doors --exclude=my_sliding_doors'
  )
  #
  # Modify as needed
  # ================
  # Associative list of repositories that point to non-default branch
  #
  declare -Ag BRANCHES=(
    [minetest_game/minetest_game]=origin/stable-5 # Stay on stable version
    [flora_ores/farming]=0b06c7cd450c5ec9a76b3c22a9c57f06e4f8a7c2 # freeze due to incompatibility with milk buckets
    [decor/basic_materials]=1009295ee68c490e388302d0600f293685226b67 # freeze until addition of xcompat
    [decor/home_workshop_modpack]=4b5e58331c8ecf6d6f1f23b5e8b8b167dc772069 # freeze until addition of xcompat
    [decor/homedecor_modpack]=52f7c54702c58bccec2877cb67dbcfa87cd83ace # freeze until addition of xcompat
    [libs/sound_api]=d13501cc10059149cde3c266df7e623556e9a5ef # freeze until addition of xcompat
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

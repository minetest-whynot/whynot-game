# Development and Maintenance

Builder scripts allow you to generate and update the game from source mods.

## Let's start - Clone the repository

```
git clone --recurse-submodules https://github.com/minetest-whynot/whynot-game
```

## Update using build-mods.sh

```
git pull --recurse-submodules
```

Check if any included mod is not in last version

```
./builder/check-updates.sh
```

All mods sources are stored in `builder/mods_src` folder, connected as submodules. You can now update the whynot game

```
./builder/build-mods.sh
```

## Update using update_mod.sh

If you wish to commit changes to the git repository, it may be more convenient to use the following :

```
./builder/update_mods.sh
```

This will go through each mods and prompt you to decide if you wish to view the changes (diff), merge them, and commit them.
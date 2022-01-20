# Builder scripts allow you to generate and update the game from source mods.


# Let's start - Clone the repository
git clone --recurse-submodules https://github.com/minetest-whynot/whynot-game

## If already cloned, update all mods
git pull --recurse-submodules

# Check if any included mod is not in last version
./builder/check-updates.sh

All mods sources are stored in `builder/mods_src` folder, connected as submodules

# Build / Update the whynot game
./builder/build-mods.sh

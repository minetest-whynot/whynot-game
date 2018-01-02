# Dice v1.3
## Description
This Minetest mod adds a red and a white dice to the game, each in form of
a full placable block. The dice can also be rolled with a nice dice rolling sound.

## Crafting
### Basic crafting
To craft a dice, you have to place *any* kind of wood like this:

    w.w
    .w.
    w.w

* `w` = any kind of wood (group "wood")
* `.` = nothing

The result is 5 white dice.

### Coloring
If you use Minetest Game or a similar subgame which has a mod called “dye”,
the following additional shapeless recipes are available:

* 1 white dice: 1 red dice, 1 white dye and 1 black dye
* 1 red dice: 1 white dice, 1 red dye and 1 white dye

## How to use
If you place a dice, it will face a random direction and turned randomly.

You can mine dice in half a second without any tool, but it can be faster
with “choppy” tools (e.g. axes).

To roll the dice, press the use key (right click) while pointing to it. So you
don’t have to mine and place it again.
If you don’t want to throw the dice but want to build something to it, you have
to rightclick it while you hold the sneak key (usually Shift). 

Careful: The dice are flammable!

## License
This mod is free software and released under the MIT License.

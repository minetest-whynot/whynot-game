# playeranim

Makes the head, and the right arm when you're mining, face the way you're facing, similar to Minecraft. Compatible with [3d_armor](https://github.com/stujones11/minetest-3d_armor). This is an ugly hack. Forked from [Kaeza's animplus mod](https://github.com/kaeza/minetest-animplus).

The head only turns up and down relative to the body, except it turns slightly to the right/left when you strafe right/left. When you turn the body turns with the head.  
Works in both singleplayer and multiplayer.

Created by [Rui](https://github.com/Rui-Minetest), this document was written by [sloantothebone](https://github.com/sloantothebone).

## Configuration

### Version of player model

Player models supported by this mod:
- minetest_game after 4 Jun 2017, Minetest 0.4.16
- minetest_game after 4 Nov 2017, Minetest 0.5.0-dev

### The delay of sideways body rotation

Configure `playeranim.body_rotation_delay`.
It's the number of frame delay of sideways body rotation.  
The default value is `7`.

### Lengthways body rotation in sneaking

Configure `playeranim.body_x_rotation_sneak`.
It's the degrees of the body's X-axis rotation in sneaking.  
The default value is `6.0`.

### The speed of an animation

Configure `playeranim.animation_speed`.
It's the number of stepping per seconds.  
The default value is `2.4`.

### The speed of an animation in sneaking

Configure `playeranim.animation_speed_sneak`.
It's the number of stepping per seconds in sneaking.  
The default value is `0.8`.

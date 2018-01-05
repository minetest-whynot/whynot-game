Hovercraft for Minetest [hovercraft]
====================================

A fun alternative mode of transport for Minetest.

Controls
========
	
	Forward (W)	Thrust
	Jump (Space)	Jump
	Mouse Move	Rotate
	Sneak (Shift)	Sit (only visible in multiplayer)

Know Issues
===========

'Bouncing' into thin air: This can simply be the result of server lag,
even in singleplayer mode, the client and server can get out of sync.
Solution, be patient, allow the environment to fully load before preceding.

Problems with bouncing in air and generally getting stuck, being pulled
underwater and all manner of other weirdness can also be caused by a rather
nasty entity duplication bug in minetest itself. The only solution here is
to track down and remove any duplicate entities or by running /clearobjects

Entity Duplication: See above. This usually occurs when you move a given
distance from where the entity was originally placed. The only solution
right now is to restrict the hovercraft to a certain area. For example,
create a sunken race track the hovercraft cannot physically escape from.

Minetest 5.4 mod: Hydroplane - Super Duck
========================================

The Super Duck

This one tries to implement some flight, using the mobkit mod.
In order to fly, it is necessary to first supply the airplane with biofuel.
Then with a bottle or gallon selected, punch it against the airplane floater.
You can use 10 bottles them to fill the tank. See the fuel gauge on the airplane
panel (right below, with a green F). To embark, click with the right button.
While the machine is off, it is possible to move it using the sneak and jump keys (shift an space).
W ans S controls the pitch (elevator).
Right and Left (A and D) controls the yaw (rudder and ailerons).

Then to fly, start the engine with the special key E. Press jump (space)
to increase the engine power (check the panel for the indicator marked with a yellow P).
Adjust to the maximum. Pull the elevator control (S) when it have the speed to lift.

During the cruise flight, it is ideal to keep the power setting below the red range,
to control fuel consumption. Use the climb indicator to stabilize altitude,
as at high altitudes you lose sustentation and you spend more fuel. 

For landing, just lower the power and stabilize the airplane. Pay attention at air speed
indicator, keeping it at green range, otherwise you will stall.

Care must be taken with impacts, as it causes damage to the aircraft and the pilot, 
so training landings is essential. 

To brake the aircraft, use the sneak (shift) key until it comes to a complete stop.
Do not stop the engine before this, or it will reverse when it stops 

To repair damages, you can use the repair tool. It subtracts steel ingots to increase
airplane hp.

It can be painted using dye of any color you want, you must punch the airplane with the dye.

Biofuel mod can be found here: https://github.com/APercy/minetest_biofuel

The limitations: because the lack in functions to roll the camera, and the rudder acting together the ailerons,
the airplane is unable to do a tuneau, barrel roll, loopings and any kind of aerobatics maneuvers. 
It was limited at the source. You can modify it by your own, just making the roll movement cumulative and increasing the speeds

**Controls overview:**
* Right click: enter in/get off plane
* Left click (with biofuel): add fuel to plane
* Right click and Sneak: enter in flight instructor mode (limited vision, so use debug info)
* E: Start engine
* Jump: Increase power, forward on ground
* Sneak: Decrease power, brake on ground
* Backward: go up flying - nose up
* Forward: go down flying - nose down
* Left/right: Turn to left/right, work on and out ground.
* Left and Right together: center all commands
* Sneak and Jump together: give/take the controls to/from pilot student
* Up and Down together: enable/disable HUD

**Chat Commands: **

/hydro_eject - ejects from the vehicle

/hydro_manual - shows the manual

-----------------------
License of source code:
LGPL v3 (see file LICENSE) 

License of media (textures and sounds):
CC0



Under Sky
=========

Minetest mod by Shara RedCat which adds a black skybox to prevent the default skybox (and sun/clouds) showing through the walls of caves which have not fully loaded. This improves atmosphere and makes caves as dark as caves should be.

Checks are in place so players using noclip underground to gain an overview of cave systems will not experience the black skybox.


Settings
--------

If you wish to change the height below which the black skybox appears, add "sky_start = x" to minetest.conf, where x is the desired height.

If using this mod on a server, you may also wish to adjust the timer on line 28 to a higher value (for example 5 instead of 2), so that checks are less frequent and performance is improved. 


Licenses and Attribution 
-----------------------

This mod is released under MIT (https://opensource.org/licenses/MIT). 

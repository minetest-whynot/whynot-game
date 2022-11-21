dofile(minetest.get_modpath("hidroplane") .. DIR_DELIM .. "hidroplane_global_definitions.lua")

--------------
-- Manual --
--------------

function hidroplane.manual_formspec(name)
    local basic_form = table.concat({
        "formspec_version[3]",
        "size[16,10]",
        "background[-0.7,-0.5;17.5,11.5;hidroplane_manual_bg.png]"
	}, "")

	basic_form = basic_form.."button[1.75,1.5;4,1;short;Shortcuts]"
	basic_form = basic_form.."button[1.75,3.5;4,1;panel;Panel]"
	basic_form = basic_form.."button[1.75,5.5;4,1;fuel;Refueling]"
	basic_form = basic_form.."button[1.75,7.5;4,1;op;Operation]"
	basic_form = basic_form.."button[10.25,1.5;4,1;paint;Painting]"
	basic_form = basic_form.."button[10.25,3.5;4,1;tips;Tips]"

    minetest.show_formspec(name, "hidroplane:manual_main", basic_form)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname == "hidroplane:manual_main" then
		if fields.short then
			local text = {
				"Shortcuts \n\n",
                "* Right click: enter in/get off plane \n",
                "* Left click (with biofuel): add fuel to plane \n",
                "* Right click and Sneak: enter in flight instructor mode \n",
                "      (limited vision, so use external camera) \n",
                "* E (aux1): Start/stop engine \n",
                "* Jump: Increase power, forward on ground \n",
                "* Sneak: Decrease power, brake on ground \n",
                "* Backward: go up flying - nose up \n",
                "* Forward: go down flying - nose down \n",
                "* Left/right: Turn to left/right, work on and out ground. \n",
                "* Left and Right together: center all commands \n",
                "* Sneak and Jump together (normal): activates the autopilot \n",
                "* Sneak and Jump together (instruction mode): give/take the \n",
                "      controls to/from pilot student \n",
                "* Up and Down together: enable/disable HUD \n",
                "* E and Right click: inventory (only external) \n"
			}
			local shortcut_form = table.concat({
				"formspec_version[3]",
				"size[16,10]",
				"background[-0.7,-0.5;17.5,11.5;hidroplane_manual_bg.png]",
				"image[0.5,3.75;6,6;hidroplane_manual_up_view.png]",
				"label[9.25,0.5;", table.concat(text, ""), "]",
			}, "")
			minetest.show_formspec(player:get_player_name(), "hidroplane:manual_shortcut", shortcut_form)
		end
		if fields.panel then
			local text = {
				"The Panel \n\n",
				"In front of the pilot is the instrument panel. \n",
				"It's used to obtain important flight information, namely: \n",
				"rate of climb/descent, speed, power applied and fuel level. \n\n",
				"The climber is the instrument that indicates the rate \n",
                "    of climb and descent, it's on the left of the panel, \n",
                "    marked with the letter C in blue. \n",
				"The speed indicator indicates the longitudinal speed of the \n",
                "    aircraft. It's on the center of the panel and is marked \n",
                "    with the letter S in white. \n",
				"The power gauge indicates the power applied to the engine. \n",
				"It's at upper right position of the panel, with an yellow P. \n",
				"The fuel gauge, located on the right and below, indicates the \n",
				"fuel available on the aircraft. It's marked with the green F."
			}
			local panel_form = table.concat({
				"formspec_version[3]",
				"size[16,10]",
				"background[-0.7,-0.5;17.5,11.5;hidroplane_manual_bg.png]",
				"image[0.2,1.75;7,7;hidroplane_manual_panel.png]",
				"label[9.25,0.5;", table.concat(text, ""), "]",
			}, "")
			minetest.show_formspec(player:get_player_name(), "hidroplane:manual_panel", panel_form)
		end
		if fields.fuel then
			local text = {
				"Fuel \n\n",
				"To fly, the aircraft needs fuel for its engine. So it is \n",
				"necessary to supply it. To do this, it is necessary to \n",
				"have the selected fuel in hand and punch it in the float. \n",
				"Depending on the fuel mod used and which container, a \n",
				"greater or lesser number of fuel units may be required to \n",
				"fill the tank. In the case of the Lokrates biofuel mod, \n",
                "with 10 bottles it is possible to fill the tank. With the \n",
                "vial, 40 units will be needed. \n",
                "Don't forget to check the fuel gauge on the panel."
			}
			local fuel_form = table.concat({
				"formspec_version[3]",
				"size[16,10]",
				"background[-0.7,-0.5;17.5,11.5;hidroplane_manual_bg.png]",
				"image[2,3.75;4,2;hidroplane_manual_fuel.png]",
				"label[9.25,0.5;", table.concat(text, ""), "]",
			}, "")
			minetest.show_formspec(player:get_player_name(), "hidroplane:fuel", fuel_form)
		end
		if fields.op then
			local text = {
				"Operation \n\n",
				"The aircraft can operate directly from the water or land.  \n",
				"When operating on land the landing gear will  \n",
				"automatically extend. \n",
				"When boarding the aircraft, centralize the commands (A  \n",
				"and D keys), press E to start the engine and hold Jump  \n",
				"until full power. When the speed reaches the green range, \n",
				"lightly pull the stick using the S key. Always keep the \n",
				"speed within the green range to avoid stalling. To land, \n",
                "remove all power, but keep the speed at the limit \n",
                "between the green and white range. \n",
                "When you are about to touch the soil or water, lightly pull \n",
                "the stick to level and touch it gently. It's possible to \n",
                "operate with an external camera, activating the HUD. \n",
                "The autopilot (jump and sneak) only keeps the airplane at the \n",
                "activation level, limited by power and designed ceiling. \n",
                "It's possible for a passenger to board the aircraft, just \n",
                "click the right button on the floater. But the passenger \n",
                "will only be able to enter if the pilot has already boarded."
			}
			local op_form = table.concat({
				"formspec_version[3]",
				"size[16,10]",
				"background[-0.7,-0.5;17.5,11.5;hidroplane_manual_bg.png]",
                "image[0.5,1.75;6,6;hidroplane_manual_side_view.png]",
				"label[9.25,0.25;", table.concat(text, ""), "]",
			}, "")
			minetest.show_formspec(player:get_player_name(), "hidroplane:op", op_form)
		end
		if fields.paint then
			local text = {
				"Painting \n\n",
				"Painting the aircraft is quite simple. It works in the same \n",
				"way as the fuel supply, but instead of using fuel to punch \n",
				"the floater, use a dye of the chosen color."
			}
			local paint_form = table.concat({
				"formspec_version[3]",
				"size[16,10]",
				"background[-0.7,-0.5;17.5,11.5;hidroplane_manual_colors.png]",
				"label[9.25,0.5;", table.concat(text, ""), "]",
			}, "")
			minetest.show_formspec(player:get_player_name(), "hidroplane:paint", paint_form)
		end
		if fields.tips then
			local text = {
				"Tips \n\n",
				"* During a stall, centralize the controls (A + D shortcut) \n",
				"    and apply maximum power, then gently pull the control. \n",
                "* The \"repair tool\" can repair damage suffered by the \n",
                "    aircraft. To use it, have some steel ingots in the \n",
                "    inventory, which will be subtracted for repair \n",
                "* There is a turbo mode that can be used for long climbs, \n",
                "    just hold the jump key. But be careful with the angle of \n",
                "    attack, because even with full power it is not possible to \n",
                "    climb with an angle of attack that is too high. \n",
				"* When boarding as a flight instructor, use \n",
				"    the external camera with the hud on. \n",
				"* As an instructor, only pass control to the student at \n",
				"    altitudes that allow time for reaction, unless you \n",
				"    already trust that student.",
			}
			local tips_form = table.concat({
				"formspec_version[3]",
				"size[16,10]",
				"background[-0.7,-0.5;17.5,11.5;hidroplane_manual_bg.png]",
				"label[0.5,0.5;", table.concat(text, ""), "]",
			}, "")
			minetest.show_formspec(player:get_player_name(), "hidroplane:tips", tips_form)
		end
	end
end)


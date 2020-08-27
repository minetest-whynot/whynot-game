New buttons can be registered using the next API call
```
sfinv_buttons.register_button(button_name, {
	-- mandatory
	image    = Texture file shown on button
	action   = function(player, context, content, show_inv). Called if button is pressed

	-- optional
	title    = Text shown in Tooltip (part 1)
	tooltip  = Text shown in Tooltip (Part 2)
	position = Number. If given the mod try to place the button to this position
	show     = function(player, context, content, show_inv). Allow show or hide button dynamically
})
```

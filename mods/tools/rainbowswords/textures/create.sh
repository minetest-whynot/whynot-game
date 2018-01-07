#!/bin/bash

# The following script will rebuild all colour variations from the two base images.
# Requires ImageMagick to be installed.

command -v convert >/dev/null 2>&1 || { echo >&2 "I require convert from ImageMagick but it's not installed.  Aborting."; exit 1; }

rm -f rainbowswords_*_sword.png

# Base blocks
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#6666ff" rainbowswords_blue_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#800000" rainbowswords_red_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#d0d0d0" rainbowswords_white_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#808080" rainbowswords_grey_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#505050" rainbowswords_dark_grey_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#202020" rainbowswords_black_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#006666" rainbowswords_cyan_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#006600" rainbowswords_dark_green_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#336600" rainbowswords_kahki_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#40d040" rainbowswords_green_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#ffff00" rainbowswords_yellow_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#663300" rainbowswords_brown_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#ff8000" rainbowswords_orange_sword.png 
convert default_tool_steelsword.png -colorspace gray -tint 200 +level-colors ,"#ff3399" rainbowswords_magenta_sword.png 

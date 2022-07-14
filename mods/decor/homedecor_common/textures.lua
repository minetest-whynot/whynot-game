homedecor.plain_wood    = { name = "homedecor_generic_wood_plain.png",  color = 0xffa76820 }
homedecor.mahogany_wood = { name = "homedecor_generic_wood_plain.png",  color = 0xff7d2506 }
homedecor.white_wood    = "homedecor_generic_wood_plain.png"
homedecor.dark_wood     = { name = "homedecor_generic_wood_plain.png",  color = 0xff39240f }
homedecor.lux_wood      = { name = "homedecor_generic_wood_luxury.png", color = 0xff643f23 }

homedecor.textures = {
    glass =
	"[combine:16x16:" ..
	"0,0=\\[combine\\:1x16\\^[noalpha\\^[colorize\\:#ffffff:" ..
	"0,0=\\[combine\\:16x1\\^[noalpha\\^[colorize\\:#ffffff:" ..
	"0,15=\\[combine\\:16x1\\^[noalpha\\^[colorize\\:#ffffff:" ..
	"15,0=\\[combine\\:1x16\\^[noalpha\\^[colorize\\:#ffffff",
    default_wood = "[combine:16x16^[noalpha^[colorize:#654321",
    default_junglewood = "[combine:16x16^[noalpha^[colorize:#563d2d",
    water = "[combine:16x16^[noalpha^[colorize:#00008b",
    wool_white = "[combine:16x16^[noalpha^[colorize:#ffffff",
    wool_black = "[combine:16x16^[noalpha^[colorize:#000000",
	wool_grey = "[combine:16x16^[noalpha^[colorize:#313b3c",
    wool_dark_grey = "[combine:16x16^[noalpha^[colorize:#313b3c",
}

if minetest.get_modpath("default") then
    homedecor.textures = {
        glass = "default_glass.png",
        default_wood = "default_wood.png",
        default_junglewood = "default_junglewood.png",
        water = "default_water.png",
        wool_white = "wool_white.png",
        wool_black = "wool_black.png",
        wool_grey = "wool_grey.png",
        wool_dark_grey = "wool_dark_grey.png",
    }
end
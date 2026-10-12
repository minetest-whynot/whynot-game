biofuel_sfx = {}

function biofuel_sfx.node_sound_refinery_defaults(tbl)
	tbl = tbl or {}
	tbl.footstep = tbl.footstep or
			{name = "biofuel_refinery_footstep", gain = 0.2}
	tbl.dig = tbl.dig or
			{name = "biofuel_dig_refinery", gain = 0.5}
	tbl.dug = tbl.dug or
			{name = "biofuel_dug_refinery", gain = 0.5}
	tbl.place = tbl.place or
			{name = "biofuel_place_refinery", gain = 0.5}
--[[	default.node_sound_defaults(tbl)	]]--
	return tbl
end
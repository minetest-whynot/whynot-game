-- Bone alias
local BODY = "Body"
local HEAD = "Head"
local CAPE = "Cape"
local LARM = "Arm_Left"
local RARM = "Arm_Right"
local LLEG = "Leg_Left"
local RLEG = "Leg_Right"

local BONE_POSITIONS = {
	MTG_0_4_x = {
		[BODY] = {x = 0,   y = -3.5, z = 0},
		[HEAD] = {x = 0,   y = 6.5,  z = 0},
		[CAPE] = {x = 0,   y = 6.5,  z = 1.2},
		[LARM] = {x = 3,   y = 5.5,  z = 0},
		[RARM] = {x = -3,  y = 5.5,  z = 0},
		[LLEG] = {x = 1,   y = 0,    z = 0},
		[RLEG] = {x = -1,  y = 0,    z = 0},

		body_sit = {x = 0, y = -5.5, z = 0},
		body_lay = {x = 0, y = -5.5, z = 0},
	},
	MTG_5_0_x = {
		[BODY] = {x = 0,   y = 6.25, z = 0},
		[HEAD] = {x = 0,   y = 6.5,  z = 0},
		[CAPE] = {x = 0,   y = 6.5,  z = 1.2},
		[LARM] = {x = 3,   y = 5.5,  z = 0},
		[RARM] = {x = -3,  y = 5.5,  z = 0},
		[LLEG] = {x = 1,   y = 0,    z = 0},
		[RLEG] = {x = -1,  y = 0,    z = 0},

		body_sit = {x = 0, y = -5, z = 0},
		body_lay = {x = 0, y = -5, z = 0},
	},
}

local BONE_ROTATIONS = {
	MTG_0_4_x = {
		[BODY] = {x = 0, y = 0, z = 0},
		[HEAD] = {x = 0, y = 0, z = 0},
		[CAPE] = {x = 0, y = 0, z = 0},
		[LARM] = {x = 0, y = 0, z = 0},
		[RARM] = {x = 0, y = 0, z = 0},
		[LLEG] = {x = 0, y = 0, z = 0},
		[RLEG] = {x = 0, y = 0, z = 0},

		body_sit = {x = 0,   y = 0, z = 0},
		body_lay = {x = 270, y = 0, z = 0},
	},
	MTG_5_0_x = {
		[BODY] = {x = 0, y = 0, z = 0},
		[HEAD] = {x = 0, y = 0, z = 0},
		[CAPE] = {x = 0, y = 0, z = 0},
		[LARM] = {x = 0, y = 0, z = 0},
		[RARM] = {x = 0, y = 0, z = 0},
		[LLEG] = {x = 0, y = 0, z = 0},
		[RLEG] = {x = 0, y = 0, z = 0},

		body_sit = {x = 0,   y = 0, z = 0},
		body_lay = {x = 270, y = 0, z = 0},
	},
}

local model = minetest.global_exists("player_api") and "MTG_5_0_x" or "MTG_0_4_x"

local BONE_POSITION = BONE_POSITIONS[model]
local BONE_ROTATION = BONE_ROTATIONS[model]
if not BONE_POSITION or not BONE_ROTATION then
	error("Internal error: invalid player_model_version: " .. PLAYER_MODEL_VERSION)
end

return BONE_POSITION, BONE_ROTATION

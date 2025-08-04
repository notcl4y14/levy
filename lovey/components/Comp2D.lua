local PATH = (...):gsub('%.[^%.]+$', '')
local PARENT_PATH = PATH:gsub('%.[^%.]+$', '')

-- ================
-- MODULES
-- ================

local Component = require(PARENT_PATH..".component")

-- ================
-- COMP2D
-- ================

local Comp2D = {}

Comp2D.Transform2D = Component:new {
	position_x = 0.0,
	position_y = 0.0,
	scale_x = 1.0,
	scale_y = 1.0,
	angle = 0.0,
}

Comp2D.Physics2D = Component:new {
	velocity_x = 0.0,
	velocity_y = 0.0,
	velocity_angle = 0.0,
	area = 0.0,
	mass = 0.0,
	density = 0.0,
}

Comp2D.BoxCollider2D = Component:new {
	width  = 0.0,
	height = 0.0,
}

Comp2D.Camera2D = Component:new {
	position_x = 0.0,
	position_y = 0.0,
	zoom_x = 1.0,
	zoom_y = 1.0,
	angle = 0.0,

	centered = false,
}

return Comp2D
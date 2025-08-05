local PATH = (...):gsub('%.[^%.]+$', '')

-- ================
-- LOVEY
-- ================

local lovey = {
	_URL = "https://github.com/notcl4y14/lovey",
	_DESCRIPTION = "A Bevy-like ECS library for LOVE2D",
	_VERSION = "1.0.0",
}

lovey.App       = require(PATH..".app")
lovey.Entity    = require(PATH..".entity")
lovey.Component = require(PATH..".component")
lovey.System    = require(PATH..".system")
lovey.Resource  = require(PATH..".resource")
lovey.Plugin    = require(PATH..".plugin")
lovey.Event     = require(PATH..".event")

return lovey
local PATH = (...):gsub('%.[^%.]+$', '')

-- ================
-- LOVEY
-- ================

local lovey = {}

lovey.App       = require(PATH..".app")
lovey.Entity    = require(PATH..".entity")
lovey.Component = require(PATH..".component")
lovey.System    = require(PATH..".system")
lovey.Resource  = require(PATH..".resource")
lovey.Plugin    = require(PATH..".plugin")
lovey.Event     = require(PATH..".event")

return lovey
local PATH = (...):gsub('%.[^%.]+$', '')

local Global = require(PATH..".global")
local Util   = require(PATH..".util")

-- ================
-- RESOURCE
-- ================

--- @class Resource
local Resource = {
	_UUID = 0,
}
Resource.__index = Resource

--- Creates a new resource instance.
--- 
--- Table `t` assigns properties to that resource.
--- 
--- Example:
--- ```lua
--- local Resource = lovey.Resource
--- 
--- local GameScoreResource = Resource:new({
--- 	currentScore = 0,
--- 	lastScore    = 0,
--- 	hiScore      = 0,
--- })
--- 
--- -- Adding a resource to an app
--- app:add_resource(GameScoreResource)
--- ```
--- 
--- @param t table
--- @return Resource
function Resource:new (t)
	local new_resource = setmetatable(t, Resource)
	new_resource._UUID = Util.get_random_uuid(Global.UUID_MAX)

	return new_resource
end

return Resource
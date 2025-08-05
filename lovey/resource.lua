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
--- @param t table
--- @return Resource
function Resource:new (t)
	local new_resource = setmetatable(t, Resource)
	new_resource._UUID = Util.get_random_uuid(Global.UUID_MAX)

	return new_resource
end

return Resource
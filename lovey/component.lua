local PATH = (...):gsub('%.[^%.]+$', '')

local Global = require(PATH..".global")
local Util   = require(PATH..".util")

-- ================
-- COMPONENT TYPE
-- ================

local ComponentType = {
	_IsComponentType = true,

	_UUID = 0,
}
ComponentType.__index = ComponentType

function ComponentType:new (t)
	local new_component = setmetatable(t or {}, ComponentInstance)

	new_component._Type = self
	new_component._UUID = self._UUID

	return new_component
end

-- ================
-- COMPONENT INSTANCE
-- ================

local ComponentInstance = {
	_IsComponentInstance = true,

	_Type = nil,
	_UUID = 0,
}
ComponentInstance.__index = ComponentInstance

-- ================
-- COMPONENT
-- ================

local Component = {}

-- Creates a new Component type.
-- @param t : table
-- @return table(Component)
function Component:new (t)
	local new_component_type = setmetatable(t, ComponentType)
	new_component_type.__index = new_component_type
	
	new_component_type._UUID = Util.get_random_uuid(Global.UUID_MAX)
	
	return new_component_type
end

return Component
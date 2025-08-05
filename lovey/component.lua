local PATH = (...):gsub('%.[^%.]+$', '')

local Global = require(PATH..".global")
local Util   = require(PATH..".util")

-- ================
-- COMPONENT INSTANCE
-- ================

--- @class ComponentInstance
local ComponentInstance = {
	_IsComponentInstance = true,

	_Type = nil,
	_UUID = 0,
}
ComponentInstance.__index = ComponentInstance

-- ================
-- COMPONENT TYPE
-- ================

--- @class ComponentType
local ComponentType = {
	_IsComponentType = true,

	_UUID = 0,
}
ComponentType.__index = ComponentType

--- Creates a new component instance.
--- @param t table?
--- @return ComponentInstance
function ComponentType:new (t)
	local new_component = setmetatable(t or {}, ComponentInstance)

	new_component._Type = self
	new_component._UUID = self._UUID

	return new_component
end

-- ================
-- COMPONENT
-- ================

--- @alias Component (ComponentType|ComponentInstance)

local Component = {}

--- Creates a new component type.
--- @param t table
--- @return ComponentType
function Component:new (t)
	local new_component_type = setmetatable(t, ComponentType)
	new_component_type.__index = new_component_type

	new_component_type._UUID = Util.get_random_uuid(Global.UUID_MAX)

	return new_component_type
end

return Component
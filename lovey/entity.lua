local PATH = (...):gsub('%.[^%.]+$', '')

local Component = require(PATH..".component")
local Global    = require(PATH..".global")
local Util      = require(PATH..".util")

-- ================
-- ENTITY
-- ================

--- @class Entity
local Entity = {
	_UUID = 0,
	_Components = {}
}
Entity.__index = Entity

--- Creates a new entity instance.
--- @return Entity
function Entity:new ()
	local new_entity = setmetatable({
		_UUID = 0,
		_Components = {}
	}, Entity)

	return new_entity
end

--- Adds a component to entity's component array.
--- @param component Component
--- @return self
function Entity:add_component (component)
	if component._IsComponentType then
		component = component:new()
	end

	if self._Components[component._UUID] ~= nil then
		error("Cannot readd component [" .. component._UUID .. "]: already added")
	end

	self._Components[component._UUID] = component

	return self
end

--- Removes the component from entity's component array.
--- @param component Component
--- @noreturn
function Entity:remove_component (component)
	if self._Components[component._UUID] == nil then
		error("Component [" .. component._UUID .. "] cannot be deleted: it is not added")
	end

	table.remove(self._Components, component._UUID)
end

--- Returns whether or not the entity has a certain component.
--- @param component Component
--- @return boolean
function Entity:has_component (component)
	return self._Components[component._UUID] ~= nil
end

--- Gets a component from entity's component array.
--- @param component Component
--- @return ComponentInstance
function Entity:get_component (component)
	return self._Components[component._UUID]
end

--- Returns an entire component array.
--- @return ComponentInstance[]
function Entity:get_components ()
	return self._Components
end

return Entity
local PATH = (...):gsub('%.[^%.]+$', '')

local Component = require(PATH..".component")
local Global    = require(PATH..".global")
local Util      = require(PATH..".util")

-- ================
-- ENTITY
-- ================

local Entity = {
	_UUID = 0,
	_Components = {}
}
Entity.__index = Entity

-- Creates a new Entity
-- @return table(Entity)
function Entity:new ()
	local new_entity = setmetatable({
		_UUID = 0,
		_Components = {}
	}, Entity)

	return new_entity
end

-- Adds a component to the Entity
-- May error() the program if the component already exists
-- @param component : table(Component)
-- @return self : table(Entity)
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

-- Removes the component from the Entity
-- May error() the program if the component does not exist
-- @param component : table(Component)
function Entity:remove_component (component)
	-- I don't know why would anyone do that.
	-- Why would anyone submit a ComponentInstance
	-- as an argument to remove the component.
	-- if component._IsComponentInstance then
	-- 	component = component._Type
	-- end

	if self._Components[component._UUID] == nil then
		error("Component [" .. component._UUID .. "] cannot be deleted: it is not added")
	end
	
	table.remove(self._Components, component._UUID)
end

-- Checks if the Entity has a certain component,
-- returns true if it does.
-- @param component : table(Component)
-- @return bool
function Entity:has_component (component)
	return self._Components[component._UUID] ~= nil
end

-- Gets the component from the Entity
-- @param component : table(Component)
-- @return table(Component)
function Entity:get_component (component)
	return self._Components[component._UUID]
end

-- Returns an entire table of Entity components
-- @return table(Component)[]
function Entity:get_components ()
	return self._Components
end

return Entity
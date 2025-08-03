local lovey = {}

-- ================
-- LOVEY
-- ================

local function is_schedule_name_valid (schedule)
	local scheduleLower = schedule:lower()

	if scheduleLower == "startup" then
		return true
	elseif scheduleLower == "update" then
		return true
	elseif scheduleLower == "draw" then
		return true
	end

	return false
end

-- ================
-- UTIL
-- ================

local function merge_table_with (t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end

	return t1
end

-- ================
-- APP
-- ================

lovey.App = {
	_UUID_MAX = 2000000000,
	_ENTITIES = {},
	_SYSTEMS = {
		_STARTUP = {},
		_UPDATE = {},
		_DRAW = {},
	},
	_PLUGINS = {},
	_RESOURCES = {},
}
lovey.App.__index = lovey.App

-- Creates a new App
-- @return table(App)
lovey.App.new = function ()
	local new_app = setmetatable({
		_UUID_MAX = 2000000000,
		_ENTITIES = {},
		_SYSTEMS = {
			_STARTUP = {},
			_UPDATE = {},
			_DRAW = {},
		},
		_PLUGINS = {},
		_RESOURCES = {},
	}, lovey.App)
	return new_app
end

-- Creates a new entity and returns it.
-- @return table(Entity)
lovey.App.create_entity = function (self)
	local new_entity = lovey.Entity.new()
	new_entity._UUID = math.floor(math.random(1, self._UUID_MAX))
	table.insert(self._ENTITIES, new_entity)
	return self._ENTITIES[#self._ENTITIES]
end

-- Removes an entity with a specific UUID.
-- May error() the program if the entity does not exist.
-- @param uuid : number (int)
lovey.App.remove_entity = function (self, uuid)
	for k, v in pairs(self._ENTITIES) do
		if v._UUID == uuid then
			table.remove(self._ENTITIES, k)
			return
		end
	end

	error("Cannot remove an non-existent entity (presuming the UUID = " .. uuid .. ")")
end

-- Searches for an entity with a specific UUID and returns it.
-- Returns nil if found none
-- @param uuid : number (int)
-- @return table(Entity) or nil
lovey.App.get_entity = function (self, uuid)
	for k, v in pairs(self._ENTITIES) do
		if v.__UUID == uuid then
			return v
		end
	end

	return nil
end

-- Searches for a resource with a specific name and returns it.
-- Returns nil if found none
-- @param resource : table(Resource)
-- @return table(Resource) or nil
lovey.App.get_resource = function (self, resource)
	for k, v in pairs(self._RESOURCES) do
		if v._NAME == resource._NAME then
			return v
		end
	end

	return nil
end

-- Adds a system to the schedule
-- May error() the program if the arguments don't match parameters
-- @param schedule : string ["startup"|"update"|"draw"]
-- @param system : function(app) [function(app, dt) for "Update" schedule]
-- @return self : table(App)
lovey.App.add_system = function (self, schedule, system)
	if type(schedule) ~= "string" then
		error("Argument \"schedule\" should be a string")
	end

	if not is_schedule_name_valid(schedule) then
		error("Invalid schedule name \"" .. schedule .. "\", (startup|update|draw)")
	end

	if type(system) ~= "function" then
		error("Argument \"system\" should be a function")
	end

	local schedule = schedule:lower()

	if schedule == "startup" then
		table.insert(self._SYSTEMS._STARTUP, system)
		-- print("ADDED TO STARTUP")
	elseif schedule == "update" then
		table.insert(self._SYSTEMS._UPDATE, system)
		-- print("ADDED TO UPDATE")
	elseif schedule == "draw" then
		table.insert(self._SYSTEMS._DRAW, system)
		-- print("ADDED TO DRAW")
	end

	return self
end

-- Adds a plugin
-- May error() the program if the arguments don't match parameters
-- @param plugin : table(Plugin)
-- @return self : table(App)
lovey.App.add_plugin = function (self, plugin)
	if type(plugin) ~= "table" then
		error("Argument \"plugin\" should be a table of Plugin")
	end
	
	table.insert(self._PLUGINS, plugin)
	return self
end

-- Adds a resource.
-- May error() the program if the arguments don't match parameters
-- @param resource : table(Resource)
-- @return self : table(App)
lovey.App.add_resource = function (self, resource)
	if type(resource) ~= "table" then
		error("Argument \"resource\" should be a table of Resource")
	end
	
	table.insert(self._RESOURCES, resource)
	return self
end

-- Returns an entire table of entities
-- @return table(Entity)[]
lovey.App.get_entities = function (self)
	return self._ENTITIES
end

-- Dispatches a Startup schedule to systems and starts plugins
lovey.App.start = function (self)
	for _, v in pairs(self._PLUGINS) do
		v.build(self)
	end

	for _, v in pairs(self._SYSTEMS._STARTUP) do
		v(self)
	end
end

-- Dispatches an Update schedule to systems
-- @param dt : float
lovey.App.update = function (self, dt)
	for _, v in pairs(self._SYSTEMS._UPDATE) do
		v(self, dt)
	end
end

-- Dispatches a Draw schedule to systems
lovey.App.draw = function (self)
	for _, v in pairs(self._SYSTEMS._DRAW) do
		v(self)
	end
end

-- ================
-- ENTITY
-- ================

lovey.Entity = {
	_UUID = 0,
	_COMPONENTS = {}
}
lovey.Entity.__index = lovey.Entity

-- Creates a new Entity
-- @return table(Entity)
lovey.Entity.new = function ()
	local new_entity = setmetatable({
		_UUID = 0,
		_COMPONENTS = {}
	}, lovey.Entity)
	return new_entity
end

-- Adds a component to the Entity
-- May error() the program if the component already exists
-- @param component : table(Component)
-- @return self : table(Entity)
lovey.Entity.add_component = function (self, component)
	if self._COMPONENTS[component._NAME] ~= nil then
		error("Cannot readd component [" .. component._NAME .. "]: already added")
	end

	self._COMPONENTS[component._NAME] = component

	return self
end

-- Removes the component from the Entity
-- May error() the program if the component does not exist
-- @param component : table(Component)
lovey.Entity.remove_component = function (self, component)
	if self._COMPONENTS[component._NAME] == nil then
		error("Component [" .. component._NAME .. "] cannot be deleted: it is not added")
	end
	
	table.remove(self._COMPONENTS, component._NAME)
end

-- Checks if the Entity has a certain component,
-- returns true if it does.
-- @param component : table(Component)
-- @return bool
lovey.Entity.has_component = function (self, component)
	return self._COMPONENTS[component._NAME] ~= nil
end

-- Gets the component from the Entity
-- @param component : table(Component)
-- @return table(Component)
lovey.Entity.get_component = function (self, component)
	return self._COMPONENTS[component._NAME]
end

-- Returns an entire table of Entity components
-- @return table(Component)[]
lovey.Entity.get_components = function (self)
	return self._COMPONENTS
end

-- ================
-- COMPONENT
-- ================

lovey.Component = {}

--[[
lovey.Component = {
	_NAME = "[UNNAMED COMPONENT]",
}
lovey.Component.__index = lovey.Component

lovey.Component.new = function ()
	local new_component = setmetatable({}, lovey.Component)
	return new_component
end
]]

-- Creates a new Component type.
-- @param name : string
-- @param t : table
-- @return table(Component)
lovey.Component.new = function (name, t)
	local new_component = setmetatable({
		_NAME = name,
	}, t)
	new_component.__index = new_component

	new_component.new = function (t)
		return setmetatable(t, new_component)
	end
	
	return new_component
end

-- ================
-- SYSTEM
-- ================

-- ================
-- PLUGIN
-- ================

lovey.Plugin = {
	build = function (app) end,
}
lovey.Plugin.__index = lovey.Plugin

-- Creates a new Plugin.
-- @param t : table(Plugin)
-- @return table(Plugin)
lovey.Plugin.new = function (t)
	local new_plugin = setmetatable(t, lovey.Plugin)
	return new_plugin
end

-- ================
-- Resource
-- ================

lovey.Resource = {
	_NAME = name,
}
lovey.Resource.__index = lovey.Resource

-- Creates a new Resource.
-- @param name : string
-- @param t : table(Resource)
-- @return table(Resource)
lovey.Resource.new = function (name, t)
	local new_resource = setmetatable(t, lovey.Plugin)
	new_resource._NAME = name
	return new_resource
end

-- ================
-- LOVEY
-- ================

return lovey
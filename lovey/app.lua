local PATH = (...):gsub('%.[^%.]+$', '')

local Entity = require(PATH..".entity")
local System = require(PATH..".system")
local Global = require(PATH..".global")
local Util   = require(PATH..".util")

-- ================
-- UTIL
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
-- APP
-- ================

local App = {
	_Entities = {},
	_Systems = {
		_Startup = {},
		_Update = {},
		_Draw = {},
	},

	_Resources = {},
	_Plugins = {},
}
App.__index = App

-- Creates a new App
-- @return table(App)
function App:new ()
	local new_app = setmetatable({
		_Entities = {},
		_Systems = {
			_Startup = {},
			_Update = {},
			_Draw = {},
		},

		_Resources = {},
		_Plugins = {},
	}, App)

	return new_app
end

-- Creates a new entity and returns it.
-- @return table(Entity)
function App:create_entity (components)
	local components = components or {}

	local new_entity = Entity:new()
	new_entity._UUID = Util.get_random_uuid(Global.UUID_MAX)

	-- Adding components to entity
	for _, v in pairs(components) do
		new_entity:add_component(v)
	end

	table.insert(self._Entities, new_entity)
	
	return self._Entities[#self._Entities]
end

-- Removes an entity with a specific UUID.
-- May error() the program if the entity does not exist.
-- @param uuid : number (int)
function App:remove_entity (uuid)
	if type(uuid) ~= "number" then
		error("Argument \"uuid\" should be a number")
	end

	for k, v in pairs(self._Entities) do
		if v._UUID == uuid then
			table.remove(self._Entities, k)
			return
		end
	end

	error("Cannot remove an non-existent entity (presuming the UUID = " .. uuid .. ")")
end

-- Searches for an entity with a specific UUID and returns it.
-- Returns nil if found none
-- @param uuid : number (int)
-- @return table(Entity) or nil
function App:get_entity (uuid)
	if type(uuid) ~= "number" then
		error("Argument \"uuid\" should be a number")
	end

	-- Search for an entity
	for _, v in pairs(self._Entities) do
		if v._UUID == uuid then
			return v
		end
	end

	return nil
end

-- Searches for a resource with a specific name and returns it.
-- Returns nil if found none
-- @param resource : table(Resource)
-- @return table(Resource) or nil
function App:get_resource (resource)
	if type(resource) ~= "table" then
		error("Argument \"resource\" should be a table of Resource")
	end

	-- Search for a resource
	for _, v in pairs(self._Resources) do
		if v._UUID == resource._UUID then
			return v
		end
	end

	return nil
end

-- Adds a system to the schedule
-- May error() the program if the arguments don't match parameters
-- @param schedule : string ["startup"|"update"|"draw"]
-- @param system : function(app) [function(app, dt) for "Update" schedule] OR table(System)
-- @return self : table(App)
function App:add_system (schedule, system)
	if type(schedule) ~= "string" then
		error("Argument \"schedule\" should be a string")
	end

	if not is_schedule_name_valid(schedule) then
		error("Invalid schedule name \"" .. schedule .. "\", (startup|update|draw)")
	end

	if type(system) ~= "function" and type(system) ~= "table" then
		error("Argument \"system\" should be either a function or a table of System")
	end

	local system = system

	if type(system) == "function" then
		system = System:new(system)
	end

	local schedule = schedule:lower()

	if schedule == "startup" then
		table.insert(self._Systems._Startup, system)
	elseif schedule == "update" then
		table.insert(self._Systems._Update, system)
	elseif schedule == "draw" then
		table.insert(self._Systems._Draw, system)
	end

	return self
end

-- Adds a plugin
-- May error() the program if the arguments don't match parameters
-- @param plugin : table(Plugin)
-- @return self : table(App)
function App:add_plugin (plugin)
	if type(plugin) ~= "table" then
		error("Argument \"plugin\" should be a table of Plugin")
	end
	
	table.insert(self._Plugins, plugin)

	return self
end

-- Adds a resource.
-- May error() the program if the arguments don't match parameters
-- @param resource : table(Resource)
-- @return self : table(App)
function App:add_resource (resource)
	if type(resource) ~= "table" then
		error("Argument \"resource\" should be a table of Resource")
	end
	
	table.insert(self._Resources, resource)
	
	return self
end

-- Returns an entire table of entities
-- @return table(Entity)[]
function App:get_entities ()
	return self._Entities
end

-- Dispatches a Startup schedule to systems and starts plugins
function App:start ()
	for _, v in pairs(self._Plugins) do
		v.build(self)
	end

	for _, v in pairs(self._Systems._Startup) do
		if v.enabled then
			v._Call(self)
		end
	end
end

-- Dispatches an Update schedule to systems
-- @param dt : float
function App:update (dt)
	for _, v in pairs(self._Systems._Update) do
		if v.enabled then
			v._Call(self, dt)
		end
	end
end

-- Dispatches a Draw schedule to systems
function App:draw ()
	for _, v in pairs(self._Systems._Draw) do
		if v.enabled then
			v._Call(self)
		end
	end
end

return App
local PATH = (...):gsub('%.[^%.]+$', '')

local Entity = require(PATH..".entity")
local System = require(PATH..".system")
local Event  = require(PATH..".event")
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

--- @class App
local App = {
	_Entities = {},
	_Systems = {
		_Startup = {},
		_Update = {},
		_Draw = {},
	},

	_Resources = {},
	_Plugins = {},
	_Events = {},
}
App.__index = App

--- Creates a new App instance.
--- @return App
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

--- Creates a new entity, adds it to app and returns the entity.
--- @param components ComponentType[]|ComponentInstance[]
--- @return Entity
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

--- Removes an entity with a specified UUID.
--- @param uuid integer
--- @noreturn
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

--- Return an entity with a specified UUID.
--- @param uuid integer
--- @return Entity|nil
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

--- Returns a resource with a specified name.
--- @param resource Resource
--- @return Resource|nil
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

--- Get event writer from the app's event array.
--- @param event_name string
--- @return EventReader
function App:get_event (event_name)
	if type(event_name) ~= "string" then
		error("Argument \"event_name\" should be a string")
	end

	return self._Events[event_name]
end

--- Adds a system to the schedule.
--- Schedule must be one of these values: 'startup', 'update', 'draw'.
--- The case of the name is insensitive.
--- @param schedule string
--- @param system function
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

--- Adds a plugin to app.
--- @param plugin Plugin
--- @return self
function App:add_plugin (plugin)
	if type(plugin) ~= "table" then
		error("Argument \"plugin\" should be a table of Plugin")
	end

	table.insert(self._Plugins, plugin)

	return self
end

--- Adds a resource to app.
--- @param resource Resource
--- @return self
function App:add_resource (resource)
	if type(resource) ~= "table" then
		error("Argument \"resource\" should be a table of Resource")
	end

	table.insert(self._Resources, resource)

	return self
end

--- Adds an event to app.
--- @param event_name string
--- @return self
function App:add_event (event_name)
	if type(event_name) ~= "string" then
		error("Argument \"event_name\" should be a string")
	end

	self._Events[event_name] = Event:new_writer(event_name)

	return self
end

--- Returns an entire table of entities.
--- @return Entity[]
function App:get_entities ()
	return self._Entities
end

--- Clears a table of entities.
--- @noreturn
function App:clear_entities ()
	self._Entities = {}
end

--- Dispatches a Startup schedule to systems and starts plugins
--- @noreturn
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

--- Dispatches an Update schedule to systems
--- @param dt number
function App:update (dt)
	for _, v in pairs(self._Systems._Update) do
		if v.enabled then
			v._Call(self, dt)
		end
	end
end

--- Dispatches a Draw schedule to systems
--- @noreturn
function App:draw ()
	for _, v in pairs(self._Systems._Draw) do
		if v.enabled then
			v._Call(self)
		end
	end
end

return App
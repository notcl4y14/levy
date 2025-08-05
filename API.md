# API

```lua
-- ================
-- APP
-- ================

--- Creates a new App instance.
--- @return App
function App:new ()

--- Creates a new entity, adds it to app and returns the entity.
--- @param components ComponentType[]|ComponentInstance[]
--- @return Entity
function App:create_entity (components)

--- Removes an entity with a specified UUID.
--- @param uuid integer
--- @return self
function App:remove_entity (uuid)

--- Return an entity with a specified UUID.
--- @param uuid integer
--- @return Entity?
function App:get_entity (uuid)

--- Returns a resource with a specified name.
--- @param resource Resource
--- @return Resource?
function App:get_resource (resource)

--- Get event writer from the app's event array.
--- @param event_name string
--- @return EventReader?
function App:get_event (event_name)

--- Adds a system to the schedule.
--- Schedule must be one of these values: 'startup', 'update', 'draw'.
--- The case of the name is insensitive.
--- @param schedule string
--- @param system function|System
--- @return self
function App:add_system (schedule, system)

--- Adds a table of systems to the schedule.
--- Schedule must be one of these values: 'startup', 'update', 'draw'.
--- The case of the name is insensitive.
--- @param schedule string
--- @param systems function[]|System[]
--- @return self
function App:add_systems (schedule, systems)

--- Adds a plugin to app.
--- @param plugin Plugin
--- @return self
function App:add_plugin (plugin)

--- Adds a resource to app.
--- @param resource Resource
--- @return self
function App:add_resource (resource)

--- Adds an event to app.
--- @param event_name string
--- @return EventWriter
function App:add_event (event_name)

--- Returns an entire table of entities.
--- @return Entity[]
function App:get_entities ()

--- Clears a table of entities.
--- @return self
function App:clear_entities ()

--- Dispatches a Startup schedule to systems and starts plugins
--- @return self
function App:start ()

--- Dispatches an Update schedule to systems
--- @param dt number
--- @return self
function App:update (dt)

--- Dispatches a Draw schedule to systems
--- @return self
function App:draw ()



-- ================
-- PLUGIN
-- ================

local Plugin = {
	build = function (app) end,
}

--- Creates a new plugin type.
--- Table `t` is an overload for Plugin.
--- @param t table
--- @return Plugin
function Plugin:new (t)



-- ================
-- RESOURCE
-- ================

--- Creates a new resource instance.
--- 
--- Table `t` assigns properties to that resource.
--- 
--- @param t table
--- @return Resource
function Resource:new (t)



-- ================
-- EVENT
-- ================

--- Adds an event reader and returns its UUID.
--- 
--- @param call function
--- @return integer
function EventWriter:add_reader (call)

--- Removes the event reader via its UUID.
--- 
--- @param uuid integer
--- @return self
function EventWriter:remove_reader (uuid)

--- Emits to all event readers.
--- 
--- @param t any
--- @return self
function EventWriter:emit (t)

--- Creates a new event writer.
--- 
--- @param name string
--- @return EventWriter
function Event:new_writer (name)



-- ================
-- ENTITY
-- ================

--- Creates a new entity instance.
--- @return Entity
function Entity:new ()

--- Adds a component to entity's component array.
--- @param component Component
--- @return self
function Entity:add_component (component)

--- Adds a table of components to entity's component array.
--- @param components Component[]
--- @return self
function Entity:add_components (components)

--- Removes the component from entity's component array.
--- @param component Component
--- @return self
function Entity:remove_component (component)

--- Returns whether or not the entity has a certain component.
--- @param component Component
--- @return boolean
function Entity:has_component (component)

--- Gets a component from entity's component array.
--- @param component Component
--- @return ComponentInstance
function Entity:get_component (component)

--- Returns an entire component array.
--- @return ComponentInstance[]
function Entity:get_components ()



-- ================
-- COMPONENT
-- ================

--- Creates a new component instance.
--- @param t table?
--- @return ComponentInstance
function ComponentType:new (t)

--- Creates a new component type.
--- @param t table
--- @return ComponentType
function Component:new (t)



-- ================
-- SYSTEM
-- ================

--- Creates a new system type.
--- 
--- @param call function
--- @return System
function System:new (call)
```
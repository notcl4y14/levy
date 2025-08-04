# lovey

## What is Lovey?

**Lovey** is a Lua/LOVE2D library that provides core mechanics of ECS paradigm. The library is inspired by the [Bevy Engine](https://github.com/bevyengine/bevy), [ECS Lua](https://github.com/nidorx/ecs-lua) and [Concord](https://github.com/Keyslam-Group/Concord) libraries. The concept for ECS Lovey uses is quite similar to Bevy's approach to ECS. **It's still in the development stage**.

## Short example

```lua
local lovey = require("lovey")

-- Modules
local App = lovey.App

-- Creaing a new App
local app = App:new()

-- Our system that will start at the "Startup" schedule
function hello_world(app)
	print("Hello World!")
end

-- LOVE2D functions
function love.load()
	app
		:add_system("Startup", hello_world)
		:start() -- App:start() calls each system set on "Startup" schedule
end

function love.update(dt)
	app:update(dt)
end

function love.draw()
	app:draw()
end
```

## Features
- **Implemented features**
	- Entities
	- Components
	- Systems
	- Schedules
	- Plugins
	- Resources

- **Planned features**
	- Scenes
	- Quieries

- **Quite possible features**
	- Built-in Component Types and Systems
	- Events

- **Possible features**
	- Custom schedules
	- System entity-iterators?

## Differences from Bevy
As expected, Lovey is written in Lua and for Lua, Bevy is written in Rust and for Rust, therefore there are some differences between these two due to the way they work, their limitations and features.
| Lovey | Bevy |
| ---- | ---- |
| Uses Lua Tables for both Component structs and instances | Uses Rust structs and instances for Components separately |
| Entire App table can be accessed from the system (might change) | Not quite sure but it seems that it uses specific function parameters for that like Query and Commands |
| Entities can be created from the App table | Entities can be created from the Commands struct |

## API
```lua
-- ================
-- APP
-- ================

-- Creates a new App
-- @return table(App)
function App:new () end

-- Creates a new entity and returns it.
-- @return table(Entity)
function App:create_entity () end

-- Removes an entity with a specific UUID.
-- May error() the program if the entity does not exist.
-- @param uuid : number (int)
function App:remove_entity (uuid) end

-- Searches for an entity with a specific UUID and returns it.
-- Returns nil if found none
-- @param uuid : number (int)
-- @return table(Entity) or nil
function App:get_entity (uuid) end

-- Searches for a resource with a specific name and returns it.
-- Returns nil if found none
-- @param resource : table(Resource)
-- @return table(Resource) or nil
function App:get_resource (resource) end

-- Adds a system to the schedule
-- May error() the program if the arguments don't match parameters
-- @param schedule : string ["startup"|"update"|"draw"]
-- @param system : function(app) [function(app, dt) for "Update" schedule]
-- @return self : table(App)
function App:add_system (schedule, system) end

-- Adds a plugin
-- May error() the program if the arguments don't match parameters
-- @param plugin : table(Plugin)
-- @return self : table(App)
function App:add_plugin (plugin) end

-- Adds a resource.
-- May error() the program if the arguments don't match parameters
-- @param resource : table(Resource)
-- @return self : table(App)
function App:add_resource (resource) end

-- Returns an entire table of entities
-- @return table(Entity)[]
function App:get_entities () end

-- Dispatches a Startup schedule to systems
function App:start () end

-- Dispatches an Update schedule to systems
-- @param dt : float
function App:update (self, dt) end

-- Dispatches a Draw schedule to systems
function App:draw (self) end

-- ================
-- ENTITY
-- ================

-- Creates a new Entity
-- @return table(Entity)
function Entity:new () end

-- Adds a component to the Entity
-- May error() the program if the component already exists
-- @param component : table(Component)
-- @return self : table(Entity)
function Entity:add_component (component) end

-- Removes the component from the Entity
-- May error() the program if the component does not exist
-- @param component : table(Component)
function Entity:remove_component (component) end

-- Checks if the Entity has a certain component,
-- returns true if it does.
-- @param component : table(Component)
-- @return bool
function Entity:has_component (component) end

-- Gets the component from the Entity
-- @param component : table(Component)
-- @return table(Component)
function Entity:get_component (component) end

-- Returns an entire table of Entity components
-- @return table(Component)[]
function Entity:get_components () end

-- ================
-- COMPONENT
-- ================

-- Creates a new Component type.
-- @param t : table
-- @return table(Component)
function Component:new (t) end

-- ================
-- PLUGIN
-- ================

Plugin = {
	build = function (app) end,
}

-- Creates a new Plugin.
-- @param t : table(Plugin)
-- @return table(Plugin)
function Plugin:new (t) end

-- ================
-- RESOURCE
-- ================

-- Creates a new Resource.
-- @param t : table(Resource)
-- @return table(Resource)
function Resource:new (t) end
```
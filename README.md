# lovey

## What is Lovey?

**Lovey** is a Lua/LOVE2D library that provides core mechanics of ECS paradigm. The library is inspired by the [Bevy Engine](https://github.com/bevyengine/bevy) and [ECS Lua](https://github.com/nidorx/ecs-lua) libraries. The concept for ECS Lovey uses is quite similar to Bevy's approach to ECS. **It's still in the development stage**.

## Short example

```lua
local lovey = require("lovey")

local app = lovey.App.new()

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

- **Quite possible features**
	- Built-in Component Types and Systems

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
-- LEVY
-- ================

local lovey = {}

-- ================
-- APP
-- ================

-- Creates a new App
-- @return table(App)
lovey.App.new = function () end

-- Creates a new entity and returns it.
-- @return table(Entity)
lovey.App.create_entity = function (self) end

-- Removes an entity with a specific UUID.
-- May error() the program if the entity does not exist.
-- @param uuid : number (int)
lovey.App.remove_entity = function (self, uuid) end

-- Searches for an entity with a specific UUID and returns it.
-- Returns nil if found none
-- @param uuid : number (int)
-- @return table(Entity) or nil
lovey.App.get_entity = function (self, uuid) end

-- Searches for a resource with a specific name and returns it.
-- Returns nil if found none
-- @param resource : table(Resource)
-- @return table(Resource) or nil
lovey.App.get_resource = function (self, resource) end

-- Adds a system to the schedule
-- May error() the program if the arguments don't match parameters
-- @param schedule : string ["startup"|"update"|"draw"]
-- @param system : function(app) [function(app, dt) for "Update" schedule]
-- @return self : table(App)
lovey.App.add_system = function (self, schedule, system) end

-- Adds a plugin
-- May error() the program if the arguments don't match parameters
-- @param plugin : table(Plugin)
-- @return self : table(App)
lovey.App.add_plugin = function (self, plugin) end

-- Adds a resource.
-- May error() the program if the arguments don't match parameters
-- @param resource : table(Resource)
-- @return self : table(App)
lovey.App.add_resource = function (self, resource) end

-- Returns an entire table of entities
-- @return table(Entity)[]
lovey.App.get_entities = function (self) end

-- Dispatches a Startup schedule to systems
lovey.App.start = function (self) end

-- Dispatches an Update schedule to systems
-- @param dt : float
lovey.App.update = function (self, dt) end

-- Dispatches a Draw schedule to systems
lovey.App.draw = function (self) end

-- ================
-- ENTITY
-- ================

-- Creates a new Entity
-- @return table(Entity)
lovey.Entity.new = function () end

-- Adds a component to the Entity
-- May error() the program if the component already exists
-- @param component : table(Component)
-- @return self : table(Entity)
lovey.Entity.add_component = function (self, component) end

-- Removes the component from the Entity
-- May error() the program if the component does not exist
-- @param component : table(Component)
lovey.Entity.remove_component = function (self, component) end

-- Checks if the Entity has a certain component,
-- returns true if it does.
-- @param component : table(Component)
-- @return bool
lovey.Entity.has_component = function (self, component) end

-- Gets the component from the Entity
-- @param component : table(Component)
-- @return table(Component)
lovey.Entity.get_component = function (self, component) end

-- Returns an entire table of Entity components
-- @return table(Component)[]
lovey.Entity.get_components = function (self) end

-- ================
-- COMPONENT
-- ================

-- Creates a new Component type.
-- @param name : string
-- @param t : table
-- @return table(Component)
lovey.Component.new = function (name, t) end

-- ================
-- PLUGIN
-- ================

lovey.Plugin = {
	build = function (app) end,
}

-- Creates a new Plugin.
-- @param t : table(Plugin)
-- @return table(Plugin)
lovey.Plugin.new = function (t) end

-- ================
-- LEVY
-- ================

return lovey
```
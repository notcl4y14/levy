# lovey

## What is Lovey?

**Lovey** is a Lua/LOVE2D library that provides core mechanics of ECS paradigm. The library is inspired by the [Bevy Engine](https://github.com/bevyengine/bevy), [ECS Lua](https://github.com/nidorx/ecs-lua) and [Concord](https://github.com/Keyslam-Group/Concord) libraries. The concept for ECS Lovey uses is quite similar to Bevy's approach to ECS. **It's still not quite full-featured**.

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
	- Events

- **Planned features**

- **Quite possible features**

- **Possible features**
	- Custom schedules
	- Scenes

- **Probably won't be features**
	- A few built-in Component Types and Systems
	- Queries

## Differences from Bevy
As expected, Lovey is written in Lua and for Lua, Bevy is written in Rust and for Rust, therefore there are some differences between these two due to the way they work, their limitations and features.
| Lovey | Bevy |
| ---- | ---- |
| Uses Lua Tables for both Component structs and instances | Uses Rust structs and instances for Components separately |
| Entire App table can be accessed from the system (might change) | Not quite sure but it seems that it uses specific function parameters for that like Query and Commands |
| Entities can be created from the App table | Entities can be created from the Commands struct |
| Mostly is made for LOVE2D and is a separate library | Is a game engine |
| And many more |
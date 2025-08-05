package.path = package.path .. ";./../../?/init.lua;./../../?.lua"

local lovey = require("lovey")

-- ================
-- MODULES
-- ================

local App       = lovey.App
local Component = lovey.Component
local System    = lovey.System
local Resource  = lovey.Resource

-- ================
-- DEFAULT
-- ================

love.graphics.setDefaultFilter("nearest", "nearest")

-- ================
-- GLOBAL
-- ================

local font = love.graphics.getFont()
local font_height = font:getHeight()

local seed = 0
local is_key_r_down = false

local AMOUNT_OF_TEXTS = 10
local TEXT_LABEL = "Hello World!"
local POINT_SIZE = 5

local WINDOW_WIDTH  = love.graphics.getWidth()
local WINDOW_HEIGHT = love.graphics.getHeight()

-- ================
-- COMPONENTS
-- ================

local TextComponent = Component:new {
	label    = "",
	x        = 0,
	y        = 0,
	scale    = 1.0,
	rotation = 0.0,
	color    = { 1.0, 1.0, 1.0 }
}

-- ================
-- SYSTEMS
-- ================

local StartSystem = System:new(function (app)
	generate_texts(app)
end)

local TextSystem = System:new(function (app)
	for _, entity in pairs(app:get_entities()) do
		local text = entity:get_component(TextComponent)

		-- Text
		love.graphics.setColor(text.color[1], text.color[2], text.color[3])
		love.graphics.print(
			text.label,
			text.x,
			text.y,
			text.rotation,
			text.scale,
			text.scale,
			font:getWidth(text.label) / 2,
			font_height / 2
		)

		-- Point
		-- Uncomment to see the points
		--[[
		love.graphics.setColor(1.0, 1.0, 1.0)
		love.graphics.rectangle(
			"fill",
			text.x - POINT_SIZE / 2,
			text.y - POINT_SIZE / 2,
			POINT_SIZE,
			POINT_SIZE
		)
		]]
	end
end)

local RestartSystem = System:new(function (app)
	if love.keyboard.isDown("r") and not is_key_r_down then
		is_key_r_down = true

		app:clear_entities()
		generate_texts(app)
	end

	is_key_r_down = love.keyboard.isDown("r")
end)

local DrawInfoSystem = System:new(function (app)
	love.graphics.setColor(1.0, 1.0, 1.0)
	love.graphics.print("Press R to regenerate texts", 0, 0)
	love.graphics.print("Current seed: " .. seed, 0, 10)
end)

-- ================
-- FUNCTIONS
-- ================

function generate_texts (app)
	for i=1, AMOUNT_OF_TEXTS do
		local text_x = math.random(0, WINDOW_WIDTH)
		local text_y = math.random(0, WINDOW_HEIGHT)
		local text_scale = math.random() * 4.0 + 1.0
		local text_rotation = math.random() * 3.0
		local text_color = {
			math.random(),
			math.random(),
			math.random()
		}

		app:create_entity({
			TextComponent:new {
				label    = TEXT_LABEL,
				x        = text_x,
				y        = text_y,
				scale    = text_scale,
				rotation = text_rotation,
				color    = text_color
			}
		})
	end
end

-- ================
-- MAIN
-- ================

local app = App:new()

function love.load ()
	seed = os.time()
	math.randomseed(seed)

	app:add_system("Startup", StartSystem)
	app:add_system("Update", RestartSystem)
	app:add_system("Draw", TextSystem)
	app:add_system("Draw", DrawInfoSystem)

	app:start()
end

function love.update (dt)
	app:update(dt)
end

function love.draw ()
	app:draw()
end
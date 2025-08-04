local lovey = require("lovey")

-- This file is an example of using Lovey, use the `lovey`
-- directory instead to get the actual library.

-- ================
-- MODULES
-- ================

local App       = lovey.App
local Component = lovey.Component
local System    = lovey.System
local Resource  = lovey.Resource
local Plugin    = lovey.Plugin

-- ================
-- GLOBAL
-- ================

local AMOUNT_OF_POINTS = 100
local POINT_WIDTH   = 10
local POINT_HEIGHT  = 10
local POINT_SPEED   = 60 -- 60 pixels per second
local POINT_AS      = 25 -- Additional Size
local NOT_POINT_WIDTH   = 50
local NOT_POINT_HEIGHT  = 50
local NOT_POINT_AS_MULT = 25 -- Additional Size Multiplier
local WINDOW_WIDTH  = love.graphics.getWidth()
local WINDOW_HEIGHT = love.graphics.getHeight()

-- ================
-- COMPONENTS
-- ================

local Point = Component:new {
	x = 0.0,
	y = 0.0,
	vx = 0.0,
	vy = 0.0,
	
	as = 0.0, -- Additional Size, gets decreased each tick until it reaches 0
}

local Color = Component:new {
	r = 0.0,
	g = 0.0,
	b = 0.0,
}

local NotPoint = Component:new {
	x = 0.0,
	y = 0.0,
	w = 0.0,
	h = 0.0,
}

-- ================
-- RESOURCES
-- ================

local FPSResource = Resource:new {
	fps = 0,
}

-- ================
-- SYSTEMS
-- ================

local function init_points (app)
	for _, v in pairs(app:get_entities()) do
		if not v:has_component(Point) or not v:has_component(Color) then
		else
			-- Initializing Point component
			local point = v:get_component(Point)
			
			point.x = math.random(0, WINDOW_WIDTH)
			point.y = math.random(0, WINDOW_HEIGHT)

			local vx = 1
			local vy = 1

			if math.random() <= 0.5 then
				vx = -1
			end

			if math.random() <= 0.5 then
				vy = -1
			end

			point.vx = vx
			point.vy = vy

			-- Initializing Color component
			local color = v:get_component(Color)

			color.r = math.random()
			color.g = math.random()
			color.b = math.random()
		end
	end
end

local function update_points (app, dt)
	for _, v in pairs(app:get_entities()) do
		if not v:has_component(Point) then
		else
			local point = v:get_component(Point)

			-- Decrease the additional size each frame
			if point.as > 0.0 then
				point.as = point.as - 1
			end

			point.x = point.x + point.vx * POINT_SPEED * dt
			point.y = point.y + point.vy * POINT_SPEED * dt
			
			-- Getting horizontal point bounds and checking them
			local lbound = point.x - POINT_WIDTH / 2
			local rbound = point.x + POINT_WIDTH / 2

			if lbound < 0.0 then
				point.x = POINT_WIDTH / 2
				point.vx = 1
				point.as = POINT_AS
			elseif rbound >= WINDOW_WIDTH then
				point.x = WINDOW_WIDTH - POINT_WIDTH / 2
				point.vx = -1
				point.as = POINT_AS
			end
			
			-- Getting vertical point bounds and checking them
			local tbound = point.y - POINT_HEIGHT / 2
			local bbound = point.y + POINT_HEIGHT / 2

			if tbound < 0.0 then
				point.y = POINT_HEIGHT / 2
				point.vy = 1
				point.as = POINT_AS
			elseif bbound >= WINDOW_HEIGHT then
				point.y = WINDOW_HEIGHT - POINT_HEIGHT / 2
				point.vy = -1
				point.as = POINT_AS
			end
		end
	end
end

local function draw_points (app)
	for _, v in pairs(app:get_entities()) do
		if not v:has_component(Point) then
		else
			local point = v:get_component(Point)

			-- Setting RGB values to WHITE by default
			local r = 1.0
			local g = 1.0
			local b = 1.0

			-- If the current Entity has a Color component, apply it instead
			if v:has_component(Color) then
				local color = v:get_component(Color)

				r = color.r
				g = color.g
				b = color.b
			end

			love.graphics.setColor(r, g, b, 1.0)
			love.graphics.rectangle(
				"fill",
				point.x - (POINT_WIDTH  + point.as) / 2,
				point.y - (POINT_HEIGHT + point.as) / 2,
				(POINT_WIDTH  + point.as),
				(POINT_HEIGHT + point.as)
			)
		end
	end
end

local function draw_not_points (app)
	for _, v in pairs(app:get_entities()) do
		if not v:has_component(NotPoint) then
		else
			local not_point = v:get_component(NotPoint)

			-- Setting RGB values to WHITE by default
			local r = 1.0
			local g = 1.0
			local b = 1.0

			-- If the current Entity has a Color component, apply it instead
			if v:has_component(Color) then
				local color = v:get_component(Color)

				r = color.r
				g = color.g
				b = color.b
			end

			-- Draw transparent rectangle without size factors
			love.graphics.setColor(r, g, b, 0.25)
			love.graphics.rectangle(
				"fill",
				not_point.x - not_point.w / 2,
				not_point.y - not_point.h / 2,
				not_point.w,
				not_point.h
			)

			local draw_additional_size = math.sin(love.timer.getTime()) * NOT_POINT_AS_MULT
			local draw_width  = not_point.w + draw_additional_size
			local draw_height = not_point.h + draw_additional_size

			-- Draw opaque rectangle with size factors
			love.graphics.setColor(r, g, b, 1.0)
			love.graphics.rectangle(
				"fill",
				not_point.x - draw_width  / 2,
				not_point.y - draw_height / 2,
				draw_width,
				draw_height
			)
		end
	end
end

function update_fps_resource (app)
	local fps_res = app:get_resource(FPSResource)

	fps_res.fps = love.timer.getFPS()
end

function draw_fps_resource (app)
	local fps_res = app:get_resource(FPSResource)

	love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	love.graphics.print("FPS: " .. fps_res.fps, 0, 0)
end

-- ================
-- PLUGINS
-- ================

local InitPlugin = Plugin:new {
	build = function (app)
		app
			:create_entity()
			:add_component(
				NotPoint:new {
					x = WINDOW_WIDTH  / 2,
					y = WINDOW_HEIGHT / 2,
					w = NOT_POINT_WIDTH,
					h = NOT_POINT_HEIGHT
				}
			)
			:add_component(
				Color:new {
					r = math.random(),
					g = math.random(),
					b = math.random()
				}
			)

		for i=1, AMOUNT_OF_POINTS do
			app
				:create_entity()
				:add_component(Point:new { x=0, y=0, vx=0, vy=0, as=0 } )
				:add_component(Color:new { r=0, g=0, b=0 } )
		end

		app
			:add_system("Startup", init_points)
			:add_system("Update", update_points)
			:add_system("Update", update_fps_resource)
			:add_system("Draw", draw_not_points)
			:add_system("Draw", draw_points)
			:add_system("Draw", draw_fps_resource)
			:add_resource(FPSResource)
	end
}

-- ================
-- MAIN
-- ================

local app = nil

function love.load()
	-- Start with a different seed
	math.randomseed(os.time())
	
	app = App:new()
		:add_plugin(InitPlugin)

	app:start()
end

function love.update(dt)
	app:update(dt)
end

function love.draw()
	app:draw()
end
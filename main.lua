local lovey = require("lovey")

-- This file is an example of using Lovey, use the `lovey`
-- directory instead to get the actual library.

-- ================
-- GLOBAL
-- ================

local AMOUNT_OF_POINTS = 100
local OBJECT_WIDTH = 10
local OBJECT_HEIGHT = 10

-- ================
-- COMPONENTS
-- ================

local Point = lovey.Component.new("Point", {
	x = 0.0,
	y = 0.0,
	vx = 0.0,
	vy = 0.0,
	
	as = 0.0, -- Additional Size, gets decreased each tick until it reaches 0
})

local Color = lovey.Component.new("Color", {
	r = 0.0,
	g = 0.0,
	b = 0.0,
})

local NotPoint = lovey.Component.new("NotPoint", {
	x = 0.0,
	y = 0.0,
	w = 0.0,
	h = 0.0,
})

-- ================
-- SYSTEMS
-- ================

local function init_points (app)
	for _, v in pairs(app._ENTITIES) do
		if not v:has_component(Point) or not v:has_component(Color) then
			-- print("skipped")
		else
			local point = v:get_component(Point)
			
			point.x = math.random(0, love.graphics.getWidth())
			point.y = math.random(0, love.graphics.getHeight())

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

			local color = v:get_component(Color)

			color.r = math.random()
			color.g = math.random()
			color.b = math.random()
		end
	end
end

local function update_points (app)
	for _, v in pairs(app._ENTITIES) do
		if not v:has_component(Point) then
			-- print("skipped in update")
		else
			local point = v:get_component(Point)

			if point.as > 0.0 then
				point.as = point.as - 1
			end

			point.x = point.x + point.vx
			point.y = point.y + point.vy
			
			local lbound = point.x - OBJECT_WIDTH / 2
			local rbound = point.x + OBJECT_WIDTH / 2

			if lbound < 0.0 then
				point.x = OBJECT_WIDTH / 2
				point.vx = 1
				point.as = 25
			elseif rbound >= love.graphics.getWidth() then
				point.x = love.graphics.getWidth() - OBJECT_WIDTH / 2
				point.vx = -1
				point.as = 25
			end
			
			local tbound = point.y - OBJECT_HEIGHT / 2
			local bbound = point.y + OBJECT_HEIGHT / 2

			if tbound < 0.0 then
				point.y = OBJECT_HEIGHT / 2
				point.vy = 1
				point.as = 25
			elseif bbound >= love.graphics.getHeight() then
				point.y = love.graphics.getHeight() - OBJECT_HEIGHT / 2
				point.vy = -1
				point.as = 25
			end
		end
	end
end

local function draw_points (app)
	for _, v in pairs(app._ENTITIES) do
		if not v:has_component(Point) then
			-- print("skipped in draw")
		else
			local point = v:get_component(Point)

			local r = 1
			local g = 1
			local b = 1

			if v:has_component(Color) then
				local color = v:get_component(Color)

				r = color.r
				g = color.g
				b = color.b
			end

			love.graphics.setColor(r, g, b, 1)
			love.graphics.rectangle(
				"fill",
				point.x - (OBJECT_WIDTH + point.as) / 2,
				point.y - (OBJECT_HEIGHT + point.as) / 2,
				(OBJECT_WIDTH + point.as),
				(OBJECT_HEIGHT + point.as)
			)
		end
	end
end

local function draw_not_points (app)
	for _, v in pairs(app._ENTITIES) do
		if not v:has_component(NotPoint) then
			-- print("skipped NotPoint in draw")
		else
			local not_point = v:get_component(NotPoint)

			local r = 1
			local g = 1
			local b = 1

			if v:has_component(Color) then
				local color = v:get_component(Color)

				r = color.r
				g = color.g
				b = color.b
			end

			love.graphics.setColor(r, g, b, 1)
			love.graphics.rectangle(
				"fill",
				not_point.x - not_point.w / 2,
				not_point.y - not_point.h / 2,
				not_point.w,
				not_point.h
			)
		end
	end
end

-- ================
-- PLUGINS
-- ================

local InitPlugin = lovey.Plugin.new({
	build = function (app)
		app:create_entity()
			:add_component(NotPoint.new({
				x = love.graphics.getWidth() / 2,
				y = love.graphics.getHeight() / 2,
				w = 50,
				h = 50
			}))
			:add_component(Color.new({
				r = math.random(),
				g = math.random(),
				b = math.random()
			}))

		for i=1, AMOUNT_OF_POINTS do
			app:create_entity()
				:add_component(Point.new({x=0, y=0, vx=0, vy=0, as=0}))
				:add_component(Color.new({r=0, g=0, b=0}))
		end

		app:add_system("Startup", init_points)
		app:add_system("Update", update_points)
		app:add_system("Draw", draw_not_points)
		app:add_system("Draw", draw_points)
	end
})

-- ================
-- MAIN
-- ================

local app = nil

function love.load()
	-- Start with a different seed
	math.randomseed(os.time())
	
	app = lovey.App.new()
		:add_plugin(InitPlugin)

	app:start()
end

function love.update(dt)
	app:update(dt)
end

function love.draw()
	app:draw()
end
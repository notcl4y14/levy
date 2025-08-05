package.path = package.path .. ";./../../?/init.lua;./../../?.lua"

local lovey = require("lovey")

-- ================
-- MODULES
-- ================

local App       = lovey.App
local Component = lovey.Component
local System    = lovey.System

-- ================
-- GLOBAL
-- ================

local WINDOW_WIDTH  = love.graphics.getWidth()
local WINDOW_HEIGHT = love.graphics.getHeight()

local PLAYER_WIDTH = 25
local PLAYER_HEIGHT = 25
local PLAYER_SPEED = 60 * 1.5

local last_player_position_x = 0
local player_on_right_half = false

-- ================
-- COMPONENTS
-- ================

local PlayerComponent = Component:new {
	position_x = 0,
	position_y = 0,
	color = { 0.0, 0.0, 0.0 }
}

-- ================
-- SYSTEMS
-- ================

local PlayerMovedToOtherHalfCheckSystem = System:new(function (app, dt)
	for _, v in pairs(app:get_entities()) do

		if v:has_component(PlayerComponent) then
			local player = v:get_component(PlayerComponent)

			local last_position_on_right    = last_player_position_x > WINDOW_WIDTH / 2
			local current_position_on_right = player.position_x      > WINDOW_WIDTH / 2

			-- Player seems to have moved to the other side!
			if last_position_on_right ~= current_position_on_right then
				app:get_event("PlayerMovedToOtherHalf")
					:emit(current_position_on_right)
			end

			-- Updating last player position
			last_player_position_x = player.position_x

			-- Doing all of that only with the first entity
			break
		end

	end
end)

local HalfDrawSystem = System:new(function (app)
	if player_on_right_half == false then
		love.graphics.setColor(1.0, 0.0, 0.0)
		love.graphics.rectangle(
			"fill",
			0, 0,
			WINDOW_WIDTH / 2,
			WINDOW_HEIGHT
		)
	elseif player_on_right_half == true then
		love.graphics.setColor(0.0, 0.0, 1.0)
		love.graphics.rectangle(
			"fill",
			WINDOW_WIDTH / 2,
			0,
			WINDOW_WIDTH / 2,
			WINDOW_HEIGHT
		)
	end
end)

local PlayerMovementSystem = System:new(function (app, dt)
	for _, v in pairs(app:get_entities()) do

		if v:has_component(PlayerComponent) then
			local player = v:get_component(PlayerComponent)

			-- Move horizontally
			if love.keyboard.isDown("left") then
				player.position_x = player.position_x - PLAYER_SPEED * dt
			end

			if love.keyboard.isDown("right") then
				player.position_x = player.position_x + PLAYER_SPEED * dt
			end

			-- Move vertically
			if love.keyboard.isDown("up") then
				player.position_y = player.position_y - PLAYER_SPEED * dt
			end

			if love.keyboard.isDown("down") then
				player.position_y = player.position_y + PLAYER_SPEED * dt
			end
		end

	end
end)

local PlayerDrawSystem = System:new(function (app)
	for _, v in pairs(app:get_entities()) do

		if v:has_component(PlayerComponent) then
			local player = v:get_component(PlayerComponent)

			love.graphics.setColor(
				player.color[1],
				player.color[2],
				player.color[3]
			)
			love.graphics.rectangle(
				"fill",
				player.position_x - PLAYER_WIDTH / 2,
				player.position_y - PLAYER_HEIGHT / 2,
				PLAYER_WIDTH,
				PLAYER_HEIGHT
			)
		end

	end
end)

-- ================
-- EVENTS
-- ================

-- Event names don't have to be like this
function PlayerMovedToOtherHalfEvent (right_half)
	player_on_right_half = right_half
	print("Player moved to the other side! Right side: " .. tostring(right_half))
end

-- ================
-- MAIN
-- ================

local app = App:new()

function love.load ()
	seed = os.time()
	math.randomseed(seed)

	app:create_entity()
		:add_component(PlayerComponent:new {
			position_x = WINDOW_WIDTH / 4,
			position_y = WINDOW_HEIGHT / 2,
			color = {
				math.random(),
				math.random(),
				math.random()
			}
		})

	app:add_event("PlayerMovedToOtherHalf")
	app:get_event("PlayerMovedToOtherHalf"):add_reader(PlayerMovedToOtherHalfEvent)

	app:add_system("Update", PlayerMovedToOtherHalfCheckSystem)
	app:add_system("Update", PlayerMovementSystem)
	app:add_system("Draw",   HalfDrawSystem)
	app:add_system("Draw",   PlayerDrawSystem)

	app:start()
end

function love.update (dt)
	app:update(dt)
end

function love.draw ()
	app:draw()
end
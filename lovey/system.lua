local PATH = (...):gsub('%.[^%.]+$', '')

-- ================
-- SYSTEM
-- ================

--- @class System
local System = {
	_Call = nil,

	enabled = true,
}
System.__index = System

--- Creates a new system type.
--- 
--- Example:
--- ```lua
--- local System = lovey.System
--- 
--- -- You can also just use functions instead
--- 
--- local MyStartSystem = System:new(function (app)
--- 	print("Hello World!")
--- end)
--- 
--- local MyUpdateSystem = System:new(function (app, dt)
--- 	-- Do something each update
--- end)
--- 
--- local MyDrawSystem = System:new(function (app)
--- 	love.graphics.setColor(1.0, 1.0, 1.0)
--- 	love.graphics.print("Hello World!", 100, 100)
--- end)
--- 
--- -- Adding systems to the app's
--- -- corresponding schedules.
--- app:add_system("startup", MyStartSystem)
--- app:add_system("update",  MyUpdateSystem)
--- app:add_system("draw",    MyDrawSystem)
--- ```
--- 
--- @param call function
--- @return System
function System:new (call)
	local new_system = setmetatable({
		_Call = call,

		enabled = true,
	}, System)

	return new_system
end

return System
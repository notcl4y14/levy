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

function System:new (call)
	local new_system = setmetatable({
		_Call = call,

		enabled = true,
	}, System)

	return new_system
end

return System
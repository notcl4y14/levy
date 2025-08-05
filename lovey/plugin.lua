local PATH = (...):gsub('%.[^%.]+$', '')

-- ================
-- PLUGIN
-- ================

--- @class Plugin
local Plugin = {
	build = function (app) end,
}
Plugin.__index = Plugin

--- Creates a new plugin type.
--- @param t table
--- @return Plugin
function Plugin:new (t)
	local new_plugin = setmetatable(t, Plugin)

	return new_plugin
end

return Plugin
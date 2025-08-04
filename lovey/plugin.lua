local PATH = (...):gsub('%.[^%.]+$', '')

-- ================
-- PLUGIN
-- ================

local Plugin = {
	build = function (app) end,
}
Plugin.__index = Plugin

-- Creates a new Plugin.
-- @param t : table(Plugin)
-- @return table(Plugin)
function Plugin:new (t)
	local new_plugin = setmetatable(t, Plugin)

	return new_plugin
end

return Plugin
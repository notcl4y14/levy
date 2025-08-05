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
--- 
--- Table `t` is an overload for the Plugin table's properties.
--- 
--- The Plugin table's provided properties are:
--- ```lua
--- function Plugin:build (app: App)
--- ```
--- 
--- Example:
--- ```lua
--- local Plugin = lovey.Plugin
--- 
--- local MyPlugin = Plugin:new({
--- 	build = function (app)
--- 		app:add_system(MySystem)
--- 	end
--- })
--- 
--- -- Adding the plugin to an app
--- app:add_plugin(MyPlugin)
--- 
--- -- The plugin is built when the app starts
--- app:start()
--- ```
--- 
--- @param t table
--- @return Plugin
function Plugin:new (t)
	local new_plugin = setmetatable(t, Plugin)

	return new_plugin
end

return Plugin
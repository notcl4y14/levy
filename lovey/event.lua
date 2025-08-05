local PATH = (...):gsub('%.[^%.]+$', '')

local Global = require(PATH..".global")
local Util   = require(PATH..".util")

-- ================
-- EVENT READER
-- ================

--- @class EventReader
local EventReader = {
	_UUID = 0,
	_Call = nil,
}
EventReader.__index = EventReader

-- ================
-- EVENT WRITER
-- ================

--- @class EventWriter
local EventWriter = {
	_Name = "",
	_Readers = {}
}
EventWriter.__index = EventWriter

--- Adds an event reader and returns its UUID.
--- 
--- @param call function
--- @return integer
function EventWriter:add_reader (call)
	local reader = setmetatable({
		_UUID = Util.get_random_uuid(Global.UUID_MAX),
		_Call = call,
	}, EventReader)

	self._Readers[reader._UUID] = reader

	return reader._UUID
end

--- Removes the event reader via its UUID.
--- 
--- @param uuid integer
--- @noreturn
function EventWriter:remove_reader (uuid)
	table.remove(self._Readers, uuid)

	return self
end

--- Emits to all event readers.
--- 
--- @param t any
--- @noreturn
function EventWriter:emit (t)
	for _, v in pairs(self._Readers) do
		v._Call(t)
	end

	return self
end

-- ================
-- EVENT
-- ================

local Event = {}

--- Creates a new event writer.
--- 
--- @param name string
--- @return EventWriter
function Event:new_writer (name)
	return setmetatable({
		_Name = name,
	}, EventWriter)
end

return Event
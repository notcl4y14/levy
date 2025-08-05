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

function EventWriter:add_reader (call)
	local reader = setmetatable({
		_UUID = Util.get_random_uuid(Global.UUID_MAX),
		_Call = call,
	}, EventReader)

	self._Readers[reader._UUID] = reader

	return reader._UUID
end

function EventWriter:remove_reader (uuid)
	table.remove(self._Readers, uuid)
end

function EventWriter:emit (t)
	for _, v in pairs(self._Readers) do
		v._Call(t)
	end
end

-- ================
-- EVENT
-- ================

local Event = {}

function Event:new_writer (name)
	return setmetatable({
		_Name = name,
	}, EventWriter)
end

return Event
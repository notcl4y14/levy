-- ================
-- UTIL
-- ================

local Util = {}

function Util.get_random_uuid (uuid_max)
	return math.floor(math.random() * uuid_max)
end

return Util
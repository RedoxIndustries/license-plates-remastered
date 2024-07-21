local PLATE = PLATE_SHARED
local angForward = Angle(0, 180, 90)
local angBackward = Angle(0, 0, 90)

local function prp(...)
	PLATE:RegisterLegacy(...)
end
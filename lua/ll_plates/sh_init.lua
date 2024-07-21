--[[-- License Plate Main Code
@copyright 2020 Limelight Gaming
@release development
@author John Internet
@module PLATE
--]]--

-- Localise variables for our use.
local isstr = isstring
local agm = engine.ActiveGamemode
local PLATE = PLATE_SHARED

-- Again, we need this.
local angForward = Angle(0, 180, 90)
local angBackward = Angle(0, 0, 90)

--- Ensure we're valid. (Used for the hook lib).
-- @state shared
-- @internal
function PLATE:IsValid()
	return true
end

--- Register a plate for use by the vehicle defined by veh.
-- @state shared
-- @warns Must be ran in a shared context, otherwise plate positions will not show.
-- @string veh Vehicle name to register.
-- @tparam string|table first Vehicle name to copy or first license plate table.
-- @tparam vararg ...
-- @usage PLATE:RegisterPlate("test1", {
-- 	pos = Vector(1, 1, 1),
-- 	ang = Angle(0, 0, 90),
-- 	scale = 1.01,
-- 	condition = function(ent)
-- 		return {Vector(1, 1, 1), Angle(0, 0, 90), scale = 1.01}
-- })
-- PLATE:RegisterPlate("test1copy", "test1")
function PLATE:RegisterPlate(veh, first, ...)
	if isstr(first) then
		if self.Positions[first] then self.Positions[veh] = self.Positions[first] end
		return
	end

	local plates = {first, ...}
	for index, plate in pairs(plates) do
		if not plate.pos and plate[1] then plate.pos = plate[1]; plate[1] = nil end
		if not plate.ang and plate[2] then plate.ang = plate[2]; plate[2] = nil end
		if not plate.ang then
			plate.ang = index == 1 and angForward or angBackward
		end
	end

	self.Positions[veh] = plates
end

--- Register a legacy plate position.
-- Functionally the same as @{RegisterPlate}, but sets a few flags on the data.
-- @state shared
-- @warns Must be ran in a shared context, otherwise plate positions will not show.
-- @internal
-- @string veh Vehicle name.
-- @tparam vararg ...
-- @see PLATE.RegisterPlate
function PLATE:RegisterLegacy(veh, ...)
	self:RegisterPlate(veh, ...)
	if self.Positions[veh] then self.Positions[veh].legacy = true end
	for _, v in ipairs(self.Positions[veh]) do
		if v.condition then
			self.Positions[veh].conditioned = true
		end
	end
end

--- Register a custom renderer
-- @state shared
-- @string veh Vehicle name.
-- @tab renderer Render data.
function PLATE:RegisterRenderer(veh, renderer)
	if not self.Positions[veh] then
		ErrorNoHalt("RegisterRender calls must be made AFTER a RegisterPlate / RegisterLegacy call")
		return
	end

	if self.Positions[veh].Renderer then
		ErrorNoHalt(string.format("Duplicated Renderer call: %s already has a custom renderer.", veh))
		return
	end

	self.Positions[veh].Renderer = renderer
end

--- Get registered plates for a given vehicle.
-- @state shared
-- @string veh Vehicle name to get plates for
-- @treturn table Table of license plate positions, angles, scales and overrides.
function PLATE:GetPlate(veh) return self.Positions[veh] or {} end

--- Table for storing all information about plates and their configuration.
PLATE.Config = {}

--- The stored positions of the license plates.
PLATE.Positions = {}

-- Grab our languages.
include("sh_lang.lua")

-- And include the config files.
include("conf_misc.lua")
include("conf_derma.lua")

-- Include vehicle positions.
include("conf_vehicles.lua")
include("sh_autogen.lua")

-- Final loads.
include("sh_debugging.lua")

--> Credits
PLATE.Credits = [[Dan :: Author of "DarkRP License Plates", where we got the idea.
	https://www.gmodstore.com/scripts/view/172/darkrp-license-plates
	https://www.gmodstore.com/users/view/76561197997120007
	https://steamcommunity.com/id/__dan/
Doctor Internet :: Author of this version, bug testing etc.
	https://limelightgaming.net/forums/user-2746.html
	https://steamcommunity.com/id/DocInternet
Vadar :: Artist who created the license plate designs.
	https://limelightgaming.net/forums/user-4462.html
	https://steamcommunity.com/id/_Vadar/
goigle :: The guy who contributed code for supporting multiple plates and colours.
	https://limelightgaming.net/forums/user-2521.html
	https://steamcommunity.com/id/goigle/]]

PLATE.Config.FadeDist = PLATE.Config.FadeDist * PLATE.Config.FadeDist
PLATE.Config.MaxDist = PLATE.Config.MaxDist * PLATE.Config.MaxDist
if PLATE.Config.Version ~= "" then PLATE.Config.Version = PLATE.Config.Version .. "/" end

--- Check if a given vehicle is owned by the current player.
-- @state shared
-- @ply ply The player to check ownership from.
-- @veh veh The entity to check ownership of.
-- @treturn bool Is the vehicle owned by the player.
function PLATE:CheckVehicleOwnership(ply, veh)
	local gm = agm()
	if gm == "cityrp" or gm == "cityrp_2_by_limelight" then
		return ply == veh:GetTable()._Owner
	elseif gm == "darkrp" then
		-- Use this function, make sure the ply is the TRUE owner, as it modifies permanent data.
		return veh:isMasterOwner(ply)
	else
		return veh:GetNWEntity("PlatesOwner") == ply
	end
end

--- Function called to load model matches.
-- @state shared
-- @internal
function PLATE:GetModelMatches()
	local lookup = {}
	local vehs = list.Get("Vehicles")

	for idx, _ in pairs(self.Positions) do
		local data = vehs[idx]
		if data and data.Model then
			self:DebugPrint(Format("Setting %s as source for %s.", idx, data.Model))
			lookup[data.Model] = idx
		end
	end

	for idx, data in pairs(vehs) do
		local match = lookup[data.Model]
		if match and match ~= idx then
			self:DebugPrint(Format("Cloning %s to %s from lookup.", lookup[data.Model], idx))
			self:RegisterPlate(idx, lookup[data.Model])
		end
	end
end
hook.Add("InitPostEntity", PLATE, PLATE.GetModelMatches)

PLATE:DebugPrint("Loaded Shared.")

--[[-- License Plate Main Code
@copyright 2020 Limelight Gaming
@release development
@author John Internet
@module PLATE
--]]--

--- Table for storing all information about plates and their configuration.
local PLATE = {}

-- Ensure that the shared and clientside files are added to the download list.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
AddCSLuaFile("sh_autogen.lua")
AddCSLuaFile("sh_debugging.lua")

-- Add Configuration Files.
AddCSLuaFile("conf_vehicles.lua")
AddCSLuaFile("conf_derma.lua")
AddCSLuaFile("conf_misc.lua")

-- And then run the shared init.
PLATE_SHARED = PLATE
include("sh_init.lua")
PLATE:DebugPrint("Back to Server")

-- Precache NWStrings.
util.AddNetworkString("ll_plates::menu")
util.AddNetworkString("ll_plates::random")
PLATE:DebugPrint("Precached NWStrings")

-- Localise commonly used functions.
local chr = string.char
local rnd = math.random
local esc = sql.SQLStr
local tblExist = sql.TableExists
local quer = sql.Query
local ceil = math.ceil
local strlen = string.len
local strfind = string.find
local querrow = sql.QueryRow
local rtime = RealTime
local tostr = tostring
local isstr = isstring
local agm = engine.ActiveGamemode
local upper = string.upper
PLATE:DebugPrint("Localise the functions.")

--- Generate a random capital letter.
-- @state server
-- @treturn string Random uppercase letter.
function PLATE:RandomLetter() return chr(65 + rnd(0, 25)) end

--- Generate a random number, in the range 0-9
-- Whilst it's not quicker, it's nicer to have it being a function in the plate table.
-- @state server
-- @treturn int Random number, range 0-9.
function PLATE:RandomNumber() return rnd(0, 9) end

--- Format a string replacement for RandomPlate
-- Takes the string or digit string format pattern, returning a random letter or number.
-- @internal
-- @state server
-- @string val  Input value for testing.
-- @treturn str Random letter, number or empty string.
function PLATE.DoReplace(val) return (val == "%s" and PLATE.RandomLetter()) or (val == "%i" and PLATE.RandomNumber()) or "" end

--- Generates a random plate based on @{PLATE.Config.DefaultFormat}.
-- @state server
-- @treturn string Randomly generated plate. 333,135,504 plates using default format.
function PLATE:RandomPlate() return string.gsub(PLATE.Config.DefaultFormat, "%%%a", PLATE.DoReplace) end
PLATE:DebugPrint("Create Plate Functions")


--- Generates a random plate based on @{PLATE.Config.DefaultFormat}.
-- @state server
-- @treturn string Randomly generated plate. 333,135,504 plates using default format.
function PLATE:RandomMilitaryPlate(indicatif) 
	if indicatif == "CMO" then 
		local plaque = string.gsub("    %i", "%%%a", PLATE.DoReplace)
		plaque = indicatif .. plaque

		return plaque
	else 
		local plaque = string.gsub(" %i%i%i", "%%%a", PLATE.DoReplace)
		plaque = indicatif .. plaque

		return plaque
	end
end

--- Table containing valid vehicle classes.
-- Done as [str | class] = [bool | valid].
-- Reduces O(N) lookup to O(1)
PLATE.VehicleClasses = {
	["prop_vehicle_jeep"] = true,
	["prop_vehicle_jeep_old"] = true,
	["prop_vehicle_prisoner_pod"] = true,
	["prop_vehicle_airboat"] = true,
	["gmod_sent_vehicle_fphysics_base"] = true
}
PLATE:DebugPrint("Vehicle Classes Setup")

--- Get the "name" of the vehicle.
-- @state server
-- @ent ent The entity to get the name for.
-- @treturn ?string Returns nil on failure, vehicle name as string on success.
function PLATE:GetVehicleName(ent)
	if not IsValid(ent) then return end
	if not ent:IsVehicle() then return end

	local class = ent:GetClass()
	return (self.VehicleClasses[class] and (ent.VehicleScriptName or ent.VehicleName or ent:GetVehicleClass())) or class
end

--- Create the SQLite table, if it doesn't exist.
-- @state server
-- @internal
function PLATE:GenerateTable()
	if not tblExist("ll_plates") then
		quer([[CREATE TABLE `ll_plates` (`steamid` TEXT NOT NULL, `vehicle` TEXT NOT NULL, `plate` TEXT, PRIMARY KEY (`steamid`, `vehicle`));]])
	end
end
hook.Add("Initialize", "LL_Plates::CreateTable", function() PLATE:GenerateTable() end)
PLATE:DebugPrint("Table Generation.")

--- Get the player's chosen vehicle.
-- @state server
-- @ply ply Player to get the vehicle from.
-- @tparam boolean|Entity ent If false, get closest owned vehicle. If true, get eye trace vehicle. If ent, use specific ent.
-- @treturn ?Vehicle Chosen vehicle.
-- @treturn integer Squared Distance to chosen vehicle, or 0 if chosen vehicle isn't valid.
function PLATE:GetChosenVehicle(ply, ent)
	local closest, chosenEnt
	if ent == true then
		chosenEnt = ply:GetEyeTrace().Entity
	elseif ent == false then
		closest = 9999999999
		for _, v in pairs(ents.GetAll()) do
			local dist = v:GetPos():DistToSqr(ply:GetPos())
			if v:IsVehicle() and self:CheckVehicleOwnership(ply, v) and dist < closest then
				closest = dist
				chosenEnt = v
			end
		end
	else
		chosenEnt = ent
	end

	if not IsValid(chosenEnt) then return end
	if not chosenEnt:IsVehicle() then return end
	if not self:CheckVehicleOwnership(ply, chosenEnt) then return ply:ChatPrint(self.Language("menu.fail.unowned")) end

	return chosenEnt, (IsValid(chosenEnt) and chosenEnt:GetPos():DistToSqr(ply:GetPos())) or 0
end
PLATE:DebugPrint("Chosen Vehicle")

--- Open the plate menu on a client.
-- @state server
-- @ply ply Player to open the menu on.
-- @tparam boolean|Entity ent If false, get closest owned vehicle. If true, get eye trace vehicle. If ent, use specific ent.
-- @treturn ?boolean True if the net message sends, nil otherwise.
function PLATE:OpenMenu(ply, ent)
	if LLServer == "build" then ply:ChatPrint(self.Language("menu.fail.build")) return end
	if not self.Config.AllowChanges then return ply:ChatPrint(self.Language("menu.fail.disabled")) end

	if self.Config.LimitPlateChangesToGroup then
		local grp = ply:GetUserGroup()
		if not self.Config.PlateChangeGroups[grp] then
			ply:ChatPrint(self.Language("menu.fail.rank"))
			return
		end
	end

	local time = rtime()
	ply.LastPlateChange = ply.LastPlateChange or (time - self.Config.Delay)
	if ply.LastPlateChange + self.Config.Delay > time then
		local timeLeft = ceil((ply.LastPlateChange + self.Config.Delay) - time)
		ply:ChatPrint(self.Language("menu.fail.cooldown", {time = timeLeft}))
		return
	end

	local dist
	ent, dist = self:GetChosenVehicle(ply, ent)
	if not ent then return end
	if dist > self.Config.MaxDist then ply:ChatPrint(self.Language("menu.fail.distance")); return end
	if not self.Config.AllowEmergencyChanges and self:IsEmergency(ent) then return ply:ChatPrint(self.Language("menu.fail.disabled-emergency")) end

	local allowed = hook.Call("CanOpenLicenseMenu", self, ply, ent)
	if not allowed then return end

	net.Start("ll_plates::menu")
	net.Send(ply)
	return true
end
PLATE:DebugPrint("Menu Opening")

if PLATE.Config.BindF3 then
	--- Open the plate menu on the selected vehicle.
	-- @state server
	-- @ply ply The player who called ShowSpare1.
	function PLATE:OnShowSpare1(ply) return self:OpenMenu(ply, true) end
	hook.Add("ShowSpare1", "ll_plates::OpenF3Menu", function(ply) return PLATE:OnShowSpare1(ply) end)
end

--- Check if the player has the amount of cash required to do a transaction.
-- @state server
-- @ply ply The player to check cash on.
-- @int amt The minimum cash the player must have.
-- @treturn bool If the player can afford the transaction.
function PLATE:PlayerHasCash(ply, amt)
	local gm = agm()
	if gm == "cityrp" or gm == "cityrp_2_by_limelight" then
		return ply:CanAfford(amt)
	elseif gm == "darkrp" then
		return ply:canAfford(amt)
	end
	return true
end
PLATE:DebugPrint("Check Cash")

--- Take cash from a player.
-- @state server
-- @ply ply Player to take money from.
-- @int amt The amount of money to take.
function PLATE:PlayerTakeMoney(ply, amt)
	local gm = agm()
	if gm == "cityrp" or gm == "cityrp_2_by_limelight" then
		ply:GiveMoney(-amt)
	elseif gm == "darkrp" then
		ply:addMoney(-amt)
	end
end
PLATE:DebugPrint("Take Money")

--- Update the license plate in the DB and on the vehicle itself.
-- @state server
-- @tparam string|Player ply Player who's requesting the change, or their SteamID.
-- @tparam string|Vehicle veh The vehicle entity the change is being requested for, or the vehicle name if setting without an entity.
-- @string plate The plate that's having the change requested.
-- @treturn boolean Success?
function PLATE:SetLicensePlate(ply, veh, plate)
	if not plate then return false end
	local sid = esc(isstr(ply) and ply or ply:SteamID())
	veh = isstr(veh) and veh or self:GetVehicleName(veh)
	if not veh and not isstr(veh) then return false end

	plate = tostr(plate):gsub("[^%w- ]", ""):gsub("%l", function(val) return upper(val) end):sub(0, self.Config.MaxLength)
	local veh_name_esc = esc(veh)
	local sqlstr = "INSERT INTO ll_plates VALUES (" .. sid .. ", "  .. veh_name_esc .. ", " .. esc(plate) .. ");"
	if querrow("SELECT * FROM ll_plates WHERE steamid=" .. sid .. " AND vehicle=" .. veh_name_esc .. ";") then
		sqlstr = "UPDATE ll_plates SET plate=" .. esc(plate) .. " WHERE steamid=" .. sid .. " AND vehicle=" .. veh_name_esc .. ";"
	end

	quer(sqlstr)
	for _, v in ipairs(ents.GetAll()) do
		if self:GetVehicleName(v) == veh and self:CheckVehicleOwnership(ply, v) then
			v:SetNWString("ll_plate", plate)
		end
	end
	return true
end
PLATE:DebugPrint("Set Plates")

--- Get the steamid of the player with matching plate.
-- @state server
-- @string plate License plate to find.
-- @treturn ?string SteamID if found.
function PLATE:SearchPlate(plate)
	local res = querrow(Format("SELECT steamid FROM ll_plates WHERE plate = %s;", esc(plate)))
	if res then return res.steamid end
end

--- Fetch a table of all license plates, keyed by vehicle ID or
-- license plate for a specific steam ID / vehicle pair.
-- @state server
-- @string sid SteamID to query.
-- @string[opt] veh Vehicle ID
-- @treturn table|string|nil Table of plates if veh isn't specified. Plate or nil if veh is specified.
function PLATE:PlateFromSteamID(sid, veh)
	if veh then
		local res = querrow("SELECT * FROM ll_plates WHERE steamid=" .. esc(sid) .. " AND vehicle=" .. esc(veh) .. ";")
		if not res then return nil end

		return res.plate
	else
		local res = quer("SELECT * FROM ll_plates WHERE steamid=" .. esc(sid) .. ";")
		if not res then return end

		for id, data in ipairs(res) do
			res[data.vehicle] = data.plate
			res[id] = nil
		end
		return res
	end
end

--- Fetch license plate information for a vehicle and generate if none exists.
-- @state server
-- @tparam string|Player ply Player or SteamID to get information for.
-- @tparam string|Vehicle veh Vehicle (name) to get information for.
-- @treturn string License plate.
function PLATE:GetLicensePlate(ply, veh)
	local sid = esc(isstr(ply) and ply or ply:SteamID())
	veh = isstr(veh) and veh or self:GetVehicleName(veh)
	local veh_esc = esc(veh)

	local res = querrow("SELECT * FROM ll_plates WHERE steamid=" .. sid .. " AND vehicle=" .. veh_esc .. ";")
	if res then return res.plate end

	local plates = self:GetPlate(veh)

	if plates.IsNotEmpty then
		plqtype = plates[1].plaquetype 
		if plqtype and string.match(plqtype, "^bspp") then

			-- Récupération de l'indicatif du véhicule et passage en majuscule
			local indicatif = string.match(plqtype, "%-(.+)$")
			indicatif = string.upper(indicatif)

			local newMilitaryPlate = self:RandomMilitaryPlate(indicatif)
			while querrow("SELECT * FROM ll_plates WHERE plate=" .. esc(newMilitaryPlate) .. ";") do
				newMilitaryPlate = self:RandomMilitaryPlate(indicatif)
			end

			self:SetLicensePlate(ply, veh, newMilitaryPlate)
			return newMilitaryPlate
		end
	end


	local newPlate = self:RandomPlate()
	while querrow("SELECT * FROM ll_plates WHERE plate=" .. esc(newPlate) .. ";") do
		newPlate = self:RandomPlate()
	end
	self:SetLicensePlate(ply, veh, newPlate)

	return newPlate
end
PLATE:DebugPrint("Get Plates")

--- Hook function, called to determine if a player can open the license plate menu.
-- @state server
-- @ply ply The player updating their plate.
-- @veh veh The vehicle being updated.
-- @treturn boolean If the change is allowed.
function PLATE:CanOpenLicenseMenu(ply, veh) return true end

--- Hook function, called to determine if a player can update their license plate.
-- @state server
-- @ply ply The player updating their plate.
-- @veh veh The vehicle being updated.
-- @string plate The new license plate.
-- @treturn boolean If the change is allowed.
function PLATE:CanUpdateLicensePlate(ply, veh, plate) return true end

function PLATE:IsNumber(plate)
	local number = "0123456789"
	for i = 1, strlen(number) do
		if (plate == number[i]) then
			return true
		end
	end
	return false
end

function PLATE:IsAlpha(plate)
	local alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	for i = 1, strlen(alpha) do
		if (plate == alpha[i]) then
			return true
		end
	end
	return false
end

--- Internal function, used to process the plate update net message.
-- @state server
-- @int leng Length of incoming net message.
-- @ply ply The player sending the message.
-- @string plate The new plate.
-- @int veh_type The vehicle picker type.
-- @veh veh The vehicle entity.
function PLATE:GetUpdate(leng, ply, plate, veh_type, veh, random)
	if veh_type == 0 then
		veh = self:GetChosenVehicle(ply, veh)
	elseif veh_type == 1 then
		veh = self:GetChosenVehicle(ply, true)
	elseif veh_type == 2 then
		veh = self:GetChosenVehicle(ply, false)
	end

	if not IsValid(veh) then return end
	local strleng = strlen(plate)

	if not self.Config.AllowChanges then return ply:ChatPrint(self.Language("menu.fail.disabled")) end
	if not self.Config.AllowEmergencyChanges and self:IsEmergency(veh) then return ply:ChatPrint(self.Language("menu.fail.disabled-emergency")) end
	local platesBspp = self:GetPlate(veh:GetVehicleClass())
	if platesBspp then 
		plqtype = platesBspp[1].plaquetype
		if plqtype and string.match(plqtype, "^bspp") then
			return ply:ChatPrint("Vous ne pouvez pas modifier la plaque d'un véhicule de la BSPP")
		end
	end

	if (random == 0) then
		if not self:PlayerHasCash(ply, self.Config.Cost) then return ply:ChatPrint(self.Language("menu.fail.cost", {cost = self.Config.Cost, dollar = self.Config.CurrencySymbol})) end
	else
		if not self:PlayerHasCash(ply, PLATE.Config.CostRandom) then return ply:ChatPrint(self.Language("menu.fail.cost", {cost = self.Config.CostRandom, dollar = self.Config.CurrencySymbol})) end
	end

	local allowed = hook.Call("CanUpdateLicensePlate", self, ply, veh, plate)
	if not allowed then return end
	

	if (strleng != 9) then ply:ChatPrint("Invalid License Plate! Length must be 9 characters.") return end
	print(plate)
	if (plate[3] != "-" || plate[7] != "-") then ply:ChatPrint("Invalid License Plate! Plate must have '-' in 3rd and 7th character.") return end
	if (!PLATE:IsNumber(plate[4]) || !PLATE:IsNumber(plate[5]) || !PLATE:IsNumber(plate[6])) then ply:ChatPrint("Invalid License Plate! Numbers must be between '-'.") return end
	if (!PLATE:IsAlpha(plate[1]) || !PLATE:IsAlpha(plate[2]) || !PLATE:IsAlpha(plate[8]) || !PLATE:IsAlpha(plate[9])) then ply:ChatPrint("Invalid License Plate! Alphabetic character must be before and after '-'.") print(plate[1], plate[2] ,plate[8], plate[9]) return end
	if strfind(plate, "[^%w- ]") then return ply:ChatPrint(self.Language("menu.fail", {reason = "{{menu.fail.chars}}"})) end
	if querrow("SELECT * FROM ll_plates WHERE plate=" .. esc(plate) .. ";") then return ply:ChatPrint(self.Language("menu.fail.dupe")) end

	local success = self:SetLicensePlate(ply, veh, plate)
	if success then
		if (random == 0) then
			self:PlayerTakeMoney(ply, self.Config.Cost)
		else
			self:PlayerTakeMoney(ply, PLATE.Config.CostRandom)
		end
		ply:ChatPrint(self.Language("menu.success"))
		ply.LastPlateChange = rtime()
	end
end

--- Check if a given vehicle is an emergency vehicle.
-- @state server
-- @veh veh Vehicle to check.
-- @treturn boolean If the vehicle is an emergency vehicle.
function PLATE:IsEmergency(veh)
	local vname = self:GetVehicleName(veh)
	if self.EmergOverride[vname] then return false end

	if self.Config.ParseVCEmergency and (veh.VC_isELS or self.Emergency[veh.VC_Category]) then return true end
	if self.Emergency[vname] then return true end
	if veh.VehicleTable and self.Emergency[veh.VehicleTable.Category] then return true end

	return false
end

net.Receive("ll_plates::menu", function(leng, ply)
	local plate = net.ReadString()
	local veh_type = net.ReadUInt(2)

	local veh
	if veh_type == 0 then veh = net.ReadEntity() end

	PLATE:GetUpdate(leng, ply, plate, veh_type, veh, 0)
end)

net.Receive("ll_plates::random", function(leng, ply)
	local plate = string.gsub(PLATE.Config.DefaultFormat, "%%%a", PLATE.DoReplace)
	local veh_type = net.ReadUInt(2)

	local veh
	if veh_type == 0 then veh = net.ReadEntity() end

	PLATE:GetUpdate(leng, ply, plate, veh_type, veh, 1)
end)

--- Setup a vehicle's license plates, upon spawn.
-- If, for whatever reason, you need to call this on a non-registered-vehicle?
-- Dev or something idk. SCars maybe? Should work.
-- @state server
-- @ply ply The player that spawned the vehicle.
-- @veh veh The vehicle spawned.
function PLATE:PrepareVehicle(ply, veh)
	PLATE:DebugPrint("Attempting to Prepare Vehicle")
	if not IsValid(ply) then return end
	if not IsValid(veh) then return end
	PLATE:DebugPrint("Vehicle and Owner Are Valid")

	veh:SetNWEntity("PlatesOwner", ply)
	PLATE:DebugPrint("Set Owner")

	local vname = self:GetVehicleName(veh)
	if not vname then return end
	veh:SetNWString("ll_v_name", vname)
	PLATE:DebugPrint("Got Name")

	local plate = self:GetLicensePlate(ply, vname) -- Use the vname here to save a few cycles.
	if not plate then return end
	veh:SetNWString("ll_plate", plate)
	PLATE:DebugPrint("Got Plate")

	local plates = self:GetPlate( vname )

	if plates then
		local platesnb = #plates
		veh.Plates = veh.Plates || {}
		
		for i = 1, platesnb do
			local plte = plates[ i ]
			if !veh.Plates[ plte ] then
				local pos, ang, _, cond, bgs = plte.pos, plte.ang, _, plte.condition, plte.bg
				local plqtype = plte.plaquetype && plte.plaquetype || "avant"
				if (string.StartsWith(plqtype, "bspp")) then
					plqtype = string.match(plqtype, "^(.-)-")
				end
				
				if cond then
					local res = cond(ent)
					if res == false then return end
			
					pos = res and (res[1] or res.pos) or pos
					ang = res and (res[2] or res.ang) or ang
				end
			
				if bgs and bgs.id then
					local va = ent:GetBodygroup(bgs.id)
					if bgs.val[va] then
						local ov = bgs.val[va]
						if ov.hidden then return end
			
						pos = ov.pos or pos
						ang = ov.ang or ang
					end
				end

				pos = veh:LocalToWorld( pos || Vector( 0, 0, 0 ) )
				ang = ang + Angle( 0, 0, 90 )
				ang = veh:LocalToWorldAngles( ang || Angle( 0, 0, 0 ) )

				veh.Plates[ plte ] = ents.Create( "ent_plaque" .. plqtype )
				veh.Plates[ plte ]:SetPos( pos )
				veh.Plates[ plte ]:SetAngles( ang )
				veh.Plates[ plte ]:SetParent( veh )
				veh.Plates[ plte ]:Spawn()
			end
		end
	end

	if self:IsEmergency(veh) then
		veh:SetNWBool("IsExemptVehicle", true)
		PLATE:DebugPrint("Set as Exempt")
	end
end
hook.Add("PlayerSpawnedVehicle", "ll_plates::OnVehicleSpawn", function(p, v) PLATE:PrepareVehicle(p, v) end)
hook.Add("playerBoughtCustomVehicle", "ll_plates::OnVehicleSpawn", function(p, t, v, c) PLATE:PrepareVehicle(p, v) end)
hook.Add("playerBoughtVehicle", "ll_plates::OnVehicleSpawn", function(p, v, c) PLATE:PrepareVehicle(p, v) end)
hook.Add("VC_CD_spawnedVehicle", "ll_plates::OnVehicleSpawn", function(p, e, t)
	if t then return end
	PLATE:PrepareVehicle(p, e)
end)
PLATE:DebugPrint("Prepare Hooks.")

LL_PLATES_SYSTEM = PLATE

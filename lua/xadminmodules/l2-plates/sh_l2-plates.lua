--[[-- License Plate XAdmin Integration
@copyright 2020 Limelight Gaming
@release development
@author John Internet
@module xAdmin
--]]--

local q = sql.Query
local e = sql.SQLStr
local l = LL_PLATES_SYSTEM.Language
local f = Format

xAdmin.RegisterCategory("plates", "L² Plates")

xAdmin.RegisterCommand("getplate", "Get Plate", function(tgt, ply)
	local vehs = list.Get("Vehicles")

	if not isstring(tgt) then tgt = tgt:SteamID() end
	local plates = q(f("SELECT * FROM ll_plates WHERE steamid=%s", e(tgt)))

	for i, plate in ipairs(plates) do
		local veh = vehs[plate.vehicle]
		plates[i].sort = (veh and "1" or "0") .. "_" .. (veh and veh.Name or plate.vehicle)
		plates[i].value = Format("%s: '%s'", veh and veh.Name or plate.vehicle, plate.plate)
	end

	for _, plate in SortedPairsByMemberValue(plates, "sort") do
		if IsValid(ply) then
			ply:PrintMessage(HUD_PRINTCONSOLE, plate.value)
		else
			print(plate.value)
		end
	end

	if IsValid(ply) then xAdmin.Notify(ply, xAdmin.NotificationSUCCESS, l("xadmin.found", {count = #plates, steamid = tgt})) end

	return true
end, "plates", {{"Player", "User"}}, "<User>", "Fetches license plates for a given user.")

xAdmin.RegisterCommand("searchplate", "Search Plate", function(tgt, ply, args)
	local plate = args[1]
	if not plate then
		if IsValid(ply) then
			xAdmin.Notify(ply, xAdmin.NotificationERROR, l("xadmin.missarg", {arg = "plate"}))
		else
			print(l("xadmin.missarg", {arg = "plate"}))
		end
		return false
	end

	local vehs = list.Get("Vehicles")
	local plates = q(f("SELECT * FROM ll_plates WHERE plate=%s", e(plate)))

	if plates and #plates == 0 then
		if IsValid(ply) then
			xAdmin.Notify(ply, xAdmin.NotificationSUCCESS, l("xadmin.nomatch", {plate = plate}))
		else
			print(l("xadmin.nomatch", {plate = plate}))
		end
		return true
	end

	plate = plates[1]
	local veh = vehs[plate.vehicle]
	plate = l("xadmin.match", {plate = plate.plate, steamid = plate.steamid, car = veh and veh.Name or plate.vehicle})

	if IsValid(ply) then
		xAdmin.Notify(ply, xAdmin.NotificationSUCCESS, plate)
	else
		print(plate)
	end

	return true
end, "plates", {{"String", "License Plate"}}, "<License Plate>", "Searches for a license plate's owner.", true)

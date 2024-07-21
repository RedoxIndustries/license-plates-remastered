AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" ) 
include('shared.lua')

util.AddNetworkString("ll_plates::change_menu")

function ENT:Initialize()
	self:SetModel("models/Humans/Group01/Male_06.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_IDLE)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE or CAP_TURN_HEAD)
	self:SetUseType(SIMPLE_USE)
	self:SetMaxYawSpeed(90)
end

function ENT:OnTakeDamage() return false end

function ENT:AcceptInput(n, a, c)
	if n == "Use" and IsValid(c) and c:IsPlayer() then
		if LL_PLATES_SYSTEM.Config.LimitPlateChangesToGroup then
			local grp = c:GetUserGroup()
			if not LL_PLATES_SYSTEM.Config.PlateChangeGroups[grp] then
				c:ChatPrint("You don't have the right rank to change your license plate.")
				return
			end
		end

		local v = LL_PLATES_SYSTEM:GetChosenVehicle(c, false)
		if not IsValid(v) then
			c:ChatPrint("You must have a vehicle out to change your license plate.")
			return
		end

		net.Start("ll_plates::change_menu")
		net.WriteEntity(v)
		net.Send(c)
	end
end

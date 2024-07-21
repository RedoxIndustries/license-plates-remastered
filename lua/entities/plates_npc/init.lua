--[[-- License Seller NPC
@copyright 2020 Limelight Gaming
@release development
@author John Internet
@classmod Plates_NPC
@alias ENT
--]]--

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("ll_plates::npc_menu")

--- Prepare the entity for use.
-- @state server
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

--- Hook function called when damage is sent.
-- @state server
-- @treturn boolean If the entity should take damage.
function ENT:OnTakeDamage() return false end

--- Called when an input is sent.
-- @state server
-- @string n The name of the sent input.
-- @ent a Direct activator.
-- @ent c Primary caller.
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

		net.Start("ll_plates::npc_menu")
		net.WriteEntity(v)
		net.Send(c)
	end
end
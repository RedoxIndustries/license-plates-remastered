AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/w4nou/l2_plaque_immatriculation_petite.mdl" )
    self:PhysicsInit( SOLID_NONE )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_NONE )
    self:SetUseType( SIMPLE_USE )

    local phys = self:GetPhysicsObject()

    if IsValid( phys ) then
        phys:Wake()
    end
end
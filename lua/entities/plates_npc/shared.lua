--[[-- License Seller NPC
@copyright 2020 Limelight Gaming
@release development
@author John Internet
@classmod Plates_NPC
@alias ENT
--]]--

--- The entity base used.
-- @field[type=string] ENT.Base
-- @state shared
ENT.Base = "base_ai"

--- The type of entity.
-- @field[type=string] ENT.Type
-- @state shared
ENT.Type = "ai"

--- If frames are automatically advanced.
-- @field[type=boolean] ENT.AutomaticFrameAdvance
-- @state shared
ENT.AutomaticFrameAdvance = true

--- Client spawn name.
-- @field[type=string] ENT.PrintName
-- @state shared
ENT.PrintName = "License Plate NPC"

--- Author's name.
-- @field[type=string] ENT.PrintName
-- @state shared
ENT.Author = "Doctor Internet"

--- Author's contact.
-- @field[type=string] ENT.Contact
-- @state shared
ENT.Contact = ""

--- Fluff text
-- @field[type=string] ENT.Purpose
-- @state shared
ENT.Purpose = "Selling custom places."

--- Fluff text
-- @field[type=string] ENT.Instructions
-- @state shared
ENT.Instructions = "Press E, do the menu."

--- If the ent can be spawned by admins.
-- @field[type=boolean] ENT.AdminSpawnable
-- @state shared
ENT.AdminSpawnable = false

--- If the ent can be spawned.
-- @field[type=boolean] ENT.Spawnable
-- @state shared
ENT.Spawnable = true

--- Setter for AutomaticFrameAdvance
-- @function ENT:SetAutomaticFrameAdvance
-- @bool bUsingAnim If the entity is uses animations.
-- @state shared
AccessorFunc(ENT, "AutomaticFrameAdvance", "AutomaticFrameAdvance", FORCE_BOOL)

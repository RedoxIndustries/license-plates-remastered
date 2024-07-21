--[[-- Bootstrap Loader.
@copyright 2020 Limelight Gaming
@release development
@author John Internet
@module Bootstrap
--]]--

if SERVER then
	include("ll_plates/sv_init.lua")
	AddCSLuaFile("ll_plates/sh_init.lua")
	AddCSLuaFile("ll_plates/cl_init.lua")
else
	include("ll_plates/cl_init.lua")
end

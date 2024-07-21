--[[-- License Plate Language Handler
@copyright 2020 Limelight Gaming
@release development
@author John Internet
@classmod lang
--]]--
AddCSLuaFile()

local lang = {}
lang.__index = lang

function lang:__call(key, phrase)
	self.stored[key or "#"] = (phrase or "?")
end

local plural = include("sh_plural.lua")
function lang:NewPlural()
	return setmetatable({parent = self}, plural)
end

function lang:Plural(...)
	self:NewPlural()
		:Set(...)
		:Register()
end

function lang:RegisterPlural(newPlural)
	self.plurals[newPlural.id] = newPlural
end

function lang:Register()
	self.parent:Register(self)
end

return lang

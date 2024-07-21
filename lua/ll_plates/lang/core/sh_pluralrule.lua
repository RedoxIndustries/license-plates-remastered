--[[-- License Plate Language Handler
@copyright 2020 Limelight Gaming
@release development
@author John Internet
@classmod rule
--]]--
AddCSLuaFile()

local rule = {}
rule.__index = rule

function rule:Add(check)
	table.insert(self.rules, check)
	return self
end
rule.__call = rule.Add

function rule:Check(num)
	for i, check in ipairs(self.rules) do
		if isfunction(check) and check(num) then
			return i
		elseif istable(check) and check[num] then
			return i
		elseif isnumber(check) and check == num then
			return i
		elseif isbool(check) and check then
			return i
		end
	end
	return #self.rules + 1
end

function rule:Register()
	self.parent:RegisterPluralRule(self)
end

return rule
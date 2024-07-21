--[[-- License Plate Language Handler
@copyright 2020 Limelight Gaming
@release development
@author John Internet
@module PLATE.Language
@alias lang
--]]--
AddCSLuaFile()

local PLATE = PLATE_SHARED
PLATE.Language = PLATE.Language or {}

local lang = {}
lang.__index = lang


--- Get a given key for a binding.
-- @string bind The bind (ex: +use) to search for.
-- @string[opt] default Fallback value to display if no bind is found.
function lang.GetKey(bind, default)
	if not bind then return default end
	if bind == "" then return default end

	local b = input.LookupBinding(bind)
	if not b then
		return default
	end

	return b:upper()
end

--- Check if a language code exists.
-- @string code Language code.
-- @treturn bool If the language code exists.
function lang:Exists(code)
	return self.stored[code] ~= nil
end

--- Check if a language phrase exists.
-- @string code Language code.
-- @string key Phrase key.
-- @treturn bool If the phrase exists within the language.
function lang:PhraseExists(code, key)
	return self:Exists(code) and self.stored[code].stored[key] ~= nil
end

--- Adds an empty language.
-- @string code Language code to register under.
function lang:AddLanguage(code)
	self.stored[code] = self.stored[code] or {}
end

--- Add a phrase to a language.
-- @string code Language code.
-- @string key Unique locisation key.
-- @string phrase Localised phrase.
function lang:AddPhrase(code, key, phrase)
	if not self:Exists(code) then
		self:AddLanguage(code)
	end

	self.stored[code][key] = phrase
end

--- Get a language with a given code.
-- @string code Language code.
-- @treturn lang
function lang:GetLanguage(code)
	if not self:Exists(code) then
		self:AddLanguage(code)
	end

	return self.stored[code]
end

--- Get a phrase from a language.
-- @string code Language code.
-- @string key Unique localisation key.
-- @treturn ?string Localised string.
function lang:GetLanguagePhrase(code, key)
	if not self:PhraseExists(code, key) then
		return
	end

	return self.stored[code].stored[key]
end

--- Check if a language phrase exists.
-- @string code Language code.
-- @string key Phrase key.
-- @treturn bool If the phrase exists within the language.
function lang:PluralExists(code, key)
	return self:Exists(code) and self.stored[code].plurals[key] ~= nil
end

--- Get a plural from a language.
-- @string code Language code.
-- @string key Unique localisation key.
-- @treturn ?plural Plural
function lang:GetLanguagePlural(code, key)
	if not self:PluralExists(code, key) then
		return
	end

	return self.stored[code].plurals[key]
end

--- Get a localised version of a string.
-- @string code Language code to fetch for.
-- @string key Phrase key to fetch.
-- @string[opt] fallback Fallback language key if the phrase doesn't exist here.
function lang:Localise(code, key, fallback)
	local phrase = self:GetLanguagePhrase(code, key)
	if not phrase then
		phrase = self:GetLanguagePhrase(fallback, key)
	end

	return phrase
end

--- Get a localised version of a plural.
-- @string code Language code to fetch for.
-- @string key Plural key to fetch.
-- @string[opt] fallback Fallback language key if the plural doesn't exist here.
function lang:LocalisePlural(code, key, fallback)
	local plural = self:GetLanguagePlural(code, key)
	if not plural then
		plural = self:GetLanguagePlural(fallback, key)
	end

	return plural
end

function lang:GeneratePlural(code, key, fallback, num)
	local plural = self:LocalisePlural(code, key, fallback)
	if plural then
		return plural:Check(num)
	end

	return "??"
end

function lang:Interpolate(str, data, code, fallback)
	if not data then data = {} end

	local old = str
	local pattern = "{{([%w|.]+)}}"
	local substr = str:match(pattern)
	while substr do
		local plr, var = substr:match("(%w+)|(%w+)")
		if plr and var then
			var = tonumber(data[var] or 1) or 1
			str = str:gsub("{{" .. substr .. "}}", self:GeneratePlural(code, plr, fallback, var))
		elseif data[substr] then
			str = str:gsub("{{" .. substr .. "}}", data[substr])
		else
			local phrase = self:Localise(code, substr, fallback)
			if phrase then
				str = str:gsub("{{" .. substr .. "}}", phrase)
			else
				str = str:gsub("{{" .. substr .. "}}", "??")
			end
		end

		if old == str then
			break
		end
		old = str
		substr = str:match(pattern)
	end

	return str
end

function lang.GetLanguage()
	return cvars.String("gmod_language")
end

function lang.GetFallback()
	return "en"
end

function lang:Register(iLang)
	iLang.pluralRule = self:GetPluralRule(iLang.pluralRuleID)
	self.stored[iLang.code] = iLang
end

function lang:__call(key, data)
	local code, fallback = self.GetLanguage(), self.GetFallback()
	local phrase

	phrase = self:Localise(code, key, fallback)
	if not phrase then
		ErrorNoHalt("Missing key " .. key .. " in languages " .. code .. " and " .. fallback .. "!\n")
		return "<ERR:" .. key .. ">"
	end
	phrase = self:Interpolate(phrase, data, code, fallback)

	return phrase
end

local iLang = include("lang/core/sh_language.lua")
function lang:New(code, pluralRuleID)
	if not code then
		code = debug.getinfo(2, "S").short_src:match("lua/ll_plates/lang/sh_(.*?).lua$")
	end
	if not code then
		error("Attempted to create language but no language code was provided or inferred.")
		return
	end

	return setmetatable({code = code, stored = {}, parent = self, pluralRuleID = pluralRuleID, plurals = {}}, iLang)
end

local rule = include("lang/core/sh_pluralrule.lua")
function lang:NewPluralRule(id)
	if not id then
		-- TODO: Fix dis
		id = tonumber(debug.getinfo(2, "S").short_src:match("lua/ll_plates/lang/core/rules/sh_([^/]?).lua$"))
	end
	if not id then
		error("Attempted to create plural rule but no rule id was provided or inferred.")
		return
	end

	return setmetatable({parent = self, rules = {}, id = id}, rule)
end
function lang:RegisterPluralRule(newRule)
	self.rules[newRule.id] = newRule
end
function lang:GetPluralRule(id)
	return self.rules[id]
end

PLATE.Language = setmetatable({stored = {}, rules = {}}, lang)

AddCSLuaFile("lang/core/rules.lua")
include("lang/core/rules.lua")
print("Including Plural Rule File")

local files = file.Find("ll_plates/lang/*.lua", "LUA")
for _, f in pairs(files) do
	AddCSLuaFile("lang/" .. f)
	include("lang/" .. f)
	print("Including Language File: " .. f)
end

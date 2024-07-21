--[[-- License Plate Misc Configs
@copyright 2020 Limelight Gaming
@release 3.9.0
@author John Internet
@module PLATE.Config
--]]--

local PLATE = PLATE_SHARED

--- General Settings
-- @section general

--- The default format for the license plate.
-- @field[type=string] PLATE.Config.DefaultFormat
PLATE.Config.DefaultFormat = "%s%s-%i%i%i-%s%s"

--- The symbol to use for currency.
-- @field[type=string] PLATE.Config.CurrencySymbol
PLATE.Config.CurrencySymbol = "€"

--- If custom plates are allowed.
-- @field[type=boolean] PLATE.Config.AllowChanges
PLATE.Config.AllowChanges = true

--- If custom plates for emergency vehicles are allowed.
-- @field[type=boolean] PLATE.Config.AllowEmergencyChanges
PLATE.Config.AllowEmergencyChanges = false

--- If a player has an arrest warrant, disallow them to change their plate.
-- @field[type=boolean] PLATE.Config.DisallowArrestChanges
PLATE.Config.DisallowArrestChanges = false

--- If the plate seller NPC should have text above them.
-- @field[type=boolean] PLATE.Config.NPCHeadText
PLATE.Config.NPCHeadText = false

--- Time in seconds between changes.
-- @field[type=integer] PLATE.Config.Delay
PLATE.Config.Delay = 10

--- Distance in source units for which the license plates fade out.
-- @field[type=integer] PLATE.Config.FadeDist
PLATE.Config.FadeDist = 2500

--- Distance in source units for which you can change your plate.
-- @field[type=integer] PLATE.Config.MaxDist
PLATE.Config.MaxDist = 500

--- Cost to change the license plate for a vehicle.
-- @field[type=integer] PLATE.Config.Cost
PLATE.Config.Cost = 2000

--- Cost to change the license plate for a vehicle.
-- @field[type=integer] PLATE.Config.Cost
PLATE.Config.CostRandom = 1000

--- Bind F3 to open the menu if pressed whilst looking at a vehicle.
-- @field[type=boolean] PLATE.Config.BindF3
PLATE.Config.BindF3 = false

--- Maximum length of a license plate. Up to 8 is supported by default.
-- @field[type=integer] PLATE.Config.MaxLength
PLATE.Config.MaxLength = 9


--- Material Configs
-- @section material

--- Path to the plate textures.
-- @field[type=string] PLATE.Config.Path
PLATE.Config.Path = "ll_plates/"

--- Version of the plates to use.
-- @field[type=string] PLATE.Config.Version
PLATE.Config.Version = "2"
--- The default license plate, if none other is selected.
-- @field[type=string] PLATE.Config.DefaultPlate
PLATE.Config.DefaultPlate = "plaque-immatriculation-75.png"


--- Plate Configs
-- @section plate

--- Width of plate at scale 1.
-- @field[type=integer] PLATE.Config.WidthScale
PLATE.Config.WidthScale = 1250

--- Height of plate at scale 1.
-- @field[type=integer] PLATE.Config.HeightScale
PLATE.Config.HeightScale = 300

--- The default colour for plate text, if no other colour is defined.
-- @field[type=Color] PLATE.Config.DefaultColour
PLATE.Config.DefaultColour = Color(0, 0, 0, 255)

--- Decimal to darken the plate by. (0 <=> 1)
--- @field[type=float] PLATE.Config.PlateDarken
PLATE.Config.PlateDarken = 0.9

--- The header text to display over the plate.
-- @field[type=string] PLATE.Config.HeaderText
PLATE.Config.HeaderText = ""

--- If plates should be hidden if behind a prop.
-- @field[type=boolean] PLATE.Config.BlockedHide
PLATE.Config.BlockedHide = false

--- Exempt Plate Settings
-- @section exempt

--- If we should parse VCMod Data to check emergency vehicles.
-- @field[type=boolean] PLATE.Config.ParseVCEmergency
PLATE.Config.ParseVCEmergency = false

--- Vehicle Categories / vehicle IDs which are deemed "emergency" vehicles, and get exempt plates.
-- @field[type=table] PLATE.Emergency
PLATE.Emergency = {}
PLATE.Emergency["LW Emergency Vehicles"] = true
PLATE.Emergency["TDM Emergency"] = true
PLATE.Emergency["Emergency Vehicles"] = true
PLATE.Emergency["2016 Ford Police Interceptor Utility"] = true
PLATE.Emergency["h2talambu"] = true
PLATE.Emergency["perryn_ford_f550_ambulance"] = true
PLATE.Emergency["perryn_lenco_bearcat"] = true
PLATE.Emergency["17raptor_cop_sgm"] = true
PLATE.Emergency["perryn_american_laddertruck"] = true
PLATE.Emergency["perryn_pierce_arrow_xt"] = true
PLATE.Emergency["perryn_cadillac_dts_limousine"] = true
PLATE.Emergency["bus"] = true
PLATE.Emergency["perryn_rescue_truck"] = true
PLATE.Emergency["bustdm"] = true
PLATE.Emergency["forcrownvicpoltdm"] = true
PLATE.Emergency["Dodge Charger 2015 Pursuit"] = true
PLATE.Emergency["bmw_530d_touring_pol_lw"] = true
PLATE.Emergency["bmw_x5_48i_pol_lw"] = true
PLATE.Emergency["chev_impala_09_police"] = true
PLATE.Emergency["chev_suburban_pol"] = true
PLATE.Emergency["dodge_charger_2015_police_lw"] = true
PLATE.Emergency["dodge_monaco_police_lw"] = true
PLATE.Emergency["perryn_american_laddertruck"] = true
PLATE.Emergency["perryn_american_lafrance"] = true
PLATE.Emergency["perryn_cadillac_dts_limousine"] = true
PLATE.Emergency["perryn_pierce_arrow_xt"] = true
PLATE.Emergency["perryn_ford_f150"] = true
PLATE.Emergency["perryn_ford_f550_ambulance"] = true
PLATE.Emergency["perryn_lenco_bearcat"] = true
PLATE.Emergency["perryn_pierce_pumper"] = true
PLATE.Emergency["perryn_rescue_truck"] = true
PLATE.Emergency["17raptor_cop_sgm"] = true
PLATE.Emergency["charger12poltdm"] = true
PLATE.Emergency["chargersrt8poltdm"] = true
PLATE.Emergency["forcrownvicpoltdm"] = true
PLATE.Emergency["for_crownvic_fh3tdm"] = true
PLATE.Emergency["fortauruspoltdm"] = true
PLATE.Emergency["hsvw427poltdm"] = true
PLATE.Emergency["lex_is300poltdm"] = true
PLATE.Emergency["mereclasspoltdm"] = true
PLATE.Emergency["mitsuevoxpoltdm"] = true
PLATE.Emergency["scaniafiretdm"] = true
PLATE.Emergency["sm_charpursuit15"] = true
PLATE.Emergency["Super's Emergency Cars"] = true

--- Vehicle Names which are in "emergency" categories, but shouldn't get plates.
-- @field[type=table] PLATE.Config.EmergOverride
PLATE.EmergOverride = {}
PLATE.EmergOverride["dodge_charger_2015_undercover_lw"] = true
PLATE.EmergOverride["Dodge Charger 2015 Undercover"] = true
PLATE.EmergOverride["jag_xfr_pol_und"] = true
PLATE.EmergOverride["smc_mustang_gp_15"] = true


--- Colours and Dates
-- @section colordate
local p = PLATE.Config.Path
local ve = PLATE.Config.Version
local pv = p .. ve

--- List of plate paths and their colours.
-- @field[type=table] PLATE.Colours
PLATE.Colours = {}
PLATE.Colours[p .. PLATE.Config.DefaultPlate] = Color(38, 50, 56)
PLATE.Colours[p .. "plaque-immatriculation-75.png"] = Color(178, 47, 47)
PLATE.Colours[pv .. "plaque-immatriculation-75.png"] = Color(25, 25, 25)
PLATE.Colours[pv .. "plaque-immatriculation-75.png"] = Color(233, 233, 233)
PLATE.Colours[pv .. "plaque-immatriculation-75.png"] = Color(233, 233, 233)
PLATE.Colours[pv .. "plaque-immatriculation-75.png"] = Color(25, 25, 25)
PLATE.Colours[pv .. "plaque-immatriculation-75.png"] = Color(25, 25, 25)
PLATE.Colours[pv .. "plaque-immatriculation-75.png"] = Color(24, 24, 24, 0)

--- List of Plates by Month / Day
-- @field[type=table] PLATE.Months
PLATE.Months = {}
PLATE.Months["03"] = "plaque-immatriculation-75.png"
PLATE.Months["04"] = PLATE.Months["03"]
PLATE.Months["05"] = PLATE.Months["03"]
PLATE.Months["06"] = "plaque-immatriculation-75.png"
PLATE.Months["07"] = PLATE.Months["06"]
PLATE.Months["08"] = PLATE.Months["06"]
PLATE.Months["09"] = "plaque-immatriculation-75.png"
PLATE.Months["10"] = PLATE.Months["09"]
PLATE.Months["11"] = PLATE.Months["09"]
-- Special Case Here, since we break down by days.
PLATE.Months["12"] = {}
for i = 1, 23 do
	local str = i
	if i < 10 then str = "0" .. str end
	PLATE.Months["12"][str] = "plaque-immatriculation-75.png"
end
PLATE.Months["12"]["24"] = "plaque-immatriculation-75.png"
PLATE.Months["12"]["25"] = "plaque-immatriculation-75.png"
PLATE.Months["12"]["default"] = "plaque-immatriculation-75.png"
PLATE.Months["01"] = PLATE.Months["12"]["default"]
PLATE.Months["02"] = PLATE.Months["12"]["default"]

--- General Settings
-- @section general

--- Whether the system will do debug prints.
-- @field[type=boolean] DoDebugPrints
PLATE.Config.DoDebugPrints = false

--- Set to true if only certain groups are allowed to change their license plates.
-- @field[type=boolean] LimitPlateChangesToGroup
PLATE.Config.LimitPlateChangesToGroup = false

--- The list of groups which are allowed to change their plates.
-- @field[type=table] PlateChangeGroups
PLATE.Config.PlateChangeGroups = {
	-- ["Group Name"] = true, -- If the group name has weird characters
	-- groupname = true, -- If it doesn't.
	SuperAdmin = true,
	Admin = true,
	superadmin = true,
	admin = true
}

local l = PLATE_SHARED.Language:New("en", 1)

-- data interpolation: {{var}}
-- plural interpolation {{pluralid|var}} (numeric var)
-- template interpolation: {{template}}
-- priority: plural > data > template

l("cancel", "Cancel")

l:Plural("sec", "second", "seconds")
l:Plural("char", "character", "characters")
l:Plural("plate", "plate", "plates")

l("dmv.header", "Register for a Custom Plate")
l("dmv.body", [[Please enter your custom plate ({{max}} {{char|max}})
Spaces, Dashes, Numbers and Letters are allowed.

Example: SC-021-LJ
This will cost: {{dollar}}{{cost}}.]])
l("dmv.buy", "Buy Plates")

l("xadmin.found", "Found {{count}} license {{plate|count}} for {{steamid}}. Printed to console.")
l("xadmin.missarg", "Missing argument '{{arg}}'")
l("xadmin.nomatch", "No plates match '{{plate}}'")
l("xadmin.match", "Found '{{plate}}', links to '{{steamid}}' on '{{car}}'")

l("menu.fail.build", "You cannot change your license plates on the build server.")
l("menu.fail.disabled", "License plate changes are disabled.")
l("menu.fail.disabled-emergency", "License plate changes are disabled for emergency vehicles.")
l("menu.fail.rank", "You don't have the right rank to change your license plates.")
l("menu.fail.cooldown", "You have {{time}} {{sec|time}} left before you can change your license plate again.")
l("menu.fail.distance", "You are too far away from your vehicle to change the plate.")

l("menu.fail.cost", "You don't have the {{dollar}}{{cost}} required to purchase a custom plate.")

-- Right, so this bit looks confusing.
-- Don't worry.
-- {{reason}} is replaced by EITHER menu.fail.length or menu.fail.chars.
-- In .length, {{boundary}} is replaced by either max or min
-- So, menu.fail, using .length and min with a minimum of 1.
-- Invalid License Plate! {{reason}} ->
-- Invalid License Plate! {{menu.fail.length}} ->
-- Invalid License Plate! {{boundary}} length is {{length}} {{char|length}}.
-- Invalid License Plate! Minimum length is 1 character.
l("menu.fail", "Invalid License Plate! {{reason}}")
l("menu.fail.length", "{{boundary}} length is {{length}} {{char|length}}.")
l("max", "Maximum")
l("min", "Minimum")
l("menu.fail.chars", "Only spaces, dashes, numbers and letters allowed.")
l("menu.fail.unowned", "You do not own this vehicle.")
l("menu.fail.dupe", "License plate already in use.")
l("menu.success", "Thank you for purchasing your custom plate.")

l:Register()
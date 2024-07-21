local l = PLATE_SHARED.Language:New("de", 1)

-- data interpolation: {{var}}
-- plural interpolation {{pluralid|var}} (numeric var)
-- template interpolation: {{template}}
-- priority: plural > data > template

l("cancel", "Abbrechen")

l:Plural("sec", "Sekunde", "Sekunden")
l:Plural("char", "Zeichen", "Zeichen")
l:Plural("plate", "Nummernschild", "Nummernschilder")

l("dmv.header", "Registriere Dein persönliches Nummernschild")
l("dmv.body", [[Nummernschild hier eingeben (max {{max}} {{char|max}})
Ziffern, Buchstaben, sowie Leerzeichen und Striche sind erlaubt.

Beispiel: LL-2018
Kosten: {{dollar}}{{cost}}.]])
l("dmv.buy", "Registrieren")

l("xadmin.found", "Es wurden {{count}} {{plate|count}} gefunden für: {{steamid}}. Dies wurde in die Konsole kopiert.")
l("xadmin.missarg", "Fehlende Eingabe: '{{arg}}'")
l("xadmin.nomatch", "Es gab keine Übereinstimmung mit dem Nummernschild '{{plate}}'")
l("xadmin.match", "Nummernschild '{{plate}}' in Datenbank gefunden. Es gehört '{{steamid}}' mit folgendem Fahrzeug: '{{car}}'")

l("menu.fail.build", "Du kannst Dein Nummernschild auf dem Build Server nicht ändern.")
l("menu.fail.disabled", "Änderungen für Nummernschilder sind deaktiviert.")
l("menu.fail.disabled-emergency", "Änderungen für Nummernschilder sind an Einsatzfahrzeugen deaktiviert.")
l("menu.fail.rank", "Du verfügst nicht über die nötigen Berechtigungen um Dein Nummernschild zu ändern.")
l("menu.fail.cooldown", "Du musst {{time}} {{sec|time}} warten, bevor Du Dein Nummernschild erneut ändern kannst.")
l("menu.fail.distance", "Du bist zu weit von Deinem Fahrzeug entfernt, um das Nummernschild zu ändern.")

l("menu.fail.cost", "Du verfügst nicht über die geforderten {{dollar}}{{cost}}, um ein benutzerdefiniertes Nummernschild zu erwerben.")
l("menu.fail", "Ungültiges Nummernschild! {{reason}}")
l("menu.fail.length", "Die {{boundary}} Länge beträgt {{length}} {{char|length}}.")
l("max", "maximale")
l("min", "minimale")
l("menu.fail.chars", "Nur Ziffern, Buchstaben, sowie Leerzeichen und Striche sind erlaubt.")
l("menu.fail.unowned", "Dir gehört dieses Fahrzeug nicht.")
l("menu.fail.dupe", "Dieses Nummernschild ist bereits vergeben.")
l("menu.success", "Danke, dass Du Dich für den Kauf eines eigenen Nummernschildes entschieden hast.")

PLATE_SHARED.Language:Register(l)
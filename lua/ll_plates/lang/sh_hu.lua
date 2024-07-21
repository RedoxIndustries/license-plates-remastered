local l = PLATE_SHARED.Language:New("hu", 1)

l("cancel", "Megszakítás")

l:Plural("sec", "másodperc", "másodpercek")
l:Plural("char", "karakter", "karakterek")
l:Plural("plate", "rendszámtábla", "rendszámtáblák")

l("dmv.header", "Regisztrálj egy egyéni rendszámért")
l("dmv.body", [[Írd be az egyéni rendszámodat (max {{max}} karakter)
Szóközök, Kötőjelek, Számok és Betűk használhatóak.

Például: LL-2018
Ennek az ára: {{dollar}}{{cost}}.]])
l("dmv.buy", "Vásárolj rendszámokat")

l("xadmin.found", "A rendszer {{count}} rendszámot talált {{steamid}} ID alatt. Az eredmények a console-ban találhatóak.")
l("xadmin.missarg", "Hiányzó paraméter '{{arg}}'")
l("xadmin.nomatch", "Nem található egyezés '{{plate}}'")
l("xadmin.match", "Egyezés található a '{{plate}}' rendszámhoz. Tulajdonos: '{{steamid}}', jármű: '{{car}}'")

l("menu.fail.build", "Nem tudod megváltoztatni a rendszámodat a build serveren.")
l("menu.fail.disabled", "A rendszámtábla változtatása ki van kapcsolva.")
l("menu.fail.disabled-emergency", "A rendszámtábla változtatása ki van kapcsolva a megkülönböztetett járművek számára.")
l("menu.fail.rank", "Nincsen megfelelő rangod a rendszámtábla megváltoztatására.")
l("menu.fail.cooldown", "Még {{time}} {{sec|time}} van hátra mielőtt a rendszámtábládat újra meg tudnád változtatni.")
l("menu.fail.distance", "Túl távol vagy a járműtől a rendszám megváltoztatásához.")
l("menu.fail.cost", "Nincsen {{dollar}}{{cost}} összeged, hogy személyreszabott rendszámot tudjál vásárolni.")

l("menu.fail", "Helytelen rendszámtábla! {{reason}}")
l("menu.fail.length", "{{boundary}} hossz: {{length}} {{char|length}}.")
l("max", "Maximum")
l("min", "Minimum")
l("menu.fail.chars", "Csak szóközök, kötőjelek, számok és betűk engedélyezettek.")
l("menu.fail.unowned", "Ez a jármű nem a te tulajdonod.")
l("menu.fail.dupe", "Ez a rendszám már használatban van.")
l("menu.success", "Köszönjük, hogy egyéni rendszámot vásárolt.")

l:Register()
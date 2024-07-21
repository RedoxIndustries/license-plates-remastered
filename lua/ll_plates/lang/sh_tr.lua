local l = PLATE_SHARED.Language:New("tr", 1)

-- data interpolation: {{var}}
-- plural interpolation {{pluralid|var}} (numeric var)
-- template interpolation: {{template}}
-- priority: plural > data > template

l("cancel", "İptal")

l:Plural("sn", "saniye", "saniyeler")
l:Plural("kar", "karakter", "karakterler")
l:Plural("plaka", "plaka", "plakalar")

l("dmv.header", "Özel bir plaka için başvur")
l("dmv.body", [[Lütfen özel plakanızı yazın (max {{max}} {{char|max}})
boşluk, kesik çizgiler, numaralar ve harfler yer alabilir.

Example: LL-2018
This will cost: {{dollar}}{{cost}}.]])
l("dmv.buy", "Plaka Al")

l("xadmin.found", "{{steamid}} için {{count}} tane araba {{plate|count}} bulundu. Konsola yazıldı.")
l("xadmin.missarg", "Eksik argüman '{{arg}}.'")
l("xadmin.nomatch", "'{{plate}}' ile eşleşen plaka yok.")
l("xadmin.match", "'{{car}}' aracında '{{steamid}}'a bağlı '{{plate}}' plakası bulundu.")

l("menu.fail.build", "İnşaat sunucusunda araç plakasını değiştiremezsin.")
l("menu.fail.disabled", "Araç plakaları devre dışı.")
l("menu.fail.disabled-emergency", "Acil durum araçları için araç plakaları devre dışı.")
l("menu.fail.rank", "Aracının plakasını değiştirmek için gerekli rütbeye sahip değilsin.")
l("menu.fail.cooldown", "Araç plakanı tekrar değiştirebilmene {{time}} {{sec|time}} kaldı.")
l("menu.fail.distance", "Araç plakanı değiştirebilmek için uzaktasın.")

l("menu.fail.cost", "Özel plaka satın almak için yeterli paraya {{dollar}}{{cost}} sahip değilsin.")
l("menu.fail", "Geçersiz Plaka! {{reason}}")
l("menu.fail.length", "{{boundary}} uzunluk {{length}} {{char|length}}.")
l("max", "Maximum")
l("min", "Minimum")
l("menu.fail.chars", "Sadece boşluklar, kesik çizgiler, numaralar ve harfler yer alabilir.")
l("menu.fail.unowned", "Bu araca sahip değilsiniz.")
l("menu.fail.dupe", "Plaka zaten kullanımda.")
l("menu.success", "Özel plaka satın aldığınız için teşekkür ederiz.")

l:Register()
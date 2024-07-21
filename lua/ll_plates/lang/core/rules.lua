-- Asian (Chinese, Japanese, Korean), Persian, Turkic/Altaic (Turkish), Thai, Lao
PLATE_SHARED.Language:NewPluralRule(0):Register()

-- Germanic (Danish, Dutch, English, Faroese, Frisian, German, Norwegian, Swedish), Finno-Ugric (Estonian, Finnish, Hungarian)
-- Language isolate (Basque), Latin/Greek (Greek), Semitic (Hebrew), Romanic (Italian, Portuguese, Spanish, Catalan), Vietnamese
PLATE_SHARED.Language:NewPluralRule(1)
	:Add(1)
	:Register()

-- Romanic (French, Brazilian Portuguese), Lingala
PLATE_SHARED.Language:NewPluralRule(2)
	:Add({[0] = true, [1] = true})
	:Register()

-- Baltic (Latvian, Latgalian)
PLATE_SHARED.Language:NewPluralRule(3)
	:Add(function(num) return tostring(num):sub(-1) == "0" end)
	:Add(function(num) return num ~= 11 and tostring(num):sub(-1) == "1" end)
	:Register()

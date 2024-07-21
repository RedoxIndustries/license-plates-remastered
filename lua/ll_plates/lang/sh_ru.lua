local l = PLATE_SHARED.Language:New("ru")

l("greeting", "Привет")
l("test", "{greeting}, {{name}}")

l("cancel", "Отмена")

l("dmv.header", "Зарегестрировать Автомобильный Номер")
l("dmv.body", [[Введите Номер (максимум {{max}} символов)
Пробелы, Дефисы, Цифры, и Буквы разрешены.

Например: LL-2018
Цена: {{dollar}}{{cost}}.]])
l("dmv.buy", "Купить Автомобильный Номер")

l("xadmin.found", "Найдено {{count}} номеров для {{steamid}}. Напечатано в консоль.")
l("xadmin.missarg", "Не найден параметр '{{arg}}'")
l("xadmin.nomatch", "Не найдено совпадений с '{{plate}}'")
l("xadmin.match", "Найден номер '{{plate}}', связан с '{{steamid}}' на машине '{{car}}'")

PLATE_SHARED.Language:Register(l)
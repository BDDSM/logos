﻿//////////////////////////////////////////////////////////////////////
//
// Fluent-API для описания пакета
//
//////////////////////////////////////////////////////////////////////

Перем мСвойстваПакета;
Перем мЗависимости;
Перем мМодули;
Перем мВключаемыеФайлы;
Перем мИсполняемыеФайлы;

Перем ТипыМодулей Экспорт;

//////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Функция Имя(Знач Параметр) Экспорт
	УстановитьСвойствоПакета("Имя", Параметр);
	Возврат ЭтотОбъект;
КонецФункции

Функция Версия(Знач Параметр) Экспорт
	УстановитьСвойствоПакета("Версия", Параметр);
	Возврат ЭтотОбъект;
КонецФункции

Функция Автор(Знач Параметр) Экспорт
	УстановитьСвойствоПакета("Автор", Параметр);
	Возврат ЭтотОбъект;
КонецФункции

Функция Описание(Знач Параметр) Экспорт
	УстановитьСвойствоПакета("Описание", Параметр);
	Возврат ЭтотОбъект;
КонецФункции

Функция АдресАвтора(Знач Параметр) Экспорт
	УстановитьСвойствоПакета("АдресАвтора", Параметр);
	Возврат ЭтотОбъект;
КонецФункции

Функция ВерсияСреды(Знач Параметр) Экспорт
	УстановитьСвойствоПакета("ВерсияСреды", Параметр);
	Возврат ЭтотОбъект;
КонецФункции

Функция ТочкаВхода(Знач Параметр) Экспорт
	УстановитьСвойствоПакета("ТочкаВхода", Параметр);
	Возврат ЭтотОбъект;
КонецФункции

Функция Свойства() Экспорт
	
	// Проверка обязательных свойств
	Если Не мСвойстваПакета.Свойство("Имя") или Не ЗначениеЗаполнено(мСвойстваПакета.Имя) Тогда
		ВызватьИсключение "Не задано имя пакета";
	КонецЕсли;
	
	Если Не мСвойстваПакета.Свойство("Версия") или Не ЗначениеЗаполнено(мСвойстваПакета.Версия) Тогда
		ВызватьИсключение "Не задана версия пакета";
	КонецЕсли;
	
	КопияСвойств = Новый Структура;
	Для Каждого Свойство Из мСвойстваПакета Цикл
		КопияСвойств.Вставить(Свойство.Ключ, Свойство.Значение);
	КонецЦикла;
	
	Возврат КопияСвойств;
	
КонецФункции


//////////////////////////////////////////////////////////////////////
// Зависимости

Функция ЗависитОт(Знач ИмяПакета, Знач МинимальнаяВерсия = Неопределено, Знач МаксимальнаяВерсия = Неопределено) Экспорт
	
	ТекЗависимость = Зависимость(ИмяПакета);
	Если ТекЗависимость = Неопределено Тогда
		Зависимость = мЗависимости.Добавить();
		Зависимость.ИмяПакета = ИмяПакета;
	КонецЕсли;
	
	Если МинимальнаяВерсия = Неопределено Тогда
		Возврат ЭтотОбъект;
	КонецЕсли;
	
	Зависимость.МинимальнаяВерсия  = МинимальнаяВерсия;
	Зависимость.МаксимальнаяВерсия = МаксимальнаяВерсия;
	
	Возврат ЭтотОбъект;
	
КонецФункции

Функция Зависимость(Знач ИмяПакета) Экспорт
	
	Возврат мЗависимости.Найти(ИмяПакета, "ИмяПакета");
	
КонецФункции

Функция РазобратьМаркерВерсии(Знач МаркерВерсии)
	
	Перем ИндексВерсии;
	
	Оператор = Лев(МаркерВерсии, 1);
	Если Оператор = "<" или Оператор = ">" Тогда
		ТестОператор = Сред(МаркерВерсии, 2, 1);
		Если ТестОператор = "=" Тогда
			ИндексВерсии = 3;
		Иначе
			ИндексВерсии = 2;
		КонецЕсли;
	ИначеЕсли Оператор = "=" Тогда
		ИндексВерсии = 2;
	ИначеЕсли Найти("0123456789", Оператор) > 0 Тогда
		ИндексВерсии = 1;
	Иначе
		ВызватьИсключение "Некорректно задан маркер версии";
	КонецЕсли;
	
	Если ИндексВерсии > 1 Тогда
		Оператор = Лев(МаркерВерсии, ИндексВерсии-1);
	Иначе
		Оператор = "";
	КонецЕсли;
	
	Версия = Сред(МаркерВерсии, ИндексВерсии);
	
	Возврат Новый Структура("Оператор,Версия", Оператор, Версия);
	
КонецФункции

Функция Зависимости() Экспорт
	Возврат мЗависимости.Скопировать();
КонецФункции

//////////////////////////////////////////////////////////////////////
// Модули пакета

Функция ОпределяетКласс(Знач Идентификатор, Знач Файл) Экспорт
	
	ЗарегистрироватьМодульПакета(Идентификатор, Файл, ТипыМодулей.Класс);
	Возврат ЭтотОбъект;
	
КонецФункции

Функция Классы() Экспорт
	Возврат мМодули.Скопировать(Новый Структура("Тип", ТипыМодулей.Класс));
КонецФункции

Функция ОпределяетМодуль(Знач Идентификатор, Знач Файл) Экспорт
	
	ЗарегистрироватьМодульПакета(Идентификатор, Файл, ТипыМодулей.Модуль);
	Возврат ЭтотОбъект;
	
КонецФункции

Функция Модули() Экспорт
	Возврат мМодули.Скопировать(Новый Структура("Тип", ТипыМодулей.Модуль));
КонецФункции

Функция ВсеМодулиПакета() Экспорт
	Возврат мМодули.Скопировать();
КонецФункции

Процедура ЗарегистрироватьМодульПакета(Знач Идентификатор, Знач Файл, Знач Тип)
	УжеЕсть = мМодули.НайтиСтроки(Новый Структура("Идентификатор,Тип", Идентификатор, Тип));
	Если УжеЕсть.Количество() Тогда
		ВызватьИсключение "Уже определен " + НРег(тип) + " с именем " + Идентификатор;
	КонецЕсли;
	
	Объявление = мМодули.Добавить();
	Объявление.Идентификатор = Идентификатор;
	Объявление.Файл          = Файл;
	Объявление.Тип           = Тип;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////
// Включаемые файлы

Функция ВключитьФайл(Знач ИсходныйПуть) Экспорт
	
	мВключаемыеФайлы.Добавить(ИсходныйПуть);
	Возврат ЭтотОбъект;
	
КонецФункции

Функция ВключаемыеФайлы() Экспорт
	Возврат мВключаемыеФайлы;
КонецФункции

//////////////////////////////////////////////////////////////////////
// Исполняемые файлы

Функция ИсполняемыйФайл(Знач Путь) Экспорт
	мИсполняемыеФайлы.Добавить(Путь);
	Возврат ЭтотОбъект;
КонецФункции

Функция ИсполняемыеФайлы() Экспорт
	Возврат мИсполняемыеФайлы;
КонецФункции

//////////////////////////////////////////////////////////////////////
// Вспомогательные функции

Процедура УстановитьСвойствоПакета(Знач Имя, Знач Значение)
	мСвойстваПакета.Вставить(Имя, Значение);
КонецПроцедуры

//////////////////////////////////////////////////////////////////////
//

Процедура Инициализация()

	мСвойстваПакета = Новый Структура;
	
	мЗависимости = Новый ТаблицаЗначений;
	мЗависимости.Колонки.Добавить("ИмяПакета");
	мЗависимости.Колонки.Добавить("МинимальнаяВерсия");
	мЗависимости.Колонки.Добавить("МаксимальнаяВерсия");

	мМодули = Новый ТаблицаЗначений;
	мМодули.Колонки.Добавить("Идентификатор");
	мМодули.Колонки.Добавить("Файл");
	мМодули.Колонки.Добавить("Тип");
	
	ТипыМодулей = Новый Структура("Класс,Модуль", "Класс", "Модуль");
	
	мВключаемыеФайлы  = Новый Массив;
	мИсполняемыеФайлы = Новый Массив;
	
КонецПроцедуры

Инициализация();
﻿
&НаКлиенте
Перем ВременнаяСсылка;

&НаСервере
Функция СформироватьHTMLПутеводителя(Раздел)

	Перем КорневойЭлемент;

	Если НЕ Раздел = "" Тогда

		ДокументРаздела = Обработки.Путеводитель.ПолучитьМакет(Раздел).ПолучитьДокументHTML();
		КорневойЭлемент = ДокументРаздела.Тело;

	Иначе;

		КорневойЭлемент = "";
		Если Параметры.МобильныйВариант	Тогда
			
			КорневойЭлемент = Обработки.Путеводитель.ПолучитьМакет("ГлавнаяСтраницаМобильная").ПолучитьДокументHTML();
			
		Иначе
			КорневойЭлемент = Обработки.Путеводитель.ПолучитьМакет("ГлавнаяСтраница").ПолучитьДокументHTML();
			
			МенюРазделов = КорневойЭлемент.ПолучитьЭлементПоИдентификатору("ГлавноеМеню");

			Для Сч = 0 По РазделыКонфигурации.Количество() - 1 Цикл

				ДанныеРаздела = РазделыКонфигурации.Получить(Сч);
				СтрТ = КорневойЭлемент.СоздатьЭлемент("tr");
				СтрТ.УстановитьАтрибут("style", "padding: 3px");
				КолТ = КорневойЭлемент.СоздатьЭлемент("td");
				СтрТ.ДобавитьДочерний(КолТ);
				МенюРазделов.ДобавитьДочерний(СтрТ);
				Ссылка = КорневойЭлемент.СоздатьЭлемент("a");
				Ссылка.УстановитьАтрибут("style", "color: #000000; text-decoration: none;");
				Ссылка.Гиперссылка = "#" + Сч;
				Ссылка.Идентификатор = ДанныеРаздела.Название;
				КолТ.ДобавитьДочерний(Ссылка);
				Текст = КорневойЭлемент.СоздатьТекстовыйУзел(ДанныеРаздела.Описание);
				Ссылка.ДобавитьДочерний(Текст);

			КонецЦикла;
		КонецЕсли;

	КонецЕсли;

	ЗапиcьHTML = Новый ЗаписьHTML;
	ЗапиcьHTML.УстановитьСтроку();
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьDOM.Записать(КорневойЭлемент, ЗапиcьHTML);

	Возврат ЗапиcьHTML.Закрыть();

КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Макет ТиповыеПриемкиРазработки должен идти последним в списке
	ПозицияМакетаТПР = Неопределено;
	ИмяМакетаТПР = "ТиповыеПриемыРазработки";
	ИмяМакетаГлавнойСтраницы = "ГлавнаяСтраница";
	ИмяМакетаГлавнойМобильнойСтраницы = "ГлавнаяСтраницаМобильная";
	
	Для Сч = 2 По Метаданные.Обработки.Путеводитель.Макеты.Количество() - 1 Цикл

		МетД = Метаданные.Обработки.Путеводитель.Макеты.Получить(Сч);
		Если МетД.Имя <> ИмяМакетаТПР Тогда
			Стр = РазделыКонфигурации.Добавить();
			Стр.Название = МетД.Имя;
			Стр.Описание = МетД.Синоним;
		Иначе
			ПозицияМакетаТПР = Сч;
		КонецЕсли;
	КонецЦикла;

	//Добавляем последним макет ТиповыеПриемкиРазработки
	Если  ПозицияМакетаТПР <> Неопределено Тогда
		МетД = Метаданные.Обработки.Путеводитель.Макеты.Получить(ПозицияМакетаТПР);
		Стр = РазделыКонфигурации.Добавить();
		Стр.Название = МетД.Имя;
		Стр.Описание = МетД.Синоним;
	КонецЕсли;
		
	ПолеHTML = СформироватьHTMLПутеводителя("");
	
	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	Если ТекущийПользователь.Роли.Содержит(Метаданные.Роли.Администратор) Тогда
		Элементы.ДекорацияЕслиНеАдминистратор.Видимость = Ложь;
	Иначе
		Элементы.ДекорацияЕслиНеАдминистратор.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьИндексРаздела(Раздел)

	Для Сч = 0 По РазделыКонфигурации.Количество() - 1 Цикл

		ДанныеРаздела = РазделыКонфигурации.Получить(Сч);

		Если ДанныеРаздела.Название = Раздел Тогда

			Возврат Сч;

		КонецЕсли;

	КонецЦикла;

	Возврат -1;

КонецФункции

&НаКлиенте
Процедура ПоказатьРаздел(Документ, Раздел)

	СодержимоеРаздела = СформироватьHTMLПутеводителя(Раздел);
	ЭлементHTML = Документ.getElementById("ПолеИнформации");
	ЭлементHTML.innerHTML = СодержимоеРаздела;
	
	Индекс = ПолучитьИндексРаздела(Раздел);
	
	Если Параметры.МобильныйВариант	Тогда
		Якорь = Документ.getElementById("Разделы");
		ДанныеРаздела = РазделыКонфигурации.Получить(Индекс);
		Якорь.innerText = ДанныеРаздела.Описание;
	Иначе
		Якорь = Документ.getElementById(Раздел);
		// В зависимости от типа браузера надо обращаться к разным свойствам
		Если НЕ ВременнаяСсылка = Неопределено Тогда
			Если Якорь.parentElement = Неопределено Тогда
				ВременнаяСсылка.parentNode.style.backGroundColor = "#FFFFFF";
			Иначе
				ВременнаяСсылка.parentElement.style.backGroundColor = "#FFFFFF";
			КонецЕсли;
		КонецЕсли;
		ВременнаяСсылка = Якорь;
		Если Якорь.parentElement = Неопределено Тогда
			Якорь.parentNode.style.backGroundColor = "#FFFFD5";
		Иначе
			Якорь.parentElement.style.backGroundColor = "#FFFFD5";
		КонецЕсли;
	КонецЕсли;

	СтрелкаЛев = Документ.getElementById("СтрелкаЛев");
	СтрелкаЛев.href = "#" + Строка(Индекс - 1);
	СтрелкаЛев.style.display = "";
	Если Индекс - 1 < 0 Тогда
		СтрелкаЛев.style.display = "none";
	КонецЕсли;
	
	СтрелкаПрав = Документ.getElementById("СтрелкаПрав");
	СтрелкаПрав.href = "#" + Строка(Индекс + 1);
	СтрелкаПрав.style.display = "";
	Если Индекс + 1 > РазделыКонфигурации.Количество() -1 Тогда
		СтрелкаПрав.style.display = "none";
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;	
	ТекущийДокумент = ДанныеСобытия.Document;
	ОтбработкаВыбораОбластиПутеводителя(ТекущийДокумент, ДанныеСобытия.Href, ДанныеСобытия.Anchor);
КонецПроцедуры

&НаКлиенте
Асинх Процедура ОтбработкаВыбораОбластиПутеводителя(ТекущийДокумент, Ссылка, Якорь)
#Если МобильныйКлиент Тогда
	Позиция = Найти(Ссылка, "ОткрытьФорму=");
	Если Позиция > 0 Тогда
		ОткрытьФорму(Сред(Ссылка, Позиция + 13));
	КонецЕсли;
	Позиция = Найти(Ссылка, "ОткрытьСправку=");
	Если Позиция > 0 Тогда
		ОткрытьСправку(Сред(Ссылка, Позиция + 15));
	КонецЕсли;
	Позиция = Найти(Ссылка, "ОткрытьСсылку=");
	Если Позиция > 0 Тогда
		ПерейтиПоНавигационнойСсылке(Сред(Ссылка, Позиция + 14));
	КонецЕсли;
	Позиция = Найти(Ссылка, "#");
	Если Позиция > 0 Тогда
		Индекс = Число(Сред(Ссылка, Позиция + 1));
		ПоказатьРаздел(ТекущийДокумент, РазделыКонфигурации[Индекс].Название);
	ИначеЕсли Позиция = 0 Тогда
		СписокЗначений = Новый СписокЗначений;
		Для Сч = 0 По РазделыКонфигурации.Количество() - 1 Цикл
			ДанныеРаздела = РазделыКонфигурации.Получить(Сч);
			СписокЗначений.Добавить(ДанныеРаздела.Название, ДанныеРаздела.Описание);
		КонецЦикла;
		ВыбранныйЭлемент = Ждать ВыбратьИзМенюАсинх(СписокЗначений);
		Если ВыбранныйЭлемент <> Неопределено Тогда
			ПоказатьРаздел(ТекущийДокумент, ВыбранныйЭлемент.Значение);
		КонецЕсли;
	КонецЕсли;
#Иначе
	Если НЕ Якорь = Неопределено Тогда
		Если Якорь.protocol = "v8:" Тогда
			Позиция = Найти(Ссылка, "ОткрытьФорму=");
			Если Позиция > 0 Тогда
				ОткрытьФорму(Сред(Ссылка, Позиция + 13));
			КонецЕсли;
			Позиция = Найти(Ссылка, "ОткрытьСправку=");
			Если Позиция > 0 Тогда
				ОткрытьСправку(Сред(Ссылка, Позиция + 15));
			КонецЕсли;
			Позиция = Найти(Ссылка, "ОткрытьСсылку=");
			Если Позиция > 0 Тогда
				ПерейтиПоНавигационнойСсылке(Сред(Ссылка, Позиция + 14));
			КонецЕсли;
		ИначеЕсли Якорь.id = "СтрелкаЛев" Тогда
			Позиция = Найти(Ссылка, "#");
			Индекс = Число(Сред(Ссылка, Позиция + 1));
			ПоказатьРаздел(ТекущийДокумент, РазделыКонфигурации[Индекс].Название);
		ИначеЕсли Якорь.id = "СтрелкаПрав" Тогда
			Позиция = Найти(Якорь.href, "#");			
			Индекс = Число(Сред(Якорь.href, Позиция + 1));
			ПоказатьРаздел(ТекущийДокумент,
			РазделыКонфигурации.Получить(Индекс).Название);
		ИначеЕсли Якорь.id = "Разделы" Тогда
			СписокЗначений = Новый СписокЗначений;
			Для Сч = 0 По РазделыКонфигурации.Количество() - 1 Цикл
				ДанныеРаздела = РазделыКонфигурации.Получить(Сч);
				СписокЗначений.Добавить(ДанныеРаздела.Название, ДанныеРаздела.Описание);
			КонецЦикла;
			ВыбранныйЭлемент = Ждать ВыбратьИзМенюАсинх(СписокЗначений);
			Если ВыбранныйЭлемент <> Неопределено Тогда
				ПоказатьРаздел(ТекущийДокумент, ВыбранныйЭлемент.Значение);
			КонецЕсли;
		Иначе;
			ПоказатьРаздел(ТекущийДокумент, Якорь.id);
		КонецЕсли;
	КонецЕсли;
#КонецЕсли
КонецПроцедуры // ОтбработкаВыбораОбластиПутеводителя()

&НаКлиенте
Процедура ПолеHTMLДокументСформирован(Элемент)
	ВременнаяСсылка = Неопределено;
	ПоказатьРаздел(Элемент.Документ, РазделыКонфигурации[0].Название);
КонецПроцедуры


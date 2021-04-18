﻿

&НаСервере
Процедура ИспользоватьТекущееМестоположениеСервер(ДанныеАдреса, ДанныеМестоположения)
	
	Объект.Регион = Справочники.Регионы.НайтиПоНаименованию(ДанныеАдреса.Регион);
	Объект.Страна = ДанныеАдреса.Страна;
	Объект.Город = ДанныеАдреса.Город;
	Объект.Улица = ДанныеАдреса.Улица;
	Объект.Дом = ДанныеАдреса.Дом;
	Объект.Индекс = ДанныеАдреса.Индекс;
	Если ДанныеМестоположения <> Неопределено Тогда
		Объект.Широта = ДанныеМестоположения.Координаты.Широта;
		Объект.Долгота = ДанныеМестоположения.Координаты.Долгота;
	КонецЕсли;
    
КонецПроцедуры

&НаСервере
Процедура СоздатьНовыйФайлСервер(Данные, Расширение, Тип)
	
	ТипСодержимого = Тип;
	Номер = Найти(ТипСодержимого, "/");
	Если Номер > 0 Тогда
		ТипСодержимого = Лев(ТипСодержимого, Номер - 1);
	КонецЕсли;
	Файл = Новый Файл(СтрЗаменить(Строка(ТекущаяДата()), ":", "_") + "." + Расширение);
	
	ХранимыйФайл = Справочники.ХранимыеФайлы.СоздатьЭлемент();
	ХранимыйФайл.Владелец = Объект.Ссылка;
	ХранимыйФайл.Наименование = ТипСодержимого + " " + Строка(ТекущаяДата());
	ХранимыйФайл.ИмяФайла = Файл.Имя;
	ХранимыйФайл.ДанныеФайла = Новый ХранилищеЗначения(Данные, Новый СжатиеДанных());
	ХранимыйФайл.Подпись = Новый ХранилищеЗначения(Неопределено, Новый СжатиеДанных());
	ХранимыйФайл.Зашифрован = Ложь;
	ХранимыйФайл.Подписан = Ложь;
	ХранимыйФайл.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИзКонтактаНаСервере(ДанныеКонтакта)
	
#Если МобильныйАвтономныйСервер Тогда
	Объект.Наименование = ДанныеКонтакта.Фамилия + " " + ДанныеКонтакта.Имя + " " + ДанныеКонтакта.Отчество;
	Если ДанныеКонтакта.Адреса.Количество() > 0 Тогда
		ИспользоватьТекущееМестоположениеСервер(ДанныеКонтакта.Адреса[0].Значение, Неопределено)
	КонецЕсли;
	Для каждого Номер из ДанныеКонтакта.НомераТелефонов Цикл
		Если Номер.ТипДанных = ТипНомераТелефонаДанныхКонтакта.ДомашнийФакс
			ИЛИ Номер.ТипДанных = ТипНомераТелефонаДанныхКонтакта.РабочийФакс
			Или Номер.ТипДанных = ТипНомераТелефонаДанныхКонтакта.ДругойФакс Тогда
			Объект.Факс = Номер.Значение;
		Иначе
			Объект.Телефон = Номер.Значение;
		КонецЕсли;
	КонецЦикла;
	Если ДанныеКонтакта.АдресаЭлектроннойПочты.Количество() > 0 Тогда
		Объект.ЭлектроннаяПочта = ДанныеКонтакта.АдресаЭлектроннойПочты[0].Значение;
	КонецЕсли;
	Если ДанныеКонтакта.ВебАдреса.Количество() > 0 Тогда
		Объект.ВебСайт = ДанныеКонтакта.ВебАдреса[0].Значение;
	КонецЕсли;
	Объект.ДополнительнаяИнформация = ДанныеКонтакта.Заметка;
#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеОтметки(ОтметкаДаты, ТекстОтметки)
	ОтметкаДаты = Константы.ОтметкаНаФотоснимкеДата.Получить();
	ТекстОтметки = Константы.ОтметкаНаФотоснимкеТекст.Получить();
КонецПроцедуры

#Если МобильныйКлиент Тогда 
	
&НаКлиенте
Процедура СоздатьНовыйФайл(ДанныеМультимедиа)
	
	Если ДанныеМультимедиа <> Неопределено Тогда
		СоздатьНовыйФайлСервер(ДанныеМультимедиа.ПолучитьДвоичныеДанные(),ДанныеМультимедиа.РасширениеФайла,ДанныеМультимедиа.ТипСодержимого);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли

&НаКлиенте
Функция ПолучитьКоординатыКонтрагента()
	
#Если МобильныйКлиент Тогда 
	Координаты = Неопределено;
	Если Объект.Широта <> 0 ИЛИ Объект.Долгота <> 0 Тогда
		Координаты = Новый ГеографическиеКоординаты(Объект.Широта, Объект.Долгота);
	Иначе
		СтруктураДанныхАдреса = Новый Структура();
		СтруктураДанныхАдреса.Вставить("Регион",Объект.Регион);
		СтруктураДанныхАдреса.Вставить("Страна",Объект.Страна);
		СтруктураДанныхАдреса.Вставить("Город",Объект.Город);
		СтруктураДанныхАдреса.Вставить("Улица",Объект.Улица);
		СтруктураДанныхАдреса.Вставить("Дом",Объект.Дом);
		СтруктураДанныхАдреса.Вставить("Индекс",Объект.Индекс);
		ДанныеАдреса = Новый ДанныеАдреса(СтруктураДанныхАдреса);	
		Координаты = ПолучитьМестоположениеПоАдресу(ДанныеАдреса);
	КонецЕсли;
	Возврат Координаты;
#КонецЕсли

КонецФункции

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ
//

&НаКлиенте
Процедура ПриОткрытии(Отказ)

#Если НЕ МобильныйКлиент Тогда
    // Команды имеют смысл только на мобильном клиенте
    Элементы.ФормаПозвонить.Видимость = Ложь;
    Элементы.ФормаОтправитьСМС.Видимость = Ложь;
	Элементы.ФормаПостроитьМаршрут.Видимость = Ложь;
	Элементы.ФормаПоказатьКарту.Видимость = Ложь;
	Элементы.ФормаИспользоватьТекущееМестоположение.Видимость = Ложь;
	Элементы.ФормаСделатьАудиозапись.Видимость = Ложь;
	Элементы.ФормаСделатьВидеозапись.Видимость = Ложь;
	Элементы.ФормаСделатьФотоснимок.Видимость = Ложь;
	Элементы.ФормаИзКонтактов.Видимость = Ложь;
	Элементы.ФормаПоказатьКарту.Доступность = Ложь;
#Иначе
    Элементы.ФормаПозвонить.Доступность = СредстваТелефонии.ПоддерживаетсяНаборНомера();
    Элементы.ФормаОтправитьСМС.Доступность = СредстваТелефонии.ПоддерживаетсяОтправкаSMS(Истина);
	Элементы.ФормаСделатьАудиозапись.Доступность = СредстваМультимедиа.ПоддерживаетсяАудиозапись();
	Элементы.ФормаСделатьВидеозапись.Доступность = СредстваМультимедиа.ПоддерживаетсяВидеозапись();
	Элементы.ФормаСделатьФотоснимок.Доступность = СредстваМультимедиа.ПоддерживаетсяФотоснимок();
	Элементы.ФормаПоказатьКарту.Доступность = ПоддерживаетсяОтображениеКарты();

	Если Объект.Ссылка.Пустая() Тогда
		НачатьРедактированиеЭлемента();
    КонецЕсли;
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура НовыйРасчетныйСчет(Команда)
	НовыйРасчетныйСчетЗаполнить();
КонецПроцедуры

&НаКлиенте
Асинх Процедура НовыйРасчетныйСчетЗаполнить()
	Если Объект.Ссылка.Пустая() Тогда
		Ждать ПредупреждениеАсинх(НСтр("ru = 'Данные не записаны'", "ru"));
		Возврат;
	КонецЕсли;
	// Подготовка параметров и открытие формы нового расчетного счета контрагента.
	ЗначенияЗаполнения = Новый Структура();
	ЗначенияЗаполнения.Вставить("НаименованиеЗаполнить", "Р/С " + Объект.Наименование);
	ЗначенияЗаполнения.Вставить("Владелец", Объект.Ссылка);
	СтруктураПараметров = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Справочник.РасчетныеСчетаКонтрагентов.ФормаОбъекта", СтруктураПараметров);
КонецПроцедуры

&НаКлиенте
Процедура Позвонить(Команда)
	
    Если ЗначениеЗаполнено(Объект.Телефон) Тогда
        
#Если МобильныйКлиент Тогда 
		СредстваТелефонии.НабратьНомер(Объект.Телефон, Ложь);
#КонецЕсли
        
    Иначе
        
		// Сообщим пользователю о том, что информация не консистентна
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Телефон не указан!'", "ru");
		Сообщение.Поле  = "Объект.Телефон";
		Сообщение.Сообщить();
        
    КонецЕсли
    
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьСМС(Команда)
    
    Если ЗначениеЗаполнено(Объект.Телефон) Тогда
		
#Если МобильныйКлиент Тогда 
		Сообщение = Новый SMSСообщение();
		Сообщение.Получатели.Добавить(Объект.Телефон);
		СредстваТелефонии.ПослатьSMS(Сообщение, Истина);
#КонецЕсли
        
    Иначе
        
		// Сообщим пользователю о том, что информация не консистентна
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Телефон не указан!'", "ru");
		Сообщение.Поле  = "Объект.Телефон";
		Сообщение.Сообщить();
        
    КонецЕсли
    
КонецПроцедуры
	
&НаКлиенте
Процедура СделатьАудиозапись(Команда)
	ВыполнитьСозданиеАудиозаписьВидеозаписьФотоснимок("АудиоЗапись");
КонецПроцедуры

&НаКлиенте
Процедура СделатьВидеозапись(Команда)
	ВыполнитьСозданиеАудиозаписьВидеозаписьФотоснимок("ВидеоЗапись");
КонецПроцедуры

&НаКлиенте
Процедура СделатьФотоснимок(Команда)
	ВыполнитьСозданиеАудиозаписьВидеозаписьФотоснимок("ФотоСнимок");
КонецПроцедуры

&НаКлиенте
Асинх Процедура ВыполнитьСозданиеАудиозаписьВидеозаписьФотоснимок(ТипМультиМедиа)
	Если Объект.Ссылка.Пустая() Тогда
		Ждать ПредупреждениеАсинх(НСтр("ru = 'Данные не записаны'", "ru"));
		Возврат;
	КонецЕсли;
#Если МобильныйКлиент Тогда 
	Если ТипМультиМедиа = "АудиоЗапись" Тогда
		ДанныеМультимедиа = СредстваМультимедиа.СделатьАудиозапись();
	ИначеЕсли ТипМультиМедиа = "ВидеоЗапись" Тогда
		ДанныеМультимедиа = СредстваМультимедиа.СделатьВидеозапись();
	ИначеЕсли ТипМультиМедиа = "ФотоСнимок" Тогда
		ОтметкаДаты = Неопределено;
		ТекстОтметки = Неопределено;
		ПолучитьДанныеОтметки(ОтметкаДаты, ТекстОтметки);
		Отметка = Новый ОтметкаНаФотоснимке(ОтметкаДаты, "ДФ='dd.MM.yyyy ЧЧ:мм'", ТекстОтметки);
		ДанныеМультимедиа = СредстваМультимедиа.СделатьФотоснимок(,,,,,Отметка);
	КонецЕсли;
	СоздатьНовыйФайл(ДанныеМультимедиа);
#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура НапомнитьОЗвонке(Команда)
	Если ЗначениеЗаполнено(Объект.Телефон) Тогда
#Если МобильныйКлиент Тогда 
		УведомитьОЗвонке();
#КонецЕсли
    Иначе
		// Сообщим пользователю о том, что информация не консистентна
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Телефон не указан!'", "ru");
		Сообщение.Поле  = "Объект.Телефон";
		Сообщение.Сообщить();
	КонецЕсли
КонецПроцедуры

#Если МобильныйКлиент Тогда 

&НаКлиенте
Асинх Процедура УведомитьОЗвонке()
	ВыбраннаяДата = Ждать ВвестиДатуАсинх(ТекущаяДата(), НСтр("ru = 'Введите время напоминания.'", "ru"));
	Если Не ВыбраннаяДата = Неопределено Тогда
		Уведомление = Новый ДоставляемоеУведомление();
		Уведомление.Текст = НСтр("ru = 'Перезвоните '", "ru") +  Объект.Наименование;
		Уведомление.Данные = "TN:" + Объект.Телефон;
		Уведомление.ДатаПоявленияУниверсальноеВремя = УниверсальноеВремя(ВыбраннаяДата);
		ДоставляемыеУведомления.ДобавитьЛокальноеУведомление(Уведомление);
	КонецЕсли;
КонецПроцедуры

#КонецЕсли

&НаКлиенте
Процедура ПоказатьКарту(Команда)
	
#Если МобильныйКлиент Тогда 
	Координаты = ПолучитьКоординатыКонтрагента();
	Если Координаты <> Неопределено Тогда
		ПоказатьНаКарте(Координаты);
	Иначе
		// Сообщим пользователю о том, что информация не консистентна
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Не заполнены поля, описывающие адрес контрагента.'", "ru");
		Сообщение.Поле  = "Объект.Регион";
		Сообщение.Сообщить();
	КонецЕсли;
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьТекущееМестоположение(Команда)
	
#Если МобильныйКлиент Тогда 
	Имя = "";		
	Если ГеопозиционированиеКлиент.ОбновитьМестоположение(Имя) Тогда
		ДанныеМестоположения = СредстваГеопозиционирования.ПолучитьПоследнееМестоположение(Имя);
		ДанныеАдреса = ПолучитьАдресПоМестоположению(ДанныеМестоположения.Координаты);
		Если ДанныеАдреса <> Неопределено Тогда
			ИспользоватьТекущееМестоположениеСервер(ДанныеАдреса, ДанныеМестоположения);
		Иначе
			Сообщить(НСтр("ru = 'Не удалось установить адрес по местоположению.'", "ru"));
		КонецЕсли;
	КонецЕсли;
#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПостроитьМаршрут(Команда)
	
#Если МобильныйКлиент Тогда 
	ДанныеМестоположения = Неопределено;
	Имя = "";		
	Если ГеопозиционированиеКлиент.ОбновитьМестоположение(Имя) Тогда
		ДанныеМестоположения = СредстваГеопозиционирования.ПолучитьПоследнееМестоположение(Имя);
	КонецЕсли;
	
	Если ДанныеМестоположения = Неопределено Тогда
		Сообщить(НСтр("ru = 'Не удалось установить текущее местоположению.'", "ru"));
		Возврат;
	КонецЕсли;
	
	КоординатыКонтрагента = ПолучитьКоординатыКонтрагента();
	Если КоординатыКонтрагента = Неопределено Тогда
		Сообщить(НСтр("ru = 'Не удалось установить расположение контрагента.'", "ru"));
		Возврат;
	КонецЕсли;
	
	Запуск = Новый ЗапускПриложенияМобильногоУстройства("android.intent.action.VIEW",
		"http://maps.google.com/maps?saddr="
			+ XMLСтрока(ДанныеМестоположения.Координаты.Широта) + "," + XMLСтрока(ДанныеМестоположения.Координаты.Долгота)
			+ "&daddr="
			+ XMLСтрока(КоординатыКонтрагента.Широта) + "," + XMLСтрока(КоординатыКонтрагента.Долгота));
	Запуск.Запустить(Ложь);
	
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзКонтактов(Команда)
#Если МобильныйКлиент Тогда 
	Список = Новый СписокЗначений();
	МенеджерКонтактов = Новый МенеджерКонтактов();
	Ключи = МенеджерКонтактов.НайтиКонтакты();
	Для каждого Ключ Из Ключи Цикл
		Контакт = МенеджерКонтактов.ПолучитьКонтакт(Ключ);
		Представление = Контакт.ДанныеКонтакта.Имя;
		Если Не ПустаяСтрока(Представление) И Не ПустаяСтрока(Контакт.ДанныеКонтакта.Отчество) Тогда
			Представление = Представление + " " + Контакт.ДанныеКонтакта.Отчество;
		КонецЕсли;
		Если Не ПустаяСтрока(Представление) И Не ПустаяСтрока(Контакт.ДанныеКонтакта.Фамилия) Тогда
			Представление = Представление + " " + Контакт.ДанныеКонтакта.Фамилия;
		КонецЕсли;
		Если Не ПустаяСтрока(Представление) И Не ПустаяСтрока(Контакт.ДанныеКонтакта.Прозвище) Тогда
			Представление = Контакт.ДанныеКонтакта.Прозвище + "( " + Представление  + " )";
		КонецЕсли;
		Список.Добавить(Ключ, Представление);
	КонецЦикла;
	ВыполнитьЗаполнениеИзКонтакта(Список);
#КонецЕсли
КонецПроцедуры

#Если МобильныйКлиент Тогда 

&НаКлиенте
Асинх Процедура ВыполнитьЗаполнениеИзКонтакта(Список)
	ВыбранныйЭлементСписка = Ждать ВыбратьИзСпискаАсинх(Список);
	Если НЕ ВыбранныйЭлементСписка = Неопределено Тогда
		МенеджерКонтактов = Новый МенеджерКонтактов();
		Контакт = МенеджерКонтактов.ПолучитьКонтакт(ВыбранныйЭлементСписка.Значение);
		ЗаполнитьИзКонтактаНаСервере(Контакт.ДанныеКонтакта);
	КонецЕсли;
КонецПроцедуры

#КонецЕсли

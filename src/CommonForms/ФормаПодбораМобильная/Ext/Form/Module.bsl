﻿//////////////////////////////////////////////////////////////////////////////// 
// ПРОЦЕДУРЫ И ФУНКЦИИ 
//       

// Процедура помещает результаты подбора в хранилище
&НаСервере
Процедура ЗаписатьПодборВХранилище() 
    
	ПоместитьВоВременноеХранилище(Товары.Выгрузить(), АдресТоваровДокумента);
    
КонецПроцедуры


// Функция добавляет товар в подбор
// Если товар не был выбран раньше, в подбор добавляется новая строка, 
// иначе увеличивается количество
//
// Параметры:
//  Товары – подбор
//  Товар - добавляемый в подбор товар
//  Элементы - элементы формы подбора
//
// Возвращаемое значение:
//  количество данного товара в подборе
&НаКлиентеНаСервереБезКонтекста
Функция ДобавитьТовар(Товары, Товар, Элементы)
    
	Строки = Товары.НайтиСтроки(Новый Структура("Товар", Товар));
	Если Строки.Количество() > 0 Тогда
		Элемент = Строки[0];
		Элемент.Количество = Строки[0].Количество + 1;
	Иначе 
		Элемент = Товары.Добавить();
		Элемент.Товар = Товар;
		Элемент.Количество = 1;
	КонецЕсли;	
	
	Элементы.Товары.ТекущаяСтрока = Элемент.ПолучитьИдентификатор();
	Возврат Элемент.Количество;
    
КонецФункции

// Функция добавляет в подбор товар, который находит по штрихкоду
&НаСервере
Функция ДобавитьТоварПоШтрихКоду(ШтрихКод, Сообщение)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Товары.Ссылка,
	               |	Товары.Наименование
	               |ИЗ
	               |	Справочник.Товары КАК Товары
	               |ГДЕ
	               |	Товары.Штрихкод = &ШтрихКод";
	Запрос.Параметры.Вставить("ШтрихКод", ШтрихКод);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = ДобавитьТовар(Товары, Выборка.Ссылка, Элементы);
		Сообщение = Выборка.Наименование + " : " + Количество;
		Возврат Истина;
	Иначе
		Сообщение = НСтр("ru = 'Товар с данным штрих-кодом не найден!'", "ru");
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции
	
//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ   
// 

&НаКлиенте
Процедура СписокТоваровВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
    
	СтандартнаяОбработка = Ложь;
	ДобавитьТовар(Товары, Значение, Элементы);
    
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
	АдресТоваровДокумента = Параметры.АдресТоваровДокумента;
	Товары.Загрузить(ПолучитьИзВременногоХранилища(АдресТоваровДокумента));
	
КонецПроцедуры

&НаКлиенте
Процедура ОКВыполнить()
    
	ЗаписатьПодборВХранилище();
	ВладелецФормы.ОбработатьПодбор();
	Закрыть();
    
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
    
    Если Элементы.Товары.ТекущиеДанные.Количество = 0 Тогда
        Товары.Удалить(Элементы.Товары.ТекущиеДанные);
    КонецЕсли;
        
КонецПроцедуры

&НаКлиенте
Процедура НачатьСканирование(Команда)
#Если МобильныйКлиент Тогда 
	Если СредстваМультимедиа.ПоддерживаетсяСканированиеШтрихКодов() Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаШтрихкода", ЭтаФорма);
		СредстваМультимедиа.ПоказатьСканированиеШтрихКодов(НСтр("ru = 'Подбор товара.'", "ru"),
														ОписаниеОповещения,,ТипШтрихКода.Линейный);
	КонецЕсли;
#КонецЕсли
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаШтрихкода(ШтрихКод, Результат, Сообщение, ДополнительныеПараметры) экспорт
	Результат = ДобавитьТоварПоШтрихКоду(ШтрихКод, Сообщение);
КонецПроцедуры

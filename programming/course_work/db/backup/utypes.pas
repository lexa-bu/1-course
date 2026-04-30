unit uTypes;

{ Модуль типов данных для БД продаж товаров в канцелярном магазине }
{ Автор: Булдыгеров Алексей }

{$mode ObjFPC}{$H+}
{$codepage utf8}
interface

type
// Структура для товаров
  TProduct = record
    ID        : integer;             // Артикул товара
    Name      : string[50];          // Наименование товара
    ItemType  : string[20];          // Тип товара
    Price     : double;              // Цена за единицу товара
  end;

// Структура для представления информации о продаже / чеке
  TSale = record
    ID            : integer;         // Порядковый номер в списке продаж
    ProductID     : integer;         // Ссылка на ID товара из каталога
    Name          : string[50];      // Копия названия
    ItemType      : string[20];      // Копия типа товара
    Price         : double;          // Цена на момент пробития чека
    Quantity      : integer;         // Объем продажи
    Seller        : string[50];      // ФИО продавца
    Subtotal      : double;          // Сумма позиции (Price * Quantity)
    CheckDateTime : TDateTime;       // Дата+время проведения чека
    PaymentType   : boolean;         // Наличные=False или Карта=True
    ChangeRub     : double;          // Сдача (для наличных)
  end;

// Двухсвязный список для хранения записей о продаж
  PNode = ^TNode;
  TNode = record
    Data : TSale ;                    // Данные узла
    Next : PNode;                    // Указатель на следующий  элемент списка
    Prev : PNode;                    // Указатель на предыдущий элемент списка
  end;
  TSaleList = record
    Head : PNode;                    // Указатель на начальный элемент списка
    Tail : PNode;                    // Указатель на последний элемент списка
  end;

implementation

end.

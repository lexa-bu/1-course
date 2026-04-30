unit uDataLogic;

{ Модуль работы со списками и файлами для БД продаж }
{ Автор: Булдыгеров Алексей }

{$mode ObjFPC}{$H+}
{$codepage utf8}
interface

uses
  Classes, SysUtils, uTypes;

                        // РАБОТА СО СПИСКАМИ

// Инициализирует указатели Head и Tail в nil
procedure CreateList(var List: TSaleList);

// Освобождение памяти
// Проходит по всем узлам и вызывает Dispose для каждого
procedure DestroyList(var List: TSaleList);

// Автоматически присваивает новый ID
// Обновляет указатели Next/Prev для двусвязной структуры
procedure AddToList(var List: TSaleList; const Data: TSale);

// Найти узел по индексу
// Index > 0: поиск с головы списка
// Index < 0: поиск с хвоста списка
// Возвращает nil, если индекс вне диапазона
function SearchNodeByIndex(const List: TSaleList; Index: integer): PNode;

// Удалить узел по индексу
// Пересоединяет соседей (Prev/Next)
// Вызывает RefreshID для перенумерации оставшихся записей
procedure DeleteNodeByIndex(var List: TSaleList; Index: integer);

// Перенумеровать все записи в списке (1, 2, 3...)
// Вызывается после удаления или массовой вставки
procedure RefreshID(var List: TSaleList);

// Получить данные узла по индексу
// Возвращает пустую запись, если индекс не найден
function GetDataByIndex(const List: TSaleList; Index: integer): TSale;

// Заменить данные в узле по индексу
// Меняет ТОЛЬКО содержимое поля Data
procedure ReplaceDataByIndex(var List: TSaleList; const NewData: TSale; Index: integer);

                        // РАБОТА С ФАЙЛАМИ

// Сохранить список в типизированный файл (.dat)
// Использует file of TSale
procedure SaveToTypedFile(const FileName: string; const List: TSaleList);

// Загрузить список из типизированного файла (.dat)
// Предварительно очищает список через DestroyList
// Возвращает данные в том же порядке, в котором были сохранены
procedure LoadFromTypedFile(const FileName: string; var List: TSaleList);

// Сохранить список в текстовый файл (.txt)
// ';' считается разделителем
procedure SaveToTextFile(const FileName: string; const List: TSaleList);

// Загрузить список из текстового файла (.txt)
// ';' считается разделителем
procedure LoadFromTextFile(const FileName: string; var List: TSaleList);

// Загрузить каталог товаров из CSV-файла
// ';' считается разделителем
// Формат: ID;Name;ItemType;Price (пропускаем первую строку)
// Заполняет только поля каталога: ProductID, Name, ItemType, Price
// Остальные поля (Seller, CheckDateTime и т.д.) инициализируются по умолчанию
procedure LoadCatalogFromCSV(const FileName: string; var Catalog: TSaleList);

                        // РАБОТА С СОРТИРОВКОЙ И ПОИСКОМ

// Сортировать список по выбранному полю
// SortField: 0=ID, 1=ProductID, 2=Name, 3=ItemType, 4=Price, 5=Quantity, 6=Subtotal, 7=Seller
// Ascending: True = по возрастанию, False = по убыванию
// Используется пузырьковая сортировка
// После сортировки вызывает RefreshID для нумерации
procedure SortList(var List: TSaleList; SortField: integer; Ascending: boolean);

// Найти записи, содержащие запрос в ключевых полях
// Поиск не чувствителен к регистру
// Ищет в: Name, ItemType, Seller, ProductID
// Возвращает новый список с найденными записями
function SearchInList(const List: TSaleList; const Query: string): TSaleList;

                        // РАСЧЁТЫ

// Рассчитать общую сумму всех позиций в списке
// Суммирует поле Subtotal для каждого узла
// Возвращает 0, если список пуст
function CalculateTotal(const List: TSaleList): double;

// Пересчитать Subtotal для всех записей (Price (Цена) * Quantity (Количество))
// Вызывается после изменения Quantity или Price
// Модифицирует список на месте
procedure RecalcSubtotals(var List: TSaleList);

implementation

//=============================================================================

                        // РЕАЛИЗАЦИЯ РАБОТЫ СО СПИСКАМИ

// Инициализирует указатели Head и Tail в nil
procedure CreateList(var List: TSaleList);
begin
  List.Head := nil;
  List.Tail := nil;
end;

// Освобождение памяти
// Проходит по всем узлам и вызывает Dispose для каждого
procedure DestroyList(var List: TSaleList);
var
  TempNode: PNode;
begin
  TempNode := List.Head;
  while TempNode <> nil do
  begin
    List.Head := List.Head^.Next;
    Dispose(TempNode);
    TempNode := List.Head;
  end;
  List.Tail := nil;
end;

// Автоматически присваивает новый ID
// Обновляет указатели Next/Prev для двусвязной структуры
procedure AddToList(var List: TSaleList; const Data: TSale);
var
  NewNode: PNode;
begin
  New(NewNode);
  NewNode^.Data := Data;
  NewNode^.Next := nil;
  NewNode^.Prev := List.Tail;

  if List.Tail = nil then  // Список был пуст → новый элемент становится головой
  begin
    NewNode^.Data.ID := 1;
    List.Head := NewNode;
  end
  else  // Добавляем после текущего хвоста
  begin
    NewNode^.Data.ID := List.Tail^.Data.ID + 1;
    List.Tail^.Next := NewNode;
  end;

  List.Tail := NewNode;  // Обновляем указатель на хвост
end;

// Найти узел по индексу
// Index > 0: поиск с головы списка
// Index < 0: поиск с хвоста списка
// Возвращает nil, если индекс вне диапазона
function SearchNodeByIndex(const List: TSaleList; Index: integer): PNode;
var
  TempNode: PNode;
  i: integer;
begin
  Result := nil;
  if Index = 0 then Exit;  // Индекс 0 невалиден (нумерация с 1)

  if Index > 0 then  // Поиск с головы
  begin
    TempNode := List.Head;
    i := 1;
    while (TempNode <> nil) and (i < Index) do
    begin
      TempNode := TempNode^.Next;
      Inc(i);
    end;
    Result := TempNode;
  end
  else  // Поиск с хвоста (отрицательные индексы)
  begin
    TempNode := List.Tail;
    i := -1;
    while (TempNode <> nil) and (i > Index) do
    begin
      TempNode := TempNode^.Prev;
      Dec(i);
    end;
    Result := TempNode;
  end;
end;

// Удалить узел по индексу
// Пересоединяет соседей (Prev/Next)
// Вызывает RefreshID для перенумерации оставшихся записей
procedure DeleteNodeByIndex(var List: TSaleList; Index: integer);
var
  TempNode: PNode;
begin
  TempNode := SearchNodeByIndex(List, Index);
  if TempNode = nil then Exit;  // Индекс вне диапазона

  // Перелинковка: обходим удаляемый узел
  if TempNode^.Prev <> nil then
    TempNode^.Prev^.Next := TempNode^.Next
  else
    List.Head := TempNode^.Next;  // Удаляем голову

  if TempNode^.Next <> nil then
    TempNode^.Next^.Prev := TempNode^.Prev
  else
    List.Tail := TempNode^.Prev;  // Удаляем хвост

  Dispose(TempNode);  // Освобождаем память
  RefreshID(List);    // Перенумеровываем оставшиеся
end;


// Перенумеровать все записи в списке (1, 2, 3...)
// Вызывается после удаления или массовой вставки
procedure RefreshID(var List: TSaleList);
var
  TempNode: PNode;
  NewID: integer;
begin
  NewID := 1;
  TempNode := List.Head;
  while TempNode <> nil do
  begin
    TempNode^.Data.ID := NewID;
    Inc(NewID);
    TempNode := TempNode^.Next;
  end;
end;

// Получить данные узла по индексу
// Возвращает пустую запись, если индекс не найден
function GetDataByIndex(const List: TSaleList; Index: integer): TSale;
var
  TempNode: PNode;
begin
  Result := Default(TSale);  // Пустая запись по умолчанию
  TempNode := SearchNodeByIndex(List, Index);
  if TempNode <> nil then
    Result := TempNode^.Data;
end;


// Заменить данные в узле по индексу
// Меняет ТОЛЬКО содержимое поля Data
procedure ReplaceDataByIndex(var List: TSaleList; const NewData: TSale; Index: integer);
var
  TempNode: PNode;
begin
  TempNode := SearchNodeByIndex(List, Index);
  if TempNode <> nil then
    TempNode^.Data := NewData;
end;

                        // РЕАЛИЗАЦИЯ РАБОТЫ С ФАЙЛАМИ

// Сохранить список в типизированный файл (.dat)
// Использует file of TSale
procedure SaveToTypedFile(const FileName: string; const List: TSaleList);
var
  F: file of TSale;
  TempNode: PNode;
begin
  AssignFile(F, FileName);
  Rewrite(F);
  try
    TempNode := List.Head;
    while TempNode <> nil do
    begin
      write(F, TempNode^.Data);
      TempNode := TempNode^.Next;
    end;
  finally
    CloseFile(F);
  end;
end;

// Загрузить список из типизированного файла (.dat)
// Предварительно очищает список через DestroyList
// Возвращает данные в том же порядке, в котором были сохранены
procedure LoadFromTypedFile(const FileName: string; var List: TSaleList);
var
  F: file of TSale;
  Item: TSale;
begin
  DestroyList(List);
  CreateList(List);

  if not FileExists(FileName) then Exit;

  AssignFile(F, FileName);
  Reset(F);
  try
    while not Eof(F) do
    begin
      Read(F, Item);
      AddToList(List, Item);
    end;
  finally
    CloseFile(F);
  end;
end;

// Сохранить список в текстовый файл (.txt)
// ';' считается разделителем
procedure SaveToTextFile(const FileName: string; const List: TSaleList);
var
  F: TextFile;
  TempNode: PNode;
  Data: TSale;
begin
  AssignFile(F, FileName);
  Rewrite(F);
  try
    TempNode := List.Head;
    while TempNode <> nil do
    begin
      Data := TempNode^.Data;
      // Формат: ID;ProductID;Name;ItemType;Price;Quantity;Seller;Subtotal
      writeln(F,
        Data.ID, ';', Data.ProductID, ';', Data.Name, ';', Data.ItemType, ';',
        FormatFloat('0.00', Data.Price), ';', Data.Quantity, ';', Data.Seller, ';',
        FormatFloat('0.00', Data.Subtotal), ';', DateTimeToStr(Data.CheckDateTime), ';',
        Ord(Data.PaymentType), ';', FormatFloat('0.00', Data.ChangeRub));
      TempNode := TempNode^.Next;
    end;
  finally
    CloseFile(F);
  end;
end;

// Загрузить список из текстового файла (.txt)
// ';' считается разделителем
procedure LoadFromTextFile(const FileName: string; var List: TSaleList);
var
  F: TextFile;
  Line: String;
  Parts: array of String;
  Item: TSale;
  i, StartPos: integer;
begin
  DestroyList(List);
  CreateList(List);

  if not FileExists(FileName) then Exit;

  AssignFile(F, FileName);
  Reset(F);
  try
    while not Eof(F) do
    begin
      ReadLn(F, Line);
      if Trim(Line) = '' then Continue;  // Пропуск пустых строк

      // Парсинг по ';'
      StartPos := 1;
      SetLength(Parts, 0);

      for i := 1 to Length(Line) + 1 do
      begin
        if (i > Length(Line)) or (Line[i] = ';') then
        begin
          SetLength(Parts, Length(Parts) + 1);
          Parts[High(Parts)] := Copy(Line, StartPos, i - StartPos);
          StartPos := i + 1;
        end;
      end;

      if Length(Parts) >= 11 then
      begin
        Item.ID := StrToIntDef(Parts[0], 0);
        Item.ProductID := StrToIntDef(Parts[1], 0);
        Item.Name := Parts[2];
        Item.ItemType := Parts[3];
        Item.Price := StrToFloatDef(Parts[4], 0);
        Item.Quantity := StrToIntDef(Parts[5], 0);
        Item.Seller := Parts[6];
        Item.Subtotal := StrToFloatDef(Parts[7], 0);
        Item.CheckDateTime := StrToDateTimeDef(Parts[8], Now);
        Item.PaymentType := StrToIntDef(Parts[9], 0) = 1;
        Item.ChangeRub := StrToFloatDef(Parts[10], 0);
        AddToList(List, Item);
      end;
    end;
  finally
    CloseFile(F);
  end;
end;

// Загрузить каталог товаров из CSV-файла
// ';' считается разделителем
// Формат: ID;Name;ItemType;Price (пропускаем первую строку)
// Заполняет только поля каталога: ProductID, Name, ItemType, Price
// Остальные поля (Seller, CheckDateTime и т.д.) инициализируются по умолчанию
procedure LoadCatalogFromCSV(const FileName: string; var Catalog: TSaleList);
var
  F: TextFile;
  Line: string;
  Parts: array of string;
  Item: TSale;
  i, StartPos: integer;
begin
  DestroyList(Catalog);
  CreateList(Catalog);

  if not FileExists(FileName) then Exit;

  AssignFile(F, FileName);
  Reset(F);
  try
    // Пропускаем заголовок (первая строка)
    if not Eof(F) then ReadLn(F);

    while not Eof(F) do
    begin
      ReadLn(F, Line);
      if Trim(Line) = '' then Continue;

      // Парсинг по ';' (как в chancery.csv)
      StartPos := 1;
      SetLength(Parts, 0);

      for i := 1 to Length(Line) + 1 do
      begin
        if (i > Length(Line)) or (Line[i] = ';') then
        begin
          SetLength(Parts, Length(Parts) + 1);
          Parts[High(Parts)] := Trim(Copy(Line, StartPos, i - StartPos));
          StartPos := i + 1;
        end;
      end;

      // Ожидаем 4 поля: ID, Name, ItemType, Price
      if Length(Parts) >= 4 then
      begin
        Item := Default(TSale);  // Обнуляем все поля
        Item.ProductID := StrToIntDef(Parts[0], 0);
        Item.ID := Item.ProductID;
        Item.Name := Parts[1];
        Item.ItemType := Parts[2];
        Item.Price := StrToFloatDef(Parts[3], 0);
        Item.Quantity := 1;
        Item.Subtotal := Item.Price;
        // Остальные поля (Seller, CheckDateTime и т.д.) остаются пустыми
        AddToList(Catalog, Item);
      end;
    end;
  finally
    CloseFile(F);
  end;
end;

                        // РАБОТА С СОРТИРОВКОЙ И ПОИСКОМ

// Сортировать список по выбранному полю
// SortField: 0=ID, 1=ProductID, 2=Name, 3=ItemType, 4=Price, 5=Quantity, 6=Subtotal, 7=Seller
// Ascending: True = по возрастанию, False = по убыванию
// Используется пузырьковая сортировка
// После сортировки вызывает RefreshID для нумерации
procedure SortList(var List: TSaleList; SortField: Integer; Ascending: Boolean);
var
  i, j, Count: integer;
  Temp: TSale;
  Node1, Node2: PNode;
  ShouldSwap: boolean;
begin
  // Считаем количество элементов
  Count := 0;
  Node1 := List.Head;
  while Node1 <> nil do
  begin
    Inc(Count);
    Node1 := Node1^.Next;
  end;

  if Count < 2 then Exit;

  // Пузырьковая сортировка (меняем данные, не структуру списка)
  for i := Count downto 2 do
  begin
    Node1 := List.Head;
    Node2 := Node1^.Next;

    for j := 1 to i - 1 do
    begin
      ShouldSwap := False;

      // Сравнение по выбранному полю
      case SortField of
        0: ShouldSwap := (Node1^.Data.ProductID > Node2^.Data.ProductID); // По ID Товара
        1: ShouldSwap := (AnsiCompareText(Node1^.Data.Name, Node2^.Data.Name) > 0); // По наименованию
        2: ShouldSwap := (AnsiCompareText(Node1^.Data.ItemType, Node2^.Data.ItemType) > 0); // По типу
        3: ShouldSwap := (Node1^.Data.Price > Node2^.Data.Price); // По цене
        4: ShouldSwap := (Node1^.Data.ID > Node2^.Data.ID);
        5: ShouldSwap := (Node1^.Data.Quantity > Node2^.Data.Quantity);
        6: ShouldSwap := (Node1^.Data.Subtotal > Node2^.Data.Subtotal);
        7: ShouldSwap := (AnsiCompareText(Node1^.Data.Seller, Node2^.Data.Seller) > 0);

      end;

      // Инвертируем для убывания
      if not Ascending then
        ShouldSwap := not ShouldSwap;

      // Обмен данными между узлами
      if ShouldSwap then
      begin
        Temp := Node1^.Data;
        Node1^.Data := Node2^.Data;
        Node2^.Data := Temp;
      end;

      Node1 := Node2;
      Node2 := Node2^.Next;
    end;
  end;

  RefreshID(List);  // Перенумеровываем после сортировки
end;

// Найти записи, содержащие запрос в ключевых полях
// Поиск не чувствителен к регистру
// Ищет в: Name, ItemType, Seller, ProductID
// Возвращает новый список с найденными записями
function SearchInList(const List: TSaleList; const Query: string): TSaleList;
var
  TempNode: PNode;
  Q: string;
begin
  CreateList(Result);

  Q := LowerCase(Trim(Query));
  if Q = '' then Exit;  // Пустой запрос → пустой результат

  TempNode := List.Head;
  while TempNode <> nil do
  begin
    // Поиск вхождения в ключевые поля (нечувствительный к регистру)
    if (Pos(Q, LowerCase(TempNode^.Data.Name)) > 0) or
       (Pos(Q, LowerCase(TempNode^.Data.ItemType)) > 0) or
       (Pos(Q, LowerCase(TempNode^.Data.Seller)) > 0) or
       (Pos(Q, IntToStr(TempNode^.Data.ProductID)) > 0) then
    begin
      AddToList(Result, TempNode^.Data);
    end;
    TempNode := TempNode^.Next;
  end;
end;

                        // РАБОТА С РАСЧЁТАМИ

// Рассчитать общую сумму всех позиций в списке
// Суммирует поле Subtotal для каждого узла
// Возвращает 0, если список пуст
function CalculateTotal(const List: TSaleList): Double;
var
  TempNode: PNode;
begin
  Result := 0;
  TempNode := List.Head;
  while TempNode <> nil do
  begin
    Result := Result + TempNode^.Data.Subtotal;
    TempNode := TempNode^.Next;
  end;
end;

// Пересчитать Subtotal для всех записей (Price (Цена) * Quantity (Количество))
// Вызывается после изменения Quantity или Price
// Модифицирует список на месте
procedure RecalcSubtotals(var List: TSaleList);
var
  TempNode: PNode;
begin
  TempNode := List.Head;
  while TempNode <> nil do
  begin
    TempNode^.Data.Subtotal := TempNode^.Data.Price * TempNode^.Data.Quantity;
    TempNode := TempNode^.Next;
  end;
end;

end.

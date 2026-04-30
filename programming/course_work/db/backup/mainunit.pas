  unit MainUnit;

  { Модуль главной формы программы (касса) }
  { Автор: Булдыгеров Алексей }

  {$mode ObjFPC}{$H+}
  {$codepage utf8}
  interface

  uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
    ExtCtrls, Menus, ActnList, uTypes, uDataLogic, CatalogUnit, ReportUnit;

  type

    { TMainForm }

    TMainForm = class(TForm)
      DeleteButtonAction: TAction;
      EditButtonAction: TAction;
      HotkeyItem: TMenuItem;
      CloseProgramMenuItem: TMenuItem;
      PasteButtonAction: TAction;
      CopyButtonAction: TAction;
      MakeCheckButtonAction: TAction;
      CardButtonAction: TAction;
      CashButtonAction: TAction;
      NotThisUserLabelAction: TAction;
      QuantityEditAction: TAction;
      MinusQuantityButtonAction: TAction;
      PlusQuantityButtonAction: TAction;
      AddButtonAction: TAction;
      ActionList1: TActionList;
                          // МЕНЮ
      MainMenu: TMainMenu;                         // Меню
      FileMenu: TMenuItem;                         // Меню Файл
      OpenMenu: TMenuItem;                         // Меню Файл > Открыть...
      SaveMenu: TMenuItem;                         // Меню файл > Сохранить...
      ServiceMenu: TMenuItem;                      // Меню Сервис
      ReportMenu: TMenuItem;                       // Меню Сервис > Отчёт
      ClearMenu: TMenuItem;                        // Меню Сервис > Очистить
                          // ИНФОРМАЦИЯ О ТОВАРЕ
      SelectedLabel: TLabel;                       // Выбранный товар
      SelectedPriceLabel: TLabel;                  // Цена за 1 шт
      MinusQuantityButton: TButton;                // Кнопка "-" (уменьшить количество)
      QuantityEdit: TEdit;                         // Поле ввода количества
      PlusQuantityButton: TButton;                 // Кнопка "+" (увеличить количество)
      UnitSelectedSeveralPriceLabel: TLabel;       // Цена за N шт (превью)
                          // ПРОДАВЕЦ
      UserIcon: TLabel;                            // Иконка продавца
      UserLabel: TLabel;                           // ФИО продавца
      NotThisUserLabel: TLabel;                    // Ссылка "Сменить продавца"
                          // ИТОГО И ОПЛАТА
      TotalLabel: TLabel;                          // ИТОГО (сумма корзины)
      CashButton: TButton;                         // Оплата наличными
      CardButton: TButton;                         // Оплата картой
      ChangeLabel: TLabel;                         // Сдача (для наличных)
                          // КОРЗИНА
      MakeCheckButton: TButton;                    // Пробить чек
      AddButton: TButton;                          // Добавить товар (каталог)
      CopyButton: TButton;                         // Копировать позицию
      PasteButton: TButton;                        // Вставить позицию
      EditButton: TButton;                         // Редактировать количество
      DeleteButton: TButton;                       // Удалить позицию
      MainStringGrid: TStringGrid;                 // Таблица корзины

      // Закрытие программы
      procedure CloseProgramMenuItemClick(Sender: TObject);
      // Создаёт списки, настраивает сетку, загружает каталог
      procedure FormCreate(Sender: TObject);
      // Освобождение ресурсов при закрытии формы
      procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
      //Горячие клавиши
      procedure HotkeyItemClick(Sender: TObject);
      // Меню: Файл > Открыть
      procedure OpenMenuClick(Sender: TObject);
      // Меню: Файл > Сохранить
      procedure SaveMenuClick(Sender: TObject);
      // Меню: Сервис > Отчёт
      procedure ReportMenuClick(Sender: TObject);
      // Меню: Сервис > Очистить (сброс дня)
      procedure ClearMenuClick(Sender: TObject);
      // Кнопка: Добавить товар (открыть каталог)
      procedure AddButtonClick(Sender: TObject);
      // Кнопка: Копировать выбранную позицию
      procedure CopyButtonClick(Sender: TObject);
      // Кнопка: Вставить из буфера
      procedure PasteButtonClick(Sender: TObject);
      // Кнопка: Редактировать количество позиции
      procedure EditButtonClick(Sender: TObject);
      // Кнопка: Удалить выбранную позицию
      procedure DeleteButtonClick(Sender: TObject);
      // Кнопка: Пробить чек (завершить продажу)
      procedure MakeCheckButtonClick(Sender: TObject);
      // Кнопка: Уменьшить количество (-)
      procedure MinusQuantityButtonClick(Sender: TObject);
      // Кнопка: Увеличить количество (+)
      procedure PlusQuantityButtonClick(Sender: TObject);
      // Поле: Изменение количества вручную
      procedure QuantityEditChange(Sender: TObject);
      // Кнопка: Оплата наличными
      procedure CashButtonClick(Sender: TObject);
      // Кнопка: Оплата картой
      procedure CardButtonClick(Sender: TObject);
      // Ссылка: Смена продавца
      procedure NotThisUserLabelClick(Sender: TObject);
      // Сетка: Выбор строки (отображение инфо о товаре)
      procedure MainStringGridSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);



    private

      // Защита от рекурсии при обновлении интерфейса
      FUpdating: boolean;

      // Флаг для подтверждения оплаты
      PaymentConfirmed: boolean;

      // Обновить отображение корзины в MainStringGrid
      // Очищает сетку и заполняет данными из CurrentCart
      procedure RefreshGrid;
      // Пересчитать ИТОГО (сумма корзины) и цену за n штук
      // Вызывается при изменении количества или состава корзины
      procedure UpdateTotals;
      // Получить индекс выбранной строки в сетке
      // Возвращает 0, если ничего не выбрано или выбрана шапка
      function GetSelectedRowIndex: integer;
      // Установить ФИО продавца в интерфейсе и переменной
      // Параметр NewName: новое ФИО продавца
      procedure SetSeller(const NewName: string);
      // Загрузить каталог товаров из chancery.csv
      // При отсутствии файла показывает предупреждение
      procedure LoadCatalog;
      // Обновить количество выбранного товара в корзине
      procedure UpdateSelectedQuantity;
      // Синхронизировать интерфейс с выбранной строкой сетки
      procedure SyncInterfaceWithGrid(Row: Integer);


    public
                          // ГЛОБАЛЬНЫЕ СПИСКИ И СОСТОЯНИЕ

      CurrentCart: TSaleList;       // Текущая корзина
      DaySales: TSaleList;          // История продаж за день
      CatalogList: TSaleList;       // Справочник товаров
      CurrentSeller: string;        // ФИО текущего продавца
      ClipboardItem: TSale;         // Буфер для копирования
      HasClipboard: boolean;        // Флаг: есть что вставлять
      CashGiven: double;            // Внесённая сумма наличных
      IsCashPayment: boolean;       // Флаг: тип оплаты
    end;

  var
    MainForm: TMainForm;

  implementation

  {$R *.lfm}

  //=============================================================================

                          // ИНИЦИАЛИЗАЦИЯ И ЗАВЕРШЕНИЕ

  // Закрытие программы
  procedure TMainForm.CloseProgramMenuItemClick(Sender: TObject);
  begin
    Close;
  end;

  // Создаёт списки, настраивает сетку, загружает каталог
  procedure TMainForm.FormCreate(Sender: TObject);
  begin
    CreateList(CurrentCart);
    CreateList(DaySales);
    CreateList(CatalogList);

    CurrentSeller := 'Булдыгеров А.А.';
    HasClipboard := False;
    CashGiven := 0;
    IsCashPayment := False;
    PaymentConfirmed := False;

    SetSeller(CurrentSeller);

    with MainStringGrid do
    begin
      ColCount := 6;
      Cells[0, 0] := '№';
      Cells[1, 0] := 'ID Товара';
      Cells[2, 0] := 'Наименование товара';
      Cells[3, 0] := 'Тип товара';
      Cells[4, 0] := 'Цена';
      Cells[5, 0] := 'Количество';
      FixedRows := 1;
      Options := Options - [goEditing];
    end;

    QuantityEdit.Text := '1';
    SelectedLabel.Caption := '—';
    SelectedPriceLabel.Caption := '0.00';
    UnitSelectedSeveralPriceLabel.Caption := '0.00 руб.';
    TotalLabel.Caption := 'Итого:' + #13#10 + '0.00 руб.';
    ChangeLabel.Caption := 'Сдача:' + #13#10 + '0.00 руб.';
    LoadCatalog;
    RefreshGrid;
  end;

  // Освобождение ресурсов при закрытии формы
  procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
  begin
    DestroyList(CurrentCart);
    DestroyList(DaySales);
    DestroyList(CatalogList);
  end;
//Горячие клавиши
procedure TMainForm.HotkeyItemClick(Sender: TObject);
begin
  MessageDlg('Горячие клавиши',
'Ctrl+O - Открыть...' + #13#10 +
'Ctrl+S - Сохранить...' + #13#10 +
'F11 - Открыть отчёт' + #13#10 +
'Ctrl+Del - Очистить всё' + #13#10 +
'F6 - Сменить пользователя' + #13#10 +
'F2 - Добавить товар' + #13#10 +
'Ctrl+C - Скопировать ячейку' + #13#10 +
'Ctrl+V - Вставить ячейку' + #13#10 +
'Ctrl+E; Num+ и Num- или Num* (те, которые в Num-блоке) - Редактировать ячейку (количесвто)' + #13#10 +
'Del - Удалить товар' + #13#10 +
'Ctrl+H и Ctrl+K - Выбор оплаты (наличными или картой)' + #13#10 +
'F9 - Пробить чек (Оплатить)' + #13#10 +
'Esc - Выход', mtInformation, [mbOK], 0);
end;

                          // ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ

  // Обновить отображение корзины в MainStringGrid
  // Очищает сетку и заполняет данными из CurrentCart
  procedure TMainForm.RefreshGrid;
  var
    TempNode: PNode;
    Row: integer;
  begin
    if FUpdating then Exit;
    FUpdating := True;
    try
      MainStringGrid.RowCount := 1;
      TempNode := CurrentCart.Head;

      while TempNode <> nil do
      begin
        Row := MainStringGrid.RowCount;
        MainStringGrid.RowCount := Row + 1;

        MainStringGrid.Cells[0, Row] := IntToStr(TempNode^.Data.ID);
        MainStringGrid.Cells[1, Row] := IntToStr(TempNode^.Data.ProductID);
        MainStringGrid.Cells[2, Row] := TempNode^.Data.Name;
        MainStringGrid.Cells[3, Row] := TempNode^.Data.ItemType;
        MainStringGrid.Cells[4, Row] := FormatFloat('0.00', TempNode^.Data.Price);
        MainStringGrid.Cells[5, Row] := IntToStr(TempNode^.Data.Quantity);

        TempNode := TempNode^.Next;
      end;

      UpdateTotals;
    finally
      FUpdating := False;
    end;
  end;

  // Пересчитать ИТОГО (сумма корзины) и цену за n штук
  // Вызывается при изменении количества или состава корзины
  procedure TMainForm.UpdateTotals;
  var
    Total, Price: double;
    Qty, Row: integer;
  begin
    Total := CalculateTotal(CurrentCart);
    TotalLabel.Caption := 'Итого: ' + #13#10 +
               FormatFloat('0.00', Total) + ' руб.';

      // Читает цену и количество из текущей выбранной строки
      Row := GetSelectedRowIndex;
      if (Row > 0) and
         TryStrToFloat(MainStringGrid.Cells[4, Row], Price) and
         TryStrToInt(MainStringGrid.Cells[5, Row], Qty) then
      begin
        UnitSelectedSeveralPriceLabel.Caption := FormatFloat('0.00', Price * Qty) + ' руб.';
      end;
    end;
  // Получить индекс выбранной строки в сетке
  // Возвращает 0, если ничего не выбрано
  function TMainForm.GetSelectedRowIndex: integer;
  begin
    if (MainStringGrid.Row > 0) and (MainStringGrid.Row < MainStringGrid.RowCount) then
      Result := MainStringGrid.Row
    else
      Result := 0;
  end;

  // Установить ФИО продавца в интерфейсе и переменной
  procedure TMainForm.SetSeller(const NewName: string);
  begin
    CurrentSeller := NewName;
    UserLabel.Caption := CurrentSeller;
  end;

  // Загрузить каталог товаров из chancery.csv
  // При отсутствии файла показывает предупреждение
  procedure TMainForm.LoadCatalog;
  begin
    if FileExists('chancery.csv') then
      LoadCatalogFromCSV('chancery.csv', CatalogList)
    else
      MessageDlg('Ошибка!', 'Файл chancery.csv не найден!', mtError, [mbOK], 0);
  end;

                          // РАБОТА С КОРЗИНОЙ: ДОБАВЛЕНИЕ, КОПИРОВАНИЕ, УДАЛЕНИЕ


  // Добавить товар из каталога в корзину
  procedure TMainForm.AddButtonClick(Sender: TObject);
  var
    Product: TProduct;
    SaleItem: TSale;
    Qty: integer;
    NewRow: Integer;
  begin
    CatalogForm := TCatalogForm.Create(nil);
    try
      CatalogForm.ShowCatalog(CatalogList);
      if CatalogForm.ShowModal = mrOk then
      begin
        Product := CatalogForm.GetSelectedProduct;

        if TryStrToInt(QuantityEdit.Text, Qty) and (Qty > 0) then
        begin
          SaleItem := Default(TSale);
          SaleItem.ProductID := Product.ID;
          SaleItem.Name := Product.Name;
          SaleItem.ItemType := Product.ItemType;
          SaleItem.Price := Product.Price;
          SaleItem.Quantity := Qty;
          SaleItem.Subtotal := Product.Price * Qty;
          SaleItem.Seller := CurrentSeller;

          AddToList(CurrentCart, SaleItem);
          RefreshGrid;

          // Выделяем новую строку
          if CurrentCart.Tail <> nil then
          begin
            NewRow := MainStringGrid.RowCount - 1;
            MainStringGrid.Row := NewRow;

            // Синхронизируем интерфейс с новой строкой
            SyncInterfaceWithGrid(NewRow);
          end;
        end
        else
          MessageDlg('Ошибка!', 'Введите корректное количество!', mtError, [mbOK], 0);
      end;
    finally
      CatalogForm.Free;
    end;

    // Сброс поля для следующего добавления
    QuantityEdit.Text := '1';
  end;

  // Копировать выбранную позицию в буфер обмена
  // Сохраняет данные позиции в ClipboardItem для последующей вставки
  procedure TMainForm.CopyButtonClick(Sender: TObject);
  var
    Row: integer;
    Node: PNode;
  begin
    Row := GetSelectedRowIndex;
    if Row = 0 then Exit;

    Node := SearchNodeByIndex(CurrentCart, Row);
    if Node <> nil then
    begin
      ClipboardItem := Node^.Data;
      HasClipboard := True;
      MessageDlg('Копирование', 'Готово! Позиция скопирована в буфер.', mtInformation, [mbOK], 0);
    end;
  end;

  // Вставить позицию из буфера обмена в корзину
  // Создаёт копию ClipboardItem с новым порядковым номером
  procedure TMainForm.PasteButtonClick(Sender: TObject);
  var
    FoundNode: PNode;
  begin
    if not HasClipboard then Exit;

    // Сравниваем товар по ProductID
    FoundNode := CurrentCart.Head;
    while FoundNode <> nil do
    begin
      if FoundNode^.Data.ProductID = ClipboardItem.ProductID then
        Break;
      FoundNode := FoundNode^.Next;
    end;

    // Если нашли одинаковое - суммируем количество
    if FoundNode <> nil then
    begin
      FoundNode^.Data.Quantity := FoundNode^.Data.Quantity + ClipboardItem.Quantity;
      FoundNode^.Data.Subtotal := FoundNode^.Data.Price * FoundNode^.Data.Quantity;
    end
    else
    begin
      // Если разные - добавляем как новый товар
      // Просто передаём ClipboardItem напрямую (он уже типа TSale)
      AddToList(CurrentCart, ClipboardItem);
    end;

    RefreshGrid;
  end;

  // Редактировать количество выбранной позиции
  procedure TMainForm.EditButtonClick(Sender: TObject);
  var
    Row: Integer;
    Node: PNode;
    NewQty: Integer;
    QtyStr: string;
  begin
    Row := GetSelectedRowIndex;
    if Row = 0 then Exit;

    Node := SearchNodeByIndex(CurrentCart, Row);
    if Node = nil then Exit;

    QtyStr := IntToStr(Node^.Data.Quantity);
    if InputQuery('Редактирование', 'Новое количество:', QtyStr) then
    begin
      if TryStrToInt(QtyStr, NewQty) and (NewQty > 0) then
      begin
        Node^.Data.Quantity := NewQty;
        Node^.Data.Subtotal := Node^.Data.Price * NewQty;

        RefreshGrid;
        MainStringGrid.Row := Row;
        SyncInterfaceWithGrid(Row);
      end
      else
        MessageDlg('Ошибка!', 'Введите число > 0!', mtError, [mbOK], 0);
    end;
  end;

  // Удалить выбранную позицию из корзины
  procedure TMainForm.DeleteButtonClick(Sender: TObject);
  var
    Row: Integer;
    NewRow: Integer;
  begin
    Row := GetSelectedRowIndex;
    if Row = 0 then Exit;

    if MessageDlg('Подтверждение', 'Удалить выбранный товар из корзины?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      DeleteNodeByIndex(CurrentCart, Row);
      RefreshGrid;

      if CurrentCart.Head = nil then
      begin
        // Корзина пуста
        SelectedLabel.Caption := '—';
        SelectedPriceLabel.Caption := '0.00 руб.';
        UnitSelectedSeveralPriceLabel.Caption := '0.00 руб.';
        QuantityEdit.Text := '1';
        TotalLabel.Caption := 'Итого:' + #13#10 +
                             '0.00 руб.';
      end
      else
      begin
        // Определяем, какую строку выделить после удаления
        if Row >= MainStringGrid.RowCount then
          NewRow := MainStringGrid.RowCount - 1 // Удаляли последнюю -> берём новую последнюю
        else
          NewRow := Row; // Удаляли среднюю -> берём ту, что встала на её место

        MainStringGrid.Row := NewRow;

        // Синхронизируем интерфейс
        SyncInterfaceWithGrid(NewRow);
      end;
    end;
  end;

                          // ОПЛАТА И ЧЕК

  // Оплата наличными (реализована сдача, недосдаточно средств)
  procedure TMainForm.CashButtonClick(Sender: TObject);
  var
    Total, Given: double;
    InputStr: string;
  begin
    Total := CalculateTotal(CurrentCart);
    if Total = 0 then
    begin
      MessageDlg('Внимание!', 'Корзина пуста!', mtWarning, [mbOK], 0);
      Exit;
    end;

    InputStr := FormatFloat('0.00', Total);
    if InputQuery('Оплата наличными', 'Внесите сумму:', InputStr) then
    begin
      if TryStrToFloat(InputStr, Given) then
      begin
        if Given >= Total then
        begin
          CashGiven := Given;
          IsCashPayment := True;
          ChangeLabel.Caption := 'Сдача: ' + #13#10 +
                      FormatFloat('0.00', Given - Total) + ' руб.';
          MessageDlg('Принято!','' + ChangeLabel.Caption, mtInformation, [mbOK], 0);
          PaymentConfirmed := True;
        end
        else
        MessageDlg('Ошибка!', 'Недостаточная сумма!', mtError, [mbOK], 0);
      end
      else
        MessageDlg('Ошибка!', 'Неверный формат числа!', mtError, [mbOK], 0);
    end;
  end;

  // Оплата картой
  procedure TMainForm.CardButtonClick(Sender: TObject);
  var
    Total: double;
  begin
    Total := CalculateTotal(CurrentCart);
    if Total = 0 then
    begin
      MessageDlg('Внимание!', 'Корзина пуста!', mtWarning, [mbOK], 0);
      Exit;
    end;

    IsCashPayment := False;
    CashGiven := 0;
    ChangeLabel.Caption := 'Сдача:' + #13#10 +
                          '0.00 руб.';
    MessageDlg('Принято!', 'Платёж прошёл успешно!', mtInformation, [mbOK], 0);
    PaymentConfirmed := True;
  end;

  // Пробить чек
  // Заполняет данные чека, переносит в историю, очищает корзину
  procedure TMainForm.MakeCheckButtonClick(Sender: TObject);
  var
    TempNode: PNode;
    Total: double;
  begin
    if CurrentCart.Head = nil then
    begin
      MessageDlg('Внимание!', 'Корзина пуста!', mtWarning, [mbOK], 0);
      Exit;
    end;

    if not PaymentConfirmed then
  begin
    MessageDlg('Ошибка!', 'Сначала проведите оплату!', mtError, [mbOK], 0);
    Exit;
  end;

    Total := CalculateTotal(CurrentCart);

    // Первый цикл: фиксация данных чека для каждой позиции
    TempNode := CurrentCart.Head;
    while TempNode <> nil do
    begin
      TempNode^.Data.CheckDateTime := Now;
      TempNode^.Data.PaymentType := IsCashPayment;
      if IsCashPayment then
        TempNode^.Data.ChangeRub := CashGiven - Total
      else
        TempNode^.Data.ChangeRub := 0;
      TempNode := TempNode^.Next;
    end;

    // Второй цикл: перенос позиций в историю продаж
    TempNode := CurrentCart.Head;
    while TempNode <> nil do
    begin
      AddToList(DaySales, TempNode^.Data);
      TempNode := TempNode^.Next;
    end;

    DestroyList(CurrentCart);
    CreateList(CurrentCart);

    CashGiven := 0;
    IsCashPayment := False;
    ChangeLabel.Caption := 'Сдача:' + #13#10 +
                          '0.00 руб.';
    SelectedLabel.Caption := '—';
    SelectedPriceLabel.Caption := '0.00 руб.';
    UnitSelectedSeveralPriceLabel.Caption := '0.00 руб.';
    QuantityEdit.Text := '1';

    RefreshGrid;
    MessageDlg('Внимание!', 'Чек пробит. Сумма: ' + FormatFloat('0.00', Total) + ' руб.', mtInformation, [mbOK], 0);
  end;

                          // МЕНЮ: ФАЙЛ И СЕРВИС

  // Меню: Файл > Открыть
  // Загружает продажи из .dat или .txt файла
  procedure TMainForm.OpenMenuClick(Sender: TObject);
  var
    OpenDlg: TOpenDialog;
  begin
    OpenDlg := TOpenDialog.Create(nil);
    try
      OpenDlg.Filter := 'Типизированный файл|*.dat|Текстовый файл|*.txt';
      OpenDlg.Title := 'Открыть файл...';

      if OpenDlg.Execute then
      begin
        DestroyList(CurrentCart);
        CreateList(CurrentCart);

        if RightStr(OpenDlg.FileName, 3) = 'dat' then
          LoadFromTypedFile(OpenDlg.FileName, CurrentCart)
        else
          LoadFromTextFile(OpenDlg.FileName, CurrentCart);

        RefreshGrid;
      end;
    finally
      OpenDlg.Free;
    end;
  end;

  // Меню: Файл > Сохранить
  // Сохраняет в .dat или .txt файл
  procedure TMainForm.SaveMenuClick(Sender: TObject);
  var
    SaveDlg: TSaveDialog;
  begin
    SaveDlg := TSaveDialog.Create(nil);
    try
      SaveDlg.Filter := 'Типизированный файл|*.dat|Текстовый файл|*.txt';
      SaveDlg.Title := 'Сохранить файл...';

      if SaveDlg.Execute then
      begin
        if RightStr(SaveDlg.FileName, 3) = 'dat' then
          SaveToTypedFile(SaveDlg.FileName, CurrentCart)
        else
          SaveToTextFile(SaveDlg.FileName, CurrentCart);

        MessageDlg('Готово!', 'Файл сохранён!', mtInformation, [mbOK], 0);
      end;
    finally
      SaveDlg.Free;
    end;
  end;

  // Меню: Сервис > Отчёт
  // Показывает отчёт по DaySales, если есть данные
  procedure TMainForm.ReportMenuClick(Sender: TObject);
  begin
    if DaySales.Head = nil then
    begin
      MessageDlg('Внимание!', 'Нет продаж за день для отчёта!', mtWarning, [mbOK], 0);
      Exit;
    end;

    ReportForm := TReportForm.Create(nil);
    try
      ReportForm.ShowReport(DaySales, CurrentSeller);
      ReportForm.ShowModal;
    finally
      ReportForm.Free;
    end;
  end;

  // Меню: Сервис > Очистить (сброс дня)
  // Запрашивает подтверждение, очищает DaySales
  procedure TMainForm.ClearMenuClick(Sender: TObject);
  begin
    if MessageDlg('Подтверждение', 'Завершить смену и очистить статистику?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      DestroyList(DaySales);
      CreateList(DaySales);
      MessageDlg('Готово!', 'Статистика сброшена. Начата новая смена.', mtInformation, [mbOK], 0);
      DestroyList(CurrentCart);
      CreateList(CurrentCart);
      SelectedLabel.Caption := '—';
      SelectedPriceLabel.Caption := '0.00 руб.';
      UnitSelectedSeveralPriceLabel.Caption := '0.00 руб.';
      QuantityEdit.Text := '1';
      RefreshGrid;
    end;
  end;

                          // ИНТЕРФЕЙС: КОЛИЧЕСТВО, ВЫБОР, ПРОДАВЕЦ

  // Кнопка: Уменьшить количество (-)
  procedure TMainForm.MinusQuantityButtonClick(Sender: TObject);
  var
    Qty: integer;
  begin
    if TryStrToInt(QuantityEdit.Text, Qty) and (Qty > 1) then
    begin
      QuantityEdit.Text := IntToStr(Qty - 1);
      UpdateSelectedQuantity;
    end;
  end;

  // Кнопка: Увеличить количество (+)
  procedure TMainForm.PlusQuantityButtonClick(Sender: TObject);
  var
    Qty: integer;
  begin
    if TryStrToInt(QuantityEdit.Text, Qty) then
    begin
      QuantityEdit.Text := IntToStr(Qty + 1);
      UpdateSelectedQuantity;
    end;
  end;

  // Поле: Изменение количества вручную
  // Пересчитывает цену за n штук при любом изменении
  procedure TMainForm.QuantityEditChange(Sender: TObject);
  begin
    UpdateSelectedQuantity;
  end;

  // Сетка: Выбор строки (отображение инфо о товаре)
  // Обновляет верхнюю панель при выборе товара в таблице
  procedure TMainForm.MainStringGridSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
  begin
    if FUpdating then Exit;
    if aRow > 0 then
      SyncInterfaceWithGrid(aRow);
  end;

  // Ссылка: Смена продавца
  // Запрашивает новое ФИО через InputQuery, обновляет интерфейс
  procedure TMainForm.NotThisUserLabelClick(Sender: TObject);
  var
    NewName: string;
  begin
    NewName := CurrentSeller;

    if InputQuery('Смена продавца', 'Введите ФИО продавца:', NewName) then
    begin
      NewName := Trim(NewName);
      if NewName <> '' then
        SetSeller(NewName);
    end;
  end;

  // Обновить количество выбранного товара в корзине
  // Записывает новое значение в память и обновляет интерфейс
  // Защита от записи в заголовок таблицы
  procedure TMainForm.UpdateSelectedQuantity;
  var
    Row: integer;
    Node: PNode;
    NewQty: integer;
    UnitPrice: double;
  begin
    if FUpdating then Exit;
    if CurrentCart.Head = nil then Exit;

    Row := GetSelectedRowIndex;

    if Row = 0 then
      Node := CurrentCart.Tail
    else
      Node := SearchNodeByIndex(CurrentCart, Row);

    if Node = nil then Exit;

    if TryStrToInt(QuantityEdit.Text, NewQty) and (NewQty > 0) then
    begin
      FUpdating := True;
      try
        Node^.Data.Quantity := NewQty;
        Node^.Data.Subtotal := Node^.Data.Price * NewQty;

        if Row > 0 then
          MainStringGrid.Cells[5, Row] := IntToStr(NewQty);

        SyncInterfaceWithGrid(Row);
      finally
        FUpdating := False;
      end;
    end;
  end;

  // Синхронизировать интерфейс с выбранной строкой сетки
  // Обновляет метки товара, цену и поле количества на основе данных из MainStringGrid
  procedure TMainForm.SyncInterfaceWithGrid(Row: Integer) ;
  var
    Price: Double;
    Qty: Integer;
  begin
    if Row = 0 then Exit;

    FUpdating := True;
    try
      SelectedLabel.Caption := MainStringGrid.Cells[2, Row];
      SelectedPriceLabel.Caption := MainStringGrid.Cells[4, Row] + ' руб.';
      QuantityEdit.Text := MainStringGrid.Cells[5, Row];
      if TryStrToFloat(MainStringGrid.Cells[4, Row], Price) and
         TryStrToInt(MainStringGrid.Cells[5, Row], Qty) then
      begin
        UnitSelectedSeveralPriceLabel.Caption := FormatFloat('0.00', Price * Qty) + ' руб.';
      end;

      UpdateTotals;
    finally
      FUpdating := False;
    end;
  end;


  end.

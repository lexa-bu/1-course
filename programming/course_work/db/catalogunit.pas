unit CatalogUnit;

{ Модуль формы выбора товара из каталога }
{ Автор: Булдыгеров Алексей }

{$mode ObjFPC}{$H+}
{$codepage utf8}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, ActnList, uTypes, uDataLogic;

type

  { TCatalogForm }

  TCatalogForm = class(TForm)
    CloseCatalogAction: TAction;
    ActionList1: TActionList;
    AddProductButton: TButton;              // Кнопка: Добавить товар (ОК)
    CancelProductButton: TButton;           // Кнопка: Отмена
    SearchEdit: TEdit;                      // Поле поиска по каталогу
    CategoryLabel: TLabel;                  // Заголовок категории
    SortByRadioGroup: TRadioGroup;          // Выбор поля для сортировки
    SortDirectionRadioGroup: TRadioGroup;   // Выбор направления сортировки
    SelectedCatalogStringGrid: TStringGrid; // Таблица товаров каталога
    // Обработчики событий

    // Инициализация формы при создании
    // Настраивает сетку, списки, значения по умолчанию
    procedure FormCreate(Sender: TObject);

    // При показе формы обновляет сетку
    procedure FormShow(Sender: TObject);

    // Кнопка "Добавить" > подтвердить выбор товара
    procedure AddProductButtonClick(Sender: TObject);

    // Кнопка "Отмена" > закрыть форму без выбора
    procedure CancelProductButtonClick(Sender: TObject);

    // Изменение критерия сортировки > применить сортировку
    procedure SortByRadioGroupClick(Sender: TObject);

    // Изменение направления сортировки > применить сортировку
    procedure SortDirectionRadioGroupClick(Sender: TObject);

    // Выбор строки в сетке > запомнить индекс
    procedure SelectedCatalogStringGridSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);

    // Поиск: поле получило фокус > убрать подсказку
    procedure SearchEditEnter(Sender: TObject);

    // Поиск: поле потеряло фокус > если пусто, вернуть подсказку
    procedure SearchEditExit(Sender: TObject);

    // Поиск: изменение текста > фильтрация каталога
    procedure SearchEditChange(Sender: TObject);
  private
    // Обновить отображение сетки на основе списка Catalog
    procedure RefreshGrid(const Catalog: TSaleList);

    // Применить сортировку к списку и обновить сетку
    procedure ApplySort(var Catalog: TSaleList);

  public

    // Показать каталог товаров в форме
    // Копирует данные из Catalog во временный список для сортировки/поиска
    procedure ShowCatalog(const Catalog: TSaleList);

    // Получить выбранный пользователем товар
    // Возвращает TProduct из выбранной строки сетки
    function GetSelectedProduct: TProduct;
  end;

var
  CatalogForm: TCatalogForm;

implementation
{$R *.lfm}
{ TReportForm }
//=============================================================================


                        // ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ МОДУЛЯ

var
  TempCatalog: TSaleList;      // Временная копия каталога (для сортировки/поиска)
  SelectedRowIndex: integer;   // Индекс выбранной строки (-1 = ничего не выбрано)

                        // ИНИЦИАЛИЗАЦИЯ

// Инициализация формы при создании
// Настраивает сетку, списки, значения по умолчанию
procedure TCatalogForm.FormCreate(Sender: TObject);
begin
  CreateList(TempCatalog);
  SelectedRowIndex := -1;

  // Настройка сетки (5 колонок)
  with SelectedCatalogStringGrid do
  begin
    ColCount := 5;
    Cells[0, 0] := '№';
    Cells[1, 0] := 'ID Товара';
    Cells[2, 0] := 'Наименование товара';
    Cells[3, 0] := 'Тип товара';
    Cells[4, 0] := 'Цена';
    FixedRows := 1;
    Options := Options - [goEditing];
    ColWidths[0] := 40;
    ColWidths[1] := 70;
    ColWidths[2] := 300;
    ColWidths[3] := 120;
    ColWidths[4] := 80;
  end;

  // Сортировка по умолчанию: по ID и по возрастанию
  SortByRadioGroup.ItemIndex := 0;
  SortDirectionRadioGroup.ItemIndex := 0;

  // Настройка поля поиска
  SearchEdit.Text := 'Поиск...';
  SearchEdit.Font.Color := clGray;
end;

// При показе формы обновляет сетку
procedure TCatalogForm.FormShow(Sender: TObject);
begin
  if TempCatalog.Head <> nil then
    RefreshGrid(TempCatalog);
  SelectedRowIndex := -1;
end;

                        // ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ

// Обновить отображение сетки на основе списка Catalog
procedure TCatalogForm.RefreshGrid(const Catalog: TSaleList);
var
  TempNode: PNode;
  Row: integer;
begin
  SelectedCatalogStringGrid.RowCount := 1;  // Оставить только заголовок
  TempNode := Catalog.Head;

  while TempNode <> nil do
  begin
    Row := SelectedCatalogStringGrid.RowCount;
    SelectedCatalogStringGrid.RowCount := Row + 1;

    SelectedCatalogStringGrid.Cells[0, Row] := IntToStr(TempNode^.Data.ID);
    SelectedCatalogStringGrid.Cells[1, Row] := IntToStr(TempNode^.Data.ProductID);
    SelectedCatalogStringGrid.Cells[2, Row] := TempNode^.Data.Name;
    SelectedCatalogStringGrid.Cells[3, Row] := TempNode^.Data.ItemType;
    SelectedCatalogStringGrid.Cells[4, Row] := FormatFloat('0.00', TempNode^.Data.Price);

    TempNode := TempNode^.Next;
  end;
end;

// Применить сортировку к списку и обновить сетку
procedure TCatalogForm.ApplySort(var Catalog: TSaleList);
var
  SortField: integer;
  Ascending: boolean;
begin
  SortField := SortByRadioGroup.ItemIndex;
  Ascending := (SortDirectionRadioGroup.ItemIndex = 0);
  SortList(Catalog, SortField, Ascending);
  RefreshGrid(Catalog);
end;

                        // ПУБЛИЧНЫЕ МЕТОДЫ

// Показать каталог товаров в форме
// Копирует данные из Catalog во временный список для безопасной сортировки
procedure TCatalogForm.ShowCatalog(const Catalog: TSaleList);
var
  TempNode: PNode;
begin
  // Очистить временный список
  DestroyList(TempCatalog);
  CreateList(TempCatalog);

  // Скопировать все товары из основного каталога
  TempNode := Catalog.Head;
  while TempNode <> nil do
  begin
    AddToList(TempCatalog, TempNode^.Data);
    TempNode := TempNode^.Next;
  end;

  // Применить сортировку по умолчанию и обновить сетку
  SortByRadioGroup.ItemIndex := 0;
  SortDirectionRadioGroup.ItemIndex := 0;
  ApplySort(TempCatalog);
end;

// Получить выбранный пользователем товар
// Возвращает TProduct из выбранной строки сетки
// Если ничего не выбрано — возвращает пустую запись
function TCatalogForm.GetSelectedProduct: TProduct;
var
  Row: Integer;
begin
  Result := Default(TProduct);

  Row := SelectedRowIndex;
  if (Row > 0) and (Row < SelectedCatalogStringGrid.RowCount) then
  begin
    Result.ID := StrToIntDef(SelectedCatalogStringGrid.Cells[1, Row], 0);
    Result.Name := SelectedCatalogStringGrid.Cells[2, Row];
    Result.ItemType := SelectedCatalogStringGrid.Cells[3, Row];
    Result.Price := StrToFloatDef(SelectedCatalogStringGrid.Cells[4, Row], 0);
  end;
end;

                        // ОБРАБОТЧИКИ СОБЫТИЙ

// Выбор строки в сетке > запомнить индекс
procedure TCatalogForm.SelectedCatalogStringGridSelectCell(Sender: TObject; aCol, aRow: integer; var CanSelect: boolean);
begin
  if aRow > 0 then
    SelectedRowIndex := aRow;
end;

// Поиск: поле получило фокус > убрать подсказку
procedure TCatalogForm.SearchEditEnter(Sender: TObject);
begin
  if SearchEdit.Text = 'Поиск...' then
  begin
    SearchEdit.Text := '';
    SearchEdit.Font.Color := clBlack;
  end;
end;

// Поиск: поле потеряло фокус > если пусто, вернуть подсказку
procedure TCatalogForm.SearchEditExit(Sender: TObject);
begin
  if Trim(SearchEdit.Text) = '' then
  begin
    SearchEdit.Text := 'Поиск...';
    SearchEdit.Font.Color := clDkGray;
  end;
end;

// Поиск: изменение текста > фильтрация каталога
procedure TCatalogForm.SearchEditChange(Sender: TObject);
var
  Query: string;
  SearchList: TSaleList;
begin
  // Если показана подсказка — не ищем
  if SearchEdit.Text = 'Поиск...' then Exit;

  Query := Trim(SearchEdit.Text);

  // Пустой запрос > показать весь каталог
  if Query = '' then
  begin
    RefreshGrid(TempCatalog);
    Exit;
  end;

  // Выполнить поиск и показать результаты
  CreateList(SearchList);
  SearchList := SearchInList(TempCatalog, Query);
  RefreshGrid(SearchList);
  DestroyList(SearchList);
end;

// Изменение критерия сортировки > применить сортировку
procedure TCatalogForm.SortByRadioGroupClick(Sender: TObject);
begin
  ApplySort(TempCatalog);
end;

// Изменение направления сортировки > применить сортировку
procedure TCatalogForm.SortDirectionRadioGroupClick(Sender: TObject);
begin
  ApplySort(TempCatalog);
end;

// Кнопка "Добавить" > подтвердить выбор товара
procedure TCatalogForm.AddProductButtonClick(Sender: TObject);
begin
  if SelectedRowIndex > 0 then
    ModalResult := mrOk
  else
    MessageDlg('Внимание', 'Выберите товар из каталога!', mtWarning, [mbOK], 0);
end;

// Кнопка "Отмена" > закрыть форму без выбора
procedure TCatalogForm.CancelProductButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.

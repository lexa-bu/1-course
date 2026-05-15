{
Задание №48 (517а). Дан файл f, содержащий сведения об игрушках: указывается
название игрушки (например, кукла, кубики, мяч, конструктор и т.д.),
ее стоимость в копейках и возрастные границы детей, для которых игрушка
предназначена (например, для детей от двух до пяти лет).
Получить название игрушек, цена которых не превышает 4 руб. и которые подходят
детям 5 лет.
Автор: Булдыгеров Алексей.
}
unit Main;
{$codepage UTF8}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, Menus, StrUtils;

type
  // Запись для хранения данных об игрушке
  TToy = record
    Name: string;      // Название
    PriceKop: integer; // Цена в копейках
    AgeMin: integer;   // Мин. возраст
    AgeMax: integer;   // Макс. возраст
  end;

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    SaveMenuItem: TMenuItem;   // Сохранить...
    OpenMenuItem: TMenuItem;   // Открыть...
    StringGrid1: TStringGrid;  // Таблица
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    // Открывает файл
    procedure OpenMenuItemClick(Sender: TObject);
    // Сохраняет файл
    procedure SaveMenuItemClick(Sender: TObject);
  private
    FToys: array of TToy; // Массив данных
    // Загрузка данных из файла в массив и фильтрация
    procedure LoadToysFromFile(const FileName: string);
    // Сохранение массива в файл
    procedure SaveToysToFile(const FileName: string);
    // Заполнение таблицы из массива
    procedure FillGridFromToys;
    // Добавление одной записи в TStringGrid
    procedure AddToyToGrid(const Toy: TToy; RowIndex: integer);
    // Проверка: цена ≤ 400 коп. И возраст 5 лет входит в диапазон
    function IsToySuitable(const Toy: TToy): boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

// Проверка: цена ≤ 400 коп. И возраст 5 лет входит в диапазон
function TMainForm.IsToySuitable(const Toy: TToy): boolean;
begin
  Result := (Toy.PriceKop <= 400) and
            (Toy.AgeMin <= 5) and
            (Toy.AgeMax >= 5);
end;

// Добавление одной записи в TStringGrid
procedure TMainForm.AddToyToGrid(const Toy: TToy; RowIndex: integer);
begin
  with StringGrid1 do
  begin
    Cells[1, RowIndex] := Toy.Name;
    Cells[2, RowIndex] := IntToStr(Toy.PriceKop);
    Cells[3, RowIndex] := IntToStr(Toy.AgeMin);
    Cells[4, RowIndex] := IntToStr(Toy.AgeMax);
  end;
end;

// Заполнение таблицы из массива
procedure TMainForm.FillGridFromToys;
var
  i: integer;
begin
  StringGrid1.RowCount := Length(FToys) + 1;
  for i := 0 to High(FToys) do
  begin
    // Добавляем нумерацию в первый столбец (индекс 0)
    StringGrid1.Cells[0, i + 1] := IntToStr(i + 1);

    // Заполняем остальные данные
    AddToyToGrid(FToys[i], i + 1);
  end;
end;
// Загрузка данных из файла в массив и фильтрация
procedure TMainForm.LoadToysFromFile(const FileName: string);
var
  F: TextFile;
  Line: string;
  Toy: TToy;
  SuitableNames: string;
  Separators: TSysCharSet = [';'];
begin
  AssignFile(F, FileName);
  reset(F);
  SetLength(FToys, 0);
  SuitableNames := '';

  while not Eof(F) do
  begin
    readln(F, Line);
    if Trim(Line) = '' then Continue;

    // Парсинг строки в запись
    Toy.Name := ExtractWord(1, Line, Separators);
    Toy.PriceKop := StrToIntDef(ExtractWord(2, Line, Separators), 0);
    Toy.AgeMin := StrToIntDef(ExtractWord(3, Line, Separators), 0);
    Toy.AgeMax := StrToIntDef(ExtractWord(4, Line, Separators), 0);

    // Добавление в массив
    SetLength(FToys, Length(FToys) + 1);
    FToys[High(FToys)] := Toy;

    // Проверка критериев
    if IsToySuitable(Toy) then
    begin
      if SuitableNames <> '' then SuitableNames := SuitableNames + ', ';
      SuitableNames := SuitableNames + Toy.Name;
    end;
  end;
  closefile(F);

  FillGridFromToys; // Обновление таблицы

  // Вывод результата фильтрации
  if SuitableNames <> '' then
    MessageDlg('Успех!', 'Подходящие игрушки:' + sLineBreak + SuitableNames,
               mtInformation, [mbOk], 0)
  else
    MessageDlg('Информация', 'Игрушки не найдены по заданным критериям',
               mtInformation, [mbOk], 0);
end;

// Сохранение массива в файл
procedure TMainForm.SaveToysToFile(const FileName: string);
var
  F: TextFile;
  i: integer;
begin
  AssignFile(F, FileName);
  rewrite(F);
  for i := 0 to High(FToys) do
  begin
    with FToys[i] do
      writeln(F, Name, ';', PriceKop, ';', AgeMin, ';', AgeMax);
  end;
  closefile(F);
  MessageDlg('Успех!', 'Данные сохранены!', mtInformation, [mbOk], 0);
end;

// Открывает файл
procedure TMainForm.OpenMenuItemClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    LoadToysFromFile(OpenDialog1.FileName);
end;
// Сохраняет файл
procedure TMainForm.SaveMenuItemClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveToysToFile(SaveDialog1.FileName);
end;

end.

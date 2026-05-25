{
Задание №48 (517а).
Дан файл f, содержащий сведения об игрушках: указывается
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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, Menus;

type
  TToy = record
    Name: string;     // название игрушки
    Price: integer;   // цена в копейках
    AgeMin: integer;  // мин. возраст
    AgeMax: string;   // макс. возраст
  end;

  { TMainForm }

  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    SaveMenuItem: TMenuItem;                          // Сохранить...
    SaveDialog: TSaveDialog;                          // сохранение файла
    OpenMenuItem: TMenuItem;                          // Открыть...
    OpenDialog: TOpenDialog;                          // открытие файла
    FindMenuItem: TMenuItem;                          // Найти
    ExitMenuItem: TMenuItem;                          // Выход
    StringGrid: TStringGrid;                          // таблица StringGrid
    // Меню Сохранить...
    // Вызывает SaveDialog и передает данные для записи в файл.
    procedure SaveMenuItemClick(Sender: TObject);
    // Меню Открыть...
    // Вызывает OpenDialog и загружает данные из файла.
    procedure OpenMenuItemClick(Sender: TObject);
    // Меню Найти.
    // Фильтрует игрушки: цена не превышает 4 рублей, подходят детям 5 лет.
    procedure FindMenuItemClick(Sender: TObject);
    // Меню Выход.
    // Выходит из программы.
    procedure ExitMenuItemClick(Sender: TObject);
    // Редактирование.
    // Редактирует ячейку в StringGrid.
    procedure StringGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
  private
    toys: array of TToy;                              // массив данных об игрушках
    // Загружает данные.
    // Текстовой файл > Массив Toys.
    procedure LoadData(const fName: string);
    // Сохраняет данные.
    // StringGrid > Текстовой файл.
    procedure SaveData(const fName: string);
    // Заполнение StringGrid данными.
    // OnlyFiltered=True показывает игрушки, подходящие под фильтр.
    function FillGrid(OnlyFiltered: Boolean = False): Boolean;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

// Заполнение StringGrid данными.
// OnlyFiltered=True показывает игрушки, подходящие под фильтр.
function TMainForm.FillGrid(OnlyFiltered: Boolean = False): Boolean;
var
  i, CurrentRow: integer;
  PassesFilter: boolean;
begin
  StringGrid.RowCount := 1;
  CurrentRow := 0;

  for i := 0 to High(toys) do
  begin
    if OnlyFiltered then
    PassesFilter := (toys[i].Price <= 400) and (toys[i].AgeMin <= 5)
    else
      PassesFilter := True;

    if PassesFilter then
    begin
      Inc(CurrentRow);
      StringGrid.RowCount := CurrentRow + 1;
      StringGrid.Cells[0, CurrentRow] := IntToStr(CurrentRow);
      StringGrid.Cells[1, CurrentRow] := toys[i].Name;
      StringGrid.Cells[2, CurrentRow] := IntToStr(toys[i].Price);
      StringGrid.Cells[3, CurrentRow] := IntToStr(toys[i].AgeMin);
      StringGrid.Cells[4, CurrentRow] := toys[i].AgeMax;
    end;
  end;

  Result := CurrentRow > 0;

  if OnlyFiltered and not Result then
    MessageDlg('Неудача!', 'Игрушки, удовлетворяющие фильтрации не найдены.', mtWarning, [mbOk], 0);
end;

// Загружает данные.
// Текстовой файл > Массив Toys.
procedure TMainForm.LoadData(const fName: string);
var
  f: TextFile;
  line: string;
  parts: TStringArray;
begin
  if not FileExists(fName) then
  begin
    MessageDlg('Ошибка', 'Файл не найден!', mtError, [mbOk], 0);
    exit;
  end;

  AssignFile(f, fName);
  Reset(f);
  SetLength(toys, 0);

  try
    while not Eof(f) do
    begin
      readln(f, line);
      line := Trim(line);
      if line = '' then continue;

      parts := line.Split([';']);
      if Length(parts) < 4 then continue;

      SetLength(toys, Length(toys) + 1);

      toys[High(toys)].name  := Trim(parts[0]);
      toys[High(toys)].Price := StrToIntDef(Trim(parts[1]), 0);
      toys[High(toys)].AgeMin  := StrToIntDef(Trim(parts[2]), 0);
      toys[High(toys)].AgeMax  := Trim(parts[3]);
    end;
  finally
    CloseFile(f);
    FillGrid;
  end;
end;

// Сохраняет данные.
// StringGrid > Текстовой файл.
procedure TMainForm.SaveData(const fName: string);
var
  f: TextFile;
  i: integer;
begin
  AssignFile(f, fName);
  Rewrite(f);
  try
    for i := 1 to StringGrid.RowCount - 1 do
    begin
      writeln(f, StringGrid.Cells[1, i], ';',
                 StringGrid.Cells[2, i], ';',
                 StringGrid.Cells[3, i], ';',
                 StringGrid.Cells[4, i]);
    end;
    MessageDlg('Успех!', 'Данные сохранены.', mtInformation, [mbOk], 0);
  finally
    CloseFile(f);
  end;
end;

// Меню Сохранить...
// Вызывает SaveDialog и передает данные для записи в файл.
procedure TMainForm.SaveMenuItemClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    SaveData(SaveDialog.FileName);
end;

// Меню Открыть...
// Вызывает OpenDialog и загружает данные из файла.
procedure TMainForm.OpenMenuItemClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    LoadData(OpenDialog.FileName);
end;

// Меню Найти.
// Фильтрует игрушки: цена не превышает 4 рублей, подходят детям 5 лет.
procedure TMainForm.FindMenuItemClick(Sender: TObject);
begin
  if Length(toys) = 0 then
  begin
    MessageDlg('Ошибка!', 'Откройте файл с корректными данными!', mtError, [mbOk], 0);
    exit;
  end;

  if FillGrid(True) then
  MessageDlg('Успех!', 'Фильтрация прошла успешно!', mtInformation, [mbOk], 0);
end;

// Меню Выход.
// Выходит из программы.
procedure TMainForm.ExitMenuItemClick(Sender: TObject);
begin
  Close;
end;
// Редактирование.
// Редактирует ячейку в StringGrid.
procedure TMainForm.StringGridSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
var
  idx: integer;
begin
  if (ARow = 0) or (ACol = 0) then Exit;

  idx := ARow - 1;

  if (idx < 0) or (idx >= Length(toys)) then Exit;

  case ACol of
    1: toys[idx].Name  := Value;
    2: toys[idx].Price := StrToIntDef(Value, 0);
    3: toys[idx].AgeMin  := StrToIntDef(Value, 0);
    4: toys[idx].AgeMax  := Value;
  end;
end;

end.

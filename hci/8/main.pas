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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, Menus, StrUtils;

type
  TToy = record
    name: string;
    price: integer; // цена
    amin: integer;  // мин. возраст
    amax: integer;  // макс. возраст
  end;

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    SaveMenuItem: TMenuItem;
    OpenMenuItem: TMenuItem;
    StringGrid1: TStringGrid;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure OpenMenuItemClick(Sender: TObject);
    procedure SaveMenuItemClick(Sender: TObject);
  private
    toys: array of TToy;
    procedure LoadData(const fName: string);
    procedure SaveData(const fName: string);
    procedure FillGrid;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

// заполнение StringGrid из массива
procedure TMainForm.FillGrid;
var
  i: integer;
begin
  StringGrid1.RowCount := Length(toys) + 1;

  for i := 0 to High(toys) do
  begin
    StringGrid1.Cells[0, i + 1] := IntToStr(i + 1); // № строки
    StringGrid1.Cells[1, i + 1] := toys[i].name;
    StringGrid1.Cells[2, i + 1] := IntToStr(toys[i].price);
    StringGrid1.Cells[3, i + 1] := IntToStr(toys[i].amin);
    StringGrid1.Cells[4, i + 1] := IntToStr(toys[i].amax);
  end;
end;

// загрузка и фильтрация данных
procedure TMainForm.LoadData(const fName: string);
var
  f: TextFile;
  line: string;
  t: TToy;
  resList: string;
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
  resList := '';

  while not Eof(f) do
  begin
    Readln(f, line);
    line := Trim(line);
    if line = '' then continue;

    // разбиение строки по ;
    parts := line.Split([';']);

    // проверка элементов в строке (если полей < 4 - пропускаем)
    if Length(parts) < 4 then continue;

    t.name  := Trim(parts[0]);
    t.price := StrToIntDef(Trim(parts[1]), 0);
    t.amin  := StrToIntDef(Trim(parts[2]), 0);
    t.amax  := StrToIntDef(Trim(parts[3]), 0);

    if (t.price <= 400) and (t.amin <= 5) and (t.amax >= 5) then
    begin
      SetLength(toys, Length(toys) + 1);
      toys[High(toys)] := t;

      if resList <> '' then resList := resList + ', ';
      resList := resList + t.name;
    end;
  end;
  CloseFile(f);

  FillGrid;

  if resList <> '' then
    MessageDlg('Успех!', 'Найдены игрушки по заданным критериям: ' + resList, mtInformation, [mbOk], 0)
  else
    MessageDlg('Ошибка', 'Игрушки, удовлетворяющие условиям, не найдены.', mtError, [mbOk], 0);
end;
// сохранение текущего массива в файл
procedure TMainForm.SaveData(const fName: string);
var
  f: TextFile;
  i: integer;
begin
  AssignFile(f, fName);
  rewrite(f);
  for i := 0 to High(toys) do
  begin
    writeln(f, toys[i].name, ';', toys[i].price, ';', toys[i].amin, ';', toys[i].amax);
  end;
  closefile(f);
  MessageDlg('Успех!', 'Данные сохранены.', mtInformation, [mbOk], 0);
end;
// кнопка "Открыть..."
procedure TMainForm.OpenMenuItemClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    LoadData(OpenDialog1.FileName);
end;
// кнопка "Сохранить..."
procedure TMainForm.SaveMenuItemClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveData(SaveDialog1.FileName);
end;

end.

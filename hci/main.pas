{
  Автор: Булдыгеров Алексей
  Задание №48 (517а). Дан файл f, содержащий сведения об игрушках: указывается
  название игрушки (например, кукла, кубики, мяч, конструктор и т.д.),
  ее стоимость в копейках и возрастные границы детей, для которых игрушка
  предназначена (например, для детей от двух до пяти лет).
  Получить название игрушек, цена которых не превышает 4 руб. и которые
  подходят детям 5 лет.
}

unit Main;
{$codepage UTF8}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, Menus, StrUtils;

type

  { TMainForm }
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    SaveMenuItem: TMenuItem;
    OpenMenuItem: TMenuItem;
    StringGrid1: TStringGrid;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure OpenMenuItemClick(Sender: TObject);
    procedure SaveMenuItemClick(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.SaveMenuItemClick(Sender: TObject);
var
  f: TextFile;
  i: Integer;
begin
  if SaveDialog1.Execute then
  begin
    AssignFile(f, SaveDialog1.FileName);
    Rewrite(f);

    for i := 1 to StringGrid1.RowCount - 1 do
    begin
      if StringGrid1.Cells[1, i] <> '' then
      begin
        writeln(f, StringGrid1.Cells[1, i] + ';' +
                   StringGrid1.Cells[2, i] + ';' +
                   StringGrid1.Cells[3, i] + ';' +
                   StringGrid1.Cells[4, i]);
      end;
    end;

    CloseFile(f);
    MessageDlg('Успех!', 'Данные сохранены!', mtInformation, [mbOk], 0);
  end;
end;

procedure TMainForm.OpenMenuItemClick(Sender: TObject);
var
  F: TextFile;
  Line: string;
  Row, Price, AgeMin, AgeMax: Integer;
  Found: string;
  Separators: TSysCharSet = [';'];
begin
  if OpenDialog1.Execute then
  begin
    AssignFile(F, OpenDialog1.FileName);
    Reset(F);
    StringGrid1.RowCount := 2;
    Row := 1;
    Found := '';

    while not Eof(F) do
    begin
      ReadLn(F, Line);
      if Line = '' then Continue;

      StringGrid1.RowCount := StringGrid1.RowCount + 1;
      StringGrid1.Cells[1, Row] := ExtractWord(1, Line, Separators);
      StringGrid1.Cells[2, Row] := ExtractWord(2, Line, Separators);
      StringGrid1.Cells[3, Row] := ExtractWord(3, Line, Separators);
      StringGrid1.Cells[4, Row] := ExtractWord(4, Line, Separators);

      Price := StrToIntDef(ExtractWord(2, Line, Separators), 0);
      AgeMin := StrToIntDef(ExtractWord(3, Line, Separators), 0);
      AgeMax := StrToIntDef(ExtractWord(4, Line, Separators), 0);

      // Проверка: цена <= 4 руб И 5 лет в диапазоне [Min, Max]
      if (Price <= 4) and (AgeMin <= 5) and (AgeMax >= 5) then
      begin
        if Found <> '' then Found := Found + ', ';
        Found := Found + ExtractWord(1, Line, Separators);
      end;

      Inc(Row);
    end;

    CloseFile(F);
    if Found <> '' then ShowMessage('Подходят: ' + Found)
    else ShowMessage('Не найдено');
  end;
end;

end.

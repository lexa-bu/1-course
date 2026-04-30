{
Автор: Алексей Булдыгеров
Задача: Определить силу притяжения F между телами массы m 1 и m2,
входящимся на расстоянии r друг от друга.
}
unit Unit1;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ActnList, Menus;
type

{model}
  TGravitationModel = class
    class function Calculate(m1, m2, r: Double): Double;
  end;

{view}

  { Ttask }

  Ttask = class(TForm)
    ActionOpen: TAction;
    ActionSave: TAction;
    ActionDel: TAction;
    ActionExitEsc: TAction;
    ActionResult: TAction;
    ActionExit: TAction;
    ActionList1: TActionList;
    Button1: TButton;
    Button_Result: TButton;
    Edit_m1: TEdit;
    Edit_m2: TEdit;
    Edit_r: TEdit;
    Image1: TImage;
    Label_res: TLabel;
    Label_task: TLabel;
    Label_m1: TLabel;
    Label_m2: TLabel;
    Label_r: TLabel;
    Label_task1: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItemRef_autor: TMenuItem;
    MenuItemRef_info: TMenuItem;
    MenuItemRef: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItemOpen: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure ActionExitExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button_ResultClick(Sender: TObject);
    procedure MenuItemOpenClick(Sender: TObject);
    procedure MenuItemRef_autorClick(Sender: TObject);
    procedure MenuItemRef_infoClick(Sender: TObject);
    procedure MenuItemSaveClick(Sender: TObject);
  end;

var
  task: Ttask;

implementation

{$R *.lfm}


class function TGravitationModel.Calculate(m1, m2, r: Double): Double;
begin
  Result := 6.674e-11 * m1 * m2 / (r * r);
end;

{controller}
procedure Ttask.Button_ResultClick(Sender: TObject);
var
  m1, m2, r, F: Double;
begin
  try
    //cбор данных
    m1 := StrToFloat(Edit_m1.Text);
    m2 := StrToFloat(Edit_m2.Text);
    r := StrToFloat(Edit_r.Text);

    if r <= 0 then
    begin
      Memo1.Lines.Add('❌ Ошибка: r должен быть > 0!');
      Label_res.Caption := '❌ Ошибка: r должен быть > 0!';
      Label_res.Font.Color := clRed;
      Edit_r.Text := '';
      Exit;
    end;

    F := TGravitationModel.Calculate(m1, m2, r);

    Label_res.Caption := Format('✔  F = %.2e Н', [F]);
    Label_res.Font.Color := clBlack;

    Memo1.Lines.Add(Format('✔  6.674e-11 * %.2f * %.2f / (%.2f * %.2f) = F = %.2e Н', [m1, m2, r, r, F]));

  except
    Memo1.Lines.Add('❌ Ошибка: введите корректные числа!');
    Label_res.Caption := '❌ Ошибка: введите корректные числа!';
    Label_res.Font.Color := clRed;
  end;
end;

procedure Ttask.MenuItemRef_autorClick(Sender: TObject);
begin
  ShowMessage(
  'Автор: Булдыгеров Алексей.' + #13#10 +
  'Студент 2-го курса по специальности "Информатика и вычислительная техника".' + #13#10 +
  'Telegram: @lexa_bu'
  );
end;

procedure Ttask.MenuItemRef_infoClick(Sender: TObject);
begin
  ShowMessage(
  'Определить силу притяжения F между телами массы m 1 и m2, входящимся на расстоянии r друг от друга.'
  );
end;

procedure Ttask.MenuItemSaveClick(Sender: TObject);
var
  files: TextFile;
  m1, m2, r, F: double;
begin
  //окно сохранить...
  if SaveDialog1.Execute then
  begin
    try
      //cоздание файла по выбранному пути
      AssignFile(files, SaveDialog1.FileName);
      rewrite(files);

      //копируем числа из форм
      m1 := StrToFloat(Edit_m1.Text);
      m2 := StrToFloat(Edit_m2.Text);
      r := StrToFloat(Edit_r.Text);

      //сила притяжения
      F := TGravitationModel.Calculate(m1, m2, r);

      //пишем данные в файл
      writeln(files, 'm1=' + Edit_m1.Text);
      writeln(files, 'm2=' + Edit_m2.Text);
      writeln(files, 'r=' + Edit_r.Text);
      writeln(files, 'result=' + Format('6.674e-11 * %.2f * %.2f / (%.2f * %.2f) = F = %.2e Н', [m1, m2, r, r, F]));

      closefile(files);
      Memo1.Lines.Add('✔ Файл успешно сохранён!');
      Label_res.Caption := '✔ Файл успешно сохранён!';
      Label_res.Font.Color := clGreen;
    except
      Memo1.Lines.Add('❌ Ошибка при сохранении файла!');
      Label_res.Caption := '❌ Ошибка при сохранении файла!';
      Label_res.Font.Color := clRed;
    end;
  end;
end;

//= разделяет

procedure Ttask.MenuItemOpenClick(Sender: TObject);
var
  fileso: TextFile;
  s, key, val: string;
  i: Integer;
begin
  //окно открыть
  if OpenDialog1.Execute then
  begin
    try
      //открываем файл
      AssignFile(fileso, OpenDialog1.FileName);
      Reset(fileso);

      //чистим поле
      Edit_m1.Clear;
      Edit_m2.Clear;
      Edit_r.Clear;
      Label_res.Caption := '';

      //читаем файл
      while not Eof(fileso) do
      begin
        ReadLn(fileso, s);
        i := Pos('=', s);
        if i > 0 then
        begin
          key := Copy(s, 1, i - 1);
          val := Copy(s, i + 1, MaxInt);

          if key = 'm1' then Edit_m1.Text := val
          else if key = 'm2' then Edit_m2.Text := val
          else if key = 'r' then Edit_r.Text := val
          else if key = 'result' then Label_res.Caption := val;
        end;
      end;

      CloseFile(fileso);
      Memo1.Lines.Add('✔ Данные успешно загружены!');
      if (Edit_m1.Text <> '') and (Edit_m2.Text <> '') and (Edit_r.Text <> '') then
        Button_ResultClick(nil);
    except
      Memo1.Lines.Add('❌ Ошибка открытия файла!');
      Label_res.Caption := '❌ Ошибка открытия файла!';
      Label_res.Font.Color := clRed;
    end;
  end;
end;

procedure Ttask.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Edit_m1.Text := '';
  Edit_m2.Text := '';
  Edit_r.Text := '';
  Label_res.Caption := '';
end;

procedure Ttask.ActionExitExecute(Sender: TObject);
begin
  Close;
end;

end.

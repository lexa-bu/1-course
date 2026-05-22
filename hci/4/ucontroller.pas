unit uController;

{$mode objfpc}{$H+}

interface
// результат
procedure Result;
// сохранить данные в файл
procedure SaveToFile;
// загрузить данные из файла
procedure LoadFromFile;
// очистить
procedure ClearAll;

implementation

uses SysUtils, Graphics, uView, uModel, Windows;

// результат
procedure Result;
var
  m1, m2, r, F: double;
begin
  try
    m1 := StrToFloat(task.Edit_m1.Text);
    m2 := StrToFloat(task.Edit_m2.Text);
    r :=  StrToFloat(task.Edit_r.Text);

    if r <= 0 then
    begin
      task.MemoHistory.Lines.Add('❌ Ошибка: r должен быть > 0!');
      task.Label_res.Caption := '❌ Ошибка: r должен быть > 0!';
      task.Label_res.Font.Color := clRed;
      MessageBeep(MB_ICONERROR);
      exit;
    end;

    F := Calculate(m1, m2, r);

    task.Label_res.Caption := Format('✔  F = %.2e Н', [F]);
    task.Label_res.Font.Color := clGreen;
    task.MemoHistory.Lines.Add(Format('✔  Расчет: m1=%.2f, m2=%.2f, r=%.2f, Ответ=%.2e Н', [m1, m2, r, F]));
  except
    task.MemoHistory.Lines.Add('❌ Ошибка: введите корректные числа!');
    task.Label_res.Caption := '❌ Ошибка: введите корректные числа!';
    task.Label_res.Font.Color := clRed;
    MessageBeep(MB_ICONERROR);
  end;
end;

// сохранить данные в файл
procedure SaveToFile;
var
  f: TextFile;
  fileName: string;
begin
  if task.SaveDialog.Execute then
  begin
    fileName := task.SaveDialog.FileName;
    AssignFile(f, fileName);
    Rewrite(f);

    writeln(f, task.Edit_m1.Text);
    writeln(f, task.Edit_m2.Text);
    writeln(f, task.Edit_r.Text);

    CloseFile(f);

    task.MemoHistory.Lines.Add('✔  Файл успешно сохранён!');
    task.Label_res.Caption := '✔  Файл успешно сохранён!';
    task.Label_res.Font.Color := clGreen;
    SysUtils.Beep;
  end;
end;

// загрузить данные из файла
procedure LoadFromFile;
var
  f: TextFile;
  fileName, s_m1, s_m2, s_r: string;
begin
  if task.OpenDialog.Execute then
  begin
    fileName := task.OpenDialog.FileName;
    AssignFile(f, fileName);
    Reset(f);

    readln(f, s_m1);
    readln(f, s_m2);
    readln(f, s_r);

    CloseFile(f);

    task.Edit_m1.Text := s_m1;
    task.Edit_m2.Text := s_m2;
    task.Edit_r.Text := s_r;
    task.MemoHistory.Lines.Add('✔  Данные успешно загружены!');
    SysUtils.Beep;
    Result;
  end;
end;

// очистить
procedure ClearAll;
begin
  task.Edit_m1.Clear;
  task.Edit_m2.Clear;
  task.Edit_r.Clear;
  task.Label_res.Caption := '';
  task.MemoHistory.Lines.Clear;
end;

end.

unit uController;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, uModel;

type
{controller}
  IGravitationView = interface
    function GetM1: double;
    function GetM2: double;
    function GetR: double;
    procedure SetResult(const Value: string; IsError: boolean);
    procedure AddLog(const Msg: string);
    procedure ClearInput;
    procedure SetM1(const Value: string);
    procedure SetM2(const Value: string);
    procedure SetR(const Value: string);
    function AskSaveFile: string;
    function AskOpenFile: string;
  end;

  TGravitationController = class
  private
  public
    FView: IGravitationView;
    constructor Create(AView: IGravitationView);
    procedure CalculateAndShow;
    procedure SaveToFile;
    procedure LoadFromFile;
    procedure ClearAll;
  end;

implementation

// сохраняет ссылку на интерфейс View
constructor TGravitationController.Create(AView: IGravitationView);
begin
  inherited Create;
  FView := AView;
end;

// читает данные и выводит результат
procedure TGravitationController.CalculateAndShow;
var
  m1, m2, r, F: double;
begin
  try
    // cбор данных
    m1 := FView.GetM1;
    m2 := FView.GetM2;
    r := FView.GetR;

    if r <= 0 then
    begin
      FView.AddLog('❌ Ошибка: r должен быть > 0!');
      FView.SetResult('❌ Ошибка: r должен быть > 0!', true);
      Exit;
    end;

    F := TGravitationModel.Calculate(m1, m2, r);

    FView.SetResult(Format('✔  F = %.2e Н', [F]), false);
    FView.AddLog(Format('✔  6.674e-11 * %.2f * %.2f / (%.2f * %.2f) = F = %.2e Н', [m1, m2, r, r, F]));

  except
    FView.AddLog('❌ Ошибка: введите корректные числа!');
    FView.SetResult('❌ Ошибка: введите корректные числа!', true);
  end;
end;

// сохранение результатов расчета в текстовый файл *.txt
procedure TGravitationController.SaveToFile;
var
  files: TextFile;
  m1, m2, r, F: double;
  fileName: string;
begin
  fileName := FView.AskSaveFile;
  if fileName = '' then
  exit;

  try
    // cоздание файла по выбранному пути
    AssignFile(files, fileName);
    rewrite(files);

    // копируем числа из форм
    m1 := FView.GetM1;
    m2 := FView.GetM2;
    r := FView.GetR;

    // сила притяжения
    F := TGravitationModel.Calculate(m1, m2, r);

    // пишем данные в файл
    writeln(files, 'm1=' + FloatToStr(m1));
    writeln(files, 'm2=' + FloatToStr(m2));
    writeln(files, 'r=' + FloatToStr(r));
    writeln(files, 'result=' + Format('6.674e-11 * %.2f * %.2f / (%.2f * %.2f) = F = %.2e Н', [m1, m2, r, r, F]));

    closefile(files);
    FView.AddLog('✔ Файл успешно сохранён!');
    FView.SetResult('✔ Файл успешно сохранён!', false);
  except
    FView.AddLog('❌ Ошибка при сохранении файла!');
    FView.SetResult('❌ Ошибка при сохранении файла!', true);
  end;
end;

// загрузка данных из файла и пересчет
procedure TGravitationController.LoadFromFile;
var
  fileso: TextFile;
  s, key, val: string;
  i: integer;
  fileName: string;
  m1, m2, r: string;
begin
  fileName := FView.AskOpenFile;
  if fileName = '' then Exit;

  try
    // открываем файл
    AssignFile(fileso, fileName);
    Reset(fileso);

    // чистим поле
    FView.ClearInput;
    m1 := ''; m2 := ''; r := '';

    // читаем файл
    while not Eof(fileso) do
    begin
      readln(fileso, s);
      i := Pos('=', s);
      if i > 0 then
      begin
        key := Copy(s, 1, i - 1);
        val := Copy(s, i + 1, MaxInt);

        if key = 'm1' then m1 := val
        else if key = 'm2' then m2 := val
        else if key = 'r' then r := val;
      end;
    end;

    CloseFile(fileso);

    if (m1 <> '') and (m2 <> '') and (r <> '') then
    begin
      FView.SetM1(m1);
      FView.SetM2(m2);
      FView.SetR(r);
      FView.AddLog('✔ Данные успешно загружены!');
      CalculateAndShow;
    end;
  except
    FView.AddLog('❌ Ошибка открытия файла!');
    FView.SetResult('❌ Ошибка открытия файла!', True);
  end;
end;

// полная очистка
procedure TGravitationController.ClearAll;
begin
  FView.ClearInput;
end;

end.

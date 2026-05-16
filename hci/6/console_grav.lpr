program console_grav;
{$mode objfpc}{$H+}
{$codepage UTF8}
uses
  SysUtils, Windows, uModel;

//вывод
procedure PrintHelp;
begin
  writeln('--------------------------------------------------------');
  writeln('');
  writeln('Использование: .\console_grav.exe <m1> <m2> <r>');
  writeln('');
  writeln('Параметры:');
  writeln('  m1    Масса первого тела (кг)');
  writeln('  m2    Масса второго тела (кг)');
  writeln('  r     Расстояние между центрами масс (м), r > 0');
  writeln('');
  writeln('Пример:');
  writeln('  .\console_grav.exe 67 42 1398');
  writeln('');
  writeln('--------------------------------------------------------');
end;

var
  m1, m2, r, F: double;
  i, argCount: integer;
  hasHelp: boolean;

begin
//  SetConsoleOutputCP(65001);
  // кол-во аргументов cmd
  argCount := ParamCount;
  hasHelp := false;

  // -h или -help
  for i := 1 to argCount do
  begin
    if (ParamStr(i) = '-h') or (ParamStr(i) = '-help')
    or (ParamStr(i) = 'h') or (ParamStr(i) = 'help') then
    begin
      hasHelp := True;
      break;
    end;
  end;
  if hasHelp or (argCount = 0) then
  begin
    PrintHelp;
    halt(0);
  end;

  // проверка аргументов
  if argCount <> 3 then
  begin
    writeln('--------------------------------------------------------');
    writeln('Ошибка! Неверное количество параметров.');
    writeln('--------------------------------------------------------');
    halt(1);
  end;

  try
    // парсинг
    m1 := StrToFloat(ParamStr(1));
    m2 := StrToFloat(ParamStr(2));
    r  := StrToFloat(ParamStr(3));
    // если 0 больше или меньше
    if r <= 0 then
    begin
      writeln('--------------------------------------------------------');
      writeln('Ошибка! r должен быть > 0!');
      writeln('--------------------------------------------------------');
      halt(1);
    end;

{model}
    F := TGravitationModel.Calculate(m1, m2, r);

    // вывод
  writeln('--------------------------------------------------------');
    writeln(Format('Ответ: F = %.2e Н', [F]));
    writeln(Format('Развернуто: 6.674e-11 * %.2f * %.2f / (%.2f * %.2f) = F = %.2e Н', [m1, m2, r, r, F]));
  writeln('--------------------------------------------------------');
  except
    on E: EConvertError do
    begin
      writeln('--------------------------------------------------------');
      writeln('Ошибка! введите корректные числа!');
      writeln('--------------------------------------------------------');
      halt(1);
    end;
    on E: Exception do
    begin
      writeln('--------------------------------------------------------');
      writeln('Неизвестная ошибка! ', E.Message);
      writeln('--------------------------------------------------------');
      halt(1);
    end;
  end;
end.

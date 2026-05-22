program console_grav;
{$mode objfpc}{$H+}
{$codepage UTF8}
uses
  SysUtils, uModel;

//вывод
procedure Help;
begin
  writeln('' + #13#10 +
          'Использование:' + #13#10 +
          '.\console_grav.exe <m1> <m2> <r>' + #13#10 +
          '' + #13#10 +
          'Параметры:' + #13#10 +
          'm1 Масса первого тела в кг.' + #13#10 +
          'm2 Масса второго тела в кг.' + #13#10 +
          'r  Расстояние между центрами масс в м. (r > 0)' + #13#10 +
          '' + #13#10 +
          'Пример:' + #13#10 +
          '.\console_grav.exe 67 42 1398' + #13#10 +
          '');
end;

var
  m1, m2, r, F: Double;
  firstArg: string;
begin
  firstArg := LowerCase(ParamStr(1));

  // помощь
  if (ParamCount <> 3) or (firstArg = '-h') or (firstArg = '-help') or
                          (firstArg =  '')  or (firstArg = 'help') then
  begin
    Help;
    halt(0);
  end;

  // проверка аргументов
  if not TryStrToFloat(ParamStr(1), m1) or
     not TryStrToFloat(ParamStr(2), m2) or
     not TryStrToFloat(ParamStr(3), r) then
    begin
      writeln('Ошибка! Пожалуйста, введите корректные числа.' + #13#10 + '');
      halt(1);
    end;

  if r <= 0 then
  begin
    writeln('Ошибка! r > 0!' + #13#10 + '');
    halt(1);
  end;

    F := Calculate(m1, m2, r);

    // вывод
    writeln(Format('Ответ: F = %.2e Н', [F]));
    writeln(Format('Развернуто: 6.674e-11 * %.2f * %.2f / (%.2f * %.2f) = F = %.2e Н', [m1, m2, r, r, F]) + #13#10 + '');
  end.

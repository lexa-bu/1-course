// Задание 4.
// Даны действительные числа x, y. Получить: max(x, y), min(x, y).
uses
  SysUtils, Windows;

var
  x, y, max, min :double;

begin
  SetConsoleOutputCP(65001);
  writeln('Введите x: '); readln(x);
  writeln('Введите y: '); readln(y);
if x > y then     // сравнение, определение max и min
  begin
    max := x;
    min := y;
  end
  else
  begin
    max := y;
    min := x;
  end;

  writeln('max(x, y) = ', max:0:4);
  writeln('min(x, y) = ', min:0:4);
  writeln('Нажмите Enter для выхода...'); readln;
end.


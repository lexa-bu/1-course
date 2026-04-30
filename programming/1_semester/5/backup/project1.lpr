// Задание 5.
// Даны действительные положительные числа x, y, z.
// а) Выяснить, существует ли треугольник с длинами сторон x, y, z.
// б) Если треугльник существует, то ответить - является ли он остроугльным.
uses
  SysUtils, Math, Windows;

var
  x, y, z :double;
begin
  SetConsoleOutputCP(65001);
// x, y, z - стороны треугольника
  writeln('Введите x: '); readln(x);
  writeln('Введите y: '); readln(y);
  writeln('Введите z: '); readln(z);
if (x + y > z) and (x + z > y) and (y + z > x) then
begin
  writeln('Треугольник существует.');
// угол < 90 - острый
  if (sqr(x) + sqr(y) > sqr(z)) and (sqr(x) + sqr(z) > sqr(y)) and (sqr(y) + sqr(z) > sqr(x)) then
    writeln('Треугольник остроугольный.')
  else
    writeln('Треугольник не остроугольный.');
end
else
  writeln('Треугольник не существует.');
  writeln('Нажмите Enter для выхода...'); readLn;
end.


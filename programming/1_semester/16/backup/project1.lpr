//Задание 16.
// Дано натуральное число n. Получить последовательность $b_{1}, ..., b_{n}$,
// где при i = 1, 2, ..., n значение $b_{i}$ равно: $1+\frac{1}{2}+\dots+\frac{1}{i}$.
uses
  SysUtils, Windows;

var
  n, i: integer;
  b: real;
begin
  SetConsoleOutputCP(65001);
  writeln('Введите число n: '); readln(n);

  b := 0;
  for i := 1 to n do
  begin
  b := b + 1 / i;
  writeln(i, ' Шаг = ',b:0:4);
  writeln('----------------------');
  end;
  writeln('Нажмите Enter для выхода...');
  readln;
end.

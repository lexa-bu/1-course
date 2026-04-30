//Задание 20.
// Даны натуральное число n, действительные числа $x_{1}..., x_{n}$.
// В последовательности $x_{1}..., x_{n}$ все члены, меньшие двух, заменить нулями.
// Кроме того, получить сумму членов, принадлежащих отрезку [3,7], а также число таких членов.

uses
  SysUtils, Windows;

var
  n, i, count: integer;
  sum: real;
  x: array[1..1000] of real;
begin
  SetConsoleOutputCP(65001);
  write('Введите количество элементов n (1 - 1000): ');
  readln(n);

  if (n <= 0) or (n > 1000) then
  begin
    writeln('Ошибка! Введите значение от 1 до 1000.');
    writeln('Нажмите Enter для выхода...');
    readln;
    exit;
  end;

  write('Введите ', n, ' действительных чисел: ');
  for i := 1 to n do
    read(x[i]);

  readln;

  sum := 0;
  count := 0;

  for i := 1 to n do
  begin
    if x[i] < 2 then
      x[i] := 0;

    if (x[i] >= 3) and (x[i] <= 7) then
    begin
      sum := sum + x[i];
      inc(count);
    end;
  end;
  writeln('Изменённая последовательность:');
  for i := 1 to n do
    write(x[i]:0:2, '  |  ');
  writeln;
  writeln('Сумма элементов на отрезке [3; 7]: ', sum:0:2);
  writeln('Количество таких элементов: ', count);
  writeln('Нажмите Enter для выхода...');
  readln;
end.

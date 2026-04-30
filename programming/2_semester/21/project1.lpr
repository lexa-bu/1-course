{
Автор: Булдыгеров Алексей
Задание № 21 (201в). Даны натуральное число n, действительные числа $a_{1},...,a_{n}$.
Получить: в) $max (a_{2},a_{4},...)$.
}

uses
  SysUtils, Windows;

var
  n, i: integer;
  a: array[1..100] of real;
  max_val: real;

begin
  SetConsoleOutputCP(65001);
// ввод данных
  write('Введите n: ');
  readln(n);
// если n НЕ от 2 до 100
  if (n < 2) or (n > 100) then
  begin
    writeln('Ошибка: нужно число от 2 до 100!');
    writeln('Нажмите Enter для выхода...'); readln;
    exit;
  end;

  write('Введите ', n, ' чисел (через пробел): ');
  for i := 1 to n do
    read(a[i]); readln;
// поиск максимума
  max_val := a[2];

  for i := 1 to n do
    begin
      // индекс делится на 2 без остатка
      if (i mod 2 = 0) then
      begin
        if a[i] > max_val then
          max_val := a[i];
      end;
    end;
// вывод
  writeln('Максимум среди элементов с четными индексами: ', max_val:0:2);
  writeln('Нажмите Enter для выхода...'); readln;
end.

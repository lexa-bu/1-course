//Задание 12.
// Пусть n - натуральное число и пусть n!! означает 1*3*5*...*n для нечетного n и 2*4*....*n для чётного n. Для заданного натурального n вычислить: n!!
uses
  SysUtils, Windows;

var
  n, result : integer;
begin
  SetConsoleOutputCP(65001);
  result := 1;
  write('Введите число n:'); readln(n);
  while n > 0 do
  begin
    result := result * n;
    n := n - 2;
  end;
  writeln('n!! = ',result);
  writeln('Нажмите Enter для выхода...');
  readln;
end.

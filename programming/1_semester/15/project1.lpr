//Задание 15.
// Даны натуральное число n, действительные числа $a_{1},..., a_{n}$.
// Вычислить: $|a_{1}| + ... + |a_{n}|$.
uses
  SysUtils, Windows;

var
  n, i: integer;
  result: real;
  a: array[1..100] of real;
begin
  SetConsoleOutputCP(65001);
  write('Введите количество до 100 (через пробел): '); readln(n);
  if (n < 1) or (n > 100) then
  begin
  writeln('Вы ввели неверное число (нужно от 1 до 100)!');
  end
  else
  begin
  result:= 0;
  write('Введите ',n,' чисел: ');
  for i := 1 to n do
  read(a[i]);
  readln;
    for i := 1 to n do
      result := result + Abs(a[i]);
    writeln('Ответ: ', result:0:3);
  end;
  writeln('Нажмите Enter для выхода...');
  readln;
end.

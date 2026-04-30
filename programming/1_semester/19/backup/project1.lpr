//Задание 19.
// Даны натуральные числа n, p, целые числа $a_{1},...,a_{n}$.
// Получить произведение членов последовательности $a_{1},...,a_{n}$, кратных p.
uses
  SysUtils, Windows;

var
  n, p, i, num: integer;
  found :boolean;
  pr :int64;
begin
SetConsoleOutputCP(65001);
  write('Введите число n и p (через пробел): '); readln(n, p);
  found := false;
  pr := 1;

  write('Введите ', n, ' чисел (через пробел): ');
  for i := 1 to n do
  begin
  read(num);

  if num mod p = 0 then
  begin
  pr := pr * num;
  found := true;
  end;
end;

if found then
    writeln('Произведение чисел, кратных ', p, ': ', pr)
  else
    write('Ошибка! Нет чисел, кратных ', p, '.'); read;

    writeln('Нажмите Enter для выхода...'); readln;
end.

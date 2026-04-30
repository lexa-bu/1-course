//Задание 17.
// Даны натуральное число n, действительные числа $a, h, b, d_{0},..., d_{n}$.
// Вычислить $d_{0} + d_{1}(b - a) + d_{2}(b - a)(b- a - h) + ... + d_{n}(b - a) (b - a - h)...(b - a - (n - 1)h)$.
uses
  SysUtils, Windows;

var
  n, cycle_ext, cycle_int: integer;
  a, h, b, temp, result: real;
  d: array[0..100] of real;
begin
  SetConsoleOutputCP(65001);
  write('Введите число n: '); readln(n);
  write('Введите числа a, h, b (через пробел): '); readln(a, h, b);
  write('Введите коэффициенты от d[0] до d[', n, ']: ');
  for cycle_ext := 0 to n do
  begin
    write('d[' ,cycle_ext, ']: '); readln(d[cycle_ext]);
  end;
  result := 0;
    for cycle_ext := 0 to n do
  begin
    temp := 1;
    for cycle_int := 0 to cycle_ext -1 do
    begin
      temp := temp *(b - a - cycle_int * h);
    end;
    result := result + d[cycle_ext] * temp;
  end;
    writeln('Ответ: ', result:0:4);
    writeln('Нажмите Enter для выхода...'); readln;
end.

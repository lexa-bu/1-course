//Задание 11.
// Дано действительное число х. Вычислить:
// $$x- \frac{x^{3}}{3!}+\frac{x^{5}}{5!}-\frac{x^{7}}{7!}+\frac{x^{9}}{9!}-
// \frac{x^{11}}{11!}+\frac{x^{13}}{13!}$$
uses
  SysUtils, Windows;

var
  x, p, f, result : real;
  i : integer;
begin
  SetConsoleOutputCP(65001);
  write('Введите число x: '); readln(x);

  f := 1;
  p := x;
  result := 0;
  for i := 1 to 7 do
  begin
    if i mod 2 = 1 then
    result := result + p / f
    else
    result := result - p / f;
    p := p * x * x;
    f := f * (2*i) * (2*i + 1);
  end;
  writeln('Ответ:' ,result:0:4);
  writeLn('Нажмите Enter для выхода...');
  readln;
end.

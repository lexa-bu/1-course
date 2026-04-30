//Задание 27 (760а).
//Дано действительное число х. Последовательность $a_{1}, a_{2}, ...$
//образована по следующему закону: $a_{n}= \frac{x^{n}}{(2n)!}$.
uses
  SysUtils, Windows;

var
  x, term, sum: double;
  n: integer;
begin
  SetConsoleOutputCP(65001);
  write('Введите x: ');
  readln(x);

  sum := 0;
  n := 1;
  term := x / 2;  // a₁ = x/2!

  repeat
    sum := sum + term;
    term := term * x / ((2*n + 1) * (2*n + 2));
    n := n + 1;
  until abs(term) < 1e-6;

  writeln('Сумма ряда: ', sum:0:8);
  writeln('Нажмите Enter для выхода...'); readln;
end.

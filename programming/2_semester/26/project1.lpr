{
Автор: Булдыгеров Алексей
Задание № 26 (376б). Дано действительное число х. Вычислить с точностью $10^{-6}$:
$\sum^{\infty}_{k=1} \frac{x}{k^{3}+k\sqrt{|x|}+1}$.
}

uses
  SysUtils, Windows;

var
  x, n, term, sum: double;
  k: integer;
begin
  SetConsoleOutputCP(65001);
  write('Введите x: ');
  readln(x);

  n := sqrt(abs(x));

  sum := 0;
  k := 1;

  repeat
    term := x / (k*k*k + k*n + 1);
    sum := sum + term;
    k := k + 1;
  until abs(term) < 1e-6;

  writeln('Сумма ряда: ', sum:0:8);
  writeln('Нажмите Enter для выхода...'); readln;
end.

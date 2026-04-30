//Задание 13.
// Дано натуральное число n. Вычислить: $\sum^{n}_{k=1}\frac{k!}{\frac{1}{2}+\frac{1}{3}+\dots +\frac{1}{k+1}}$
uses
  SysUtils, Windows;

var
  n, k, i: integer; //i - вспомогательное
  factorial, denom, result: extended;

begin
  SetConsoleOutputCP(65001);
  writeln('Введите число n: '); readln(n);

  result := 0;
  for k := 1 to n do
  begin
    factorial := 1;
    for i := 1 to k do
    factorial := factorial * i;

    denom := 0;
    for i := 2 to k + 1 do
    denom := denom + 1.0 / i;
    result := result + factorial / denom;
  end;

  writeln('Ответ: ',result:0:5);
  writeln('Нажмите Enter для выхода...');
  readln;
end.

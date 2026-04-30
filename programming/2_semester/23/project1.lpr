{
Автор: Булдыгеров Алексей
Задание № 23 (320). Вычислить $\sum^{10}_{k=1}k^{3}\sum^{15}_{l=1}(k-l)^{2}$.
}

uses
  SysUtils, Windows;

var
  k, l, sum_inn, sum_t: integer;
begin
  SetConsoleOutputCP(65001);
  sum_t := 0;

  for k := 1 to 10 do
  begin
    sum_inn := 0;

    for l := 1 to 15 do
    begin
      sum_inn := sum_inn + sqr(k - l);
    end;

    sum_t := sum_t + (k * k * k) * sum_inn;
  end;

  writeln('Ответ: ' ,sum_t);
  writeln('Нажмите Enter для выхода...'); readln;
end.

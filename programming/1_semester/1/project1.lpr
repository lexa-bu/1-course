// Задача 1.
// Определить силу притяжения F между телами массы m1 и m2,
// находящимся на расстоянии r друг от друга.
uses
  SysUtils, Windows;

var
  F, m1, m2, r: real;
const
  G = 6.6743e-11;
begin
  SetConsoleOutputCP(65001);
  write('Введите массу тела m1: '); readln(m1);
  write('Введите массу тела m2: '); readln(m2);
  write('Введите расстояние между ними (r): '); readln(r);
  F := G * (m1 * m2) /sqr(r);
  writeln('Ответ: ',F);
  writeln('Нажмите Enter для выхода...'); readln;
end.

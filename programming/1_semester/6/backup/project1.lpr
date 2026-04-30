// Задание 6.
// Даны действительные числа x, y. Определить U
// Пусть D - заштрихованная часть плоскости (рис.3, а - е) и пусть
// U определяется по x и y следующим образом (запись(x, y)Є D означает,
// что точка с координатами x, y принадлежит D):
// г) $$
// U = \begin{cases}x^{2} - 1, & \text{если } (x, y) \in D, \\
// \sqrt{|x - 1|}, & \text{в противном случае}. \end{cases}$$
// Рисунок в папке
uses
  SysUtils, Math, Windows;

var
  x, y, u :double;
begin
SetConsoleOutputCP(65001);
  write('Введите x: '); readln(x);
  write('Введите y: '); readln(y);

if (sqr(x) + sqr(y) <= 1) and (y >= 0) and (sqr(x-1) + sqr(y) >= 0.09) then
U := sqr(x) - 1
else
U := sqrt(abs(x - 1));
writeln('U = ',u:0:4);
writeln('Нажмите Enter для выхода...'); readln;
end.


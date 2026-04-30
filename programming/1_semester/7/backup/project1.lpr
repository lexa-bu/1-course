// Задание 7.
// Дано действительное число h. Выяснить, имеет ли уравнение
// ax2 + bx + c = 0 действительные корни, если:
// $a={\sqrt{\frac{|\sin8h|+17}{(1-\sin 4h(h^{2}+18))^{2'}}}}$
// $b=1-\sqrt{ \frac{3}{3+|tg ah^{2}-\sin ah|'} }$
// $c=ah^{2}\sin bh+bh^{3}\cos ah$
uses
  SysUtils, Windows;

var
  a, b, c, h, D :double;
begin
SetConsoleOutputCP(65001);
  writeln('Введите h: '); readln(h);
// коэффиценты a, b, c
a := sqrt( (abs(sin(8 * h)) + 17) / sqr(1 - sin(4 * h * (h * h + 18))) );
b := 1 - sqrt( 3 / (3 + abs(tan(h * h) - sin(h))) );
c := a * h * h * sin(b * h) + b * h * h * h * cos(a * h);
// дискриминант
  D := sqr(b) - 4 * a * c;
  if D >= 0 then
  writeln('Уравнение имеет действительные корни.')
  else
  writeln('Уравнение не имеет действительные корни.');

  writeln('Нажмите Enter для выхода...'); readln;
end.


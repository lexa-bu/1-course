// Задача 2.
// Даны x, y, z. Вычислить a, b, если
// $$a=ln|(y-\sqrt{ |x| })\left( x- \frac{y}{\frac{z+x^2}{4}} \right)|,
// b=x-\frac{x^{2}}{3!}+\frac{x^{5}}{5!}$$
uses
    SysUtils, Windows;

var
    x, y, z, a, b: double;
begin
    SetConsoleOutputCP(65001);
    write('Введите x: '); readln(x);
    write('Введите y: '); readln(y);
    write('Введите z: '); readln(z);

//b=x-\frac{x^{2}}{3!}+\frac{x^{5}}{5!}
    b := x - (Sqr(x) / 6) + (Power(x, 5) / 120);
//a=ln|(y-\sqrt{ |x| })\left( x- \frac{y}{\frac{z+x^2}{4}} \right)|
    a := Ln(Abs((y - Sqrt(Abs(x))) * (x - (y / ((z + Sqr(x)) / 4)))));
//вывод
    writeln('Ответ:');
    writeln('a = ', a:0:6);
    writeln('b = ', b:0:6);
    writeln('Нажмите Enter для выхода...');
    readln;
end.

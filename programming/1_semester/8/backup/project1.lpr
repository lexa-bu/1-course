//Задание 8.
//Определить, верно ли, что при делении неотрицательного целого числа a
//на положительное целое число b получается остаток, равный одному из
//двух заданных чисел r или s.
uses
  SysUtils, Windows, Math;

var
  a, b, r, s :integer;
begin
SetConsoleOutputCP(65001);
write('Введите Неотрицательное целое число (a): '); readln(a);
write('Введите положительное целое число (b): '); readln(b);
write('Введите ~ первое значение остатка (r): '); readln(r);
write('Введите ~ второе значение остатка (s): '); readln(s);

if a < 0 then
  begin
    writeln('ВВЕДИТЕ НЕОТРИЦАТЕЛЬНОЕ ЦЕЛОЕ ЧИСЛО!!! (a)');
  end;
if b <= 0 then
  begin
    writeln('ВВЕДИТЕ ПОЛОЖИТЕЛЬНОЕ ЦЕЛОЕ ЧИСЛО!!! (b)');
  end;
writeln('Остаток от a/b = ', a mod b);     // вывод остатка
if (a mod b = r) or (a mod b = s) then
  writeln ('Верно. остаток равен r или s.')
  else
  writeln ('Неверно. остаток не равен ни r, ни s.');
  writeln('Нажмите Enter для выхода...'); readln;
end.

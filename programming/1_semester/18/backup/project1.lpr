//Задание 18.
// Даны натуральные числа $x, y_{1}, ..., y_{100} (y_{1} < y_{2} < ... < y_{100}, y_{1} < x ≤ y_{100})$.
// Найти натуральное k, при котором $y_{k-1} < x ≤ y_{k}$.
uses
  SysUtils, Windows;

var
x, i, mid, left, right :integer;
y :array[1..100] of integer;
y_or_n :char;
begin
    SetConsoleOutputCP(65001);
    randomize;
    write('Введите число x: '); readln(x);
    writeln('Необходимо ввести 100 чисел. Сгенерировать их? [Y/N]:'); readln(y_or_n);
    //генерация
    if (y_or_n = 'y') then
    begin
       for i := 1 to 100 do
       begin
         if i = 1 then
           y[i] := random(8) + 1
         else
           y[i] := y[i-1] + random(8) + 1;

         writeln('y[', i, '] = ', y[i]);
       end;
     end
     else

    //вручную
    begin
      writeln('Введите 100 упорядоченных чисел:');
      for i := 1 to 100 do
      begin
        write('y[', i, '] = ');
        readln(y[i]);
      end;
    end;


    left := 1;
    right := 100;
    while left < right do
    begin
      mid := (left + right) div 2;
      if x <= y[mid] then
        right := mid
      else
        left := mid + 1;
    end;


    writeln('----------------------------');
    writeln('k = ', left);
    writeln('Нажмите Enter для выхода...');
    readln;
  end.

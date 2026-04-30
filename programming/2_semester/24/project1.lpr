{
Автор: Булдыгеров Алексей
Задание № 24 (338в). Даны натуральное число n, целые числа $a_{1},..., a_{25}, b_{1},..., b_{n}$.
Среди $a_{1},..., a_{25}$ нет повторяющихся чисел, нет их и среди $b_{1},..., b_{n}$.
Получить все члены последовательности $b_{1},..., b_{n}$$, которые не входят
в последовательность $a_{1},..., a_{25}$.
}

uses
  SysUtils, Windows;

var
  n, i, j: integer;
  found: boolean;
  a: array[1..25] of integer;
  b: array[1..100] of integer;
  y_or_n: char;
begin
  SetConsoleOutputCP(65001);
   randomize;
   writeln('Необходимо ввести 25 чисел для массива a. Сгенерировать их? [Y/N]:'); readln(y_or_n);
    // генерация
    if (y_or_n = 'y') or (y_or_n = 'Y') then
    begin
       for i := 1 to 25 do
       begin
         if i = 1 then
           a[i] := random(3) + 1
         else
           a[i] := a[i-1] + random(5) + 1;

         writeln('a[', i, '] = ', a[i]);
       end;
     end
     else
    // вручную
    begin
      writeln('Введите 25 чисел:');
      for i := 1 to 25 do
      begin
        write('a[', i, '] = ');
        readln(a[i]);
      end;
    end;



    write('Введите количество элементов массива B (n, 1..100): ');
  readln(n);

  if (n < 1) or (n > 100) then
  begin
    writeln('Ошибка: n должно быть от 1 до 100');
    writeln('Нажмите Enter для выхода...'); readln;
    exit;
  end;

  if n >= 20 then
  begin
    writeln('Необходимо ввести массив из ', n, ' элементов. Сгенерировать их? [Y/N]:');
    readln(y_or_n);

    if (y_or_n = 'y') or (y_or_n = 'Y') then
    begin
      // генерация
      for i := 1 to n do
      begin
        if i = 1 then
          b[i] := random(3) + 1
        else
          b[i] := b[i-1] + random(5) + 1;
        writeln('b[', i, '] = ', b[i]);
      end;
    end
    else
    begin
      // вручную
      writeln('Введите ', n, ' чисел для массива B:');
      for i := 1 to n do
      begin
        write('b[', i, '] = ');
        readln(b[i]);
      end;
    end;
  end
  else
  begin
    writeln('Введите ', n, ' чисел для массива B:');
    for i := 1 to n do
    begin
      write('b[', i, '] = ');
      readln(b[i]);
    end;
  end;




  writeln;
  writeln('Ответ (элементы B, которых нет в A):');

  for i := 1 to n do
  begin
    found := false;

    for j := 1 to 25 do
    begin
      if b[i] = a[j] then
      begin
        found := true;
        break;
      end;
    end;

    if not found then
      write(b[i], ' ');
  end;

  writeln();
  writeln('Нажмите Enter для выхода...'); readln;
end.

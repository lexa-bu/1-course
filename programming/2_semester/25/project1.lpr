{
Автор: Булдыгеров Алексей
Задание № 25 (376б). Даны натуральное число m, целые числа $a_{1}, ..., a_{m}$ и
целочисленная квадратная матрица порядка m.
Строку с номером i матрицы назовём отмеченной, если $a_{i}>0$,
и неотмеченной в противном случае.
Подсчитать число отрицательных элементов матрицы, расположенных в отмеченных строках.
}

uses
  SysUtils, Windows;

var
  m, i, j, count: integer;
  a: array[1..100] of integer;
  matrix: array[1..100, 1..100] of integer;
begin
  SetConsoleOutputCP(65001);
  write('Введите порядок матрицы m (1..100): ');
  readln(m);

  if (m < 1) or (m > 100) then
  begin
    writeln('Ошибка: m должно быть от 1 до 100');
    writeln('Нажмите Enter для выхода...'); readln;
    exit;
  end;

  writeln;
  writeln('Введите ', m, ' чисел для массива a:');
  for i := 1 to m do
  begin
    write('a[', i, '] = ');
    readln(a[i]);
  end;

  writeln;
  writeln('Введите элементы матрицы ', m, 'x', m, ' построчно:');
  for i := 1 to m do
  begin
    writeln('Строка ', i, ':');
    for j := 1 to m do
    begin
      write('matrix[', i, ',', j, '] = ');
      readln(matrix[i, j]);
    end;
  end;

  count := 0;

  for i := 1 to m do
  begin
    if a[i] > 0 then
    begin
      for j := 1 to m do
      begin
        if matrix[i, j] < 0 then
          inc(count);
      end;
    end;
  end;

  writeln('Ответ: число отрицательных элементов в отмеченных строках = ', count);
  writeln('Нажмите Enter для выхода...'); readln;
end.

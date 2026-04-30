{
Автор: Булдыгеров Алексей
Задание № 28 (680б). В данной действительности матрице размера _n x m_ (n ≥ 3, m ≥ 3)
поменять местами: столбцы с номерами 3 и n-2.
}

uses
  SysUtils, Windows;

var
  a: array[1..100, 1..100] of double;
  n, m, i, j :integer;
  temp :double;
begin
  SetConsoleOutputCP(65001);
  write('Введите n строк (>=3): '); readln(n);
  write('Введите m столбцов (>=3): '); readln(m);

  writeln('Введите элементы матрицы по строкам:');
  for i := 1 to n do
    for j := 1 to m do begin
      write('a[', i, ',', j, '] = '); readln(a[i, j]);
    end;

// проверка выходов
  if (3 < 1) or (3 > m) or (n-2 < 1) or (n-2 > m) then begin
    writeln('Ошибка: один из столбцов выходит за пределы матрицы');
    writeln('Нажмите Enter...'); readln; exit;
  end;

// обмен
  for i := 1 to n do begin
    temp := a[i, 3]; a[i, 3] := a[i, n-2]; a[i, n-2] := temp;
  end;

  writeln('Матрица после обмена:');
  for i := 1 to n do begin
    for j := 1 to m do write(a[i, j]:8:2, ' '); writeln;
  end;
  writeln('Нажмите Enter для выхода...'); readln;
end.

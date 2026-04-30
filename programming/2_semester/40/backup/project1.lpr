{
Автор: Булдыгеров Алексей
Задание № 40 (680б). В данной действительности матрице размера n x m
(n ≥ 3, m ≥ 3) поменять местами: столбцы с номерами 3 и n-2.
}
{$codepage UTF8}
  uses
    SysUtils;

type
  TMat = array of array of double;
//ввод матрицы
procedure ReadMat(var A: TMat; n, m: integer);
var
  i, j: integer;
  choice: char;
begin
  Randomize;
  SetLength(A, n, m);
  write('Заполнить матрицу случайными числами? [y/n]: '); readln(choice);

  if (choice = 'y') or (choice = 'Y') then
  begin
    //генерация
    for i := 0 to n - 1 do
    begin
      for j := 0 to m - 1 do
      begin
        A[i, j] := Random(100);
        write(A[i, j]:8:2, ' ');
      end;
      writeln;
    end;
  end
  else
  //вручную
  begin
    writeln('Введите элементы матрицы:');
    for i := 0 to n - 1 do
      for j := 0 to m - 1 do
        read(A[i, j]);
    readln;
  end;
end;


procedure WriteMat(const A: TMat; n, m: integer);
var i, j: integer;
begin
  for i := 0 to n - 1 do
  begin
    for j := 0 to m - 1 do write(A[i, j]:8:2, ' ');
    writeln;
  end;
end;


procedure SwapCols(var A: TMat; n, c1, c2: integer);
var i: Integer; t: double;
begin
  for i := 0 to n-1 do
  begin
    t := A[i, c1]; A[i, c1] := A[i, c2]; A[i, c2] := t;
  end;
end;

var
  n, m, c1, c2: Integer;
  mat: TMat;
//ввод размеров матрицы
begin
  write('Введите n и m: '); readln(n, m);
//если размер матрицы < 3
  if (n < 3) or (m < 3) then
begin
  writeln('Ошибка: n и m должны быть >= 3!');
  writeln('Нажмите Enter для выхода...'); readln;
  exit;
end;

  ReadMat(mat, n, m);

  c1 := 2;
  c2 := n - 3;
//проверка на сущ. столбца c2
  if (c2 < 0) or (c2 >= m) then
  begin
  writeln('Ошибка: столбец m-2 выходит за границы m!');
  writeln('Нажмите Enter для выхода...'); readln;
  end
  else
  begin
  SwapCols(mat, n, c1, c2);
  writeln('Результат:'); WriteMat(mat, n, m);
  end;
  writeln('Нажмите Enter для выхода...'); readln;
end.

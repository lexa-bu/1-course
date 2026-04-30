//Задание 31 (694в).
//Получить квадратную матрицу порядка n:
// \quad
// \begin{vmatrix}
// n & & & & & \\
// &n-1 & & & 0& \\
// & & & & & \\
// & & & & & \\
// &0 & & & & \\
// & & & & &1// \end{vmatrix}
//Рисунок в папке
uses
  SysUtils, Windows;

var
  a: array[1..100, 1..100] of integer;
  n, i, j: integer;
begin
  SetConsoleOutputCP(65001);
  write('Введите порядок матрицы n: '); readLn(n);

  for i := 1 to n do
    for j := 1 to n do
      a[i, j] := 0;

  for i := 1 to n do
    a[i, i] := n - i + 1;

  for i := 1 to n do
  begin
    for j := 1 to n do
      write(a[i, j]:4); writeln;
  end;
    writeln('Нажмите Enter для выхода...'); readln;
end.

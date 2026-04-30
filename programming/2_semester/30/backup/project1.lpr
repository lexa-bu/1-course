//Задание 30 (694з).
//Получить квадратную матрицу порядка n:
// \quad
// \begin{vmatrix}
// 1 & 1 & \dots & 1 & 1 \\
//   & 1 & \dots & 1 &   \\
// 0 &   & \dots &   & 0 \\
//   & 1 & \dots & 1 &   \\
// 1 & 1 & \dots & 1 & 1
// \end{vmatrix}
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
      if (i = 1) or (i = n) or (j = 1) or (j = n) then
        a[i, j] := 1
      else
        a[i, j] := 0;

  for i := 1 to n do begin
    for j := 1 to n do
      write(a[i, j]:4);
    writeln;
  end;
  writeln('Нажмите Enter для выхода...'); readln;
end.

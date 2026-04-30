{
Автор: Булдыгеров Алексей
Задание № 29 (692г). Дана действительная квадратная матрица порядка n. Найти наибольшее из
значений элементов, расположенных в заштрихованной части матрицы:
}

  uses
    SysUtils, Windows;

  var
    n, i, j: integer;
    a: array[1..100, 1..100] of real;
    max: real;

  begin
    SetConsoleOutputCP(65001);
    writeln('Введите размер матрицы n:');
    readln(n);

    writeln('Введите элементы матрицы:');
    for i := 1 to n do
      for j := 1 to n do
        read(a[i, j]);

    max := a[n, 1];

    writeln('Исходная матрица:');
      for i := 1 to n do
        begin
        for j := 1 to n do
          write(a[i, j]:8:2, ' ');
        writeln;
      end;

// поиск максимума в нижнем треугольнике (i >= j)
      for i := 1 to n do
        for j := 1 to i do
          if a[i, j] > max then
            max := a[i, j];

      writeln('Наибольший элемент в заштрихованной части: ', max:0:2); readln;
      writeln('Нажмите Enter для выхода...'); readln;
  end.

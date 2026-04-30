{
Автор: Булдыгеров Алексей
Задание № 37 (429). Даны натуральные числа n, m, целые числа
$a_{1}, ..., a_{n}, b_{1}, ..., b_{m}, c_{1}, ..., c_{30}$.
Получить $$l = \begin{cases}
\min(b_1, \dots, b_m) + \min(c_1, \dots, c_{30}) & \\
\text{при } |\min(a_1, \dots, a_n)| > 10, \\
1 + (\max(c_1, \dots, c_{30}))^2 & \text{в противном случае.}
\end{cases}$$
}
{$codepage UTF8}    // включение кириллицы (2 вариант)
uses
  SysUtils, Windows;

//vминимальный элемент массива
function GetMin(const arr: array of integer): integer;
var
  i: integer;
begin
  if Length(Arr) = 0 then
    raise Exception.Create('Пустой массив!');
  result := arr[0];
  for i := 1 to high(arr) do
    if arr[i] < result then
      result := arr[i];
end;

// максимальный элемент массива
function GetMax(const arr: array of integer): integer;
var
  i: integer;
begin
  if length(Arr) = 0 then
    raise Exception.Create('Пустой массив!');
  result := arr[0];
  for i := 1 to high(arr) do
    if arr[i] > result then
      result := arr[i];
end;

// ввод массива
procedure ReadArray(var arr: array of integer; const prompt: string);
var
  i: integer;
begin
  writeln(prompt);
  for i := 0 to high(arr) do
    read(arr[i]); readln;
end;

var
  n, m, i: integer;
  l: int64;
  a, b: array of integer;
  c: array[0..29] of integer;
  y_or_n: char;
begin
  // SetConsoleCP(65001);
  // SetConsoleOutputCP(65001); почему-то не работают, я вставил вместо их {$codepage UTF8}
  write('Введите число n: '); readLn(n);
  write('Введите число m: '); readLn(m);
  // проверка на некорректный ввод размеров
  if (n <= 0) or (m <= 0) then
  begin
    writeln('Ошибка: n и m должны быть натуральными числами!'); readln;
    exit;
  end;

  setlength(a, n);
  setlength(b, m);

  readarray(a, 'Введите ' + IntToStr(n) + ' элементов массива a:');
  readarray(b, 'Введите ' + IntToStr(m) + ' элементов массива b:');

  randomize;
   writeln('Необходимо ввести 30 элементов массива c. Сгенерировать их? [Y/N]:'); readln(y_or_n);
   // генерация
     if (y_or_n = 'y') or (y_or_n = 'Y') then
     begin
        for i := 0 to 29 do
        begin
          if i = 0 then
            c[i] := random(3) + 1
          else
            c[i] := c[i-1] + random(5) + 1;

          writeln('c[', i + 1, '] = ', c[i]);
        end;
      end
     else
     // вручную
     begin
       writeln('Введите 30 чисел:');
       for i := 0 to 29 do
       begin
         write('c[', i + 1, '] = ');
         readln(c[i]);
       end;
     end;

  // результат GetMin к Int64
  if abs(Int64(GetMin(a))) > 10 then
    l := int64(GetMin(b)) + int64(GetMin(c))
  else
    l := 1 + sqr(Int64(GetMax(c)));

  writeln('l = ', l);
  writeln('Нажмите Enter для выхода...'); readln;
end.

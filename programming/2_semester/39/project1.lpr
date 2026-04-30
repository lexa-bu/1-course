{
Автор: Булдыгеров Алексей
Задание № 39 (457) Даны натуральные числа a, c, m. Получить f(m), где
$$f(n) = \begin{cases}
n, \text{если } 0 \le n \le 9, \\
g(n) f(n - 1 - g(n)) + n & \text{\textbf{в противном случае.}}
\end{cases}$$ g(n) = _остаток от деления_ $a_{n+c}$ на 10.
}
{$codepage UTF8}
  uses
    SysUtils;

var A, C, M: integer;

// остаток от деления (a*n + c) / 10
function G(n:integer): integer;
begin
  result := abs(A * n + C) mod 10;
end;

function F(n: integer): int64;
begin
  if (n >= 0) and (n <= 9) then
    result := n
  else
// рекурсивный вызов
// g(n) * f(n - 1 - g(n)) + n
    result := int64(G(n)) * F(n - 1 - G(n)) + n;
end;

begin
// ввод параметров
  write('Введите a: '); readln(A);
  write('Введите c: '); readln(C);
  write('Введите m: '); readln(M);

  if M < 0 then
  begin
    writeln('Ошибка: m должно быть неотрицательным.');
  end
  else
  begin
    writeln('Ответ: f(', M, ') = ', F(M));
  end;
  write('Нажмите Enter для выхода...'); readln;
end.

//Задание 10.
//Дано натуральное число n (n ≤ 9999).
//б) Верно ли, что это цисло содержит ровно три одинаковые цифры,
//как, например, числа 6676, 4544, 0006 и т.д.?
uses
  SysUtils, Windows;

var
   n, a, b, count :Integer;
   found :boolean;
   c :string;
begin
  SetConsoleOutputCP(65001);
  writeln('Введите число до 9999: '); readln(n);
  c := IntToStr(n);
  while Length(c) < 4 do
  c := '0' + c;
  found :=false;
  for b := 1 to 4 do
  count := 0;
  for a := 1 to 4 do
  if c[b] = c[a] then
    count := count + 1;
  if count = 3 then
  found := true;
  if found then
  writeln('Число СОДЕРЖИТ ровно три одинаковые цифры')
else
  writeln('Число НЕ СОДЕРЖИТ ровно три одинаковые цифры');
  writeLn('Нажмите Enter для выхода...'); readln;
end.

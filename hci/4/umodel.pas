// Модуль uModel: Отвечает за математические расчеты и работу с файлами
// Автор: Булдыгеров Алексей
unit uModel;

{$mode objfpc}{$H+}

interface

// Вычисление гравитационной силы F = G * (m1 * m2) / r^2; G = 6.674e-11 Н * м^2 / кг^2.
// m1 и m2 - масса тел в кг;  r - расстояние между ними.
// Возвращает значение вычесленной гравитационной силы в Ньютонах.
function Calculate(m1, m2, r: double): double;
// Сохраняет введённые данные в файл.
procedure SaveToData(fileName, m1, m2, r: string);
// Загружает данные из файла.
procedure LoadFromData(fileName: string; out m1, m2, r: string);

implementation

// Вычисление гравитационной силы F = G * (m1 * m2) / r^2; G = 6.674e-11 Н * м^2 / кг^2.
// m1 и m2 - масса тел в кг;  r - расстояние между ними.
// Возвращает значение вычесленной гравитационной силы в Ньютонах.
function Calculate(m1, m2, r: double): double;
const
  G = 6.674e-11;
begin
  Result := G * m1 * m2 / (r * r);
end;
// Сохраняет введённые данные в файл.
procedure SaveToData(fileName, m1, m2, r: string);
var
  f: TextFile;
begin
  AssignFile(f, fileName);
  Rewrite(f);

  writeln(f, m1);
  writeln(f, m2);
  writeln(f, r);

  CloseFile(f);
end;
// Загружает данные из файла.
procedure LoadFromData(fileName: string; out m1, m2, r: string);
var
  f: TextFile;
begin
  AssignFile(f, fileName);
  Reset(f);

  readln(f, m1);
  readln(f, m2);
  readln(f, r);

  CloseFile(f);
end;

end.

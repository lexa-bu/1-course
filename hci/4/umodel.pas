// Модуль uModel (данные и логика): Отвечает за математические расчеты и работу с файлами.
// Автор: Булдыгеров Алексей
unit uModel;

{$mode objfpc}{$H+}

interface

// Вычисление гравитационной силы F = G * (m1 * m2) / r^2; G = 6.674e-11 Н * м^2 / кг^2.
// m1 и m2 - масса тел в кг;  r - расстояние между ними.
// Возвращает значение вычесленной гравитационной силы в Ньютонах.
function Calculate(m1, m2, r: double): double;
// Сохраняет введённые данные в файл.
// fileName - путь к файлу; m1, m2, r - значения, которые будут записаны.
procedure SaveToData(fileName: string; m1, m2, r: double);
// Загружает данные из файла.
// fileName - путь к файлу; m1, m2, r - значения, которые будут загружены из файла.
procedure LoadFromData(fileName: string; out m1, m2, r: double);
// Сохраняет отчёт в файл.
// fileName - путь к файлу; report - Текст отчёта.
procedure SaveToReport(fileName, report: string);
// Загружает отчёт из файла.
// fileName - путь к файлу; report - Текст отчёта.
procedure OpenFromReport(fileName: string; out report: string);
implementation

// Вычисление гравитационной силы F = G * (m1 * m2) / r^2; G = 6.674e-11 Н * м^2 / кг^2.
// m1 и m2 - масса тел в кг;  r - расстояние между ними.
// Возвращает значение вычесленной гравитационной силы в Ньютонах.
function Calculate(m1, m2, r: double): double;
const
  G = 6.674e-11;           // Константа.
begin
  Result := G * m1 * m2 / (r * r); // Вычисление.
end;


// Сохраняет введённые данные в файл.
// fileName - путь к файлу; m1, m2, r - значения, которые будут записаны.
procedure SaveToData(fileName: string; m1, m2, r: double);
var
  f: TextFile;             // Файловая переменная.
begin
  AssignFile(f, fileName); // Связь f с путём к файлу.
  try
  Rewrite(f);              // Создание нового файла.

  writeln(f, m1);          // Запись данных.
  writeln(f, m2);
  writeln(f, r);
  finally
  CloseFile(f);            // Закрывает файл.
  end;
end;


// Загружает данные из файла.
// fileName - путь к файлу; m1, m2, r - значения, которые будут загружены из файла.
procedure LoadFromData(fileName: string; out m1, m2, r: double);
var
  f: TextFile;             // Файловая переменная.
begin
  AssignFile(f, fileName); // Связь f с путём к файлу.
  try
  Reset(f);                // Открытие файла.

  readln(f, m1);           // Чтение файлов.
  readln(f, m2);
  readln(f, r);
  finally
  CloseFile(f);            // Закрывает файл.
  end;
end;


// Сохраняет отчёт в файл.
// fileName - путь к файлу; report - Текст отчёта.
procedure SaveToReport(fileName, report: string);
var
  f: TextFile;             // Файловая переменная.
begin
  AssignFile(f, fileName); // Связь f с путём к файлу.
  try
  Rewrite(f);              // Создание нового файла.

  write(f, report);      // Запись данных.
  finally
  CloseFile(f);            // Закрывает файл.
  end;
end;


// Загружает отчёт из файла.
// fileName - путь к файлу; report - Текст отчёта.
procedure OpenFromReport(fileName: string; out report: string);
var
  f: TextFile;             // Файловая переменная.
  line: string;            // Строка для чтения.
begin
  report := '';            // Очистка.
  AssignFile(f, fileName); // Связь f с путём к файлу.
  try
  Reset(f);                // Открытие файла.

  while not Eof(f) do      // Чтение файла до самого конца.
  begin
  readln(f, line);         // Чтение файлов.
  if report <> '' then
    report := report + LineEnding;  // Перенос строки
  report := report + line;          // Добавление строки
  end;
  finally
  CloseFile(f);            // Закрывает файл.
  end;
end;
end.

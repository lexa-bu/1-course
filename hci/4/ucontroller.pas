// Модуль uController: Проверяет корректность данных перед расчётом.
// Автор: Булдыгеров Алексей
unit uController;

{$mode objfpc}{$H+}

interface
// Проверяет входные данные на корректность и вызывает расчёт силы.
// m1 и m2 - масса тел в кг;  r - расстояние между ними;
// F - переменная для записи результата; ErrorMsg - переменная для записи ошибки.
// Возвращает true (успех) или false (ошибка) при вычислении силы через F.
function TryCalculate(m1, m2, r: double; out F: double; out ErrorMsg: string): boolean;
// Передаёт комманду на сохранение данных в файл.
procedure SaveData(fileName: string; m1, m2, r: double);
// Передаёт комманду на загрузку данных в файл.
procedure LoadData(fileName: string; out m1, m2, r: double);
// Передаёт комманду на сохранение отчёта в файл.
procedure SaveReport (fileName, report: string);
// Передаёт комманду на загрузку отчёта в файл.
procedure LoadReport(fileName: string; out report: string);

implementation

uses SysUtils, uModel;
// Проверяет входные данные на корректность и вызывает расчёт силы.
// m1 и m2 - масса тел в кг;  r - расстояние между ними;
// F - переменная для записи результата; ErrorMsg - переменная для записи ошибки.
// Возвращает true (успех) или false (ошибка) при вычислении силы через F.
function TryCalculate(m1, m2, r: double; out F: double; out ErrorMsg: string): boolean;
begin // проверки
  if m1 < 0 then
  begin
    ErrorMsg := 'm1 не может быть < 0!';
    Exit(False);
  end;

  if m2 < 0 then
  begin
    ErrorMsg := 'm2 не может быть < 0!';
    Exit(False);
  end;

  if r <= 0 then
  begin
    ErrorMsg := 'r должно быть > 0!';
    Exit(False);
  end;

  F := uModel.Calculate(m1, m2, r); // Передает данные в uModel.
  Result := True;
end;


// Передаёт комманду на сохранение данных в файл.
// fileName - путь к файлу; m1, m2, r - значения, которые будут записаны.
procedure SaveData(fileName: string; m1, m2, r: double);
begin
  uModel.SaveToData(fileName, m1, m2, r);    // Обращение к модулю uModel.
end;


// Передаёт комманду на загрузку данных в файл.
// fileName - путь к файлу; m1, m2, r - значения, которые будут загружены из файла.
procedure LoadData(fileName: string; out m1, m2, r: double);
begin
  uModel.LoadFromData(fileName, m1, m2, r);  // Обращение к модулю uModel.
end;


// Передаёт комманду на сохранение отчёта в файл.
procedure SaveReport(fileName, report: string);
begin
  uModel.SaveToReport(fileName, report);     // Обращение к модулю uModel.
end;

// Передаёт комманду на загрузку отчёта в файл.
procedure LoadReport(fileName: string; out report: string);
begin
  uModel.OpenFromReport(fileName, report);   // Обращение к модулю uModel.
end;


end.

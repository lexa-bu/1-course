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
procedure SaveData(fileName, m1, m2, r: string);
// Передаёт комманду на загрузку данных в файл.
procedure LoadData(fileName: string; out m1, m2, r: string);
implementation

uses SysUtils, uModel;
// Проверяет входные данные на корректность и вызывает расчёт силы.
// m1 и m2 - масса тел в кг;  r - расстояние между ними;
// F - переменная для записи результата; ErrorMsg - переменная для записи ошибки.
// Возвращает true (успех) или false (ошибка) при вычислении силы через F.
function TryCalculate(m1, m2, r: double; out F: double; out ErrorMsg: string): boolean;
begin
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


  F := uModel.Calculate(m1, m2, r);
  Result := True;
end;
// Передаёт комманду на сохранение данных в файл.
procedure SaveData(fileName, m1, m2, r: string);
begin
  uModel.SaveToData(fileName, m1, m2, r);
end;
// Передаёт комманду на загрузку данных в файл.
procedure LoadData(fileName: string; out m1, m2, r: string);
begin
  uModel.LoadFromData(fileName, m1, m2, r);
end;

end.

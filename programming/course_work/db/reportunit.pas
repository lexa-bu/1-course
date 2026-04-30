unit ReportUnit;

{ Модуль формирования и вывода отчёта о продажах }
{ Автор: Булдыгеров Алексей }

{$mode ObjFPC}{$H+}
{$codepage utf8}
interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ActnList,
  uTypes, uDataLogic;

type

  { TReportForm }

  TReportForm = class(TForm)
    CloseReportForm: TAction;
    OpenReportAction: TAction;
    SaveReportAction: TAction;
    ActionList1: TActionList;
    OpenFileReportButton: TButton;
    SaveFileReportButton: TButton;         // Кнопка: Открыть файл отчёта
    ReportLabel: TLabel;                   // Заголовок формы отчёта
    ReportMemo: TMemo;                     // Поле для вывода текста отчёта
    // Сохранить отчёт в текстовый файл
    // Вызывает диалог сохранения, записывает содержимое Memo
    procedure CloseReportFormExecute(Sender: TObject);
    procedure OpenFileReportButtonClick(Sender: TObject);
    procedure SaveFileReportButtonClick(Sender: TObject);
  private
  public
    // Показать отчёт по продажам
    // SalesList: список всех продаж за день
    // SellerName: ФИО продавца для заголовка
    procedure ShowReport(const SalesList: TSaleList; const SellerName: string);
  end;

var
  ReportForm: TReportForm;

implementation
{$R *.lfm}
{ TReportForm }
//=============================================================================

// Показать отчёт: сформировать текст и вывести в Memo
// Проходит по списку продаж, группирует по чекам, считает итоги
procedure TReportForm.ShowReport(const SalesList: TSaleList; const SellerName: string);
var
  TempNode: PNode;           // Указатель для обхода списка
  TotalSales: double;        // Общая выручка за день
  TotalItems: integer;       // Всего продано товаров (шт)
  CheckID: integer;          // Порядковый номер текущего чека (1, 2, 3...)
  CheckTotal: double;        // Сумма текущего чека
  LastDateTime: TDateTime;   // Время последнего обработанного чека
begin
  ReportMemo.Clear;

  // Заголовок отчёта
  ReportMemo.Lines.Add('════════════════════════════════════════');
  ReportMemo.Lines.Add('           ОТЧЁТ О ПРОДАЖАХ');
  ReportMemo.Lines.Add('════════════════════════════════════════');
  ReportMemo.Lines.Add('');
  ReportMemo.Lines.Add('Продавец: ' + SellerName);
  ReportMemo.Lines.Add('Дата формирования: ' + DateTimeToStr(Now));
  ReportMemo.Lines.Add('');
  ReportMemo.Lines.Add('════════════════════════════════════════');

  // Инициализация переменных
  TotalSales := 0;
  TotalItems := 0;
  CheckID := 0;              // Счётчик чеков (начинаем с 0, первый Inc даст 1)
  CheckTotal := 0;
  LastDateTime := 0;

  TempNode := SalesList.Head;

  // Обход всех записей в списке продаж
  while TempNode <> nil do
  begin
    // Если время чека отличается от последнего → начался новый чек
    if TempNode^.Data.CheckDateTime <> LastDateTime then
    begin
      // Вывести итоги предыдущего чека (если он был)
      if CheckID > 0 then
      begin
        ReportMemo.Lines.Add('  Сумма чека: ' + FormatFloat('0.00', CheckTotal) + ' руб.');
        ReportMemo.Lines.Add('');
      end;

      // Начать новый чек
      Inc(CheckID);          // Увеличиваем номер чека (1, 2, 3...)
      CheckTotal := 0;       // Сброс суммы текущего чека
      LastDateTime := TempNode^.Data.CheckDateTime;  // Запомнить время

      // Заголовок чека
      ReportMemo.Lines.Add('Чек №' + IntToStr(CheckID) + ' от ' + DateTimeToStr(LastDateTime));
      ReportMemo.Lines.Add('════════════════════════════════════════');
    end;

    // Добавить строку товара в отчёт
    ReportMemo.Lines.Add(Format('  %s | %s | %d шт. | %.2f руб.',
      [TempNode^.Data.Name,
       TempNode^.Data.ItemType,
       TempNode^.Data.Quantity,
       TempNode^.Data.Subtotal]));

    // Накопить суммы для итогов
    CheckTotal := CheckTotal + TempNode^.Data.Subtotal;
    TotalSales := TotalSales + TempNode^.Data.Subtotal;
    TotalItems := TotalItems + TempNode^.Data.Quantity;

    TempNode := TempNode^.Next;
  end;

  // Вывести итоги последнего чека
  if CheckID > 0 then
  begin
    ReportMemo.Lines.Add('  Сумма чека: ' + FormatFloat('0.00', CheckTotal) + ' руб.');
    ReportMemo.Lines.Add('');
  end;

  // Общие итоги за день
  ReportMemo.Lines.Add('════════════════════════════════════════');
  ReportMemo.Lines.Add('ИТОГО ЗА ДЕНЬ:');
  ReportMemo.Lines.Add('Всего чеков: ' + IntToStr(CheckID));
  ReportMemo.Lines.Add('Всего товаров: ' + IntToStr(TotalItems) + ' шт.');
  ReportMemo.Lines.Add('Общая выручка: ' + FormatFloat('0.00', TotalSales) + ' руб.');
  ReportMemo.Lines.Add('════════════════════════════════════════');
end;

//=============================================================================

// Сохранить отчёт в текстовый файл
// Вызывает диалог сохранения, записывает содержимое Memo
procedure TReportForm.SaveFileReportButtonClick(Sender: TObject);
var
  SaveDlg: TSaveDialog;
begin
  SaveDlg := TSaveDialog.Create(nil);
  try
    SaveDlg.Filter := 'Text files|*.txt';
    SaveDlg.Title := 'Сохранить отчёт';

    if SaveDlg.Execute then
    begin
      ReportMemo.Lines.SaveToFile(SaveDlg.FileName);
      MessageDlg('Успех!', 'Отчёт успешно сохранён!', mtInformation, [mbOK], 0);
    end;
  finally
    SaveDlg.Free;
  end;
end;

// Открыть ранее сохраненный файл отчёта
// Вызывает диалог открытия, загружает текст из файла в Memo
procedure TReportForm.OpenFileReportButtonClick(Sender: TObject);
var
  OpenDlg: TOpenDialog;
begin
  // Создаем диалог открытия файла
  OpenDlg := TOpenDialog.Create(nil);
  try
    OpenDlg.Filter := 'Текстовые файлы|*.txt|Все файлы|*.*';
    OpenDlg.Title := 'Выберите файл отчёта для открытия';

    // Если пользователь выбрал файл и нажал "Ок"
    if OpenDlg.Execute then
    begin
      // Проверяем существование файла перед загрузкой
      if FileExists(OpenDlg.FileName) then
      begin
        ReportMemo.Lines.LoadFromFile(OpenDlg.FileName);
        MessageDlg('Успех!', 'Отчёт успешно загружен из файла!', mtInformation, [mbOK], 0);
      end
      else
        MessageDlg('Ошибка', 'Файл не найден.', mtError, [mbOK], 0);
    end;
  finally
    OpenDlg.Free;
  end;
end;

procedure TReportForm.CloseReportFormExecute(Sender: TObject);
begin
  Close;
end;

end.

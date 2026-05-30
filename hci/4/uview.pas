// Модуль uView: Отвечает за визуальный интерфейс, обработку действий пользователя и вывод результатов.
// Автор: Булдыгеров Алексей
unit uView;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ActnList, Menus, Windows, Classes;

type

  { TTask }

  TTask = class(TForm)
    ActionList1: TActionList;                         // горячие клавиши
    ActionInfo: TAction;                              // о программе F1
    ActionOpen: TAction;                              // открыть      Ctrl+O
    ActionSave: TAction;                              // сохранить   Ctrl+S
    ActionDel: TAction;                               // очистка     Del
    ActionResult: TAction;                            // рассчитать  F2
    ActionExitEsc: TAction;                           // выход       Esc
    ActionExit: TAction;                              // выход       Ctrl+Q
    ButtonClear: TButton;                             // кнопка "Очистить"
    ButtonResult: TButton;                            // кнопка "Рассчитать"
    Edit_m1: TEdit;                                   // ввод данных в m1
    Edit_m2: TEdit;                                   // ввод данных в m2
    Edit_r: TEdit;                                    // ввод данных в r
    Image: TImage;                                    // фото
    Label_res: TLabel;                                // текст с результатом
    Label_task: TLabel;                               // текст с задачей
    Label_m1: TLabel;                                 // m1 (масса 1 тела в кг)
    Label_m2: TLabel;                                 // m2 (масса 2 тела в кг)
    Label_r: TLabel;                                  // r  (расстояние между ними в м)
    Label_formuls: TLabel;                            // текст с формулами
    MemoHistory: TMemo;                               // история
    MainMenu1: TMainMenu;                             // меню
    MenuSave: TMenuItem;                              // Сохранить...
    SaveDialog: TSaveDialog;                          // сохранение файла
    MenuItemSave: TMenuItem;                          // Сохранить... > Сохранить данные
    MenuItemSaveReport: TMenuItem;                    // Сохранить... > Сохранить отчёт
    MenuOpen: TMenuItem;                              // Открыть...
    OpenDialog: TOpenDialog;                          // открытие файла
    MenuItemOpen: TMenuItem;                          // Открыть... > Открыть данные
    MenuItemOpenReport: TMenuItem;                    // Открыть... > Открыть отчёт
    MenuItemRef: TMenuItem;                           // Справка
    MenuItemRef_info: TMenuItem;                      // Справка > О программе...
    MenuItemRef_autor: TMenuItem;                     // Справка > Об авторе...
    MenuItemRef_Hotkeys: TMenuItem;                   // Справка > Горячие клавиши
    // Выход из программы
    procedure ActionExitExecute(Sender: TObject);
    // Кнопка "Очистить".
    // Очищает поля ввода. результат и историю.
    procedure ButtonClearClick(Sender: TObject);
    // Кнопка "Рассчитать".
    // Считывает данные. отправляет контроллеру и выводит результат / ошибку.
    procedure ButtonResultClick(Sender: TObject);
    // Меню Сохранить... > Сохранить данные.
    // Вызывает SaveDialog и передает данные контроллеру для записи в файл.
    procedure MenuItemSaveClick(Sender: TObject);
    // Меню Сохранить... > Сохранить отчёт.
    // Вызывает SaveDialog и записывает историю расчетов в файл.
    procedure MenuItemSaveReportClick(Sender: TObject);
    // Меню Открыть... > Открыть данные.
    // Вызывает OpenDialog и загружает данные через контроллер
    procedure MenuItemOpenClick(Sender: TObject);
    // Меню Открыть... > Открыть отчёт.
    // Вызывает OpenDialog и загружает историю расчетов из файла.
    procedure MenuItemOpenReportClick(Sender: TObject);
    // Меню Справка > Об авторе.
    // Показывает окно с информацией об авторе.
    procedure MenuItemRef_autorClick(Sender: TObject);
    // Меню Справка > О программе.
    // Показывает окно с информацией о программе.
    procedure MenuItemRef_infoClick(Sender: TObject);
    // Меню Справка > Горячие клавиши.
    // Показывает Form с горячими клавишами.
    procedure MenuItemRef_HotkeysClick(Sender: TObject);
  private
  public
  end;

var
  Task: TTask;

implementation

uses uController, Hotkeys;

{$R *.lfm}
// Кнопка "Рассчитать".
// Считывает данные. отправляет контроллеру и выводит результат / ошибку.
// m1 и m2 - масса тел в кг;  r - расстояние между ними; F - гравитационная сила.
procedure TTask.ButtonResultClick(Sender: TObject);
var
  m1, m2, r, F: double;
  ErrorMsg: string;
begin
  try
    m1 := StrToFloat(Edit_m1.Text);
    m2 := StrToFloat(Edit_m2.Text);
    r  := StrToFloat(Edit_r.Text);

    if uController.TryCalculate(m1, m2, r, F, ErrorMsg) then
    begin
      Label_res.Caption := Format('✔ F = %.2e Н', [F]);
      Label_res.Font.Color := clGreen;
      MemoHistory.Lines.Add(Format('✔ Расчет: m1=%.2f, m2=%.2f, r=%.2f, Ответ=%.2e Н', [m1, m2, r, F]));
    end
    else

    begin
      Label_res.Caption := '❌ Ошибка: ' + ErrorMsg;
      Label_res.Font.Color := clRed;
      MemoHistory.Lines.Add('❌ Ошибка: ' + ErrorMsg);
      MessageBeep(MB_ICONERROR);
    end;
  except
    Label_res.Caption := '❌ Ошибка: Введите корректные числа!';
    Label_res.Font.Color := clRed;
    MemoHistory.Lines.Add('❌ Ошибка: Введите корректные числа!');
    MessageBeep(MB_ICONERROR);
  end;
end;


// Меню Сохранить... > Сохранить данные.
// Вызывает SaveDialog и передает данные контроллеру для записи в файл.
procedure TTask.MenuItemSaveClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    uController.SaveData(SaveDialog.FileName,
    StrToFloat(Edit_m1.Text),
    StrToFloat(Edit_m2.Text),
    StrToFloat(Edit_r.Text));

    MemoHistory.Lines.Add('✔ Данные успешно сохранены!');
    Label_res.Caption := '✔ Данные успешно сохранены!';
    Label_res.Font.Color := clGreen;
    MessageBeep(MB_OK);
  end;
end;


// Меню Сохранить... > Сохранить отчёт.
// Вызывает SaveDialog и записывает историю расчетов в файл.
procedure TTask.MenuItemSaveReportClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    MemoHistory.Lines.SaveToFile(SaveDialog.FileName);

    MemoHistory.Lines.Add('✔ Отчёт успешно сохранён!');
    Label_res.Caption := '✔ Отчёт успешно сохранён!';
    Label_res.Font.Color := clGreen;
    MessageBeep(MB_OK);
  end;
end;


// Меню Открыть... > Открыть данные.
// Вызывает OpenDialog и загружает данные через контроллер.
// m1 и m2 - масса тел в кг;  r - расстояние между ними.
procedure TTask.MenuItemOpenClick(Sender: TObject);
var
  m1, m2, r: double;
begin
  if OpenDialog.Execute then
  begin
    uController.LoadData(OpenDialog.FileName, m1, m2, r);

    Edit_m1.Text := FloatToStr(m1);
    Edit_m2.Text := FloatToStr(m2);
    Edit_r.Text  := FloatToStr(r);

    MemoHistory.Lines.Add('✔ Данные успешно загружены!');
    Label_res.Caption := '✔ Данные успешно загружены!';
    Label_res.Font.Color := clGreen;
    MessageBeep(MB_OK);

    ButtonResultClick(nil);
  end;
end;


// Меню Открыть... > Открыть отчёт.
// Вызывает OpenDialog и загружает историю расчетов из файла.
procedure TTask.MenuItemOpenReportClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    try
      MemoHistory.Lines.LoadFromFile(OpenDialog.FileName);
      MemoHistory.Lines.Add('✔ Отчёт успешно загружен!');
      Label_res.Caption := '✔ Отчёт успешно загружен!';
      Label_res.Font.Color := clGreen;
      MessageBeep(MB_OK);
    except
      on E: Exception do
      begin
        Label_res.Caption := '❌ Ошибка: ' + E.Message;
        Label_res.Font.Color := clRed;
        MemoHistory.Lines.Add('❌ Ошибка: ' + E.Message);
        MessageBeep(MB_ICONERROR);
      end;
    end;
  end;
end;

// Кнопка "Очистить".
// Очищает поля ввода. результат и историю.
procedure TTask.ButtonClearClick(Sender: TObject);
begin
  Edit_m1.Clear;
  Edit_m2.Clear;
  Edit_r.Clear;
  Label_res.Caption := '';
  MemoHistory.Lines.Clear;
end;


// Выход из программы.
procedure TTask.ActionExitExecute(Sender: TObject);
begin
  Close;
end;


// Меню Справка > Об авторе.
// Показывает окно с информацией об авторе.
procedure TTask.MenuItemRef_autorClick(Sender: TObject);
begin
  MessageDlg('Об авторе', 'Автор: Булдыгеров Алексей.' + #13#10 +
  'Студент 2-го курса по специальности "Информатика и вычислительная техника".' + #13#10 +
  'Telegram: @sixteenfive', mtInformation, [mbOk], 0);
end;


// Меню Справка > О программе.
// Показывает окно с информацией о программе.
procedure TTask.MenuItemRef_infoClick(Sender: TObject);
begin
  MessageDlg('О программе', 'Задача:' + #13#10 + 'Определить силу притяжения F между телами массы m1 и m2, находящимися на расстоянии r друг от друга.', mtInformation, [mbOk], 0);
end;


// Меню Справка > Горячие клавиши.
// Показывает TFormHotkeys с горячими клавишами.
procedure TTask.MenuItemRef_HotkeysClick(Sender: TObject);
begin
  if not Assigned(FormHotkeys) then
    Application.CreateForm(TFormHotkeys, FormHotkeys);

  if FormHotkeys.Visible then
  begin
    FormHotkeys.Hide;
  end
  else
  begin
    FormHotkeys.Left := Task.Left + Task.Width;
    FormHotkeys.Top := Task.Top;
    FormHotkeys.Show;
    MessageBeep(MB_OK);
  end;
end;


end.

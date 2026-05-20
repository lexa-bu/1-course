unit uView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ActnList, Menus;

type
  Ttask = class(TForm)
    ActionList1: TActionList;                         // горячие клавиши
    ActionInfo: TAction;                              // о программе F1
    ActionOpen: TAction;                              // открыть     Ctrl+O
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
    LabelHotkeys: TLabel;                             // текст с горяч. клавиш
    Label_res: TLabel;                                // текст с результатом
    Label_task: TLabel;                               // текст с задачей
    Label_m1: TLabel;                                 // m1 (масса 1 тела в кг)
    Label_m2: TLabel;                                 // m2 (масса 2 тела в кг)
    Label_r: TLabel;                                  // r  (расстояние между ними в м)
    Label_formuls: TLabel;                            // текст с формулами
    MemoHistory: TMemo;                               // история
    MainMenu1: TMainMenu;                             // меню
    MenuItemSave: TMenuItem;                          // Сохранить...
    OpenDialog1: TOpenDialog;                         // сохранение файла *.txt
    MenuItemOpen: TMenuItem;                          // Открыть...
    SaveDialog1: TSaveDialog;                         // открытие файла *.txt
    MenuItemRef: TMenuItem;                           // Справка
    MenuItemRef_info: TMenuItem;                      // Справка > О программе...
    MenuItemRef_autor: TMenuItem;                     // Справка > Об авторе...
    // выход из программы
    procedure ActionExitExecute(Sender: TObject);
    // кнопка "Очистить"
    procedure ButtonClearClick(Sender: TObject);
    // кнопка "Рассчитать"
    procedure ButtonResultClick(Sender: TObject);
    // меню Открыть...
    procedure MenuItemOpenClick(Sender: TObject);
    // меню Сохранить...
    procedure MenuItemSaveClick(Sender: TObject);
    // меню Справка > Об авторе...
    procedure MenuItemRef_autorClick(Sender: TObject);
    // меню Справка > О программе...
    procedure MenuItemRef_infoClick(Sender: TObject);
  private
  public
  end;

var
  task: Ttask;

implementation

uses uController;

{$R *.lfm}
// кнопка "Рассчитать"
procedure Ttask.ButtonResultClick(Sender: TObject);
begin
  uController.CalculateAndShow;
end;

// меню Сохранить...
procedure Ttask.MenuItemSaveClick(Sender: TObject);
begin
  uController.SaveToFile;
end;

// меню Открыть...
procedure Ttask.MenuItemOpenClick(Sender: TObject);
begin
  uController.LoadFromFile;
end;

// кнопка "Очистить"
procedure Ttask.ButtonClearClick(Sender: TObject);
begin
  uController.ClearAll;
end;

// выход из программы
procedure Ttask.ActionExitExecute(Sender: TObject);
begin
  Close;
end;

// меню Справка > Об авторе...
procedure Ttask.MenuItemRef_autorClick(Sender: TObject);
begin
  MessageDlg('Об авторе', 'Автор: Булдыгеров Алексей.' + #13#10 +
  'Студент 2-го курса по специальности "Информатика и вычислительная техника".' + #13#10 +
  'Telegram: @sixteenfive', mtInformation, [mbOk], 0);
end;
// меню Справка > О программе...
procedure Ttask.MenuItemRef_infoClick(Sender: TObject);
begin
  MessageDlg('О программе', 'Задача:' + #13#10 + 'Определить силу притяжения F между телами массы m1 и m2, находящимися на расстоянии r друг от друга.', mtInformation, [mbOk], 0);
end;

end.

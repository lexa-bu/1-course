unit uView;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ActnList, Menus, uController;

type

  { Ttask }

  Ttask = class(TForm, IGravitationView)
    ActionInfo: TAction;
    ActionOpen: TAction;
    ActionSave: TAction;
    ActionDel: TAction;
    ActionExitEsc: TAction;
    ActionResult: TAction;
    ActionExit: TAction;
    ActionList1: TActionList;
    Button1: TButton;
    Button_Result: TButton;
    Edit_m1: TEdit;
    Edit_m2: TEdit;
    Edit_r: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label_res: TLabel;
    Label_task: TLabel;
    Label_m1: TLabel;
    Label_m2: TLabel;
    Label_r: TLabel;
    Label_task1: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItemRef_autor: TMenuItem;
    MenuItemRef_info: TMenuItem;
    MenuItemRef: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItemOpen: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure ActionExitExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button_ResultClick(Sender: TObject);
    procedure MenuItemOpenClick(Sender: TObject);
    procedure MenuItemRef_autorClick(Sender: TObject);
    procedure MenuItemRef_infoClick(Sender: TObject);
    procedure MenuItemSaveClick(Sender: TObject);
  private
    FController: TGravitationController;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetM1: Double;
    function GetM2: Double;
    function GetR: Double;
    procedure SetResult(const Value: string; IsError: Boolean);
    procedure AddLog(const Msg: string);
    procedure ClearInput;
    procedure SetM1(const Value: string);
    procedure SetM2(const Value: string);
    procedure SetR(const Value: string);
    function AskSaveFile: string;
    function AskOpenFile: string;
  end;

var
  task: Ttask;

implementation

{$R *.lfm}

{ Ttask }

//экземпляр контроллера
constructor Ttask.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FController := TGravitationController.Create(Self);
end;

//освобождает память контроллера
destructor Ttask.Destroy;
begin
  FController.Free;
  inherited Destroy;
end;

//m1 из поля ввода
function Ttask.GetM1: Double;
begin
  Result := StrToFloat(Edit_m1.Text);
end;

//m2 из поля ввода
function Ttask.GetM2: Double;
begin
  Result := StrToFloat(Edit_m2.Text);
end;

//r из поля ввода
function Ttask.GetR: Double;
begin
  Result := StrToFloat(Edit_r.Text);
end;

//отображает результат/ошибку в метке Label_res
procedure Ttask.SetResult(const Value: string; IsError: Boolean);
begin
  Label_res.Caption := Value;
  if IsError then
    Label_res.Font.Color := clRed
  else
    Label_res.Font.Color := clGreen;
end;

//пишет сообщение в Memo1
procedure Ttask.AddLog(const Msg: string);
begin
  Memo1.Lines.Add(Msg);
end;

//очистка
procedure Ttask.ClearInput;
begin
  Edit_m1.Clear;
  Edit_m2.Clear;
  Edit_r.Clear;
  Label_res.Caption := '';
  Memo1.Lines.Clear;
end;

//текст в поле ввода m1
procedure Ttask.SetM1(const Value: string);
begin
  Edit_m1.Text := Value;
end;

//текст в поле ввода m2
procedure Ttask.SetM2(const Value: string);
begin
  Edit_m2.Text := Value;
end;

//текст в поле ввода r
procedure Ttask.SetR(const Value: string);
begin
  Edit_r.Text := Value;
end;

//сохранения файла
function Ttask.AskSaveFile: string;
begin
  if SaveDialog1.Execute then
    Result := SaveDialog1.FileName
  else
    Result := '';
end;

//открытия файла
function Ttask.AskOpenFile: string;
begin
  if OpenDialog1.Execute then
    Result := OpenDialog1.FileName
  else
    Result := '';
end;

//кнопка расчета
procedure Ttask.Button_ResultClick(Sender: TObject);
begin
  FController.CalculateAndShow;
end;

//Сохранить...
procedure Ttask.MenuItemSaveClick(Sender: TObject);
begin
  FController.SaveToFile;
end;

//Открыть...
procedure Ttask.MenuItemOpenClick(Sender: TObject);
begin
  FController.LoadFromFile;
end;

//Очистить
procedure Ttask.Button1Click(Sender: TObject);
begin
  FController.ClearAll;
end;

//Выход из приложения
procedure Ttask.ActionExitExecute(Sender: TObject);
begin
  Close;
end;

//Об авторе...
procedure Ttask.MenuItemRef_autorClick(Sender: TObject);
begin
  ShowMessage(
  'Автор: Булдыгеров Алексей.' + #13#10 +
  'Студент 2-го курса по специальности "Информатика и вычислительная техника".' + #13#10 +
  'Telegram: @lexa_bu'
  );
end;

//О программе...
procedure Ttask.MenuItemRef_infoClick(Sender: TObject);
begin
  ShowMessage(
  'Определить силу притяжения F между телами массы m 1 и m2, входящимся на расстоянии r друг от друга.'
  );
end;

end.

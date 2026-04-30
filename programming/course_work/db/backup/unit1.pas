unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    EditButton: TButton;
    DeleteButton: TButton;
    CashButton: TButton;
    QuantityEdit: TEdit;
    UserLabel: TLabel;
    NotThisUserLabel: TLabel;
    UserIcon: TLabel;
    PlusQuantityButton: TButton;
    AddButton: TButton;
    ReportButton: TButton;
    MinusQuantityButton: TButton;
    CardButton: TButton;
    MakeCheckButton: TButton;
    CopyButton: TButton;
    SelectedLabel: TLabel;
    SelectedPriceLabel: TLabel;
    TotalLabel: TLabel;
    ChangeLabel: TLabel;
    MainStringGrid: TStringGrid;
    UnitSelectedPriceLabel: TLabel;
    procedure AddButtonClick(Sender: TObject);
    procedure ReportButtonClick(Sender: TObject);
  private

  public

  end;

var
  MainForm:    TMainForm;

implementation
uses
  CatalogUnit, ReportUnit, uTypes, uDataLogic;

{$R *.lfm}

{ TMainForm }

procedure TMainForm.AddButtonClick(Sender: TObject);
begin
  FromCatalog := TCatalogForm.Create(nil);
  try
    if FromCatalog.ShowModal = mrOk then
    begin
      ShowMessage('Товар выбран');
    end;
  finally
    FromCatalog.Free;
  end;
end;

procedure TMainForm.ReportButtonClick(Sender: TObject);
begin
  FromReport := TReportForm.Create(nil);
  try
    if FromReport.ShowModal = mrOk then
    begin
      ShowMessage('Товар выбран');
    end;
  finally
    FromReport.Free;
  end;
end;

end.


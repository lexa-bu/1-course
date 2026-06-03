program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  uView in 'uView.pas' {task},
  uModel in 'uModel.pas',
  uController in 'uController.pas', hotkeys;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title:='Сила притяжения';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TTask, Task);
  Application.CreateForm(TFormHotkeys, FormHotkeys);
  Application.Run;
end.

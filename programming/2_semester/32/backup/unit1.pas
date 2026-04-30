{
Автор: Булдыгеров Алексей
Задание № 32 (129д). Дан рисунок, он составлен из простейших геометрических фигур:
треугольников, квадратов, окружностей, точек и т.п.
Рисунок в папке
Получить на экране и раскрасить рисунок.
}

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormPaint(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormPaint(Sender: TObject);
begin
  Canvas.Pen.Color := clBlack;       //черная рамка
  Canvas.Pen.Width := 4;             //толщина рамки
  Canvas.Brush.Color := clBlue;   //заливка
  Canvas.Brush.Style := bsSolid;     // Сплошная заливка
  Canvas.Rectangle(50, 50, 200, 250);

  Canvas.Brush.Color := $00EFEFEF;
  Canvas.Pen.Color := $00EFEFEF;
  Canvas.Ellipse(100, 40, 270, 260);

  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Width := 4;
  Canvas.Brush.Color := clGreen;
  Canvas.Ellipse(150, 100, 250, 200);
end;

end.


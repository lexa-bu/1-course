{
Автор: Булдыгеров Алексей
Задание № 36 (951). Круглое кольцо вращается с постоянной угловой скоростью вокруг своего диаметра,
расположенного параллельно горизонтальной оси экрана.
Изобразить на экране процесс вращения. Считать, что в момент времени t
кольцо выглядит для наблюдателя как эллипс, большая ось которого равна
постоянной величине с, а малая равна с|cos φ t|, где φ - угловая
скорость вращения. В правой части рисунка приведено несколько последовательных изображений.
В левой части рисунка кольцо изображено сбоку (этот вид не даётся на экране).
}

unit Unit1;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    FTime: double;
    FPhi: double;
    FC: double;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FPhi := 2.0;
  FC := 190.0;
  Timer1.Interval := 1;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  FTime := FTime + 0.03;
  PaintBox1.Invalidate;
  // перерисовка
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  MinorAxis: double;
  cx, cy: integer;
begin
  with PaintBox1.Canvas do
  begin
    MinorAxis := FC * Abs(Cos(FPhi * FTime));
    cx := PaintBox1.Width div 2;
    cy := PaintBox1.Height div 2;

    Pen.Color := clBlack;
    Pen.Width := 4;
    Ellipse(cx - Round(FC/2), cy - Round(MinorAxis/2),
            cx + Round(FC/2), cy + Round(MinorAxis/2));
  end;
end;

end.

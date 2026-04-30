{
Автор: Булдыгеров Алексей
Задача № 34 (867). Построить узор, показанный на рисунке, используя алгоритм, описанный в скобках
(Пусть две точки заданы своими координатами ($x_{1}, y_{1}$) и ($x_{2}, y_{2}$).
Прямая, проходящая через эти две точки, может быть описана следующими
параметрическими уравнениями:
$x = x_{1} + (x_{2} - x_{1}) t, y = y_{1} + (y_{2} - y_{1})$.
При 0 < t < 1 точка (х, у) лежит внутри отрезка и делит его в отношении
t / (1-t); при t = 0 достигается конец отрезка ($x_{1}, y_{1}$),
при t = 1 - конец ($x_{2}, y_{2}$). При t > 1 точка (х, у) лежит на прямой
вне отрезка с той же стороны от ($x_{1}, y_{1}$), что и ($x_{2}, y_{2}$);
при t < 0 - с противоположной стороны.
Даны натуральные числа $x_{1}, y_{1}, x_{2}, y_{2}$ действительное
число µ (0 ≤ µ < 1). Построить отрезок с координатами концов ($x_{1}, y_{1}$),
($x_{2}, y_{2}$) и точку, делящую отрезок в отношении µ/(1-µ)).
}

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Graphics, ExtCtrls;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    procedure PaintBox1Paint(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  col, row, i, step, nextIdx: integer;
  w, h: double;
  x, y: array[0..3] of double;
  p: array[0..3] of TPoint;
const
  mu = 0.03;
  maxSteps = 45;
begin
  w := 200;
  h := 200;

// цикл
  for row := 0 to 1 do
    for col := 0 to 2 do
    begin
// по часовой стрелке
      x[0] := col  * w;  y[0] := row  * h; // вверхний левый  угол
      x[1] := x[0] + w;  y[1] := y[0];     // вверхний правый угол
      x[2] := x[1];      y[2] := y[1] + h; // нижний   правый угол
      x[3] := x[0];      y[3] := y[2];     // нижний   левый  угол
// цикл построения узла
      for step := 1 to maxSteps do
      begin // вещественные координаты > целые
        for i := 0 to 3 do
        p[i] := Point(Round(x[i]), Round(y[i]));
        PaintBox1.Canvas.Polygon(p);
// вычисление координат для следующего хода
        for i := 0 to 3 do
        begin
          if col = 1 then              // определение следующей вершины
            nextIdx := (i + 3) mod 4   // против часовой
          else
            nextIdx := (i + 1) mod 4;  // по часовой
// смещение вершины к следующей
          x[i] := x[i] + (x[nextIdx] - x[i]) * mu;
          y[i] := y[i] + (y[nextIdx] - y[i]) * mu;
        end;
      end;
    end;
end;
end.

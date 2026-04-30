{
Автор: Булдыгеров Алексей
Задание № 35 (903). Построить треугольник по заданным вершинам.
Точки экрана, являющиеся вершинами треугольника, указываются с клавиатуры
по методу резиновой нити ( Выбор нужной точки экрана обычно выполняется
подводом курсора к этой точке и нажатием клавиши "ввод". Иногда бывает полезно
видеть и предыдущую выбранную точку-последнюю точку, зафиксированную клавишей
"ввод", и новую точку, на которую указывает курсор.
Для этого используются метод резиновой нити и метод резинового прямоугольника.
В методе резиновой нити один конец отрезка зафиксирован и указывает последнюю
выбранную точку, второй конец перемещается в соответствии с изменением
указываемой точки).
Управление: ЛКМ - добавить точку, ПКМ - сброс.
}

unit Unit1;
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FPoints: array[0..2] of TPoint; //вершины треугольника
    FCount: Integer;                //счетчик точек (0..3)
    FMouse: TPoint;                 //координаты курсора
    procedure Draw;                 //отрисовка
  end;
var
  Form1: TForm1;
implementation
{$R *.lfm}
//переменные
procedure TForm1.FormCreate(Sender: TObject);
begin
  FCount := 0;
  FMouse := Point(0, 0);
end;
//обновление координат курсора
procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  FMouse := Point(X, Y);
  PaintBox1.Invalidate;
end;
//клики (ЛКМ + точка, ПКМ сброс)
procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (FCount < 3) then
  begin
    FPoints[FCount] := Point(X, Y);
    Inc(FCount);
  end
  else if Button = mbRight then
  FCount := 0;
  PaintBox1.Invalidate;
end;
//вывод отрисовки
procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  Draw;
end;

procedure TForm1.Draw;
var i: Integer; C: TCanvas; S: string;
begin
  C := PaintBox1.Canvas;
  with C do
  begin
    Brush.Color := clWhite; FillRect(PaintBox1.ClientRect);     //очистка холста

    Pen.Width := 4; Pen.Color := clBlack; Pen.Style := psSolid; //основная линия
    for i := 0 to FCount - 2 do
    begin                                                       //отрисовка посторенных сторон
      MoveTo(FPoints[i].X, FPoints[i].Y); LineTo(FPoints[i+1].X, FPoints[i+1].Y);
    end;

    Brush.Color := clRed;                                       //отрисовка вершин
    for i := 0 to FCount - 1 do Ellipse(FPoints[i].X-6, FPoints[i].Y-6,
    FPoints[i].X+6, FPoints[i].Y+6);                            //т.е. красных точек


    if FCount > 0 then
    begin
      if FCount < 3 then
      begin
        Pen.Style := psDot; Pen.Color := clBlue;                //пунктир
        MoveTo(FPoints[FCount-1].X, FPoints[FCount-1].Y);
        LineTo(FMouse.X, FMouse.Y);
      end
      else
      begin
        Pen.Style := psSolid; Pen.Color := clGray;             //замыкание
        MoveTo(FPoints[2].X, FPoints[2].Y); LineTo(FPoints[0].X, FPoints[0].Y);
      end;
    end;

    //координаты
    Font.Size := 10; Font.Color := clBlack; Brush.Color := clSkyBlue;
    if FCount = 3 then
    begin
      for i := 0 to 2 do
      begin
        S := Format('[x - %d, y - %d]', [FPoints[i].X, FPoints[i].Y]);
        TextOut(FPoints[i].X + 15, FPoints[i].Y - 25, S);
      end;
    end
    else
    begin
      S := Format('[x - %d, y - %d]', [FMouse.X, FMouse.Y]);
      TextOut(FMouse.X + 12, FMouse.Y + 12, S);
    end;
  end;
end;

end.

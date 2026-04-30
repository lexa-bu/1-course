  {
  Автор: Булдыгеров Алексей
  Задание № 38 (439). Даны действительные числа $u_{1}, u_{2}, v_{1}, v_{2}, w_{1}, w_{2}$.
  Получить для $2u + \frac{3uw}{2+w+u}-7$, где u,v,w - комплексные числа
  $u_{1} + iu_{2}, v_{1} + iv_{2}, w_{1} + iw_{2}$.
  (Определить процедуры выполнения арифметических операций над комплексными числами).
  }
  {$codepage UTF8}    // окончательно перешел на 2 вариант
  uses
    SysUtils;

  type
    TComplex = record
      re, im: double;
    end;

  // конструктор комплексного числа
  function C(r, i: double): TComplex;
  begin
    result.re := r;
    result.im := i;
  end;

  // cложение (r := a + b)
  procedure Add(const a, b: TComplex; var r: TComplex);
  begin
    r.re := a.re + b.re;
    r.im := a.im + b.im;
  end;

  // умножение (r := a * b)
  procedure Mul(const a, b: TComplex; var r: TComplex);
  begin
    r.re := a.re * b.re - a.im * b.im;
    r.im := a.re * b.im + a.im * b.re;
  end;

  // деление (r := a / b)
  procedure DivC(const a, b: TComplex; var r: TComplex);
  var d: double;
  begin
    d := b.re * b.re + b.im * b.im;
    if abs(d) < 1E-10 then
    begin
      writeln('Ошибка: деление на ноль невозможно!'); halt(1);
      exit;
    end;
    r.re := (a.re * b.re + a.im * b.im) / d;
    r.im := (a.im * b.re - a.re * b.im) / d;
  end;

  // ввод комплексного числа
  procedure ReadC(var c: TComplex; name: string);
  begin
    write('Введите ', name, ' (Re Im): '); readln(c.re, c.im);
  end;

// вывод комплексного числа
procedure WriteC(const c: TComplex);
begin

  if Abs(c.im) < 1E-10 then
    // действительная часть
    write(c.re:0:4)
  else if Abs(c.re) < 1E-10 then
    // мнимая часть
    write(c.im:0:4, 'i')
  else if c.im > 0 then
    // положительная мнимая (+)
    write(c.re:0:4, ' + ', c.im:0:4, 'i')
  else
    // отрицательная мнимая (-)
    write(c.re:0:4, ' - ', Abs(c.im):0:4, 'i');
end;

var
    u, w, v, num, den, frac, res: TComplex;

  begin
  // ввод данных
    ReadC(u, 'u');
    ReadC(w, 'w');
    ReadC(v, 'v');

  // 2u + (3uw)/(2+w+u) - 7

  // 3uw
    Mul(u, w, num);            // num := u * w
    Mul(C(3, 0), num, num);    // num := 3 * num

  // 2 + w + u
    den := C(2, 0);            // den := 2
    Add(den, w, den);          // den := 2 + w
    Add(den, u, den);          // den := 2 + w + u

  // (3uw) / (2+w+u)
    DivC(num, den, frac);

  // 2u + frac - 7
    res := u;
    Mul(C(2, 0), res, res);    // res := 2u
    Add(res, frac, res);       // res := 2u + frac
    res.Re := res.Re - 7;      // res := res - 7

    // вывод результата
    writeln; write('Результат: ');
    writeC(res); writeln;
    writeln('Нажмите Enter для выхода...'); readln;
  end.

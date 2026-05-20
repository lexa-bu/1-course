unit uModel;

{$mode objfpc}{$H+}

interface

// вычисление гравитационной силы F = G * (m1 * m2) / r^2; G = 6.674e-11 Н * м^2 / кг^2
function Calculate(m1, m2, r: double): double;

implementation

// вычисление гравитационной силы F = G * (m1 * m2) / r^2; G = 6.674e-11 Н * м^2 / кг^2
function Calculate(m1, m2, r: double): double;
const
  G = 6.674e-11;
begin
  Result := G * m1 * m2 / (r * r);
end;

end.

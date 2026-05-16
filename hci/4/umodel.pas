unit uModel;

{$mode objfpc}{$H+}

interface

type
{model}
  TGravitationModel = class
    class function Calculate(m1, m2, r: double): double;
  end;

implementation
// вычисление гравитационной силы F = G * (m1 * m2) / r^2; G = 6.674e-11 Н * м^2 / кг^2
class function TGravitationModel.Calculate(m1, m2, r: double): double;
begin
  Result := 6.674e-11 * m1 * m2 / (r * r);
end;

end.

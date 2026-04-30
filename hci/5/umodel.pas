unit uModel;

{$mode objfpc}{$H+}

interface

type
{model}
  TGravitationModel = class
    class function Calculate(m1, m2, r: double): double;
  end;

implementation
// функция, по которой рассчитывается формула по
class function TGravitationModel.Calculate(m1, m2, r: double): double;
begin
  Result := 6.674e-11 * m1 * m2 / (r * r);
end;

end.

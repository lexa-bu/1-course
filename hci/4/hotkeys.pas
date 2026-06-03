  // Модуль hotkeys: Содержит визуальную форму для отображения списка горячих клавиш.
  // *.lfm относится к Виду (View).
  // Автор: Булдыгеров Алексей
  unit hotkeys;
  {$mode ObjFPC}{$H+}
  interface
  uses
    Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;
  type
    { TFormHotkeys }
    TFormHotkeys = class(TForm)
      LabelHotkeys: TLabel;   // Отображение горячих клавиш
    private
    public
    end;
  var
    FormHotkeys: TFormHotkeys;
  implementation
  {$R *.lfm}
  end.


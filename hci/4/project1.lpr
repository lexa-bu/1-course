// Главная программа.
// Она вызывает все модули.
program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces,
  Forms,
  uModel in 'uModel.pas',               // Модуль uModel (данные и логика):
  // Хранит состояние, работает с БД, применяет правила.
  uView in 'uView.pas' {task},          // Модуль uView (визуальное отображение):
  // Рисует данные Model, фиксирует действия пользователя, передаёт их в Controller.
  uController in 'uController.pas',     // Модуль uController (обработчик ввода):
  // Принимает команды пользователя, вызывает методы Model, выбирает/обновляет нужную View.
  hotkeys;                              // Модуль hotkeys:
  // Содержит визуальную форму для отображения списка горячих клавиш. *.lfm относится к Виду (View).

{ КОММЕНТАРИИ }
// Hint (подсказка) - необходима для отображение подсказок.
// Лучшим вариантом будет отображение: Горячей клавиши и свойтсво выполнения.

// Tab Order (порядок вкладок) - Переключение между вкладками посредством нажатия Tab.
// Лучшим вариантом будет назначить Tab Order на вводимые данные.

// Горячие клавиши - клавиши, которые могут обрабатывать события (например кнопку).
// Лучшим вариантом будет: установить горячие клавиши (shortcut) на популярные
// сочетания и вывести горячие клавиши на F1.




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

/**
 * @author Булдыгеров Алексей
 * @example Задание №1 (11д).
 * Даны x, y, z. Вычислить a, b, если:
 * $$a=\frac{2\cos\left( x-\frac{\pi}{6} \right)}{\frac{1}{2}+\sin^2y},
 * b=1+\frac{{z^2}}{3+\frac{z^2}{5}'}$$
 * @link https://ivtipm.github.io/Programming/Glava01/index01.htm#z11
 */
package io.github.lexa_bu.javafx_1;
// включение модулей (библиотек)
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import java.util.Locale;
// класс контроллера для fxml
public class Controller
{
    // привязки к fxml
    @FXML private TextField TextFieldX, TextFieldY, TextFieldZ;
    @FXML private Label LabelA, LabelB;
    @FXML private TextArea TextAreaSum;

    // кнопка "Рассчитать"
    @FXML
    protected void onCalculateClick()
    {
        try
        {
            // ввод значений из TextField
            String strX = TextFieldX.getText();
            String strY = TextFieldY.getText();
            String strZ = TextFieldZ.getText();

            // преобразование строк в числа
            double x = Double.parseDouble(strX);
            double y = Double.parseDouble(strY);
            double z = Double.parseDouble(strZ);

            // вычисления

            // вычисление a
            double a = (2 * Math.cos(x - Math.PI / 6.0)) / (0.5 + Math.pow(Math.sin(y), 2));
            // вычисление b
            double b = 1 + (z * z) / (3.0 + (z * z) / 5.0);

            // вывод результатов в Label
            LabelA.setText(String.format(Locale.US, "a = %.4f", a));
            LabelB.setText(String.format(Locale.US, "b = %.4f", b));

            // формирование записи для истории (TextArea)
            String historyEntry = String.format(Locale.US,
                    "x=%s, y=%s, z=%s\n" +
                            "a = (2 * cos (%s - π / 6)) / (1 / 2 + sin²%s) = %.4f\n" +
                            "b = 1 + %s² / (3 + %s² / 5) = %.4f\n\n",
                    strX, strY, strZ, strX, strY, a, strZ, strZ, b
            );
            TextAreaSum.appendText(historyEntry);
        }
        // если ввод некорректный - сообщение об ошибке
        catch (NumberFormatException e)
        {
            TextAreaSum.appendText("Ошибка! Введите корректные данные.\n\n");
        }
    }
    // кнопка "Очистить"
    @FXML
    protected void onClearClick()
    {
        // очищаем поля ввода
        TextFieldX.clear();
        TextFieldY.clear();
        TextFieldZ.clear();
        TextAreaSum.clear();
        LabelA.setText("a = ");
        LabelB.setText("b = ");

    }
}
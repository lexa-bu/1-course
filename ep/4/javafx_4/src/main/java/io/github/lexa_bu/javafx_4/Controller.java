/**
 * @author Булдыгеров Алексей
 * @example Задание №4 (84а).
 * Даны натуральное n, действительное х. Вычислить:
 * $$\sin x+\sin^2\ x +\dots + \sin^n \ x$$
 * Натуральные числа входят в множество рациональные, которые в свою очередь входят в множество действительных.
 * @link https://ivtipm.github.io/Programming/Glava04/index04.htm#z84
 */
package io.github.lexa_bu.javafx_4;
// включение модулей (библиотек)
import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import java.util.Locale;
// класс контроллера для fxml
public class Controller {

    // привязки к компонентам интерфейса из fxml
    @FXML private TextField TextFieldN;
    @FXML private TextField TextFieldX;
    @FXML private TextArea TextAreaSum;

    // кнопка "Рассчитать"
    @FXML
    protected void onCalculateClick()
    {
        try
        {
            // ввод значений из текстовых полей
            String strN = TextFieldN.getText();
            String strX = TextFieldX.getText();

            // преобразование строк в соответствующие типы данных
            int n = Integer.parseInt(strN); // натуральное число n
            double x = Double.parseDouble(strX); // действительное число x

            // проверка на n > 0
            if (n <= 0)
            {
                TextAreaSum.appendText("Ошибка! n должно быть натуральным (n > 0).\n\n");
                return;
            }
            // вычисление суммы
            double sum = 0;
            for (int i = 1; i <= n; i++)
            {
                sum += Math.pow(Math.sin(x), i);
            }
            // формирование записи для истории (TextArea)
            String historyEntry = String.format(Locale.US,
                    "sin %s + sin² %s + ... + sin^%d %s\n" +
                            "Ответ: %.6f\n\n",
                    strX, strX, n, strX, sum
            );
            // добавление результата в текстовое поле истории
            TextAreaSum.appendText(historyEntry);
        }
        catch (NumberFormatException e)
        {
            // если в полях не числа или n — не целое число
            TextAreaSum.appendText("Ошибка! Введите корректные данные.\n");
        }
    }
    // кнопка "Очистить"
    @FXML
    protected void onClearClick() {
        // полная очистка полей ввода и истории
        TextFieldN.clear();
        TextFieldX.clear();
        TextAreaSum.clear();
    }
}
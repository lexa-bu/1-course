/* Задача:
https://ivtipm.github.io/Programming/Glava11/index11.htm#z378 (ctrl + ЛКМ)
8. 378б
Даны действительные числа $x_{1}, ..., x_{8}$. Получить действительную квадратную матрицу порядка 8:
$$
\begin{bmatrix}
1 & 1 & \dots & 1 \\
x_1 & x_2 & \dots & x_8 \\
\dots & \dots & \dots & \dots \\
x_1^7 & x_2^7 & \dots & x_8^7
\end{bmatrix}
$$

Автор: Булдыгеров Алексей
*/

// включение модулей (библиотек)
#include <stdio.h>
#include <locale.h>
#include <math.h>

// главная функция программы
int main()
{
    // поддержка кириллицы
    setlocale(LC_ALL, "");
    double x[8];                                // массив для входных чисел
    double matrix[8][8];                        // матрица 8х8

    printf("Введите 8 чисел через пробел:\n");  // ввод чисел
    for (int i = 0; i < 8; i++)
    {
        scanf("%lf", &x[i]);
    }
    for (int i = 0; i < 8; i++)            // i - номер строки. перебираем их
    {
        for (int j = 0; j < 8; j++)        // j - номер столбца. перебираем их
        {
            matrix[i][j] = pow(x[j], i);   // элемент матрицы = число x[j] в степени i; при i=0 получаем 1
        }
    }
    // вывод
    printf("Полученная матрица:\n");
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            printf("%12.2f ", matrix[i][j]);  // %12.2f делает ровные колонки
        }
        printf("\n");
    }
    return 0;
}
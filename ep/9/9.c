/* Задание №9 (703). 
Даны квадратная матрица A порядка n, векторы x и у с n элементами. Получить вектор A(x+y).

Автор: Булдыгеров Алексей
*/

// включение модулей (библиотек)
#include <stdio.h>
#include <locale.h>

#define MAX_SIZE 255   // ограничитель в 255

// главная функция программы
int main()
{
    // поддержка кириллицы
    setlocale(LC_ALL, "");
    int n;
    printf("Введите размерность n (максимальное: %d): ", MAX_SIZE);
    scanf("%d", &n);

    if (n > MAX_SIZE || n <= 0)      // проверка на ограничение (от 1 до 255)
    {
        printf("Ошибка! Введите число от 1 до %d.\n", MAX_SIZE);
        return 1;
    }

    // переменные
    double A[MAX_SIZE][MAX_SIZE];      // квадратная матрица
    double x[MAX_SIZE], y[MAX_SIZE];   // входные векторы
    double sum_xy[MAX_SIZE];      // результат (x + y)
    double result[MAX_SIZE];      // итоговый вектор a * (x + y)

    // ввод данных
    printf("\nЗаполнение матрицы A (%d x %d):\n", n, n);
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            printf("A[%d][%d] = ", i, j);
            scanf("%lf", &A[i][j]);
        }
    }
    
    printf("\nВведите элементы вектора x:\n");   // заполнение вектора x
    for (int i = 0; i < n; i++)
    {
        printf("x[%d] = ", i);
        scanf("%lf", &x[i]);
    }
    printf("\nВведите элементы вектора y:\n");   // заполнение вектора y
    for (int i = 0; i < n; i++)
    {
        printf("y[%d] = ", i);
        scanf("%lf", &y[i]);
    }

    for (int i = 0; i < n; i++)                  // складывание векторов
    {
        sum_xy[i] = x[i] + y[i];
    }

    for (int i = 0; i < n; i++)                  // умножение матрицы на сумму векторов
    {
        result[i] = 0;
        for (int j = 0; j < n; j++)
        {
            result[i] += A[i][j] * sum_xy[j];
        }
    }

    // вывод
    printf("\nРезультат A(x+y):\n");
    for (int i = 0; i < n; i++)
    {
        printf("%.2f ", result[i]);
    }
    printf("\n");
    return 0;
}
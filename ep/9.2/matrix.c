/**
 * @file matrix.c
 * @brief Реализация логики обработки матриц и управления динамическими данными.
 */

 // включение модулей (библиотек)
#include <stdio.h>
#include <float.h>
#include "matrix.h"

/**
 * @brief Заполнение матрицы данными от пользователя.
 * @param matrix Указатель на выделенный блок памяти (имитация 2D массива).
 * @param n Порядок квадратной матрицы.
 */
int input_matrix(double *matrix, int n)
{
    printf("\nВведите элементы матрицы %dx%d:\n", n, n);
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            printf("a[%d][%d] = ", i, j);
                // вычисляем смещение от начала блока (i * n + j)
            if (scanf("%lf", (matrix + i * n + j)) != 1)
            {
                fprintf(stderr, "Ошибка ввода данных!\n");
                return -1;
            }
        }
    }
    return 0;
}

/**
 * @brief Поиск максимума в области "песочные часы".
 * @param matrix Указатель на матрицу (const для защиты данных).
 * @param n Порядок матрицы.
 * @return Максимальное значение в заштрихованной области.
 */
double find_max_shaded(const double *matrix, int n)
{
    // минимальное возможное значение
    double max_val = -DBL_MAX;

    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++) 
        {
            // верхний треугольник: i <= j || i + j <= n - 1
            bool upper = (i <= j && (i + j) <= (n - 1));
            // нижний треугольник:  i >= j || i + j >= n - 1
            bool lower = (i >= j && (i + j) >= (n - 1));

            // проверяем принадлежность точки заштрихованной области
            if (upper || lower)
            {
                // доступ к элементу matrix[i][j] в линейной памяти
                double val = matrix[i * n + j];
                // обновление max
                if (val > max_val)
                max_val = val;
                }
            }
        }
    return max_val;
}
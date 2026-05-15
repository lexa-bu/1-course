/**
* @file main.c
* @author Булдыгеров Алексей
* @example Задание № 9.2 (692д).
* Дана действительная квадратная матрица порядка n. Найти наибольшее из
* значений элементов, расположенных в заштрихованной части матрицы.
* @image Находится в папке.
* @note Если лень смотреть @image - Песочные часы.
* @example При n=5 выглядит так:
* X X X X X
*   X X X
*     X
*   X X X
* X X X X X
* @note Должны быть функции, отдельно реализующие ввод (если есть), расчет, и вывод, либо 
* специальные функции описанные в условие задачи. Не использовать глобальные переменные.
* Используйте модули).
* @link https://ivtipm.github.io/Programming/Glava20/index20.htm#z692
* @test Запуск теста: в PowerShell пишется cmd /c "название_компилируемого_файла.exe < test1.txt".
*/

/**
* @brief Точка входа в программу.
* Организует ввод размера, аллокацию памяти и вызов расчетных функций. 
*/

// включение модулей (библиотек)
#include <stdio.h>
#include <locale.h>
#include <stdlib.h>
#include "matrix.h"

/**
 * @brief Главная функция.
 * Организует ввод размера, аллокацию памяти и вызов расчетных функций.
 */
int main() 
{
  // поддержка кириллицы
  setlocale(LC_ALL, "");
  int n;
  printf("Введите порядок квадратной матрицы n: ");
  if (scanf("%d", &n) != 1 || n <= 0)
  {
    fprintf(stderr, "Ошибка! Введите натуральное целое число.\n");
    return EXIT_FAILURE;
  }

  // выделение памяти в куче под n x n элементов
  double *matrix = calloc(n * n, sizeof *matrix);

  // проверка успешности выделения памяти
  if (!matrix) 
  {
    fprintf(stderr, "Ошибка выделения памяти!\n");
    return EXIT_FAILURE;
  }

  // ввод данных
  if (input_matrix(matrix, n) != 0)
  {
    free(matrix);
    return EXIT_FAILURE;
  }
  // вывод результата
  double result = find_max_shaded(matrix, n);
  printf("Максимум в заштрихованной области: %.4lf\n", result);

  // освобождение памяти для предотвращение утечки памяти
  free(matrix);
  return EXIT_SUCCESS;
}
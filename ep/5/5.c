/* Задача:
https://ivtipm.github.io/Programming/Glava07/index07.htm#z190 (ctrl + ЛКМ)
5. 190
Даны натуральное число n, целые числа $a_{1}, \dots, a_{n}$.
 Получить сумму положительных и число отрицательных членов последовательности
$a_{1}, \dots, a_{n}$.

Автор: Булдыгеров Алексей
*/

// Библиотеки
#include <stdio.h>
#include <locale.h>
// Максимально допустимый размер массива 
#define ARR_MAX 256

// Главная функция программы
int main() 
{
// Поддержка кириллицы
    setlocale(LC_ALL, "");
// Объявление переменных
int n;
int a[ARR_MAX]; 
int pos_sum = 0;
int neg_count = 0;

// Запрос n
printf("Введите количество элементов:\n");
if (scanf("%d", &n) != 1 || n <= 0 || n > ARR_MAX) 
{
    printf("Ошибка! Введите число от 1 до 256!\n");
    return 1;
}

printf("Принято. Введите %d целых чисел:\n", n);    
// Ввод элементов последовательности
for(int i = 0; i < n; i++) 
{
    scanf("%d", &a[i]);
}
// Обработка
for(int i = 0; i < n; i++) 
{
    if (a[i] > 0)
        pos_sum += a[i];
    else if (a[i] < 0)
        neg_count += 1;
}
    printf("Сумма положительных: %d\n", pos_sum);
    printf("Количество отрицательных: %d\n", neg_count);
return 0;
}
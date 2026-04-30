/*
Автор: Булдыгеров А.А.

Задача:
https://ivtipm.github.io/Programming/Glava07/index07.htm#z190 (ctrl + ЛКМ)
6. 339б
Даны целые числа $a_{1}, \dots, a_{n}$ (в этой последовательности могут быть повторяющиеся члены).
Получить числа, взятые по одному из каждой группы равных членов.
*/

//включение модулей (библиотек)
#include <stdio.h>
#include <locale.h>
#include <stdlib.h>

//главная функция программы
int main() 
{
//поддержка кириллицы
setlocale(LC_ALL, "");

int n;
printf("Введите количество элементов последовательности:\n");
if (scanf("%d", &n) != 1)
    {
    puts("Введите число!");
    return 0;
    }
//массив для хранения введенных чисел
int arr[n];
printf("Введите целые числа:\n", n);
for (int i = 0; i < n; i++) 
{
    scanf("%d", &arr[i]); //считываем элементы массива
}

int unique[n]; //массив для уникальных элементов
int uniqueCount = 0; //счетчик уникальных элементов
for (int i = 0; i < n; i++) 
{ //для каждого элемента массива
   int found = 0;
    for (int j = 0; j < uniqueCount; j++) 
    { //проверяем, есть ли он уже в unique
        if (arr[i] == unique[j]) 
        {
            found = 1; //найден дубликат
            break;
        }
    }
    if (!found) { //если дубликата нет, добавляем элемент в unique
        unique[uniqueCount] = arr[i];
        uniqueCount++;
    }
}

printf("Уникальные числа из последовательности:\n");
for (int i = 0; i < uniqueCount; i++) 
{
    printf("%d ", unique[i]);
}
printf("\n");
return 0;
}
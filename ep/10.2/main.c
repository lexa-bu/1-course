/**
 * @file main.c
 * @author Булдыгеров Алексей
 * @example Задание №10.2 (507в).
 * Сведения об ученике состоят из его имени и фамилии и названия класса
 * (года обучения и буквы), в котором он учится. Дан файл f, содержащий
 * сведения об учениках школы. 
 * Выяснить, имеются ли однофамильцы в каком-нибудь классе.
 * @note Не использовать массивы или списки.
 * @link https://ivtipm.github.io/Programming/Glava13/index13.htm#z507
 * @test Создается файл "f.txt", куда записываются данные.  
 * Фамилия Имя Номер_класса  Буква_класса
 * Проверяются данные.
 */

// включение модулей (библиотек)
#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <string.h>
/**
 * @brief Структура данных.
 *
 * @param last_name    - Фамилия ученика.
 * @param first_name   - Имя ученика.
 * @param class_year   - Класс ученика.
 * @param class_letter - Буква класса ученика.
 */
struct student
{
    char last_name[128];
    char first_name[128];
    unsigned char class_year;
    char class_letter;
};

/**
 * @brief Проверяет, есть ли у студента однофамилец в том же классе
 * @param f        - указатель на входной файл
 * @param s        - указатель на текущего студента
 * @param self_pos - позиция текущей записи в файле
 * @return 1 если однофамилец найден, 0 если нет
 * @note Использует повторное чтение файла с начала (см. 9 строку).
 */
int has_namesake(FILE *f, struct student *s, long self_pos)
{
    struct student other;
    long pos;
    // сбрасываем указатель файла в начало для полного перебора
    rewind(f);
    while (fscanf(f, "%s %s %hhu %c", 
                  other.last_name, other.first_name,
                  &other.class_year, &other.class_letter) == 4)
    {
        // запоминаем позицию прочитанной записи
        pos = ftell(f);
        // сравниваем: не та же запись && совпадает фамилия && совпадает класс
        if (pos != self_pos &&
            strcmp(s->last_name, other.last_name) == 0 &&
            s->class_year == other.class_year &&
            s->class_letter == other.class_letter)
            return 1;  // однофамилец в том же классе найден
    }
    return 0;
}

/**
 * @brief Основная функция программы
 */
int main(void)
{
    // поддержка кириллицы
    setlocale(LC_ALL, "");
    
    // входной файл
    FILE *f = fopen("f.txt", "r");
    // выходной файл
    FILE *g = fopen("g.txt", "w");
    
    // проверка успешного открытия файлов
    if (!f || !g) {
        printf("Ошибка открытия файла!\n");
        if (f) fclose(f);
        if (g) fclose(g);
        return 1;
    }

    struct student s;      // буфер для текущего студента
    long pos, next;        // позиция записи и следующая позиция для возврата
    
    /**
     * @brief 1 проход - запись учеников без однофамильцев.
     */
    rewind(f);
    // читаем записи из файла f пока не конец файла
    while (fscanf(f, "%s %s %hhu %c",
                  s.last_name, s.first_name,
                  &s.class_year, &s.class_letter) == 4) {
        // позиция начала прочитанной записи
        pos = ftell(f);
        // позиция для возврата после внутреннего перебора
        next = ftell(f);
        
        // если однофамильцев в классе нет - записываем в результат
        if (!has_namesake(f, &s, pos))
            fprintf(g, "%s %s %d %c\n", s.last_name, s.first_name,
                    s.class_year, s.class_letter);
        // возвращаемся к продолжению внешнего цикла
        fseek(f, next, SEEK_SET);
    }
    
    // разделитель секций в g.txt
    fprintf(g, "------------------------\nОДНОФАМИЛЬЦЫ:\n");
    
    /**
     * @brief 2 проход - запись учеников ТОЛЬКО однофамильцев.
     */
    rewind(f);
    // читаем записи из файла f пока не конец файла
    while (fscanf(f, "%s %s %hhu %c",
                  s.last_name, s.first_name,
                  &s.class_year, &s.class_letter) == 4)
    {    
        pos = ftell(f);
        // если однофамилец есть в том же классе — записываем
        if (has_namesake(f, &s, pos))
            fprintf(g, "%s %s %d %c\n", s.last_name, s.first_name,
                    s.class_year, s.class_letter);
        fseek(f, pos, SEEK_SET);
    }
    // закрываем файлы и освобождаем ресурсы
    fclose(f); 
    fclose(g);
    // уведомление пользователя и автоматический просмотр результата
    printf("Готово! Результат записан в файл g.txt и был автоматически открыт с помощью Блокнот.\n");
    system("notepad g.txt");
    return 0;
}
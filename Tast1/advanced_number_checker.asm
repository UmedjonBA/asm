; Расширенная программа для проверки чисел
; MASM Assembly Language
; Автор: Student
; Дата: 2024

.386
.model flat, stdcall
option casemap:none

; Подключение библиотек
includelib kernel32.lib
includelib user32.lib
includelib msvcrt.lib

; Объявление внешних функций
extern GetStdHandle@4:PROC
extern WriteConsoleA@20:PROC
extern ReadConsoleA@20:PROC
extern ExitProcess@4:PROC
extern printf:PROC
extern scanf:PROC

.data
    ; Сообщения для пользователя
    menu_msg db "Выберите операцию:", 13, 10
             db "1 - Проверить четность", 13, 10
             db "2 - Проверить простое число", 13, 10
             db "3 - Обработать несколько чисел", 13, 10
             db "0 - Выход", 13, 10
             db "Ваш выбор: ", 0
    
    prompt_msg db "Введите целое число (1-100): ", 0
    count_msg db "Сколько чисел обработать? (1-10): ", 0
    even_msg db "Число %d четное!", 13, 10, 0
    odd_msg db "Число %d нечетное!", 13, 10, 0
    prime_msg db "Число %d простое!", 13, 10, 0
    not_prime_msg db "Число %d не простое!", 13, 10, 0
    error_msg db "Ошибка! Введите корректное число.", 13, 10, 0
    continue_msg db "Нажмите Enter для продолжения...", 13, 10, 0
    
    ; Форматы для ввода/вывода
    input_format db "%d", 0
    char_format db "%c", 0
    
    ; Переменные
    choice dd 0
    number dd 0
    count dd 0
    input_char db 0
    
    ; Массив для хранения чисел
    numbers_array dd 10 dup(0)
    
    ; Дескрипторы для консоли
    stdin_handle dd 0
    stdout_handle dd 0
    
    ; Буферы для ввода
    input_buffer db 256 dup(0)
    bytes_read dd 0
    bytes_written dd 0

.code
start:
    ; Инициализация дескрипторов консоли
    push -10                    ; STD_INPUT_HANDLE
    call GetStdHandle@4
    mov stdin_handle, eax
    
    push -11                    ; STD_OUTPUT_HANDLE
    call GetStdHandle@4
    mov stdout_handle, eax

main_loop:
    ; Показываем меню
    call show_menu
    
    ; Читаем выбор пользователя
    call read_choice
    
    ; Обрабатываем выбор
    mov eax, choice
    cmp eax, 0
    je exit_program
    cmp eax, 1
    je check_even_odd_mode
    cmp eax, 2
    je check_prime_mode
    cmp eax, 3
    je multiple_numbers_mode
    jmp main_loop

check_even_odd_mode:
    call process_even_odd
    jmp main_loop

check_prime_mode:
    call process_prime
    jmp main_loop

multiple_numbers_mode:
    call process_multiple_numbers
    jmp main_loop

exit_program:
    ; Завершение программы
    push 0
    call ExitProcess@4

; Процедура показа меню
show_menu PROC
    push offset menu_msg
    call printf
    add esp, 4
    ret
show_menu ENDP

; Процедура чтения выбора
read_choice PROC
    push offset choice
    push offset input_format
    call scanf
    add esp, 8
    
    ; Пропускаем символ новой строки
    push offset input_char
    push offset char_format
    call scanf
    add esp, 8
    ret
read_choice ENDP

; Процедура обработки четности/нечетности
process_even_odd PROC
    ; Выводим приглашение
    push offset prompt_msg
    call printf
    add esp, 4
    
    ; Читаем число
    call read_number
    cmp eax, 0
    je input_error_even_odd
    
    ; Проверяем четность
    call check_even_odd
    
    ; Ждем продолжения
    call wait_continue
    ret
    
input_error_even_odd:
    push offset error_msg
    call printf
    add esp, 4
    call wait_continue
    ret
process_even_odd ENDP

; Процедура обработки простых чисел
process_prime PROC
    ; Выводим приглашение
    push offset prompt_msg
    call printf
    add esp, 4
    
    ; Читаем число
    call read_number
    cmp eax, 0
    je input_error_prime
    
    ; Проверяем простое число
    call check_prime
    
    ; Ждем продолжения
    call wait_continue
    ret
    
input_error_prime:
    push offset error_msg
    call printf
    add esp, 4
    call wait_continue
    ret
process_prime ENDP

; Процедура обработки нескольких чисел
process_multiple_numbers PROC
    ; Запрашиваем количество чисел
    push offset count_msg
    call printf
    add esp, 4
    
    push offset count
    push offset input_format
    call scanf
    add esp, 8
    
    ; Пропускаем символ новой строки
    push offset input_char
    push offset char_format
    call scanf
    add esp, 8
    
    ; Проверяем диапазон
    mov eax, count
    cmp eax, 1
    jl invalid_count
    cmp eax, 10
    jg invalid_count
    
    ; Обрабатываем числа
    call process_numbers_array
    ret
    
invalid_count:
    push offset error_msg
    call printf
    add esp, 4
    call wait_continue
    ret
process_multiple_numbers ENDP

; Процедура обработки массива чисел
process_numbers_array PROC
    mov ecx, count
    mov esi, 0  ; Индекс в массиве
    
read_loop:
    ; Выводим приглашение
    push offset prompt_msg
    call printf
    add esp, 4
    
    ; Читаем число
    call read_number
    cmp eax, 0
    je skip_number
    
    ; Сохраняем число в массив
    mov eax, number
    mov numbers_array[esi*4], eax
    
    ; Проверяем четность
    call check_even_odd
    
    ; Проверяем простое число
    call check_prime
    
skip_number:
    inc esi
    loop read_loop
    
    call wait_continue
    ret
process_numbers_array ENDP

; Процедура чтения числа
read_number PROC
    push offset number
    push offset input_format
    call scanf
    add esp, 8
    
    ; Проверяем результат scanf
    cmp eax, 1
    jne read_failed
    
    ; Проверяем диапазон (1-100)
    mov eax, number
    cmp eax, 1
    jl read_failed
    cmp eax, 100
    jg read_failed
    
    mov eax, 1  ; Успех
    ret
    
read_failed:
    mov eax, 0  ; Ошибка
    ret
read_number ENDP

; Процедура проверки четности
check_even_odd PROC
    mov eax, number
    and eax, 1      ; Проверяем младший бит
    
    cmp eax, 0
    je print_even
    
    ; Число нечетное
    push number
    push offset odd_msg
    call printf
    add esp, 8
    ret
    
print_even:
    ; Число четное
    push number
    push offset even_msg
    call printf
    add esp, 8
    ret
check_even_odd ENDP

; Процедура проверки простого числа
check_prime PROC
    mov eax, number
    cmp eax, 1
    je not_prime_result
    cmp eax, 2
    je prime_result
    
    ; Проверяем делимость на числа от 2 до sqrt(number)
    mov ecx, 2  ; Делитель
    
check_divisor:
    mov eax, number
    mov edx, 0
    div ecx
    
    cmp edx, 0  ; Проверяем остаток
    je not_prime_result
    
    inc ecx
    mov eax, ecx
    mul ecx
    cmp eax, number
    jle check_divisor
    
    ; Если дошли сюда, число простое
    jmp prime_result
    
not_prime_result:
    push number
    push offset not_prime_msg
    call printf
    add esp, 8
    ret
    
prime_result:
    push number
    push offset prime_msg
    call printf
    add esp, 8
    ret
check_prime ENDP

; Процедура ожидания продолжения
wait_continue PROC
    push offset continue_msg
    call printf
    add esp, 4
    
    ; Читаем символ
    push offset input_char
    push offset char_format
    call scanf
    add esp, 8
    ret
wait_continue ENDP

end start 
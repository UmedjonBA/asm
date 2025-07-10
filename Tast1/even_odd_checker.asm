; Программа для проверки четности числа
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
    prompt_msg db "Введите целое число (1-100): ", 0
    even_msg db "Число четное!", 13, 10, 0
    odd_msg db "Число нечетное!", 13, 10, 0
    error_msg db "Ошибка! Введите корректное число.", 13, 10, 0
    continue_msg db "Нажмите Enter для продолжения или 'q' для выхода: ", 0
    
    ; Форматы для ввода/вывода
    input_format db "%d", 0
    char_format db "%c", 0
    
    ; Переменные
    number dd 0
    input_char db 0
    continue_flag db 1
    
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
    ; Проверяем флаг продолжения
    cmp continue_flag, 0
    je exit_program
    
    ; Выводим приглашение к вводу
    call print_prompt
    
    ; Читаем число
    call read_number
    
    ; Проверяем успешность чтения
    cmp eax, 0
    je input_error
    
    ; Проверяем четность
    call check_even_odd
    
    ; Спрашиваем о продолжении
    call ask_continue
    
    jmp main_loop

input_error:
    ; Выводим сообщение об ошибке
    push offset error_msg
    call printf
    add esp, 4
    jmp main_loop

exit_program:
    ; Завершение программы
    push 0
    call ExitProcess@4

; Процедура вывода приглашения
print_prompt PROC
    push offset prompt_msg
    call printf
    add esp, 4
    ret
print_prompt ENDP

; Процедура чтения числа
read_number PROC
    push offset number
    push offset input_format
    call scanf
    add esp, 8
    
    ; Проверяем результат scanf (eax содержит количество успешно прочитанных элементов)
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
    push offset odd_msg
    call printf
    add esp, 4
    ret
    
print_even:
    ; Число четное
    push offset even_msg
    call printf
    add esp, 4
    ret
check_even_odd ENDP

; Процедура запроса о продолжении
ask_continue PROC
    push offset continue_msg
    call printf
    add esp, 4
    
    ; Читаем символ
    push offset input_char
    push offset char_format
    call scanf
    add esp, 8
    
    ; Проверяем введенный символ
    mov al, input_char
    cmp al, 'q'
    je set_exit
    cmp al, 'Q'
    je set_exit
    
    ; Пропускаем символ новой строки
    push offset input_char
    push offset char_format
    call scanf
    add esp, 8
    
    ret
    
set_exit:
    mov continue_flag, 0
    ret
ask_continue ENDP

end start 
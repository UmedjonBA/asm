; Программа для проверки четности числа (Windows API версия)
; MASM Assembly Language
; Автор: Student
; Дата: 2024

.386
.model flat, stdcall
option casemap:none

; Подключение библиотек
includelib kernel32.lib
includelib user32.lib

; Объявление внешних функций
extern GetStdHandle@4:PROC
extern WriteConsoleA@20:PROC
extern ReadConsoleA@20:PROC
extern ExitProcess@4:PROC
extern wsprintfA:PROC

.data
    ; Сообщения для пользователя
    prompt_msg db "Введите целое число (1-100): ", 0
    even_msg db "Число четное!", 13, 10, 0
    odd_msg db "Число нечетное!", 13, 10, 0
    error_msg db "Ошибка! Введите корректное число.", 13, 10, 0
    continue_msg db "Нажмите Enter для продолжения или 'q' для выхода: ", 0
    
    ; Дескрипторы для консоли
    stdin_handle dd 0
    stdout_handle dd 0
    
    ; Буферы для ввода/вывода
    input_buffer db 256 dup(0)
    output_buffer db 256 dup(0)
    bytes_read dd 0
    bytes_written dd 0
    
    ; Переменные
    number dd 0
    continue_flag db 1
    
    ; Константы
    STD_INPUT_HANDLE equ -10
    STD_OUTPUT_HANDLE equ -11

.code
start:
    ; Инициализация дескрипторов консоли
    push STD_INPUT_HANDLE
    call GetStdHandle@4
    mov stdin_handle, eax
    
    push STD_OUTPUT_HANDLE
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
    call print_string
    jmp main_loop

exit_program:
    ; Завершение программы
    push 0
    call ExitProcess@4

; Процедура вывода приглашения
print_prompt PROC
    push offset prompt_msg
    call print_string
    ret
print_prompt ENDP

; Процедура вывода строки
print_string PROC
    push ebp
    mov ebp, esp
    
    ; Вычисляем длину строки
    mov esi, [ebp+8]  ; Адрес строки
    mov ecx, 0        ; Счетчик символов
    
count_loop:
    mov al, [esi]
    cmp al, 0
    je count_done
    inc esi
    inc ecx
    jmp count_loop
    
count_done:
    ; Выводим строку
    push 0                    ; lpReserved
    push offset bytes_written ; lpNumberOfCharsWritten
    push ecx                  ; nNumberOfCharsToWrite
    push [ebp+8]             ; lpBuffer
    push stdout_handle       ; hConsoleOutput
    call WriteConsoleA@20
    
    mov esp, ebp
    pop ebp
    ret 4
print_string ENDP

; Процедура чтения числа
read_number PROC
    ; Читаем строку
    push 0                    ; lpReserved
    push offset bytes_read    ; lpNumberOfCharsRead
    push 255                  ; nNumberOfCharsToRead
    push offset input_buffer  ; lpBuffer
    push stdin_handle         ; hConsoleInput
    call ReadConsoleA@20
    
    ; Преобразуем строку в число
    call string_to_number
    
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

; Процедура преобразования строки в число
string_to_number PROC
    mov esi, offset input_buffer
    mov eax, 0          ; Результат
    mov ebx, 10         ; Основание системы счисления
    mov ecx, 0          ; Счетчик цифр
    
convert_loop:
    mov dl, [esi]
    cmp dl, 13          ; CR
    je convert_done
    cmp dl, 10          ; LF
    je convert_done
    cmp dl, 0           ; NULL
    je convert_done
    
    ; Проверяем, что символ - цифра
    cmp dl, '0'
    jl convert_error
    cmp dl, '9'
    jg convert_error
    
    ; Преобразуем символ в цифру
    sub dl, '0'
    
    ; Умножаем результат на 10 и добавляем новую цифру
    mul ebx
    movzx edx, dl
    add eax, edx
    
    inc esi
    inc ecx
    jmp convert_loop
    
convert_done:
    mov number, eax
    ret
    
convert_error:
    mov number, 0
    ret
string_to_number ENDP

; Процедура проверки четности
check_even_odd PROC
    mov eax, number
    and eax, 1      ; Проверяем младший бит
    
    cmp eax, 0
    je print_even
    
    ; Число нечетное
    push offset odd_msg
    call print_string
    ret
    
print_even:
    ; Число четное
    push offset even_msg
    call print_string
    ret
check_even_odd ENDP

; Процедура запроса о продолжении
ask_continue PROC
    push offset continue_msg
    call print_string
    
    ; Читаем символ
    push 0                    ; lpReserved
    push offset bytes_read    ; lpNumberOfCharsRead
    push 2                    ; nNumberOfCharsToRead
    push offset input_buffer  ; lpBuffer
    push stdin_handle         ; hConsoleInput
    call ReadConsoleA@20
    
    ; Проверяем введенный символ
    mov al, input_buffer
    cmp al, 'q'
    je set_exit
    cmp al, 'Q'
    je set_exit
    
    ret
    
set_exit:
    mov continue_flag, 0
    ret
ask_continue ENDP

end start 
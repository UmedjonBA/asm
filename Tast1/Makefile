# Makefile для сборки программ MASM
# Использование: make [target]

# Переменные
ML = ml
LINK = link
CFLAGS = /c /coff
LDFLAGS = /subsystem:console
LIBS = kernel32.lib user32.lib msvcrt.lib

# Цели
all: even_odd_checker.exe even_odd_checker_winapi.exe advanced_number_checker.exe

# Основная версия
even_odd_checker.exe: even_odd_checker.obj
	$(LINK) $(LDFLAGS) $< $(LIBS)

even_odd_checker.obj: even_odd_checker.asm
	$(ML) $(CFLAGS) $<

# Windows API версия
even_odd_checker_winapi.exe: even_odd_checker_winapi.obj
	$(LINK) $(LDFLAGS) $< kernel32.lib user32.lib

even_odd_checker_winapi.obj: even_odd_checker_winapi.asm
	$(ML) $(CFLAGS) $<

# Расширенная версия
advanced_number_checker.exe: advanced_number_checker.obj
	$(LINK) $(LDFLAGS) $< $(LIBS)

advanced_number_checker.obj: advanced_number_checker.asm
	$(ML) $(CFLAGS) $<

# Очистка
clean:
	del *.obj *.exe

# Запуск программ
run-basic: even_odd_checker.exe
	./even_odd_checker.exe

run-winapi: even_odd_checker_winapi.exe
	./even_odd_checker_winapi.exe

run-advanced: advanced_number_checker.exe
	./advanced_number_checker.exe

# Помощь
help:
	@echo Доступные цели:
	@echo   all              - Собрать все версии
	@echo   even_odd_checker.exe - Основная версия
	@echo   even_odd_checker_winapi.exe - Windows API версия
	@echo   advanced_number_checker.exe - Расширенная версия
	@echo   clean            - Удалить временные файлы
	@echo   run-basic        - Запустить основную версию
	@echo   run-winapi       - Запустить Windows API версию
	@echo   run-advanced     - Запустить расширенную версию
	@echo   help             - Показать эту справку

.PHONY: all clean run-basic run-winapi run-advanced help 
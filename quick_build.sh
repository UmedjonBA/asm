#!/bin/bash

echo "🚀 Быстрая сборка GUI приложений"
echo "================================="

# Go + Fyne (САМЫЙ БЫСТРЫЙ)
echo ""
echo "1️⃣  Сборка Go + Fyne приложения..."
echo "   ⏱️  Время сборки: ~5 секунд"

if command -v go &> /dev/null; then
    echo "   ✅ Go найден: $(go version)"
    
    # Linux
    echo "   📦 Сборка для Linux..."
    go build -ldflags "-s -w" -o gui_app_linux main.go
    echo "   ✅ Linux: gui_app_linux ($(ls -lh gui_app_linux | awk '{print $5}')"
    
    # Windows (если доступен MinGW)
    if command -v x86_64-w64-mingw32-gcc &> /dev/null; then
        echo "   📦 Сборка для Windows..."
        CGO_ENABLED=1 GOOS=windows GOARCH=amd64 CC=x86_64-w64-mingw32-gcc go build -ldflags "-s -w -H windowsgui" -o gui_app_windows.exe main.go
        echo "   ✅ Windows: gui_app_windows.exe ($(ls -lh gui_app_windows.exe | awk '{print $5}')"
    else
        echo "   ⚠️  MinGW не найден - пропускаем Windows сборку"
    fi
else
    echo "   ❌ Go не установлен"
    echo "   📥 Установка: sudo apt install golang-go"
fi

# Rust + egui
echo ""
echo "2️⃣  Сборка Rust + egui приложения..."
echo "   ⏱️  Время сборки: ~30 секунд"

if command -v cargo &> /dev/null; then
    echo "   ✅ Rust найден: $(rustc --version)"
    cd rust_example 2>/dev/null
    if [ $? -eq 0 ]; then
        cargo build --release --quiet
        if [ -f target/release/simple-gui-app ]; then
            cp target/release/simple-gui-app ../gui_app_rust
            echo "   ✅ Rust: gui_app_rust ($(ls -lh ../gui_app_rust | awk '{print $5}')"
        fi
        cd ..
    else
        echo "   ⚠️  Нет папки rust_example"
    fi
else
    echo "   ❌ Rust не установлен"
    echo "   📥 Установка: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
fi

# C++ + Qt
echo ""
echo "3️⃣  C++ + Qt (требует установки Qt)"
echo "   ⏱️  Время сборки: ~1 минута"

if command -v qmake &> /dev/null || command -v qt6-qmake &> /dev/null; then
    echo "   ✅ Qt найден"
    echo "   ℹ️  Для сборки: cd qt_example && mkdir build && cd build && cmake .. && make"
else
    echo "   ❌ Qt не установлен"
    echo "   📥 Установка: sudo apt install qt6-base-dev cmake"
fi

echo ""
echo "🏆 РЕЗУЛЬТАТЫ:"
echo "============="

if [ -f gui_app_linux ]; then
    echo "✅ Linux (Go):     gui_app_linux     ($(ls -lh gui_app_linux | awk '{print $5}'))"
fi

if [ -f gui_app_windows.exe ]; then
    echo "✅ Windows (Go):   gui_app_windows.exe ($(ls -lh gui_app_windows.exe | awk '{print $5}'))"
fi

if [ -f gui_app_rust ]; then
    echo "✅ Linux (Rust):   gui_app_rust       ($(ls -lh gui_app_rust | awk '{print $5}'))"
fi

echo ""
echo "🎯 РЕКОМЕНДАЦИЯ: Go + Fyne для быстрого прототипирования"
echo "💡 Размер exe файлов: Go ~18МБ, Rust ~5МБ"
echo ""
echo "🚀 Готово! Время выполнения: $(date)"
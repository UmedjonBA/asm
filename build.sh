#!/bin/bash

# Установка зависимостей
go mod tidy

# Сборка для Windows (статический exe)
CGO_ENABLED=1 GOOS=windows GOARCH=amd64 go build -ldflags "-s -w -H windowsgui" -o app.exe main.go

# Сборка для Linux
CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" -o app main.go

echo "Сборка завершена!"
echo "Windows exe: app.exe"
echo "Linux binary: app"
package main

import (
	"fyne.io/fyne/v2/app"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/widget"
	"fyne.io/fyne/v2"
)

func main() {
	myApp := app.New()
	myWindow := myApp.NewWindow("Простое GUI приложение")
	myWindow.Resize(fyne.NewSize(400, 300))

	// Элементы интерфейса
	entry := widget.NewEntry()
	entry.SetPlaceHolder("Введите текст...")

	label := widget.NewLabel("Результат появится здесь")

	button := widget.NewButton("Обработать", func() {
		text := entry.Text
		if text != "" {
			label.SetText("Вы ввели: " + text)
		} else {
			label.SetText("Введите текст!")
		}
	})

	// Компоновка
	content := container.NewVBox(
		widget.NewLabel("Простое GUI приложение"),
		entry,
		button,
		label,
	)

	myWindow.SetContent(content)
	myWindow.ShowAndRun()
}
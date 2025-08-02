#include <QApplication>
#include <QWidget>
#include <QVBoxLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QLabel>

class SimpleApp : public QWidget {
    Q_OBJECT

public:
    SimpleApp(QWidget *parent = nullptr) : QWidget(parent) {
        setWindowTitle("Простое GUI приложение");
        setFixedSize(400, 300);

        // Создание элементов
        lineEdit = new QLineEdit();
        lineEdit->setPlaceholderText("Введите текст...");
        
        button = new QPushButton("Обработать");
        label = new QLabel("Результат появится здесь");

        // Компоновка
        QVBoxLayout *layout = new QVBoxLayout();
        layout->addWidget(new QLabel("Простое GUI приложение"));
        layout->addWidget(lineEdit);
        layout->addWidget(button);
        layout->addWidget(label);
        
        setLayout(layout);

        // Подключение сигналов
        connect(button, &QPushButton::clicked, this, &SimpleApp::onButtonClicked);
    }

private slots:
    void onButtonClicked() {
        QString text = lineEdit->text();
        if (!text.isEmpty()) {
            label->setText("Вы ввели: " + text);
        } else {
            label->setText("Введите текст!");
        }
    }

private:
    QLineEdit *lineEdit;
    QPushButton *button;
    QLabel *label;
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    
    SimpleApp window;
    window.show();
    
    return app.exec();
}

#include "main.moc"
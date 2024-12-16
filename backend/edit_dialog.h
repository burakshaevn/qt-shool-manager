#pragma once

#ifndef EDIT_DIALOG_H
#define EDIT_DIALOG_H

#include <QSqlRecord>
#include <QDialog>
#include <QVBoxLayout>
#include <QLabel>
#include <QLineEdit>
#include <QPushButton>
#include <QHBoxLayout>
#include <QGuiApplication>
#include <QScreen>

class EditDialog : public QDialog {
    Q_OBJECT

public:
    explicit EditDialog(const QSqlRecord& record, QWidget* parent = nullptr)
        : QDialog(parent)
        , record_(record)
    {
        // Основной макет
        auto* layout = new QVBoxLayout(this);

        // Создаём поля ввода для каждой колонки
        for (int i = 0; i < record.count(); ++i) {
            QLabel* label = new QLabel(record.fieldName(i), this);
            QLineEdit* editor = new QLineEdit(record.value(i).toString(), this);
            QString fieldName = record.fieldName(i);
            if (fieldName == "id") {
                editor->setReadOnly(true);
            }
            fields_.append(editor);

            layout->addWidget(label);
            layout->addWidget(editor);
        }

        auto* buttonLayout = new QHBoxLayout();
        auto* saveButton = new QPushButton("Save", this);
        auto* cancelButton = new QPushButton("Cancel", this);

        connect(saveButton, &QPushButton::clicked, this, &QDialog::accept);
        connect(cancelButton, &QPushButton::clicked, this, &QDialog::reject);

        buttonLayout->addWidget(saveButton);
        buttonLayout->addWidget(cancelButton);

        layout->addLayout(buttonLayout);
        setMinimumSize(300, 200);

        setSizeGripEnabled(true);
        adjustSize();

        QRect screenGeometry = QGuiApplication::primaryScreen()->geometry();
        move(screenGeometry.center() - rect().center());
    }

    QSqlRecord GetUpdatedRecord() const {
        QSqlRecord updatedRecord = record_;

        for (int i = 0; i < fields_.size(); ++i) {
            QString value = fields_[i]->text();

            // Пример проверки: поле не должно быть пустым
            if (value.isEmpty()) {
                throw std::runtime_error(
                    QString("Field '%1' cannot be empty.").arg(record_.fieldName(i)).toStdString()
                    );
            }

            // Устанавливаем обновлённое значение
            updatedRecord.setValue(i, value);
        }

        return updatedRecord;
    }

private:
    QSqlRecord record_;
    QVector<QLineEdit*> fields_;
};

#endif // EDIT_DIALOG_H

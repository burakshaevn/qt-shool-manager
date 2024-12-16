#pragma once

#ifndef TABLE_MANAGER_H
#define TABLE_MANAGER_H

#include <QWidget>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QTableView>
#include <QComboBox>
#include <QPushButton>
#include <QLabel>
#include <QMessageBox>
#include <QSqlTableModel>
#include <QHeaderView>
#include <QInputDialog>
#include <QSqlField>
#include <QTableWidget>
#include <QStandardItemModel>

#include "database_manager.h"
#include "edit_dialog.h"
#include "domain.h"

class Table : public QWidget {
    Q_OBJECT

protected:
    DatabaseManager* db_manager_;
    QTableView* data_table_;
    QLabel* description_table;

    QComboBox* table_selector_;
    QHBoxLayout* button_layout;
    QPushButton* add_button_;
    QPushButton* delete_button_;
    QPushButton* edit_button_;
    // QPushButton* save_button_;
    QPushButton* logout_button_;

    Tables current_table_;

public:
    explicit Table(DatabaseManager* db_manager, QWidget* parent = nullptr)
        : QWidget(parent)
        , data_table_(new QTableView(this))
        , description_table(new QLabel(this))
        , table_selector_(new QComboBox(this))
        , button_layout(new QHBoxLayout())
        , add_button_(new QPushButton("Add", this))
        , delete_button_(new QPushButton("Delete", this))
        , edit_button_(new QPushButton("Edit", this))
        // , save_button_(new QPushButton("Save Changes", this))
        , logout_button_(new QPushButton("Logout", this))
        , current_table_(Tables::unknown)
    {
        auto* layout = new QVBoxLayout(this);
        table_selector_->addItems(GetTables());
        table_selector_->setCurrentIndex(-1);
        table_selector_->setStyleSheet(R"(
        QComboBox{
            background-color: #fafafa;
            border: 0px;
            color: #1d1b20;
            padding-left: 27px;
        }

        QComboBox::drop-down {
            subcontrol-origin: padding;
            subcontrol-position: top right;
            width: 20px;
            border: 1px solid #cccccc;
            background-color: #e0e0e0;
        })"); // font: 10pt "Open Sans";
        layout->addWidget(table_selector_);
        description_table->setStyleSheet(R"(QLabel{\n	color: #1d1b20; \n	font: 18pt "Open Sans"; \n})");
        layout->addWidget(description_table);

        // Таблица для отображения данных
        data_table_->setSelectionBehavior(QAbstractItemView::SelectRows);
        data_table_->setSelectionMode(QAbstractItemView::SingleSelection);
        data_table_->horizontalHeader()->setStretchLastSection(true);
        data_table_->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
        layout->addWidget(data_table_);

        // Кнопки управления
        add_button_->setStyleSheet(R"(QPushButton{\n	background-color: #fafafa;\n	border: 0px;\n})");
        add_button_->setIcon(QIcon(":/add.svg"));
        add_button_->setIconSize({22, 22});
        button_layout->addWidget(add_button_);

        edit_button_->setStyleSheet(R"(QPushButton{\n	background-color: #fafafa;\n	border: 0px;\n})");
        edit_button_->setIcon(QIcon(":/edit.svg"));
        edit_button_->setIconSize({20, 20});
        button_layout->addWidget(edit_button_);

        delete_button_->setStyleSheet(R"(QPushButton{\n	background-color: #fafafa;\n	border: 0px;\n})");
        delete_button_->setIcon(QIcon(":/delete.svg"));
        delete_button_->setIconSize({20, 20});
        button_layout->addWidget(delete_button_);

        layout->addLayout(button_layout);

        // save_button_->setStyleSheet(R"(QPushButton{\n	background-color: #fafafa;\n	border: 0px;\n})");
        // save_button_->setIcon(QIcon(":/Save.svg"));
        // save_button_->setIconSize({15, 15});
        // layout->addWidget(save_button_);

        logout_button_->setStyleSheet(R"(QPushButton{\n	color: #1d1b20;\n	background-color: transparent; \n	font: 18pt "Open Sans"; \n})");
        layout->addWidget(logout_button_);

        connect(table_selector_, &QComboBox::currentTextChanged, this, &Table::LoadTable);
        connect(add_button_, &QPushButton::clicked, this, &Table::AddRecord);
        connect(edit_button_, &QPushButton::clicked, this, &Table::EditRecord);
        connect(delete_button_, &QPushButton::clicked, this, &Table::DeleteRecord);
        // connect(save_button_, &QPushButton::clicked, this, &Table::SaveChanges);
        connect(logout_button_, &QPushButton::clicked, this, &Table::Logout);
    }

    void LoadTable() {
        QString table_name = table_selector_->currentText();

        QVariant result = db_manager_->ExecuteSelectQuery(QString("SELECT * FROM public.%1").arg(table_name));
        if (result.canConvert<QSqlQuery>()) {
            QSqlQuery query = result.value<QSqlQuery>();

            if (!query.isActive()) {
                QMessageBox::critical(this, "Error", "Query execution failed: " + query.lastError().text());
                return;
            }

            if (!query.next()) {
                QMessageBox::warning(this, "Warning", "The selected table is empty or does not exist.");
                return;
            }

            // Возврат к началу результата
            query.first();

            // Обновление описания таблицы
            description_table->clear();
            description_table->setText(db_manager_->GetTableDescription(table_name));
            description_table->setWordWrap(true);
            description_table->setTextInteractionFlags(Qt::TextBrowserInteraction);
            description_table->setAlignment(Qt::AlignLeft | Qt::AlignTop);

            // Создание новой модели
            auto* model = new QStandardItemModel(this);
            data_table_->setModel(nullptr); // Удаляем старую модель

            // Получение структуры таблицы
            QSqlRecord record = query.record();
            int column_count = record.count();

            // Установка заголовков
            QStringList headers;
            for (int i = 0; i < column_count; ++i) {
                headers << record.fieldName(i); // Имена столбцов
            }
            model->setHorizontalHeaderLabels(headers);

            // Заполнение модели данными из запроса
            do {
                QList<QStandardItem*> items;
                for (int col = 0; col < column_count; ++col) {
                    auto* item = new QStandardItem(query.value(col).toString());
                    item->setEditable(false);
                    items.append(item);
                }
                model->appendRow(items);
            } while (query.next());

            // Установка модели
            data_table_->setModel(model);
            data_table_->resizeColumnsToContents();
            data_table_->setEditTriggers(QAbstractItemView::DoubleClicked | QAbstractItemView::SelectedClicked);
            data_table_->setSortingEnabled(true);

            QHeaderView* header = data_table_->horizontalHeader();
            header->setSectionResizeMode(QHeaderView::Stretch);

            // Сохранение текущей таблицы
            current_table_ = StringToTables(table_name);
        } else {
            QMessageBox::critical(this, "Error", "Failed to execute query.");
        }
    }

    QStringList GetTables() const {
        QVariant result = db_manager_->ExecuteSelectQuery(QString("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';"));
        QStringList tables;
        if (result.canConvert<QSqlQuery>()) {

            QSqlQuery query = result.value<QSqlQuery>();
            if (query.isActive()) {
                while (query.next()) {
                    tables << query.value(0).toString();
                }
            }
        }
        return tables;
    }

    // void AddRecord() {
    //     current_table_ = StringToTables(model_->tableName());
    //     switch (current_table_) {
    //     case Tables::teachers:
    //         SetupDefaultValue("teacher_id", model_->tableName());
    //         break;
    //     case Tables::students:
    //         SetupDefaultValue("student_id", model_->tableName());
    //         break;
    //     default:
    //         SetupDefaultValue("id", model_->tableName());
    //         break;
    //     }

    //     data_table_->selectRow(model_->rowCount());
    // }
    //void AddRecord() {
        // QString table_name = table_selector_->currentText();

        // QString column_name = (current_table_ == Tables::teachers) ? "teacher_id" : "id";
        // int new_id = GetMaxValueFromTable(column_name, table_name) + 1;

        // QSqlQuery query;
        // query.prepare(QString("INSERT INTO %1 (%2) VALUES (:id)").arg(table_name, column_name));
        // query.bindValue(":id", new_id);

        // if (!query.exec()) {
        //     QMessageBox::critical(this, "Error", "Failed to add record: " + query.lastError().text());
        //     return;
        // }

        // model_->select(); // Обновляем модель, чтобы отобразить изменения
    //}

    void AddRecord() {
        if (!data_table_->model()) {
            QMessageBox::warning(this, "No Model", "No model is set for the table view.");
            return;
        }

        // Получаем имя таблицы
        QString tableName = table_selector_->currentText();
        if (tableName.isEmpty()) {
            QMessageBox::critical(this, "Error", "No table selected.");
            return;
        }

        // Получаем модель и создаём пустую запись
        QAbstractItemModel* model = data_table_->model();
        QSqlRecord newRecord;

        for (int col = 0; col < model->columnCount(); ++col) {
            QString fieldName = model->headerData(col, Qt::Horizontal).toString();
            QSqlField field(fieldName, QVariant::String);

            if (fieldName == "id") {
                // Автоматически вычисляем id
                int newId = db_manager_->GetMaxOrMinValueFromTable("MAX", fieldName, tableName) + 1;
                field.setValue(newId);
            } else {
                // Для остальных полей задаём пустое значение
                field.setValue("");
            }

            newRecord.append(field);
        }

        // Открываем диалог EditDialog для ввода данных
        EditDialog dialog(newRecord, this);
        if (dialog.exec() == QDialog::Accepted) {
            // Получаем обновлённую запись из диалога
            QSqlRecord updatedRecord = dialog.GetUpdatedRecord();

            // Формируем SQL-запрос для вставки данных
            QStringList fieldNames, fieldValues;
            for (int col = 0; col < updatedRecord.count(); ++col) {
                QString fieldName = updatedRecord.fieldName(col);
                QString fieldValue = updatedRecord.value(col).toString();

                fieldNames.append(fieldName);
                fieldValues.append("'" + fieldValue + "'");
            }

            QString insertQuery = QString("INSERT INTO %1 (%2) VALUES (%3)")
                                      .arg(tableName)
                                      .arg(fieldNames.join(", "))
                                      .arg(fieldValues.join(", "));

            // Выполняем запрос
            QSqlQuery query;
            if (!query.exec(insertQuery)) {
                QMessageBox::critical(this, "SQL Error", "Failed to execute query: " + query.lastError().text());
                return;
            }

            // Перезагружаем таблицу
            LoadTable();
            QMessageBox::information(this, "Success", "Record added successfully.");
        }
    }

    void SetupDefaultValue(const QString& column_name, const QString& table_name){
        // int newRow = model_->rowCount();
        // if (!model_->insertRow(newRow)) {
        //     QMessageBox::critical(data_table_, "Error", "Failed to add record: " + model_->lastError().text());
        //     return;
        // }
        // QString tableName = model_->tableName();

        // int last_insert_id = GetMaxValueFromTable(column_name, table_name);
        // model_->setData(model_->index(newRow, model_->fieldIndex(column_name)), last_insert_id + 1);
    }

    void DeleteRecord() {
        if (!data_table_->model()) {
            QMessageBox::warning(this, "No Model", "No model is set for the table view.");
            return;
        }
        QString table_name = table_selector_->currentText();
        QString col_name = "id";

        int id = -1; // Для хранения идентификатора, если есть primary_key

        if (!col_name.isEmpty()) {
            // Если есть primary_key, запрашиваем ID для удаления
            int min_id = db_manager_->GetMaxOrMinValueFromTable("MIN", col_name, table_name);
            int max_id = db_manager_->GetMaxOrMinValueFromTable("MAX", col_name, table_name);

            bool ok;
            id = QInputDialog::getInt(
                this, "Delete Record", "Enter ID number:", 1, min_id, max_id, 1, &ok
                );

            if (!ok) {
                return;
            }

            if (id < min_id || id > max_id) {
                QMessageBox::warning(this, "Invalid Data", "The entered data number is invalid.");
                return;
            }
        } else {
            // Если primary_key отсутствует, используем выбор строки
            QItemSelectionModel* selectionModel = data_table_->selectionModel();
            if (!selectionModel->hasSelection()) {
                QMessageBox::warning(this, "No Selection", "Please select a row to delete.");
                return;
            }

            QModelIndexList selectedRows = selectionModel->selectedRows();
            if (selectedRows.size() != 1) {
                QMessageBox::warning(this, "Invalid Selection", "Please select exactly one row to delete.");
                return;
            }

            // Получаем индекс выбранной строки
            QModelIndex selectedIndex = selectedRows.first();
            int row = selectedIndex.row();

            // Получаем данные строки из модели
            QAbstractItemModel* model = data_table_->model();
            QStringList columnValues;
            for (int col = 0; col < model->columnCount(); ++col) {
                columnValues << model->data(model->index(row, col)).toString();
            }

            // Сформируем запрос для удаления строки на основе значений столбцов
            QString query_string = QString("DELETE FROM %1 WHERE ").arg(table_name);
            QStringList conditions;
            for (int col = 0; col < model->columnCount(); ++col) {
                QString col_name = model->headerData(col, Qt::Horizontal).toString();
                QString value = model->data(model->index(row, col)).toString();
                conditions << QString("%1 = '%2'").arg(col_name, value);
            }
            query_string += conditions.join(" AND ");

            // Подтверждение удаления
            QString warningMessage = "Are you sure you want to delete the selected record?";
            if (QMessageBox::warning(this, "Confirm Deletion", warningMessage,
                                     QMessageBox::Yes | QMessageBox::No) == QMessageBox::No) {
                return;
            }

            // Выполняем удаление
            QSqlQuery query;
            if (!query.exec(query_string)) {
                QMessageBox::critical(this, "Error", "Failed to delete record: " + query.lastError().text());
                return;
            }

            LoadTable();
            return;
        }

        // Удаление по primary_key
        if (GetConfirmation(table_name, col_name, id)) {
            QStringList foreignKeys = db_manager_->GetForeignKeysForColumn(table_name, col_name);

            QString infoMessage;
            if (!foreignKeys.isEmpty()) {
                infoMessage = "Deleting this record will affect the following related tables:\n";
                infoMessage += foreignKeys.join("\n");
                infoMessage += "\n\nAre you sure you want to proceed?";
            } else {
                infoMessage = "Are you sure you want to delete this record?";
            }

            if (QMessageBox::warning(this, "Confirm Deletion", infoMessage,
                                     QMessageBox::Yes | QMessageBox::No) == QMessageBox::No) {
                return;
            }

            QSqlQuery query;
            QString query_string = QString("DELETE FROM %1 WHERE %2 = :id")
                                       .arg(table_name, col_name);

            query.prepare(query_string);
            query.bindValue(":id", id);

            if (!query.exec()) {
                QMessageBox::critical(this, "Error", "Failed to delete record: " + query.lastError().text());
                return;
            }

            LoadTable();
        }
    }

    QString GetPrimaryKeyColumnName(const QString& table_name) {
        QSqlQuery query;
        query.prepare(R"(
        SELECT a.attname
        FROM pg_index i
        JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
        WHERE i.indrelid = :table_name::regclass AND i.indisprimary;
    )");
        query.bindValue(":table_name", table_name);

        if (query.exec() && query.next()) {
            return query.value(0).toString();
        }
        return QString();
    }

    bool GetConfirmation(const QString& table_name, const QString& primary_key_column, int id) {
        QSqlQuery query;
        query.prepare(QString("SELECT * FROM %1 WHERE %2 = :id").arg(table_name, primary_key_column));
        query.bindValue(":id", id);

        if (!query.exec() || !query.next()) {
            QMessageBox::critical(nullptr, "Error", "Failed to fetch record for confirmation: " + query.lastError().text());
            return false;
        }

        // Создаем модальное окно
        QDialog dialog;
        dialog.setWindowTitle("Confirm Deletion");
        dialog.setModal(true);

        // Создаем табличный виджет
        QTableWidget* tableWidget = new QTableWidget(&dialog);

        QSqlRecord record = query.record();
        int columnCount = record.count();

        // Устанавливаем количество строк и столбцов
        tableWidget->setColumnCount(columnCount);
        tableWidget->setRowCount(1);

        // Устанавливаем заголовки столбцов
        QStringList headers;
        for (int i = 0; i < columnCount; ++i) {
            headers << record.fieldName(i);
        }
        tableWidget->setHorizontalHeaderLabels(headers);

        // Заполняем данные строки
        for (int i = 0; i < columnCount; ++i) {
            tableWidget->setItem(0, i, new QTableWidgetItem(query.value(i).toString()));
        }

        // Отключаем редактирование
        tableWidget->setEditTriggers(QTableWidget::NoEditTriggers);
        tableWidget->setSelectionMode(QTableWidget::NoSelection);
        tableWidget->horizontalHeader()->setStretchLastSection(true);

        // Настраиваем размеры таблицы
        tableWidget->resizeColumnsToContents();
        tableWidget->resizeRowsToContents();

        // Установим политику размеров так, чтобы окно занимало минимально необходимый размер
        tableWidget->setSizePolicy(QSizePolicy::Minimum, QSizePolicy::Minimum);

        // Добавляем кнопку подтверждения
        QVBoxLayout* layout = new QVBoxLayout(&dialog);
        layout->addWidget(tableWidget);

        QHBoxLayout* buttonLayout = new QHBoxLayout();
        QPushButton* yesButton = new QPushButton("Yes", &dialog);
        QPushButton* noButton = new QPushButton("No", &dialog);
        buttonLayout->addStretch();
        buttonLayout->addWidget(yesButton);
        buttonLayout->addWidget(noButton);
        layout->addLayout(buttonLayout);

        // Подгоняем размер окна под содержимое
        dialog.adjustSize();

        // Сигналы кнопок
        QObject::connect(yesButton, &QPushButton::clicked, &dialog, &QDialog::accept);
        QObject::connect(noButton, &QPushButton::clicked, &dialog, &QDialog::reject);

        // Отображаем окно
        int result = dialog.exec();
        return (result == QDialog::Accepted);
    }

    void EditRecord() {
        if (!data_table_->model()) {
            QMessageBox::warning(this, "No Model", "No model is set for the table view.");
            return;
        }

        bool ok;
        int row = QInputDialog::getInt(
            this, "Edit Record", "Enter ROW number:", 1, 1, data_table_->model()->rowCount(), 1, &ok
        );

        if (!ok) {
            return;
        }

        row -= 1;

        if (row < 0 || row >= data_table_->model()->rowCount()) {
            QMessageBox::warning(this, "Invalid Data", "The entered data number is invalid.");
            return;
        }

        // Получаем данные текущей строки через модель
        QAbstractItemModel* model = data_table_->model();
        QSqlRecord record;
        for (int col = 0; col < model->columnCount(); ++col) {
            QVariant value = model->index(row, col).data();
            record.append(QSqlField(model->headerData(col, Qt::Horizontal).toString(), value.type()));
            record.setValue(col, value);
        }

        // Открываем диалог для редактирования
        EditDialog dialog(record, this);
        if (dialog.exec() == QDialog::Accepted) {
            // Получаем обновлённую запись
            QSqlRecord updatedRecord = dialog.GetUpdatedRecord();

            // Формируем SQL-запрос для обновления строки
            QString tableName = table_selector_->currentText();
            QStringList setClauses;
            QString whereClause;

            for (int col = 0; col < record.count(); ++col) {
                QString fieldName = record.fieldName(col);
                QString newValue = updatedRecord.value(col).toString();

                setClauses.append(QString("%1 = '%2'").arg(fieldName, newValue));

                if (col == 0) { // Условие WHERE берём по первому столбцу (можно настроить)
                    QString oldValue = record.value(col).toString();
                    whereClause = QString("%1 = '%2'").arg(fieldName, oldValue);
                }
            }

            if (whereClause.isEmpty()) {
                QMessageBox::critical(this, "Error", "Cannot determine the row for update.");
                return;
            }

            QString updateQuery = QString("UPDATE %1 SET %2 WHERE %3")
                                      .arg(tableName, setClauses.join(", "), whereClause);

            // Выполняем запрос
            QSqlQuery query;
            if (!query.exec(updateQuery)) {
                QMessageBox::critical(this, "SQL Error", "Failed to execute query: " + query.lastError().text());
                return;
            }

            LoadTable();
            QMessageBox::information(this, "Success", "Record updated successfully.");
        }
    }

    // void SaveChanges() {
    //     if (!model_->submitAll()) {
    //         QMessageBox::critical(this, "Error", "Failed to save changes: " + model_->lastError().text());
    //     }
    //     else {
    //         QMessageBox::information(this, "Success", "Changes saved successfully.");
    //     }
    //     model_->select();
    // }

signals:
    void Logout();
};

#endif // TABLE_MANAGER_H

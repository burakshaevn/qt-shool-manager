#include "mainwindow.h"
#include "./ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    QString hostname = "localhost";
    int port = 5432;
    QString dbname = "school";
    QString username = "postgres";
    QString password = "89274800234Nn";
    db_manager_.UpdateConnection(hostname, port, dbname, username, password);
    db_manager_.Open();
    ui->stackedWidget->setCurrentWidget(ui->login);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::UpdateUser(const UserInfo& user, QWidget* parent){
    user_ = std::make_unique<User>(user, parent);
    // ui->label_username->setText(user_->GetFirstName() + " " + user_->GetLastName());
}

// void MainWindow::SetupTable() {
//     ui->comboBox->setInsertPolicy(QComboBox::InsertAlphabetically);
//     QVariant result = db_manager_.ExecuteSelectQuery(QString("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';"));

//     if (result.canConvert<QSqlQuery>()) {
//         QSqlQuery query = result.value<QSqlQuery>();

//         if (query.isActive()) {
//             QStringList tables;

//             while (query.next()) {
//                 tables << query.value(0).toString();
//             }

//             ui->comboBox->addItems(tables);
//         }
//         else {
//             QMessageBox::critical(this, "Error", "Query is inactive:" + query.lastError().text());
//         }
//     }
//     else {
//         QMessageBox::critical(this, "Error", "Cannot convert result to QSqlQuery.");
//     }

//     // ui->comboBox->setCurrentIndex(-1);
// }

// void MainWindow::LoadTable(const QString& table_name){
//     auto model = new QSqlTableModel(this);
//     model->setTable(table_name);
//     model->setEditStrategy(QSqlTableModel::OnManualSubmit);

//     if (!model->select()) {
//         QMessageBox::critical(ui->tableView, "Error", "Failed to load table: " + model->lastError().text());
//         return;
//     }

//     ui->tableView->setModel(model);
//     ui->tableView->resizeColumnsToContents();
//     ui->tableView->setEditTriggers(QAbstractItemView::DoubleClicked | QAbstractItemView::SelectedClicked);
//     model->select();
//     SetupActions(table_name, model);
// }

// void MainWindow::SetupActions(const QString& table_name, QSqlTableModel* model){
//     connect(ui->pushButton_save, &QPushButton::clicked, this, [=]() {
//         if (!model->submitAll()) {
//             QMessageBox::critical(ui->tableView, "Error", "Failed to save changes: " + model->lastError().text());
//         } else {
//             QMessageBox::information(ui->tableView, "Success", "Changes saved successfully.");
//         }
//         model->select();
//     });
//     // connect(ui->pushButton_append, &QPushButton::clicked, this, [=]() {
//     //     int newRow = model->rowCount();
//     //     if (!model->insertRow(newRow)) {
//     //         QMessageBox::critical(ui->tableView, "Error", "Failed to add record: " + model->lastError().text());
//     //         return;
//     //     }

//     //     QSqlQuery query;
//     //     if (!query.exec(QString("SELECT MAX(id) FROM %1").arg(table_name))) {
//     //         QMessageBox::critical(ui->tableView, "Error", "Failed to fetch last ID: " + query.lastError().text());
//     //         return;
//     //     }

//     //     QString new_id;
//     //     if (query.next()) {
//     //         new_id = QString::number(query.value(0).toInt() + 1);
//     //     }
//     //     model->setData(model->index(newRow, model->fieldIndex("id")), new_id);
//     // });
//     connect(ui->pushButton_save, &QPushButton::clicked, this, [this]() {
//         auto model = qobject_cast<QSqlTableModel*>(ui->tableView->model());
//         if (!model) {
//             QMessageBox::critical(this, "Error", "No active table model.");
//             return;
//         }

//         if (!model->submitAll()) {
//             QMessageBox::critical(this, "Error", "Failed to save changes: " + model->lastError().text());
//         } else {
//             QMessageBox::information(this, "Success", "Changes saved successfully.");
//         }
//         model->select();
//     });

//     connect(ui->pushButton_append, &QPushButton::clicked, this, [this, table_name]() {
//         auto model = qobject_cast<QSqlTableModel*>(ui->tableView->model());
//         if (!model) {
//             QMessageBox::critical(this, "Error", "No active table model.");
//             return;
//         }

//         int newRow = model->rowCount();
//         if (!model->insertRow(newRow)) {
//             QMessageBox::critical(this, "Error", "Failed to add record: " + model->lastError().text());
//             return;
//         }

//         // Автоустановка ID, если столбец "id" существует
//         if (model->fieldIndex("id") != -1) {
//             QSqlQuery query;
//             if (!query.exec(QString("SELECT MAX(id) FROM %1").arg(table_name))) {
//                 QMessageBox::critical(this, "Error", "Failed to fetch last ID: " + query.lastError().text());
//                 return;
//             }

//             if (query.next()) {
//                 int new_id = query.value(0).toInt() + 1;
//                 model->setData(model->index(newRow, model->fieldIndex("id")), new_id);
//             }
//         }

//         ui->tableView->selectRow(newRow);
//     });

//     connect(ui->pushButton_delete, &QPushButton::clicked, this, [this]() {
//         auto model = qobject_cast<QSqlTableModel*>(ui->tableView->model());
//         if (!model) {
//             QMessageBox::critical(this, "Error", "No active table model.");
//             return;
//         }

//         auto selectedRows = ui->tableView->selectionModel()->selectedRows();
//         if (selectedRows.isEmpty()) {
//             QMessageBox::warning(this, "Warning", "No rows selected for deletion.");
//             return;
//         }

//         for (const QModelIndex &index : selectedRows) {
//             model->removeRow(index.row());
//         }

//         QMessageBox::information(this, "Info", "Rows marked for deletion. Press 'Save' to apply changes.");
//     });
// }

void MainWindow::on_pushButton_login_clicked() {
    auto queryResult = db_manager_.ExecuteSelectQuery(QString("SELECT * FROM public.teachers WHERE email = '%1';").arg(ui->lineEdit_login->text()));

    if (queryResult.canConvert<QSqlQuery>()) {
        QSqlQuery query = queryResult.value<QSqlQuery>();
        if (query.next()) {
            int id = query.value("id").toInt();
            QString first_name = query.value("first_name").toString();
            QString last_name = query.value("last_name").toString();
            QString subject = query.value("subject").toString();
            QString email = query.value("email").toString();
            QString password = query.value("password").toString();
            if (password == ui->lineEdit_password->text()) {
                ui->lineEdit_login->clear();
                ui->lineEdit_password->clear();
                QMessageBox::information(this, "Authorization", "Authorization was completed successfully.");
                UpdateUser(UserInfo{id, first_name, last_name, email, password, IsTeacherOrDirector(subject)}, this);
                // SetupTable();
                table_ = std::make_unique<Table>(&db_manager_, ui->main);
                connect(table_.get(), &Table::Logout, this, &MainWindow::on_logout_clicked);
                setCentralWidget(table_.get());
                ui->stackedWidget->setCurrentWidget(ui->main);
            }
            else{
                QMessageBox::critical(this, "Authorization", "Incorrect login or password entry");
            }
        }
        else {
            QMessageBox::critical(this, "Authorization", "No data found for the given email.");
        }
    }
    else {
        QMessageBox::critical(this, "Error", "Error executing query:" + queryResult.toString());
    }
}

void MainWindow::on_logout_clicked() {
    user_.reset();
    // ui->label_username->clear();
    ui->stackedWidget->setCurrentWidget(ui->login);
}

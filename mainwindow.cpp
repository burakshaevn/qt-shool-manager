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
}

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

                table_ = std::make_unique<Table>(&db_manager_, nullptr);
                connect(table_.get(), &Table::Logout, this, &MainWindow::on_logout_clicked);
                ui->stackedWidget->addWidget(table_.get());
                ui->stackedWidget->setCurrentWidget(table_.get());
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
    if (!this->ui->stackedWidget) {
        qWarning() << "stackedWidget is null!";
        return;
    }

    user_.reset();
    this->ui->stackedWidget->setCurrentWidget(this->ui->login);
}



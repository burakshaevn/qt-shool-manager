#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QMessageBox>

#include "database_manager.h"
#include "user.h"
#include "table.h"

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    void UpdateUser(const UserInfo& user, QWidget* parent);

    // void SetupTable();
    // void LoadTable(const QString& table_name);
    // void SetupActions(const QString& table_name, QSqlTableModel* model);

private slots:
    void on_pushButton_login_clicked();

    void on_logout_clicked();

private:
    Ui::MainWindow *ui;

    DatabaseManager db_manager_;
    std::unique_ptr<User> user_;
    std::unique_ptr<Table> table_;
};
#endif // MAINWINDOW_H

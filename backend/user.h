#ifndef USER_H
#define USER_H

#include <QMainWindow>
#include "domain.h"

struct UserInfo {
    UserInfo()
        : id_(0)
        , first_name_(QString())
        , last_name_(QString())
        , email_(QString())
        , password_(QString())
        , role_(Role::Guest)
    {}
    UserInfo(const int id, const QString& first_name, const QString& last_name, const QString& email, const QString& password, const Role& role)
        : id_(id)
        , first_name_(first_name)
        , last_name_(last_name)
        , email_(email)
        , password_(password)
        , role_(role)
    {}
    int id_;
    QString first_name_;
    QString last_name_;
    QString email_;
    QString password_;
    Role role_;
};

class User : public QMainWindow
{
    Q_OBJECT
public:
    explicit User(const UserInfo& user, QWidget *parent = nullptr)
        : user_(user)
        , QMainWindow(parent)
    {}

    virtual ~User() = default;

    void SetId(const int id){
        user_.id_ = id;
    }
    inline int GetId() const {
        return user_.id_;
    }

    void SetFirstName(const QString& first_name){
        user_.first_name_ = first_name;
    }
    inline const QString& GetFirstName() const {
        return user_.first_name_;
    }
    void SetLastName(const QString& last_name){
        user_.last_name_ = last_name;
    }
    inline const QString& GetLastName() const {
        return user_.last_name_;
    }

    void SetEmail(const QString& email){
        user_.email_ = email;
    }
    inline const QString& GetEmail() const {
        return user_.email_;
    }

    virtual void SetRole(const Role& role){
        user_.role_ = role;
    }
    inline virtual const Role& GetRole() const{
        return user_.role_;
    }

protected:
    UserInfo user_;

signals:
};

#endif // USER_H

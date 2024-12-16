#ifndef DOMAIN_H
#define DOMAIN_H

#include <QString>

enum class Role {
    Guest,
    Teacher,
    Director,
    Student
};

enum class Tables {
    unknown,
    classes,
    lessons,
    rooms,
    schedule,
    students,
    subjects,
    teachers
};

inline Tables StringToTables(const QString& table){
    if (table == "classes"){
        return Tables::classes;
    }
    else if (table == "lessons"){
        return Tables::lessons;
    }
    else if (table == "rooms"){
        return Tables::rooms;
    }
    else if (table == "schedule"){
        return Tables::schedule;
    }
    else if (table == "students"){
        return Tables::students;
    }
    else if (table == "subjects"){
        return Tables::subjects;
    }
    else if (table == "teachers"){
        return Tables::teachers;
    }
    else{
        return Tables::unknown;
    }
}

inline QString TablesToString(const Tables& table){
    switch(table){
        case Tables::classes:
            return "classes";
        case Tables::lessons:
            return "lessons";
        case Tables::rooms:
            return "rooms";
        case Tables::schedule:
            return "schedule";
        case Tables::students:
            return "students";
        case Tables::subjects:
            return "subjects";
        case Tables::teachers:
            return "teachers";
        default:
            return "unknown";
    }
}

inline Role IsTeacherOrDirector(const QString& role){
    if (role.toLower() == "director" || role.toLower() == "директор"){
        return Role::Director;
    }
    else {
        return Role::Teacher;
    }
}

#endif // DOMAIN_H

#ifndef CALENDAR_H
#define CALENDAR_H

#include <QDebug>
#include <QObject>

class Calendar : public QObject
{
public:
    Calendar(QObject *parent = 0) : QObject(parent) {}
    ~Calendar() {}

private:
    Q_OBJECT
};

#endif // CALENDAR_H

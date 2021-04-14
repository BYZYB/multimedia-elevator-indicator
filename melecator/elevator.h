#ifndef ELEVATOR_H
#define ELEVATOR_H

#include <QObject>

#ifndef QT_NO_DEBUG
#include <QDebug>
#endif

class Elevator : public QObject {
public:
    Elevator(QObject *parent = nullptr) : QObject(parent) {}

private:
    Q_OBJECT
};

#endif // ELEVATOR_H

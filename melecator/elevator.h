#ifndef ELEVATOR_H
#define ELEVATOR_H

#include <QObject>

class Elevator : public QObject {
public:
    Elevator(QObject *parent = nullptr) : QObject(parent) {}

private:
    Q_OBJECT
};

#endif // ELEVATOR_H

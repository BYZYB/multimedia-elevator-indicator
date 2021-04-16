#ifndef ELEVATOR_H
#define ELEVATOR_H

#include <QDateTime>
#include <QObject>
#include <QRandomGenerator>
#include <QTimer>

#ifndef QT_NO_DEBUG
#include <QDebug>
#endif

#define DEFAULT_MAX_FLOOR 12
#define DEFAULT_MAX_STOP 6
#define DEFAULT_TIME_DOOR_MOVE 3
#define DEFAULT_TIME_NEXT_FLOOR 3
#define DEFAULT_TIME_STOP 10
#define DIRECTION_DOWN 1
#define DIRECTION_STOP 0
#define DIRECTION_UP 2

class Elevator : public QObject {
public:
    Elevator(QObject *parent = nullptr) : QObject(parent) {
        timer = new QTimer(this);
        connect(timer, SIGNAL(timeout()), this, SLOT(process()));
    }
    Q_INVOKABLE static inline qreal get_capacity() { return capacity * 100; }
    Q_INVOKABLE static inline quint8 get_direction() { return direction; }
    Q_INVOKABLE static inline quint32 get_floor() { return floor; }
    Q_INVOKABLE QString get_next_stop();
    Q_INVOKABLE static inline qreal get_progress() { return progress; }
    Q_INVOKABLE static inline quint32 get_remain_time() { return remain_time; }

public slots:
    void add_next_stop_down(const quint32 &next_stop);
    void add_next_stop_up(const quint32 &next_stop);
    void door_close();
    void door_open();
    inline void start(const quint32 &max_floor = DEFAULT_MAX_FLOOR, const quint32 &max_stop = DEFAULT_MAX_STOP, const quint32 &time_door_move = DEFAULT_TIME_DOOR_MOVE, const quint32 &time_next_floor = DEFAULT_TIME_NEXT_FLOOR, const quint32 &time_stop = DEFAULT_TIME_STOP) {
        capacity = direction = floor = progress = remain_time = slice = 0;
        Elevator::max_floor = max_floor;
        Elevator::max_stop = max_stop;
        Elevator::time_door_move = time_door_move;
        Elevator::time_next_floor = time_next_floor;
        Elevator::time_stop = time_stop;
        is_next_stop = QVector<bool>(max_floor);
        timer->start(1000);
#ifndef QT_NO_DEBUG
        qDebug() << "[D] Elevator emulation process started.";
#endif
        emit elevatorStart();
    }

private:
    Q_OBJECT
    static qreal capacity, progress;
    static quint8 direction, slice;
    static quint32 floor, max_floor, max_stop, remain_time, time_door_move, time_next_floor, time_stop;
    static QTimer *timer;
    QVector<bool> is_next_stop;

private slots:
    void process();

signals:
    void elevatorCapacityUpdate();
    void elevatorDirectionUpate();
    void elevatorDoorClose();
    void elevatorDoorOpen();
    void elevatorFloorUpdate();
    void elevatorNextStopUpdate();
    void elevatorStart();
};

#endif // ELEVATOR_H

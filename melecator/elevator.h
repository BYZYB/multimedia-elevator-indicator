#ifndef ELEVATOR_H
#define ELEVATOR_H

#include <QDateTime>
#include <QObject>
#include <QRandomGenerator>
#include <QTimer>

#ifndef QT_NO_DEBUG
#include <QDebug>
#endif

#define DEFAULT_FLOOR 1
#define DEFAULT_MAX_FLOOR 12
#define DEFAULT_MIN_FLOOR 1
#define DEFAULT_TIME_DOOR_MOVE 3
#define DEFAULT_TIME_NEXT_FLOOR 3
#define DEFAULT_TIME_STOP 5
#define DIRECTION_DOWN 1
#define DIRECTION_STOP 0
#define DIRECTION_UP 2
#define SIDE_LEFT 0
#define SIDE_RIGHT 1

class Elevator : public QObject {
public:
    Elevator(QObject *parent = nullptr) : QObject(parent) {
        timer = new QTimer(this);
        connect(timer, SIGNAL(timeout()), this, SLOT(process()));
    }
    Q_INVOKABLE static inline quint8 get_capacity() { return capacity; }
    Q_INVOKABLE static inline quint8 get_direction() { return direction; }
    Q_INVOKABLE static inline quint8 get_direction_current() { return direction_current; }
    Q_INVOKABLE static inline qint32 get_floor() { return floor; }
    Q_INVOKABLE inline bool get_is_next_stop_down(const qint32 &floor) { return is_next_stop_down.at(floor); }
    Q_INVOKABLE inline bool get_is_next_stop_up(const qint32 &floor) { return is_next_stop_up.at(floor); }
    Q_INVOKABLE QString get_next_stop_down();
    Q_INVOKABLE QString get_next_stop_up();
    Q_INVOKABLE static inline qreal get_progress() { return progress == 0 ? 1.0 : 1.0 / progress; }
    Q_INVOKABLE static inline qint32 get_time_remain() { return time_remain; }

public slots:
    inline void start(const qint32 &floor_max = DEFAULT_MAX_FLOOR, const qint32 &floor_min = DEFAULT_MIN_FLOOR, const quint8 &side = SIDE_LEFT, const quint32 &time_door_move = DEFAULT_TIME_DOOR_MOVE, const quint32 &time_next_floor = DEFAULT_TIME_NEXT_FLOOR, const quint32 &time_stop = DEFAULT_TIME_STOP) {
        capacity = progress = slice = time_remain = 0;
        direction = direction_current = DIRECTION_STOP;
        floor = floor_last = floor_min > 0 ? floor_min : DEFAULT_FLOOR;
        Elevator::floor_max = floor_max;
        Elevator::floor_min = floor_last = floor_min;
        Elevator::side = side;
        Elevator::time_door_move = time_door_move;
        Elevator::time_next_floor = time_next_floor;
        Elevator::time_stop = time_stop;
        is_next_stop_down = is_next_stop_up = QVector<bool>(floor_max - (floor_min > 0 ? 0 : floor_min) + 1);
        timer->start(1000);
        emit elevatorStart();
    }
    void update_next_stop_down(const qint32 &next_stop);
    void update_next_stop_up(const qint32 &next_stop);

private:
    Q_OBJECT
    static quint8 capacity, direction, direction_current, progress, side;
    static qint32 floor, floor_last, floor_max, floor_min, time_remain;
    static bool is_door_open, is_passive_up;
    static quint32 slice, time_door_move, time_next_floor, time_stop;
    static QTimer *timer;
    QVector<bool> is_next_stop_down, is_next_stop_up;

private slots:
    void process();

signals:
    void elevatorDirectionUpdate();
    void elevatorDoorClose();
    void elevatorDoorOpen();
    void elevatorFloorUpdate();
    void elevatorNextStopUpdate();
    void elevatorTimeRemainUpdate();
    void elevatorStart();
};

#endif // ELEVATOR_H

#ifndef EMULATOR_H
#define EMULATOR_H

#include "elevator.h"
#include <QRandomGenerator>
#include <QTimer>

#define DEFAULT_FLOOR 1
#define DEFAULT_FLOOR_MAX 12
#define DEFAULT_FLOOR_MIN 1
#define DEFAULT_TIME_DOOR_MOVE 3
#define DEFAULT_TIME_NEXT_FLOOR 3
#define DEFAULT_TIME_STOP 5
#define DIRECTION_DOWN 1
#define DIRECTION_STOP 0
#define DIRECTION_UP 2

class Emulator : public Elevator {
public:
    Emulator() {
        timer = new QTimer(this);
        connect(timer, &QTimer::timeout, this, &Emulator::elevator_process);
    }
    ~Emulator() { timer->deleteLater(); }
    Q_INVOKABLE inline bool get_is_next_stop_down(const qint32 &floor) { return is_next_stop_down.at(floor); }
    Q_INVOKABLE inline bool get_is_next_stop_up(const qint32 &floor) { return is_next_stop_up.at(floor); }
    Q_INVOKABLE QString get_next_stop_down();
    Q_INVOKABLE QString get_next_stop_up();

public slots:
    inline void elevator_init(const quint32 &floor_max = DEFAULT_FLOOR_MAX, const quint32 &floor_min = DEFAULT_FLOOR_MIN, const quint32 &time_door_move = DEFAULT_TIME_DOOR_MOVE, const quint32 &time_next_floor = DEFAULT_TIME_NEXT_FLOOR, const quint32 &time_stop = DEFAULT_TIME_STOP) {
        timer->stop();
        capacity = progress = slice = time_remain = 0;
        direction_current = DIRECTION_STOP;
        direction_planned = DIRECTION_UP;
        floor_current = Emulator::floor_min = floor_min;
        Emulator::floor_max = floor_max;
        is_door_open = is_passive = false;
        is_next_stop_down = is_next_stop_up = QVector<bool>(floor_max + 1);
        Emulator::time_door_move = time_door_move;
        Emulator::time_next_floor = time_next_floor;
        Emulator::time_stop = time_stop;
        timer->start(1000);
        emit elevatorStart();
    }
    void update_next_stop_down(const qint32 &next_stop);
    void update_next_stop_up(const qint32 &next_stop);

private:
    static bool is_door_open, is_passive;
    static quint32 slice;
    QVector<bool> is_next_stop_down, is_next_stop_up;
    QTimer *timer;
    Q_OBJECT

private slots:
    void elevator_process();
};

#endif // EMULATOR_H

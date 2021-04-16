#include "elevator.h"

qreal Elevator::capacity, Elevator::progress;
quint8 Elevator::direction, Elevator::slice;
quint32 Elevator::floor, Elevator::max_floor, Elevator::max_stop, Elevator::remain_time, Elevator::time_door_move, Elevator::time_next_floor, Elevator::time_stop;
QTimer *Elevator::timer;

void Elevator::add_next_stop_down(const quint32 &next_stop) {}

void Elevator::add_next_stop_up(const quint32 &next_stop) {}

void Elevator::door_close() {}

void Elevator::door_open() {}

// Get the list of next stops that merged into one string
QString Elevator::get_next_stop() {
    QString next_stop;

    // Generate the list of next stops in a specific direction (down or up)
    switch (direction) {
    case DIRECTION_DOWN:
        for (quint32 i = max_floor; i > 1; --i) { // The elevator is going down, use descending order
            if (is_next_stop.at(i)) {
                next_stop.append(i);
                next_stop.append(" … ");
            }
        }

        if (is_next_stop.at(1)) { // No need to add "…" to the last item (exactly, the first item of is_next_stop)
            next_stop.append(1);
        }

        break;

    case DIRECTION_UP:
        for (quint32 i = 1; i < max_floor; ++i) { // The elevator is going up, use ascending order
            if (is_next_stop.at(i)) {
                next_stop.append(i);
                next_stop.append(" … ");
            }
        }

        if (is_next_stop.at(max_floor)) { // No need to add "…" to the last item
            next_stop.append(max_floor);
        }

        break;
    }

    return next_stop;
}

// The main function of elevator emulation process
void Elevator::process() {
#ifndef QT_NO_DEBUG
    qDebug() << "[D] Elevator process begin";
#endif

    /* TODO... */

#ifndef QT_NO_DEBUG
    qDebug() << "[D] Elevator process end";
#endif
}

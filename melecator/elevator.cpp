#include "elevator.h"

quint8 Elevator::capacity, Elevator::direction, Elevator::direction_current, Elevator::progress, Elevator::side;
qint32 Elevator::floor, Elevator::floor_last, Elevator::floor_max, Elevator::floor_min, Elevator::time_remain;
bool Elevator::is_door_open, Elevator::is_passive_up;
quint32 Elevator::slice, Elevator::time_door_move, Elevator::time_next_floor, Elevator::time_stop;
QTimer *Elevator::timer;

// Get the list of next stops (direction down) that merged into one string
QString Elevator::get_next_stop_down() {
    QString next_stop;

    for (auto i = floor_max; i >= 1; --i) {
        if (is_next_stop_down.at(i)) {
            next_stop.append(QString::number(i) + " … ");
        }
    }

    is_next_stop_down[0] = next_stop.isEmpty() ? false : true;
    return next_stop;
}

// Get the list of next stops (direction up) that merged into one string
QString Elevator::get_next_stop_up() {
    QString next_stop;

    for (auto i = 1; i <= floor_max; ++i) {
        if (is_next_stop_up.at(i)) {
            next_stop.append(QString::number(i) + " … ");
        }
    }

    is_next_stop_up[0] = next_stop.isEmpty() ? false : true;
    return next_stop;
}

// The entrance function of elevator emulation process
void Elevator::process() {
    switch (direction_current) {
    case DIRECTION_STOP:
        if (is_door_open) {
            if (slice < time_door_move) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator has stopped while opening door at floor: " << floor << ", slice:" << slice;
#endif
                ++slice;
                time_remain <= 0 ? time_remain = 0 : --time_remain;
                emit elevatorDoorOpen();
                emit elevatorTimeRemainUpdate();
            } else if (slice < time_door_move + time_stop) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator has stopped while waiting for the next start at floor: " << floor << ", slice:" << slice;
#endif
                ++slice;
                time_remain <= 0 ? time_remain = 0 : --time_remain;
                emit elevatorDirectionUpdate();
                emit elevatorTimeRemainUpdate();
            } else if (slice < 2 * time_door_move + time_stop) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator has stopped while closing door at floor: " << floor << ", slice:" << slice;
#endif
                ++slice;
                time_remain <= 0 ? time_remain = 0 : --time_remain;
                emit elevatorDoorClose();
                emit elevatorTimeRemainUpdate();
            } else {
                if (direction == DIRECTION_DOWN) {
                    if (floor == floor_min) {
                        capacity = progress = slice = 0;
                        direction = DIRECTION_UP;
                        direction_current = DIRECTION_STOP;
                        floor_last = floor;
                        is_door_open = is_next_stop_down[floor] = false;
                        emit elevatorDirectionUpdate();
                        emit elevatorNextStopUpdate();
                        break;
                    } else {
                        direction_current = direction;
                    }

                    is_door_open = is_next_stop_down[floor] = false;
                } else if (direction == DIRECTION_UP) {
                    if (floor == floor_max) {
                        direction = direction_current = DIRECTION_DOWN;
                    } else {
                        direction_current = direction;
                    }

                    is_door_open = is_next_stop_up[floor] = false;
                }

                slice = 0;
                capacity = 5 * QRandomGenerator::global()->bounded(20);
                floor_last = floor;
                --progress;
                emit elevatorDirectionUpdate();
                emit elevatorDoorClose();
                emit elevatorNextStopUpdate();
            }
        } else {
#ifndef QT_NO_DEBUG
            qDebug() << "[D] Elevator has stopped at floor: " << floor << ", slice:" << slice;
#endif
        }
        break;

    case DIRECTION_DOWN:
        if (is_next_stop_down.at(0)) {
            if (slice < time_next_floor - 1) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator is going down to next floor, slice:" << slice;
#endif
                ++slice;
                --time_remain;
                emit elevatorTimeRemainUpdate();
            } else {
                if (is_next_stop_down.at(floor)) {
#ifndef QT_NO_DEBUG
                    qDebug() << "[D] Elevator (down) has arrived at target floor: " << floor << ", slice:" << slice;
#endif
                    slice = 0;
                    direction = direction_current;
                    direction_current = DIRECTION_STOP;
                    is_door_open = true;
                    --progress;
                    --time_remain;
                    emit elevatorDirectionUpdate();
                    emit elevatorDoorOpen();
                    emit elevatorTimeRemainUpdate();
                } else {
#ifndef QT_NO_DEBUG
                    qDebug() << "[D] Elevator (down) has arrived at next floor: " << floor << ", slice:" << slice;
#endif
                    --floor;
                    slice = 0;
                    --time_remain;
                    emit elevatorFloorUpdate();
                    emit elevatorTimeRemainUpdate();
                }
            }
        } else {
#ifndef QT_NO_DEBUG
            qDebug() << "[D] No next stop (down) left, going down back to default floor: " << DEFAULT_FLOOR << ", current floor:" << floor;
#endif
            direction = direction_current = DIRECTION_DOWN;
            update_next_stop_down(DEFAULT_FLOOR);
            emit elevatorDirectionUpdate();
        }
        break;

    case DIRECTION_UP:
        if (is_next_stop_up.at(0)) {
            if (slice < time_next_floor - 1) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator is going up to next floor, slice:" << slice;
#endif
            ++slice;
            --time_remain;
            emit elevatorTimeRemainUpdate();
            } else {
                if (is_next_stop_up.at(floor)) {
                    if (is_passive_up) {
#ifndef QT_NO_DEBUG
                        qDebug() << "[D] Elevator (up) has arrived at target floor: " << floor << ", passive:" << is_passive_up << ", slice:" << slice;
#endif
                        direction = DIRECTION_DOWN;
                        is_next_stop_up[floor] = false;
                        is_passive_up = false;
                        emit elevatorNextStopUpdate();
                    } else {
#ifndef QT_NO_DEBUG
                        qDebug() << "[D] Elevator (up) has arrived at target floor: " << floor << ", slice:" << slice;
#endif
                        direction = direction_current;
                    }

                    slice = 0;
                    direction_current = DIRECTION_STOP;
                    is_door_open = true;
                    --progress;
                    --time_remain;
                    emit elevatorDirectionUpdate();
                    emit elevatorDoorOpen();
                    emit elevatorTimeRemainUpdate();
                } else {
#ifndef QT_NO_DEBUG
                    qDebug() << "[D] Elevator (up) has arrived at next floor: " << floor << ", slice:" << slice;
#endif
                    ++floor;
                    slice = 0;
                    --time_remain;
                    emit elevatorFloorUpdate();
                    emit elevatorTimeRemainUpdate();
                }
            }
        } else {
#ifndef QT_NO_DEBUG
            qDebug() << "[D] No next stop (up) left, going down back to default floor: " << DEFAULT_FLOOR << ", current floor:" << floor;
#endif
            direction = direction_current = DIRECTION_DOWN;
            update_next_stop_down(DEFAULT_FLOOR);
            emit elevatorDirectionUpdate();
        }
        break;
    }
}

// Update the status and check if the elevator should stop at the next stop (direction down)
void Elevator::update_next_stop_down(const qint32 &next_stop) {
    if (is_next_stop_down.at(next_stop)) {
        floor_last = floor;
        is_next_stop_down[next_stop] = false;
        --progress;
        time_remain <= 0 ? time_remain = 0 : time_remain -= time_next_floor * (1 + floor_last - next_stop) + 2 * time_door_move + time_stop;
    } else {
        is_next_stop_down[next_stop] = true;
        progress += 2;
        time_remain += time_next_floor * (floor_last - next_stop - 1) + 2 * time_door_move + time_stop;
        floor_last = next_stop;
    }

    if (direction_current == DIRECTION_STOP && !is_door_open) {
        if (floor > next_stop) {
            direction = direction_current = DIRECTION_DOWN;
        } else if (floor < next_stop) {
            direction = direction_current = DIRECTION_UP;
            is_passive_up = true;
            update_next_stop_up(next_stop);
        }

        emit elevatorDirectionUpdate();
    }

#ifndef QT_NO_DEBUG
    qDebug() << "[D] Updated next stop (down) at floor:" << next_stop << ", stauts:" << is_next_stop_down.at(next_stop) << ", direction:" << direction_current;
#endif
    emit elevatorNextStopUpdate();
    emit elevatorTimeRemainUpdate();
}

// Update the status and check if the elevator should stop at the next stop (direction up)
void Elevator::update_next_stop_up(const qint32 &next_stop) {
    if (is_next_stop_up.at(next_stop)) {
        floor_last = floor;
        is_next_stop_up[next_stop] = false;
        --progress;
        time_remain <= 0 ? time_remain = 0 : time_remain -= time_next_floor * (1 + next_stop - floor_last) + 2 * time_door_move + time_stop;
    } else {
        is_next_stop_up[next_stop] = true;
        progress += 2;
        time_remain += time_next_floor * (1 + next_stop - floor_last) + 2 * time_door_move + time_stop;
        floor_last = next_stop;
    }

    if (direction_current == DIRECTION_STOP && !is_door_open) {
        if (floor < next_stop) {
            direction = direction_current = DIRECTION_UP;
        } else if (floor > next_stop) {
            direction = direction_current = DIRECTION_DOWN;
        }

        emit elevatorDirectionUpdate();
    }

#ifndef QT_NO_DEBUG
    qDebug() << "[D] Updated next stop (up) at floor:" << next_stop << ", stauts:" << is_next_stop_up.at(next_stop) << ", direction:" << direction_current;
#endif
    emit elevatorNextStopUpdate();
    emit elevatorTimeRemainUpdate();
}

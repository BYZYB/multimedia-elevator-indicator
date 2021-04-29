#include "elevator.h"

quint8 Elevator::capacity, Elevator::direction_current, Elevator::direction_planned, Elevator::progress;
qint32 Elevator::floor_current, Elevator::floor_max, Elevator::floor_min, Elevator::time_remain;
bool Elevator::is_door_open, Elevator::is_passive;
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
                qDebug() << "[D] Elevator has stopped while opening door at floor: " << floor_current << ", slice:" << slice;
#endif
                if (slice == 0) {
                    emit elevatorDoorOpen();
                }

                ++slice;
                time_remain <= 0 ? time_remain = 0 : --time_remain;
                emit elevatorTimeRemainUpdate();
            } else if (slice < time_door_move + time_stop) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator has stopped while waiting for the next start at floor: " << floor_current << ", slice:" << slice;
#endif
                ++slice;
                time_remain <= 0 ? time_remain = 0 : --time_remain;
                emit elevatorDirectionUpdate();
                emit elevatorTimeRemainUpdate();
            } else if (slice < 2 * time_door_move + time_stop) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator has stopped while closing door at floor: " << floor_current << ", slice:" << slice;
#endif
                if (slice == time_door_move + time_stop) {
                    emit elevatorDoorClose();
                }

                ++slice;
                time_remain <= 0 ? time_remain = 0 : --time_remain;
                emit elevatorTimeRemainUpdate();
            } else {
                if (direction_planned == DIRECTION_DOWN) {
                    if (floor_current == floor_min) {
                        capacity = progress = slice = time_remain = 0;
                        direction_planned = DIRECTION_UP;
                        direction_current = DIRECTION_STOP;
                        is_door_open = is_next_stop_down[floor_current] = false;
                        emit elevatorCapacityUpdate();
                        emit elevatorDoorClose();
                        emit elevatorDirectionUpdate();
                        emit elevatorNextStopUpdate();
                        emit elevatorTimeRemainUpdate();
                        break;
                    } else {
                        direction_current = direction_planned;
                    }

                    is_door_open = is_next_stop_down[floor_current] = false;
                } else if (direction_planned == DIRECTION_UP) {
                    if (floor_current == floor_max) {
                        direction_planned = direction_current = DIRECTION_DOWN;
                    } else {
                        direction_current = direction_planned;
                    }

                    is_door_open = is_next_stop_up[floor_current] = false;
                }

                capacity = 5 * QRandomGenerator::global()->bounded(20);
                --progress;
                slice = 0;
                time_remain <= 0 ? time_remain = 0 : --time_remain;
                emit elevatorCapacityUpdate();
                emit elevatorDirectionUpdate();
                emit elevatorNextStopUpdate();
                emit elevatorTimeRemainUpdate();
            }
        } else {
#ifndef QT_NO_DEBUG
            qDebug() << "[D] Elevator has stopped at floor: " << floor_current << ", direction:" << direction_current << ", slice:" << slice;
#endif
        }
        break;

    case DIRECTION_DOWN:
        if (is_next_stop_down.at(0)) {
            if (floor_current == floor_min && !is_next_stop_down.at(floor_min)) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator has reached min floor, going up back to max floor: " << floor_max << ", current floor:" << floor_current;
#endif
                direction_planned = direction_current = DIRECTION_UP;
                update_next_stop_up(floor_max);
                emit elevatorDirectionUpdate();
            } else if (slice < time_next_floor - 1) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator is going down to next floor, slice:" << slice;
#endif
                ++slice;
                --time_remain;
                emit elevatorTimeRemainUpdate();
            } else {
                if (is_next_stop_down.at(floor_current)) {
#ifndef QT_NO_DEBUG
                    qDebug() << "[D] Elevator (down) has arrived at target floor: " << floor_current << ", slice:" << slice;
#endif
                    direction_current = DIRECTION_STOP;
                    direction_planned = DIRECTION_DOWN;
                    is_door_open = true;
                    --progress;
                    slice = 0;
                    --time_remain;
                    emit elevatorDirectionUpdate();
                    emit elevatorTimeRemainUpdate();
                } else {
#ifndef QT_NO_DEBUG
                    qDebug() << "[D] Elevator (down) has arrived at next floor: " << floor_current << ", slice:" << slice;
#endif
                    --floor_current;
                    slice = 0;
                    --time_remain;
                    emit elevatorFloorUpdate();
                    emit elevatorTimeRemainUpdate();
                }
            }
        } else {
#ifndef QT_NO_DEBUG
            qDebug() << "[D] No next stop (down) left, going down back to default floor: " << DEFAULT_FLOOR << ", current floor:" << floor_current;
#endif
            direction_planned = direction_current = DIRECTION_DOWN;
            update_next_stop_down(DEFAULT_FLOOR);
            emit elevatorDirectionUpdate();
        }
        break;

    case DIRECTION_UP:
        if (is_next_stop_up.at(0)) {
            if (floor_current == floor_max && !is_next_stop_down.at(floor_max)) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator has reached max floor, going down back to min floor: " << floor_min << ", current floor:" << floor_current;
#endif
                direction_planned = direction_current = DIRECTION_DOWN;
                update_next_stop_down(floor_min);
                emit elevatorDirectionUpdate();
            } else if (slice < time_next_floor - 1) {
#ifndef QT_NO_DEBUG
                qDebug() << "[D] Elevator is going up to next floor, slice:" << slice;
#endif
            ++slice;
            --time_remain;
            emit elevatorTimeRemainUpdate();
            } else {
                if (is_next_stop_up.at(floor_current)) {
                    if (is_passive) {
#ifndef QT_NO_DEBUG
                        qDebug() << "[D] Elevator (up) has arrived at target floor: " << floor_current << ", passive:" << is_passive << ", slice:" << slice;
#endif
                        direction_planned = DIRECTION_DOWN;
                        is_next_stop_up[floor_current] = false;
                        is_passive = false;
                        emit elevatorNextStopUpdate();
                    } else {
#ifndef QT_NO_DEBUG
                        qDebug() << "[D] Elevator (up) has arrived at target floor: " << floor_current << ", slice:" << slice;
#endif
                        direction_planned = direction_current;
                    }

                    direction_current = DIRECTION_STOP;
                    is_door_open = true;
                    --progress;
                    slice = 0;
                    --time_remain;
                    emit elevatorDirectionUpdate();
                    emit elevatorTimeRemainUpdate();
                } else {
#ifndef QT_NO_DEBUG
                    qDebug() << "[D] Elevator (up) has arrived at next floor: " << floor_current << ", slice:" << slice;
#endif
                    ++floor_current;
                    slice = 0;
                    --time_remain;
                    emit elevatorFloorUpdate();
                    emit elevatorTimeRemainUpdate();
                }
            }
        } else {
#ifndef QT_NO_DEBUG
            qDebug() << "[D] No next stop (up) left, going down back to default floor: " << DEFAULT_FLOOR << ", current floor:" << floor_current;
#endif
            direction_planned = direction_current = DIRECTION_DOWN;
            update_next_stop_down(DEFAULT_FLOOR);
            emit elevatorDirectionUpdate();
        }
        break;
    }
}

// Update the status and check if the elevator should stop at the next stop (direction down)
void Elevator::update_next_stop_down(const qint32 &next_stop) {
    if (is_next_stop_down.at(next_stop)) {
        is_next_stop_down[next_stop] = false;
        progress -= 2;
        time_remain -= time_next_floor * (1 + floor_current - next_stop) + 2 * time_door_move + time_stop;
    } else {
        is_next_stop_down[next_stop] = true;
        progress += 2;
        time_remain += time_next_floor * (1 + floor_current - next_stop) + 2 * time_door_move + time_stop;
    }

    if (direction_current == DIRECTION_STOP && !is_door_open) {
        if (floor_current > next_stop) {
            direction_planned = direction_current = DIRECTION_DOWN;
        } else if (floor_current < next_stop) {
            direction_planned = direction_current = DIRECTION_UP;
            is_passive = true;
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
        is_next_stop_up[next_stop] = false;
        progress -= 2;
        time_remain -= time_next_floor * (1 + next_stop - floor_current) + 2 * time_door_move + time_stop;
    } else {
        is_next_stop_up[next_stop] = true;
        progress += 2;
        time_remain += time_next_floor * (1 + next_stop - floor_current) + 2 * time_door_move + time_stop;
    }

    if (direction_current == DIRECTION_STOP && !is_door_open) {
        if (floor_current < next_stop) {
            direction_planned = direction_current = DIRECTION_UP;
        } else if (floor_current > next_stop) {
            direction_planned = direction_current = DIRECTION_DOWN;
        }

        emit elevatorDirectionUpdate();
    }

#ifndef QT_NO_DEBUG
    qDebug() << "[D] Updated next stop (up) at floor:" << next_stop << ", stauts:" << is_next_stop_up.at(next_stop) << ", direction:" << direction_current;
#endif
    emit elevatorNextStopUpdate();
    emit elevatorTimeRemainUpdate();
}

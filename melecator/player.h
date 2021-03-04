#ifndef PLAYER_H
#define PLAYER_H

#include <QDebug>
#include <QFile>
#include <QObject>
#include <QRegularExpression>

#define VIDEO_PATH "/../../test_data/notifications.txt"

class Player : public QObject {
    Q_OBJECT

  public:
    Player(QObject *parent = 0) : QObject(parent) {}
    ~Player() {}

  private:
};

#endif // PLAYER_H

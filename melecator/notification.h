#ifndef NOTIFICATION_H
#define NOTIFICATION_H
#define NOTIFICATION_PATH "D:/Temp/multimedia-elevator-indicator/melecator/data/notifications.txt"

#include <QFile>
#include <QObject>
#include <QRegularExpression>

class Notification : public QObject {
    Q_OBJECT

  public:
    Notification(QObject *parent = 0) : QObject(parent) { read_notification(); }
    ~Notification() {}
    Q_INVOKABLE QString get_notification();

  private:
    QStringList list;
    void read_notification();
};

#endif // NOTIFICATION_H

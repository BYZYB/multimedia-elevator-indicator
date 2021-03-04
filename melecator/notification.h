#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include <QDebug>
#include <QFile>
#include <QObject>
#include <QRegularExpression>

#define NOTIFICATION_PATH "/../../test_data/notifications.txt"

class Notification : public QObject {
    Q_OBJECT

  public:
    Notification(const QString &path, QObject *parent = 0) : QObject(parent) { read_notification(path); }
    ~Notification() {}
    Q_INVOKABLE QString get_merged_notification();

  private:
    QStringList list;
    void read_notification(const QString &path);
};

#endif // NOTIFICATION_H

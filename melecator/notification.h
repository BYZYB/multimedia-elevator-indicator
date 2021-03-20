#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QObject>

#define NOTIFICATION_PATH "/../../test_data/notifications/"

class Notification : public QObject {
public:
    Notification(const QString &path, QObject *parent = 0) : QObject(parent) { read_notification_file(path + NOTIFICATION_PATH); }
    ~Notification() {}
    Q_INVOKABLE QString get_merged_notification();
    Q_INVOKABLE QString get_notification(const qint32 &index, const qint32 &type);
    Q_INVOKABLE inline qint32 get_notification_amount() { return notifications.size(); }

private:
    Q_OBJECT
    QMap<QString, QString> notifications;
    void read_notification_file(const QString &path);
};

#endif // NOTIFICATION_H

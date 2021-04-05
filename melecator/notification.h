#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QObject>

#ifdef Q_OS_WIN
#define PATH_NOTIFICATION "/../../test_data/notifications/"
#else
#define PATH_NOTIFICATION "/../test_data/notifications/"
#endif

class Notification : public QObject {
public:
    Notification(const QString &path, QObject *parent = 0) : QObject(parent), path(path + PATH_NOTIFICATION) {}
    ~Notification() {}
    Q_INVOKABLE QString get_notification(const qint32 &type, const qint32 &index);
    Q_INVOKABLE inline qint32 get_notification_amount() { return notification_data.size(); }
    Q_INVOKABLE QString get_notification_merged();
    Q_INVOKABLE void read_notification_file();

private:
    Q_OBJECT
    QMap<QString, QString> notification_data;
    QString path;
};

#endif // NOTIFICATION_H

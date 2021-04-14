#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include <QDir>
#include <QFile>
#include <QMap>
#include <QObject>

#ifndef QT_NO_DEBUG
#include <QDebug>
#endif

#ifdef Q_OS_WIN
#define PATH_NOTIFICATION "/../../test_data/notifications/"
#else
#define PATH_NOTIFICATION "/../test_data/notifications/"
#endif

class Notification : public QObject {
public:
    Notification(const QString &path, QObject *parent = nullptr) : QObject(parent), path(path + PATH_NOTIFICATION) {}
    Q_INVOKABLE QString get_notification(const bool &is_content, const qint32 &index);
    Q_INVOKABLE static inline qint32 get_notification_amount() { return notification_data.size(); }
    Q_INVOKABLE QString get_notification_merged();
    Q_INVOKABLE void read_notification_file();

private:
    Q_OBJECT
    static QMap<QString, QString> notification_data;
    const QString path;

signals:
    void notificationAvailable();
    void notificationUnavailable();
};

#endif // NOTIFICATION_H

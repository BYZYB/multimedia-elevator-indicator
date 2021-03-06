#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QObject>

#define NOTIFICATION_PATH "/../../test_data/notification/"

class Notification : public QObject {
  public:
    Notification(const QString &path, QObject *parent = 0) : QObject(parent) { read_notification(path + NOTIFICATION_PATH); }
    ~Notification() {}
    Q_INVOKABLE QString get_all_notification();
    Q_INVOKABLE QString get_notification(const qint32 &index, const qint32 &type);
    Q_INVOKABLE inline qint32 get_notification_index() { return notification_list.size(); }

  private:
    Q_OBJECT
    QMap<QString, QString> notification_list;
    void read_notification(const QString &path);
};

#endif // NOTIFICATION_H

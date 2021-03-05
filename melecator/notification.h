#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QObject>
#include <QRegularExpression>

#define NOTIFICATION_PATH "/../../test_data/notification/"

class Notification : public QObject {
  public:
    Notification(const QString &path, QObject *parent = 0) : QObject(parent) { read_notification(path); }
    ~Notification() {}
    Q_INVOKABLE QString get_merged_notification();
    Q_INVOKABLE QString get_notification(const qint32 &index, const qint32 &type);

  private:
    Q_OBJECT
    QMap<QString, QString> notification_list;
    void read_notification(const QString &path);
};

#endif // NOTIFICATION_H

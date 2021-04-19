#ifndef NOTIFICATION_H
#define NOTIFICATION_H

#include <QDir>
#include <QFile>
#include <QMap>
#include <QObject>

#ifndef QT_NO_DEBUG
#include <QDebug>
#endif

class Notification : public QObject {
public:
    Notification(QObject *parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE QString get_data(const bool &is_content, const qint32 &index);
    Q_INVOKABLE static inline quint32 get_data_amount() { return data.size(); }
    Q_INVOKABLE QString get_data_merged();

public slots:
    void read_file(const QString &path);

private:
    Q_OBJECT
    static QMap<QString, QString> data;

signals:
    void notificationAvailable();
    void notificationUnavailable();
};

#endif // NOTIFICATION_H

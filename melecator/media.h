#ifndef MEDIA_H
#define MEDIA_H

#include <QDir>
#include <QFile>
#include <QObject>
#include <QUrl>

#ifndef QT_NO_DEBUG
#include <QDebug>
#endif

class Media : public QObject {
public:
    Media(QObject *parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE static inline QList<QUrl> get_url() { return url; }

public slots:
    void read_file(const QString &path);

private:
    Q_OBJECT
    static QList<QUrl> url;

signals:
    void mediaAvailable();
    void mediaUnavailable();
};

#endif // MEDIA_H

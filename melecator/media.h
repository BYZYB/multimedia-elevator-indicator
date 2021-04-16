#ifndef MEDIA_H
#define MEDIA_H

#include <QDir>
#include <QFile>
#include <QObject>
#include <QUrl>

#ifndef QT_NO_DEBUG
#include <QDebug>
#endif

#ifdef Q_OS_WIN
#define PATH_VIDEO "/../../test_data/videos/"
#else
#define PATH_VIDEO "/../test_data/videos/"
#endif

class Media : public QObject {
public:
    Media(const QString &path, QObject *parent = nullptr) : QObject(parent), path(path + PATH_VIDEO) {}
    Q_INVOKABLE static inline QList<QUrl> get_url() { return url; }

public slots:
    void read_file();

private:
    Q_OBJECT
    static QList<QUrl> url;
    const QString path;

signals:
    void mediaAvailable();
    void mediaUnavailable();
};

#endif // MEDIA_H

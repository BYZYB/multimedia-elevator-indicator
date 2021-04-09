#ifndef MEDIA_H
#define MEDIA_H

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QObject>
#include <QUrl>

#ifdef Q_OS_WIN
#define PATH_VIDEO "/../../test_data/videos/"
#else
#define PATH_VIDEO "/../test_data/videos/"
#endif

class Media : public QObject {
public:
    Media(const QString &path, QObject *parent = 0) : QObject(parent), path(path + PATH_VIDEO) {}
    ~Media() {}
    Q_INVOKABLE inline QList<QUrl> get_media_url() { return media_url; }
    Q_INVOKABLE void read_media_file();

private:
    Q_OBJECT
    QList<QUrl> media_url;
    QString path;

signals:
    void mediaAvailable();
    void mediaUnavailable();
};

#endif // MEDIA_H

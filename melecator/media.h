#ifndef MEDIA_H
#define MEDIA_H

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QObject>

#ifdef Q_OS_WIN
#define PATH_IMAGE "/../../test_data/images/"
#define PATH_VIDEO "/../../test_data/videos/"
#else
#define PATH_IMAGE "/../test_data/images/"
#define PATH_VIDEO "/../test_data/videos/"
#endif

class Media : public QObject {
public:
    Media(const QString &path, QObject *parent = 0) : QObject(parent), path(path) {}
    ~Media() {}
    Q_INVOKABLE inline qint32 get_image_amount() { return image_data.size(); }
    Q_INVOKABLE inline QStringList get_image_path() { return image_data; }
    Q_INVOKABLE inline qint32 get_video_amount() { return video_data.size(); }
    Q_INVOKABLE inline QStringList get_video_path() { return video_data; }
    Q_INVOKABLE void read_media_file();

private:
    Q_OBJECT
    QString path;
    QStringList image_data, video_data;

signals:
    void mediaAvailable();
    void mediaUnavailable();
};

#endif // MEDIA_H

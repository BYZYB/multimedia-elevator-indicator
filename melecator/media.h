#ifndef MEDIA_H
#define MEDIA_H

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QObject>

#define IMAGE_PATH "/../../test_data/images/"
#define VIDEO_PATH "/../../test_data/videos/"

class Media : public QObject {
public:
    Media(const QString &path, QObject *parent = 0) : QObject(parent) { read_media_file(path); }
    ~Media() {}
    Q_INVOKABLE inline qint32 get_image_amount() { return images.size(); }
    Q_INVOKABLE inline QStringList get_image_path() { return images; }
    Q_INVOKABLE inline qint32 get_video_amount() { return videos.size(); }
    Q_INVOKABLE inline QStringList get_video_path() { return videos; }

private:
    Q_OBJECT
    QStringList images;
    QStringList videos;
    void read_media_file(const QString &path);
};

#endif // MEDIA_H

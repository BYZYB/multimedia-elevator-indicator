#ifndef MEDIA_H
#define MEDIA_H

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QObject>

#define IMAGE_PATH "/../../test_data/image/"
#define VIDEO_PATH "/../../test_data/video/"

class Media : public QObject {
public:
    Media(const QString &path, QObject *parent = 0) : QObject(parent) { read_media_file(path); }
    ~Media() {}
    Q_INVOKABLE inline qint32 get_image_amount() { return images.size(); }
    Q_INVOKABLE inline QString get_image_path(const qint32 &index) { return !images.isEmpty() ? images[index] : NULL; }
    Q_INVOKABLE inline qint32 get_video_amount() { return videos.size(); }
    Q_INVOKABLE inline QString get_video_path(const qint32 &index) { return !videos.isEmpty() ? videos[index] : NULL; }

private:
    Q_OBJECT
    QStringList images;
    QStringList videos;
    void read_media_file(const QString &path);
};

#endif // MEDIA_H

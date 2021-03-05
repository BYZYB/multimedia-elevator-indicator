#ifndef MEDIA_H
#define MEDIA_H

#include <QDebug>
#include <QDir>
#include <QFile>
#include <QObject>

#define IMAGE_PATH QStringLiteral("/../../test_data/image/")
#define VIDEO_PATH QStringLiteral("/../../test_data/video/")

class Media : public QObject {
  public:
    Media(const QString &path, QObject *parent = 0) : QObject(parent) { read_media(path); }
    ~Media() {}
    Q_INVOKABLE inline qint32 get_image_amount() { return image.size(); }
    Q_INVOKABLE inline QString get_image_path(const qint32 &index) { return !image.isEmpty() ? image[index] : QStringLiteral("[E] Image index out of range!"); }

    Q_INVOKABLE inline qint32 get_video_amount() { return video.size(); }
    Q_INVOKABLE inline QString get_video_path(const qint32 &index) { return !video.isEmpty() ? video[index] : QStringLiteral("[E] Video index out of range!"); }

  private:
    Q_OBJECT
    QStringList image;
    QStringList video;
    void read_media(const QString &path);
};

#endif // MEDIA_H

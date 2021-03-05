#include "media.h"

// Get the absolute path of each media file (image/video) in a specific directory
void Media::read_media(const QString &path) {
    const QDir image_dir(path + IMAGE_PATH);
    const QDir video_dir(path + VIDEO_PATH);
    const QStringList image_filters = {"*.bmp", "*.jpg", "*.png"};
    const QStringList video_filters = {"*.avi", "*.mp4"};
    const QStringList image_list = image_dir.entryList(image_filters, QDir::Files | QDir::Readable, QDir::Name | QDir::IgnoreCase);
    const QStringList video_list = video_dir.entryList(video_filters, QDir::Files | QDir::Readable, QDir::Name | QDir::IgnoreCase);

    // Read all image files in this directory
    for (QList<QString>::const_iterator it = image_list.constBegin(); it != image_list.constEnd(); it++) {
        const QString full_path = path + IMAGE_PATH + *it;
        QFile file(full_path);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) { // Cannot open image file in readonly mode
            qWarning() << "[E] Failed to open image file in readonly mode:" << path;
        } else { // File opened successfully, save image path into list
            image.append(full_path);
            file.close();
        }
    }

    // Read all video files in this directory
    for (QList<QString>::const_iterator it = video_list.constBegin(); it != video_list.constEnd(); it++) {
        const QString full_path = path + VIDEO_PATH + *it;
        QFile file(full_path);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) { // Cannot open video file in readonly mode
            qWarning() << "[E] Failed to open video file in readonly mode:" << path;
        } else { // File opened successfully, save video path into list
            video.append(full_path);
            file.close();
        }
    }
}

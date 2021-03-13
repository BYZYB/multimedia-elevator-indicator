#include "media.h"

// Get the absolute path of each media file (image/video) in a specific directory
void Media::read_media_file(const QString &path) {
    const QDir image_dir(path + IMAGE_PATH);
    const QDir video_dir(path + VIDEO_PATH);
    const QStringList image_list = image_dir.entryList({"*.bmp", "*.jpg", "*.png"}, QDir::Files | QDir::Readable, QDir::Name | QDir::IgnoreCase);
    const QStringList video_list = video_dir.entryList({"*.avi", "*.mp4"}, QDir::Files | QDir::Readable, QDir::Name | QDir::IgnoreCase);

    // Read all image files in this directory
    for (QList<QString>::const_iterator iterator = image_list.constBegin(); iterator != image_list.constEnd(); iterator++) {
        const QString full_path = path + IMAGE_PATH + *iterator;
        QFile file(full_path);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) { // Cannot open image file in readonly mode
            qWarning() << "[E] Failed to open image file in readonly mode:" << full_path;
        } else { // File opened successfully, save image path into list
            images.append(full_path);
            file.close();
        }
    }

    // Read all video files in this directory
    for (QList<QString>::const_iterator iterator = video_list.constBegin(); iterator != video_list.constEnd(); iterator++) {
        const QString full_path = path + VIDEO_PATH + *iterator;
        QFile file(full_path);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) { // Cannot open video file in readonly mode
            qWarning() << "[E] Failed to open video file in readonly mode:" << full_path;
        } else { // File opened successfully, save video path into list
            videos.append(full_path);
            file.close();
        }
    }
}

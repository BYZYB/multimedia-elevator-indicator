#include "media.h"

// Get the absolute path of each media file (images and videos) in a specific directory
void Media::read_media_file() {
    const QStringList image_list = QDir(path + PATH_IMAGE).entryList({"*.bmp", "*.jpg", "*.jpeg", "*.png"}, QDir::Files, QDir::Name), video_list = QDir(path + PATH_VIDEO).entryList({"*.avi", "*.mp4"}, QDir::Files, QDir::Name);

    // Read all image files in this directory
    for (QList<QString>::const_iterator iterator = image_list.constBegin(); iterator != image_list.constEnd(); iterator++) {
        const QString full_path = path + PATH_IMAGE + *iterator;
        QFile file(full_path);

        if (!file.open(QIODevice::ReadOnly)) { // Cannot open image file in readonly mode
            qWarning() << "[E] Failed to open image file in readonly mode:" << full_path;
        } else { // File opened successfully, save image path into list
            image_data.append(full_path);
            file.close();
        }
    }

    // Read all video files in this directory
    for (QList<QString>::const_iterator iterator = video_list.constBegin(); iterator != video_list.constEnd(); iterator++) {
        const QString full_path = path + PATH_VIDEO + *iterator;
        QFile file(full_path);

        if (!file.open(QIODevice::ReadOnly)) { // Cannot open video file in readonly mode
            qWarning() << "[E] Failed to open video file in readonly mode:" << full_path;
        } else { // File opened successfully, save video path into list
            video_data.append(full_path);
            file.close();
        }
    }

    video_data.empty() && image_data.empty() ? emit mediaUnavailable() : emit mediaAvailable();
}

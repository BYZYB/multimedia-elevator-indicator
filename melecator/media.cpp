#include "media.h"

QList<QUrl> Media::url;

// Get the absolute path of each media file in a specific directory
void Media::read_file(const QString &path) {
    const auto list = QDir(path).entryList({"*.avi", "*.flv", "*.m4v", "*.mkv", "*.mov", "*.mp4", "*.mpeg", "*.mpg", "*.wmv"}, QDir::Files, QDir::Name);
    url.clear();

    // Read all media files in this directory
    for (auto iterator = list.constBegin(); iterator != list.constEnd(); ++iterator) {
        const auto full_path = path + *iterator;
        QFile file(full_path);

        if (file.open(QIODevice::ReadOnly)) { // File opened successfully, save media file path into list (add "file://" prefix on linux system when GStreamer is used to play regular files)
#ifdef Q_OS_WIN
            url.append(full_path);
#else
            url.append(full_path.contains("://") ? full_path : "file://" + full_path);
#endif
            file.close();
        } else { // Cannot open media file in readonly mode
#ifndef QT_NO_DEBUG
            qWarning() << "[E] [Media] Failed to open media file in readonly mode:" << full_path;
#endif
        }
    }

    url.empty() ? emit mediaUnavailable() : emit mediaAvailable();
}

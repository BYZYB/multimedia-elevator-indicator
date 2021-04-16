#include "media.h"

QList<QUrl> Media::url;

// Get the absolute path of each media file in a specific directory
void Media::read_file() {
    const auto list = QDir(path).entryList({"*.avi", "*.mp4"}, QDir::Files, QDir::Name);

    // Read all media files in this directory
    for (auto iterator = list.constBegin(); iterator != list.constEnd(); ++iterator) {
        const auto full_path = path + *iterator;
        QFile file(full_path);

        if (file.open(QIODevice::ReadOnly)) { // File opened successfully, save media file path into list (add "file://" prefix on linux system when GStreamer is used)
#ifdef Q_OS_WIN
            url.append(full_path);
#else
            media_url.append("file://" + full_path);
#endif
            file.close();
        } else { // Cannot open media file in readonly mode
#ifndef QT_NO_DEBUG
            qWarning() << "[E] Failed to open media file in readonly mode:" << full_path;
#endif
        }
    }

    url.empty() ? emit mediaUnavailable() : emit mediaAvailable();
}

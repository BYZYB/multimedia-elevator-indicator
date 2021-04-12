#include "media.h"

QList<QUrl> Media::media_url;

// Get the absolute path of each media file in a specific directory
void Media::read_media_file() {
    const QStringList media_list = QDir(path).entryList({"*.avi", "*.mp4"}, QDir::Files, QDir::Name);

    // Read all media files in this directory
    for (QList<QString>::const_iterator iterator = media_list.constBegin(); iterator != media_list.constEnd(); iterator++) {
        const QString full_path = path + *iterator;
        QFile file(full_path);

        if (!file.open(QIODevice::ReadOnly)) { // Cannot open media file in readonly mode
            qWarning() << "[E] Failed to open media file in readonly mode:" << full_path;
        } else { // File opened successfully, save media file path into list (add "file://" prefix on linux system when GStreamer is used)
#ifdef Q_OS_WIN
            media_url.append(full_path);
#else
            media_url.append("file://" + full_path);
#endif
            file.close();
        }
    }

    media_url.empty() ? emit mediaUnavailable() : emit mediaAvailable();
}

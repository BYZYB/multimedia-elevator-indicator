#include "notification.h"

// Get a notification by type (content or title) and index (notification number)
QString Notification::get_notification(const bool &is_content, const qint32 &index) {
    if (index >= 0 && index <= notification_data.size()) { // The notification index is acceptable
        QMap<QString, QString>::const_iterator iterator = notification_data.constBegin();
        iterator += index;
        return is_content ? iterator.key() : iterator.value().trimmed();
    } else { // Notification index is out of range
        qWarning() << "[E] Notification index out of range: Index" << index << ", Type" << (is_content ? "content" : "title");
        return "🔕 通知不存在";
    }
}

// Get all notifications that merged into a single string (including title and content)
QString Notification::get_notification_merged() {
    QString notification_merged;

    // Merge all notifications into a QString, including both title and content
    for (QMap<QString, QString>::const_iterator iterator = notification_data.constBegin(); iterator != notification_data.constEnd(); iterator++) {
        notification_merged.append("🔔 【" + iterator.key() + "】");
        notification_merged.append(iterator.value().simplified() + "\t");
    }

    return notification_merged;
}

// Read all notification files (*.txt) in a specific directory
void Notification::read_notification_file() {
    const QStringList list = QDir(path).entryList({"*.txt"}, QDir::Files, QDir::Name);

    // Read all files in this directory
    for (QList<QString>::const_iterator iterator = list.constBegin(); iterator != list.constEnd(); iterator++) {
        QFile file(path + *iterator);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) { // Cannot open file in readonly mode
            qWarning() << "[E] Failed to open notification file in readonly mode:" << path;
        } else { // File opened successfully, save notification title (line 1) and content (line 2+) into notification_list
            QString content;
            const QString title = file.readLine().simplified();

            // Read notification content from line 2+
            while (!file.atEnd()) {
                content.append(file.readLine());
            }

            notification_data.insert(title, content);
            file.close();
        }
    }

    notification_data.empty() ? emit notificationUnavailable() : emit notificationAvailable();
}

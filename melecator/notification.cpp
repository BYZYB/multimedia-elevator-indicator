#include "notification.h"

// Read all notification files (*.txt) in a specific directory
void Notification::read_notification_file(const QString &path) {
    const QDir dir(path);
    const QStringList list = dir.entryList({"*.txt"}, QDir::Files | QDir::Readable, QDir::Name | QDir::IgnoreCase);

    // Read all files in this directory
    for (QList<QString>::const_iterator iterator = list.constBegin(); iterator != list.constEnd(); iterator++) {
        QFile file(path + *iterator);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) { // Cannot open file in readonly mode
            qWarning() << "[E] Failed to open notification file in readonly mode:" << path;
        } else { // File opened successfully, save notification title (line 1) and content (line 2+) into notification_list
            QString content;
            const QString title = file.readLine().simplified();

            while (!file.atEnd()) {
                content.append(file.readLine());
            }

            notifications.insert(title, content);
            file.close();
        }
    }
}

// Get all notifications (title/content) that merged into one string
QString Notification::get_merged_notification() {
    if (!notifications.empty()) { // Notification list is not empty
        QString notification_merged;

        // Merge all notifications into a QString, including both title and content
        for (QMap<QString, QString>::const_iterator iterator = notifications.constBegin(); iterator != notifications.constEnd(); iterator++) {
            notification_merged.append("🔔 【" + iterator.key() + "】");
            notification_merged.append(iterator.value().simplified() + "\t");
        }

        return notification_merged;
    } else { // Notification list is empty
        qWarning() << "[W] Empty notification list!";
        return "🔕 无通知";
    }
}

// Get notification by index and type (title/content)
QString Notification::get_notification(const qint32 &index, const qint32 &type) {
    if (!notifications.empty()) {                          // Notification list is not empty
        if (index >= 0 && index <= notifications.size()) { // Check if the notification index is acceptable
            QMap<QString, QString>::const_iterator iterator = notifications.constBegin();

            switch (type) {
            case 0: // Get notification title
                iterator += index;
                return iterator.key();
            case 1: // Get notification content
                iterator += index;
                return iterator.value().trimmed();
            default: // Unknown notification type
                qWarning() << "[E] Wrong notification type: Index" << index << ", Type" << type;
                return "🔕 通知类型错误";
            }
        } else { // Notification index is out of range
            qWarning() << "[E] Notification index out of range: Index" << index << ", Type" << type;
            return "🔕 通知不存在";
        }
    } else { // Notification list is empty
        qWarning() << "[W] Empty notification list!";
        return "🔕 无通知";
    }
}

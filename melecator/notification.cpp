#include "notification.h"

// Get a notification by type (0: title, 1: content) and index (notification number)
QString Notification::get_notification(const qint32 &type, const qint32 &index) {
    if (!notification_data.empty()) {                          // Notification list is not empty
        if (index >= 0 && index <= notification_data.size()) { // The notification index is acceptable
            QMap<QString, QString>::const_iterator iterator = notification_data.constBegin();

            // Get the notification data of a specific type (title or content)
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

// Get all notifications that merged into a single string (including title and content)
QString Notification::get_notification_merged() {
    if (!notification_data.empty()) { // Notification list is not empty
        QString notification_merged;

        // Merge all notifications into a QString, including both title and content
        for (QMap<QString, QString>::const_iterator iterator = notification_data.constBegin(); iterator != notification_data.constEnd(); iterator++) {
            notification_merged.append("🔔 【" + iterator.key() + "】");
            notification_merged.append(iterator.value().simplified() + "\t");
        }

        return notification_merged;
    } else { // Notification list is empty
        qWarning() << "[W] Empty notification list!";
        return "🔕 无通知";
    }
}

// Read all notification files (*.txt) in a specific directory
void Notification::read_notification_file(const QString &path) {
    const QDir dir(path);
    const QStringList list = dir.entryList({"*.txt"}, QDir::Files | QDir::Readable, QDir::Name);

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
}

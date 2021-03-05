#include "notification.h"

// Read all notification files (*.txt) in a specific directory
void Notification::read_notification(const QString &path) {
    const QDir dir(path);
    const QStringList filters = {"*.txt"};
    const QStringList list = dir.entryList(filters, QDir::Files | QDir::Readable, QDir::Name | QDir::IgnoreCase);

    // Read all files in this directory
    for (QList<QString>::const_iterator it = list.constBegin(); it != list.constEnd(); it++) {
        QFile file(path + *it);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) { // Cannot open file in readonly mode
            qWarning() << "[E] Failed to open notification file in readonly mode:" << path;
        } else { // File opened successfully, save notification title (line 1) and content (line 2) into notification_list
            const QString title = file.readLine();
            const QString content = file.readLine();
            notification_list.insert(title, content);
            file.close();
        }
    }
}

// Get notification by index and type (title/content)
QString Notification::get_notification(const qint32 &index, const qint32 &type) {
    if (!notification_list.empty()) {                          // Notification list is not empty
        if (index >= 0 && index <= notification_list.size()) { // Check if the notification index is legal
            QMap<QString, QString>::const_iterator it = notification_list.constBegin();

            switch (type) {
            case 0: // Get notification title
                it += index;
                return it.key();
            case 1: // Get notification content
                it += index;
                return it.value();
            default: // Unknown notification type
                qWarning() << "[E] Wrong notification type: Index" << index << ", Type" << type;
            }
        } else { // Notification index is out of range
            qWarning() << "[E] Notification index out of range: Index" << index << ", Type" << type;
        }
    } else { // Notification list is empty
        qWarning() << "[W] Empty notification list!";
    }

    return QStringLiteral("🔕 无通知");
}

// Get all notifications (title/content) that merged into one string
QString Notification::get_all_notification() {
    if (!notification_list.empty()) { // Notification list is not empty
        QString merged;

        // Merge all notifications into a QString, including both title and content
        for (QMap<QString, QString>::const_iterator it = notification_list.constBegin(); it != notification_list.constEnd(); it++) {
            merged.append("🔔 【" + it.key().trimmed() + "】");
            merged.append(it.value().trimmed() + "\t");
        }

        return merged;
    } else { // Notification list is empty
        qWarning() << "[W] Empty notification list!";
        return QStringLiteral("🔕 无通知");
    }
}

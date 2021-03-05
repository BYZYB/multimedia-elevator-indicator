#include "notification.h"

// Read all notification files (*.txt) from a specific path
void Notification::read_notification(const QString &path) {
    const QDir dir(path);
    const QStringList list = dir.entryList(QDir::Files | QDir::Readable, QDir::Name | QDir::IgnoreCase);

    // Read all files in this directory
    for (QList<QString>::const_iterator it = list.constBegin(); it != list.constEnd(); it++) {
        QFile file(path + *it);

        if (!file.exists()) { // File doesn't exist
            qWarning() << "[W] 通知文件不存在：" << path;
        } else if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) { // Cannot open file in readonly mode
            qWarning() << "[E] 无法以只读方式打开通知文件：" << path;
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
                qWarning() << "[E] 通知类型错误：序号 " << index << "，类型 " << type;
            }
        } else { // Notification index is out of range
            qWarning() << "[E] 通知序号越界：序号 " << index << "，类型 " << type;
        }
    } else { // Notification list is empty
        qWarning() << "[W] 通知文件为空！";
    }

    return "🔕 无通知";
}

// Get all notifications (title/content) merged in a QString
QString Notification::get_merged_notification() {
    if (!notification_list.empty()) { // Notification list is not empty
        QString merged;

        // Merge all notifications into a QString, including both title and content
        for (QMap<QString, QString>::const_iterator it = notification_list.constBegin(); it != notification_list.constEnd(); it++) {
            merged.append("🔔 【" + it.key().trimmed() + "】");
            merged.append(it.value().trimmed() + "\t");
        }

        return merged;
    } else { // Notification list is empty
        qWarning() << "[W] 通知文件为空！";
        return "🔕 无通知";
    }
}

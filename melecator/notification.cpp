#include "notification.h"

// Read notification texts from a specific path
void Notification::read_notification(const QString &path) {
    QFile file(path);

    if (!file.exists()) {
        qWarning() << "[E] 通知文件不存在：" << path;
    } else if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "[E] 无法以只读方式打开通知文件：" << path;
    } else {
        while (!file.atEnd()) {
            list.append(file.readLine());
        }

        file.close();
    }
}

// Get the next notification string circularly
QString Notification::get_merged_notification() {
    if (!list.empty()) {
        QString list_merged = "🔔 ";
        QStringListIterator list_iterator(list);

        while (list_iterator.hasNext()) {
            list_merged.append(list_iterator.next());
        }

        list_merged = list_merged.trimmed();
        list_merged.replace(QRegularExpression("\n"), "\t🔔 ");
        return list_merged;
    } else {
        qWarning() << "[W] 通知文件为空！";
        return "🔕 无通知";
    }
}

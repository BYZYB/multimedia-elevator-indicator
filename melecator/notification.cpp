#include "notification.h"

// Read notification texts from a specific path
void Notification::read_notification() {
    QFile file(NOTIFICATION_PATH);

    if (!file.exists()) {
        printf("[E] 通知文件不存在：%s\n", NOTIFICATION_PATH);
    } else if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        printf("[E] 无法以只读方式打开通知文件：%s\n", NOTIFICATION_PATH);
    } else {
        while (!file.atEnd()) {
            list.append(file.readLine());
        }

        file.close();
    }
}

// Get the next notification string circularly
QString Notification::get_notification() {
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
        printf("[W] 通知文件为空：%s\n", NOTIFICATION_PATH);
        return "🔕 无通知";
    }
}

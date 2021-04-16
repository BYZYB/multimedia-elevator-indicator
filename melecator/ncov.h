#ifndef NCOV_H
#define NCOV_H

#include <QEventLoop>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>

#ifndef QT_NO_DEBUG
#include <QDebug>
#endif

#define URL_NCOV "https://lab.isaaclin.cn/nCoV/api/area?province="

class Ncov : public QObject {
public:
    Ncov(QObject *parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE static inline QJsonValue get_capital_data() { return capital_data; }
    Q_INVOKABLE static inline QJsonValue get_province_data() { return province_data; }

public slots:
    void request_data(const QString &province);

private:
    Q_OBJECT
    static QJsonValue capital_data, province_data;

signals:
    void ncovAvailable();
    void ncovUnavailable();
};

#endif // NCOV_H

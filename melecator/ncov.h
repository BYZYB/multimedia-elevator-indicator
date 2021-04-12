#ifndef NCOV_H
#define NCOV_H

#include <QDebug>
#include <QEventLoop>
#include <QJsonArray>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>

#define URL_NCOV "https://lab.isaaclin.cn/nCoV/api/area?province="

class Ncov : public QObject {
public:
    Ncov(QObject *parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE static inline QJsonValue get_ncov_capital() { return ncov_capital; }
    Q_INVOKABLE static inline QJsonValue get_ncov_province() { return ncov_province; }
    Q_INVOKABLE void request_ncov_data(const QString &province);

private:
    Q_OBJECT
    static QJsonValue ncov_capital, ncov_province;

signals:
    void ncovAvailable();
    void ncovUnavailable();
};

#endif // NCOV_H

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

class Ncov : public QObject {
public:
    Ncov(QObject *parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE static inline QJsonValue get_capital_data() { return capital_data; }
    Q_INVOKABLE static inline QJsonValue get_province_data() { return province_data; }

public slots:
    void request_data(const QString &province);
    static inline void set_url(const QString &url) { Ncov::url = url; }

private:
    Q_OBJECT
    static QJsonValue capital_data, province_data;
    static QString url;

signals:
    void ncovAvailable();
    void ncovUnavailable();
};

#endif // NCOV_H

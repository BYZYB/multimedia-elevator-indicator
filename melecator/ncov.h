#ifndef NCOV_H
#define NCOV_H

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
    static inline void set_url(const QString &url) { Ncov::url = url; }
    void request_data(const QString &province);

protected:
    static QJsonValue capital_data, province_data;
    static QString url;
    QNetworkReply *reply;

protected slots:
    void ncovRequestCompleted();

private:
    Q_OBJECT

signals:
    void ncovAvailable();
    void ncovUnavailable();
};

#endif // NCOV_H

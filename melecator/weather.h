#ifndef WEATHER_H
#define WEATHER_H

#include <QEventLoop>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>

#ifndef QT_NO_DEBUG
#include <QDebug>
#endif

class Weather : public QObject {
public:
    Weather(QObject *parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE static inline QJsonValue get_current_data() { return current_data; }
    Q_INVOKABLE static inline QString get_day_name(const quint8 &day) {
        switch (day) {
        case 1:
            return "星期一";
        case 2:
            return "星期二";
        case 3:
            return "星期三";
        case 4:
            return "星期四";
        case 5:
            return "星期五";
        case 6:
            return "星期六";
        case 7:
            return "星期日";
        default:
            return "--";
        }
    }
    Q_INVOKABLE static inline QJsonValue get_forecast_data() { return forecast_data; }
    Q_INVOKABLE QUrl get_image_url(const bool &is_forecast, const qint32 &day = 0);

public slots:
    void request_data(const QString &city);
    static inline void set_url(const QString &url_current, const QString &url_forecast) {
        Weather::url_current = url_current;
        Weather::url_forecast = url_forecast;
    }

protected:
    static QJsonValue current_data, forecast_data;
    static QString url_current, url_forecast;

private:
    Q_OBJECT

signals:
    void weatherAvailable();
    void weatherUnavailable();
};

#endif // WEATHER_H

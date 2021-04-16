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

#define URL_WEATHER_CURRENT "https://restapi.amap.com/v3/weather/weatherInfo?key=5d2d3e6c0d5188bec134fc4fc1b139e0&city="
#define URL_WEATHER_FORECAST "https://restapi.amap.com/v3/weather/weatherInfo?key=5d2d3e6c0d5188bec134fc4fc1b139e0&extensions=all&city="

class Weather : public QObject {
public:
    Weather(QObject *parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE static inline QJsonValue get_current_data() { return current_data; }
    Q_INVOKABLE static inline QJsonValue get_forecast_data() { return forecast_data; }
    Q_INVOKABLE QUrl get_image_url(const bool &is_forecast, const qint32 &day = 0);

public slots:
    void request_data(const QString &city);

private:
    Q_OBJECT
    static QJsonValue current_data, forecast_data;

signals:
    void weatherAvailable();
    void weatherUnavailable();
};

#endif // WEATHER_H

#ifndef WEATHER_H
#define WEATHER_H

#include <QDebug>
#include <QEventLoop>
#include <QJsonArray>
#include <QJsonDocument>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>

#define URL_WEATHER_CURRENT "https://restapi.amap.com/v3/weather/weatherInfo?key=5d2d3e6c0d5188bec134fc4fc1b139e0&city="
#define URL_WEATHER_FORECAST "https://restapi.amap.com/v3/weather/weatherInfo?key=5d2d3e6c0d5188bec134fc4fc1b139e0&extensions=all&city="

class Weather : public QObject {
public:
    Weather(QObject *parent = 0) : QObject(parent) {}
    ~Weather() {}
    Q_INVOKABLE inline QJsonValue get_weather_current() { return weather_current; }
    Q_INVOKABLE inline QJsonArray get_weather_forecast() { return weather_forecast; }
    Q_INVOKABLE QUrl get_weather_image(const bool &is_forecast, const qint32 &day = 0);
    Q_INVOKABLE void request_weather_data(const QString &city);

private:
    Q_OBJECT
    QJsonValue weather_current;
    QJsonArray weather_forecast;

signals:
    void weatherAvailable();
    void weatherUnavailable();
};

#endif // WEATHER_H

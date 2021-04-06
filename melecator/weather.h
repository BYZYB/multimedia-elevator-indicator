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

#ifdef Q_OS_WIN
#define URL_WEATHER_CURRENT "http://restapi.amap.com/v3/weather/weatherInfo?key=5d2d3e6c0d5188bec134fc4fc1b139e0&city="
#define URL_WEATHER_FORECAST "http://restapi.amap.com/v3/weather/weatherInfo?key=5d2d3e6c0d5188bec134fc4fc1b139e0&extensions=all&city="
#else
#define URL_WEATHER_CURRENT "https://restapi.amap.com/v3/weather/weatherInfo?key=5d2d3e6c0d5188bec134fc4fc1b139e0&city="
#define URL_WEATHER_FORECAST "https://restapi.amap.com/v3/weather/weatherInfo?key=5d2d3e6c0d5188bec134fc4fc1b139e0&extensions=all&city="
#endif

class Weather : public QObject {
public:
    Weather(const QString &city, QObject *parent = 0) : QObject(parent), city(city) {}
    ~Weather() {}
    Q_INVOKABLE inline QJsonValue get_weather_current() { return document_current["lives"].toArray()[0]; }
    Q_INVOKABLE inline QJsonArray get_weather_forecast() { return document_forecast["forecasts"].toArray().at(0)["casts"].toArray(); }
    Q_INVOKABLE QUrl get_weather_image(const qint32 &type, const qint32 &day = 0);
    Q_INVOKABLE void request_weather_data();

private:
    Q_OBJECT
    QJsonDocument document_current, document_forecast;
    QString city;

signals:
    void weatherAvailable();
    void weatherUnavailable();
};

#endif // WEATHER_H

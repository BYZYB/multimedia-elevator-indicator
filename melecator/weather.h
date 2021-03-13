#ifndef WEATHER_H
#define WEATHER_H

#include <QEventLoop>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QObject>

#define WEATHER_URL "http://restapi.amap.com/v3/weather/weatherInfo?key=5d2d3e6c0d5188bec134fc4fc1b139e0&extensions=all&city="

class Weather : public QObject {
public:
    Weather(const QString &city, QObject *parent = 0) : QObject(parent) { request_weather_data(WEATHER_URL + city); }
    ~Weather() {}
    Q_INVOKABLE QJsonArray get_weather_forecast();

private:
    Q_OBJECT
    QByteArray weather_data;
    void request_weather_data(const QUrl &url);
};

#endif // WEATHER_H

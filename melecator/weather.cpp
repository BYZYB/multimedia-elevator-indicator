#include "weather.h"

// Request AMAP weather data (in JSON format) using HTTP GET, which is designed to block main thread
void Weather::request_weather_data(const QUrl &url) {
    QEventLoop loop;
    QNetworkAccessManager manager;
    QNetworkRequest request(url);
    QNetworkReply *reply = manager.get(request);

    connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();

    if (reply->error()) { // Error happened during network request
        qWarning() << "[E] Failed to get weather data from:" << url;
    } else { // Successfully got network reply, save it to weather_data
        weather_data = reply->readAll();
        qDebug() << "[D] " << weather_data;
    }

    qDebug() << "[D] " << get_weather_forecast();
}

// Get weather forecast as an array from weather_data
QJsonArray Weather::get_weather_forecast() {
    const QJsonDocument document = QJsonDocument::fromJson(weather_data);

    if (!document.isNull() && !document.isEmpty()) { // JSON document is available, read array (root->forecasts->casts) without checking
        return document["forecasts"].toArray().at(0)["casts"].toArray();
    } else { // JSON document is unavailable or empty
        qWarning() << "[W] No weather data in JSON document!";
        return QJsonArray();
    }
}

#include "weather.h"

// Get the weather image URL by type (weather forecast or current weather) and day (default to today, not used in current weather)
QUrl Weather::get_weather_image(const bool &is_forecast, const qint32 &day) {
    const int hour = QTime::currentTime().hour();
    const bool is_night = hour < 7 || hour > 18 ? true : false;
    const QString phenomenon = is_forecast ? weather_forecast.at(day)[is_night ? "nightweather" : "dayweather"].toString() : weather_current["weather"].toString();

    // Return suitable weather image according to phenomenon and time (day or night)
    if (phenomenon.contains("晴")) {
        return is_night ? QUrl("qrc:/res/icons/weather/clear-night.png") : QUrl("qrc:/res/icons/weather/clear-day.png");
    } else if (phenomenon.contains("云")) {
        return is_night ? QUrl("qrc:/res/icons/weather/cloudy-night.png") : QUrl("qrc:/res/icons/weather/cloudy-day.png");
    } else if (phenomenon.contains("阴")) {
        return QUrl("qrc:/res/icons/weather/cloud.png");
    } else if (phenomenon.contains("风")) {
        return QUrl("qrc:/res/icons/weather/wind.png");
    } else if (phenomenon.contains("霾") || phenomenon.contains("尘") || phenomenon.contains("沙")) {
        return QUrl("qrc:/res/icons/weather/dust.png");
    } else if (phenomenon.contains("雷")) {
        return QUrl("qrc:/res/icons/weather/storm.png");
    } else if (phenomenon.contains("雪")) {
        return QUrl("qrc:/res/icons/weather/snow.png");
    } else if (phenomenon.contains("雨")) {
        return QUrl("qrc:/res/icons/weather/rain.png");
    } else if (phenomenon.contains("雾")) {
        return is_night ? QUrl("qrc:/res/icons/weather/fog-night.png") : QUrl("qrc:/res/icons/weather/fog-day.png");
    } else if (phenomenon.isEmpty()) { // Other weather phenomena
        qWarning() << "[E] Empty weather phenomena, the weather data might be broken.";
        emit weatherUnavailable();
        return QUrl("qrc:/res/icons/weather/unknown.png");
    } else {
        qWarning() << "[W] Unknown weather phenomena:" << phenomenon;
        return QUrl("qrc:/res/icons/weather/unknown.png");
    }
}

// Request the weather data of a specific city using AMAP weather API (in JSON format)
void Weather::request_weather_data(const QString &city) {
    QEventLoop loop;
    QNetworkAccessManager manager;
    const QNetworkRequest request_current(URL_WEATHER_CURRENT + city), request_forecast(URL_WEATHER_FORECAST + city);
    QNetworkReply *reply_current = manager.get(request_current), *reply_forecast = manager.get(request_forecast);

    connect(reply_forecast, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();

    if (reply_current->error() || reply_forecast->error()) { // Error happened during network request
        qWarning() << "[E] Failed to get weather data for:" << city;
        emit weatherUnavailable();
    } else { // Successfully got reply from remote server, save them to JSON documents
        weather_current = QJsonDocument::fromJson(reply_current->readAll())["lives"].toArray().at(0);
        weather_forecast = QJsonDocument::fromJson(reply_forecast->readAll())["forecasts"].toArray().at(0)["casts"].toArray();
        emit weatherAvailable();
    }
}

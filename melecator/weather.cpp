#include "weather.h"

// Get the weather image URL by type (0: current weather, 1: weather forecast) and day (default to today, not used in type 0)
QUrl Weather::get_weather_image(const qint32 &type, const qint32 &day) {
    const int hour = QTime::currentTime().hour();
    const bool is_night = hour < 7 || hour > 18 ? true : false;
    QString phenomenon;

    // Get the weather phenomenon of a specific type (current or forecast)
    switch (type) {
    case 0: // Get the phenomenon of current weather
        phenomenon = document_current["lives"].toArray().at(0)["weather"].toString();
        break;
    case 1: // Get the phenomenon of a specific day in weather forecast
        phenomenon = document_forecast["forecasts"].toArray().at(0)["casts"].toArray().at(day)[is_night ? "nightweather" : "dayweather"].toString();
        break;
    default: // Unknown weather type, return the default image URL
        return QUrl("qrc:/res/icons/no-weather.png");
    }

    // Return suitable weather image according to phenomenon and time (day or night)
    if (phenomenon.contains("晴") || phenomenon == ("平静")) {
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
    } else { // Other weather phenomena
        return QUrl("qrc:/res/icons/weather/unknown.png");
    }
}

// Request the weather data of a specific city using AMAP weather API (in JSON format, which is designed to block main thread)
void Weather::request_weather_data() {
    QEventLoop loop;
    QNetworkAccessManager manager;
    const QNetworkRequest request_current(URL_WEATHER_CURRENT + city), request_forecast(URL_WEATHER_FORECAST + city);
    QNetworkReply *reply_current = manager.get(request_current), *reply_forecast = manager.get(request_forecast);

    connect(reply_forecast, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();

    if (reply_current->error() || reply_forecast->error()) { // Error happened during network request
        qWarning() << "[E] Failed to get weather data for:" << city;
    } else { // Successfully got network reply, save them to JSON documents
        document_current = QJsonDocument::fromJson(reply_current->readAll());
        document_forecast = QJsonDocument::fromJson(reply_forecast->readAll());
    }
}

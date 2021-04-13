#include "weather.h"

QJsonValue Weather::weather_current, Weather::weather_forecast;

// Get the weather image URL by type (weather forecast or current weather) and day (default to today, not used in current weather)
QUrl Weather::get_weather_image(const bool &is_forecast, const qint32 &day) {
    const int hour = QTime::currentTime().hour();
    const bool is_night = hour < 7 || hour > 18 ? true : false;
    const QString phenomenon = is_forecast ? weather_forecast[day][is_night ? "nightweather" : "dayweather"].toString() : weather_current["weather"].toString();

    // Return suitable weather image according to phenomenon and time (day or night)
    if (phenomenon.contains("晴")) {
        return is_night ? QUrl("qrc:/res/icons/weather/sunny-night.svg") : QUrl("qrc:/res/icons/weather/sunny-day.svg");
    } else if (phenomenon.contains("云")) {
        return is_night ? QUrl("qrc:/res/icons/weather/partly-cloudy-night.svg") : QUrl("qrc:/res/icons/weather/partly-cloudy-day.svg");
    } else if (phenomenon.contains("阴")) {
        return QUrl("qrc:/res/icons/weather/cloudy.svg");
    } else if (phenomenon.contains("风")) {
        return QUrl("qrc:/res/icons/weather/windy.svg");
    } else if (phenomenon.contains("霾") || phenomenon.contains("尘") || phenomenon.contains("沙")) {
        return QUrl("qrc:/res/icons/weather/hazy.svg");
    } else if (phenomenon.contains("雷")) {
        return QUrl("qrc:/res/icons/weather/lightning-rainy.svg");
    } else if (phenomenon.contains("雪") && phenomenon.contains("雨")) {
        return QUrl("qrc:/res/icons/weather/snowy-rainy.svg");
    } else if (phenomenon.contains("雪")) {
        return QUrl("qrc:/res/icons/weather/snowy.svg");
    } else if (phenomenon.contains("雨")) {
        return QUrl("qrc:/res/icons/weather/rainy.svg");
    } else if (phenomenon.contains("雾")) {
        return QUrl("qrc:/res/icons/weather/foggy.svg");
    } else if (phenomenon.isEmpty()) { // Other weather phenomena
        qWarning() << "[E] Empty weather phenomena, the weather data might be broken.";
        emit weatherUnavailable();
        return QUrl("qrc:/res/icons/weather/cloudy-alert.svg");
    } else {
        qWarning() << "[W] Unknown weather phenomena:" << phenomenon;
        return QUrl("qrc:/res/icons/weather/cloudy-alert.svg");
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
        weather_current = QJsonDocument::fromJson(reply_current->readAll())["lives"][0];
        weather_forecast = QJsonDocument::fromJson(reply_forecast->readAll())["forecasts"][0]["casts"];
        emit weatherAvailable();
    }
}

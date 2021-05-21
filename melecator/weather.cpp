#include "weather.h"

QJsonValue Weather::current_data, Weather::forecast_data;
QString Weather::url_current, Weather::url_forecast;

// Get the weather image URL by type (weather forecast or current weather) and day (default to today, not used in current weather)
QUrl Weather::get_image_url(const bool &is_forecast, const qint32 &day) {
    const auto hour = QTime::currentTime().hour();
    const auto is_night = hour < 7 || hour > 18 ? true : false;
    const auto phenomenon = is_forecast ? forecast_data[day][is_night ? "nightweather" : "dayweather"].toString() : current_data["weather"].toString();

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
    } else if (phenomenon.isEmpty()) { // The weather phenomenon string is empty
#ifndef QT_NO_DEBUG
        qWarning() << "[E] [Weather] Empty weather phenomenon, the weather data might be broken.";
#endif
        is_forecast ? emit weatherForecastUnavailable() : emit weatherCurrentUnavailable();
        return QUrl("qrc:/res/icons/weather/cloudy-alert.svg");
    } else { // Other weather phenomenon
#ifndef QT_NO_DEBUG
        qWarning() << "[W] [Weather] Unknown weather phenomenon:" << phenomenon;
#endif
        return QUrl("qrc:/res/icons/weather/cloudy-alert.svg");
    }
}

// Check if the network reply of current weather data is available, then save the data or emit error signal
void Weather::weatherCurrentRequestCompleted() {
    if (reply_current->error()) { // Error happened during network request
#ifndef QT_NO_DEBUG
        qWarning() << "[E] [Weather] Failed to get current weather data, please check your internet connection and try again.";
#endif
        emit weatherCurrentUnavailable();
    } else { // Successfully got reply from remote server, save them to JSON documents
        current_data = QJsonDocument::fromJson(reply_current->readAll())["lives"][0];
        emit weatherCurrentAvailable();
    }

    reply_current->deleteLater();
}

// Check if the network reply of weather forecast data is available, then save the data or emit error signal
void Weather::weatherForecastRequestCompleted() {
    if (reply_forecast->error()) { // Error happened during network request
#ifndef QT_NO_DEBUG
        qWarning() << "[E] [Weather] Failed to get weather forecast data, please check your internet connection and try again.";
#endif
        emit weatherForecastUnavailable();
    } else { // Successfully got reply from remote server, save them to JSON documents
        forecast_data = QJsonDocument::fromJson(reply_forecast->readAll())["forecasts"][0]["casts"];
        emit weatherForecastAvailable();
    }

    reply_forecast->deleteLater();
}

// Request the weather data of a specific city using AMAP weather API (in JSON format)
// Public AMAP developer account registered with zusms.com (not my own account, for test purpose only): 16535533188
// Please login with SMS verification code, do not change password (I don't know either) or delete existing APIs.
// API key (web services without IP whitelist): 9e24a5b9641a7b9bd139940b7212cdfa
void Weather::request_data(const QString &city) {
    const QNetworkRequest request_current(url_current + city), request_forecast(url_forecast + city);
    current_data = forecast_data = QJsonValue();
    reply_current = (new QNetworkAccessManager)->get(request_current);
    reply_forecast = (new QNetworkAccessManager)->get(request_forecast);
    connect(reply_current, &QNetworkReply::finished, this, &Weather::weatherCurrentRequestCompleted);
    connect(reply_forecast, &QNetworkReply::finished, this, &Weather::weatherForecastRequestCompleted);
}

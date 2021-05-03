#include "ncov.h"

QJsonValue Ncov::capital_data, Ncov::province_data;
QString Ncov::url;

// Check if the network reply of COVID-19 infection data is available, then save the data or emit error signal
void Ncov::ncovRequestCompleted() {
    if (reply->error()) { // Error happened during network request
#ifndef QT_NO_DEBUG
        qWarning() << "[E] Failed to get COVID-19 infection data, please check your internet connection and try again.";
#endif
        emit ncovUnavailable();
    } else { // Successfully got reply from remote server, save them to JSON document
        province_data = QJsonDocument::fromJson(reply->readAll())["results"][0];
        capital_data = province_data["cities"][0];
        emit ncovAvailable();
    }

    reply->deleteLater();
}

// Request the COVID-19 infection data of a specific province using BlankerL nCoV API (in JSON format)
void Ncov::request_data(const QString &province) {
    const QNetworkRequest request(url + province);
    capital_data = province_data = QJsonValue();
    reply = (new QNetworkAccessManager)->get(request);
    connect(reply, &QNetworkReply::finished, this, &Ncov::ncovRequestCompleted);
}

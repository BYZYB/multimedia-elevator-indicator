#include "ncov.h"

QJsonValue Ncov::capital_data, Ncov::province_data;

// Request the COVID-19 infection data of a specific province using BlankerL nCoV API (in JSON format)
void Ncov::request_data(const QString &province) {
    QEventLoop loop;
    QNetworkAccessManager manager;
    const QNetworkRequest request(URL_NCOV + province);
    auto *reply = manager.get(request);

    connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();

    if (reply->error()) { // Error happened during network request
#ifndef QT_NO_DEBUG
        qWarning() << "[E] Failed to get infection data for:" << province;
#endif
        emit ncovUnavailable();
    } else { // Successfully got reply from remote server, save them to JSON document
        province_data = QJsonDocument::fromJson(reply->readAll())["results"][0];
        capital_data = province_data["cities"][0];
        emit ncovAvailable();
    }
}

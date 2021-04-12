#include "ncov.h"

QJsonValue Ncov::ncov_capital, Ncov::ncov_province;

// Request the COVID-19 infection data of a specific province using BlankerL nCoV API (in JSON format)
void Ncov::request_ncov_data(const QString &province) {
    QEventLoop loop;
    QNetworkAccessManager manager;
    const QNetworkRequest request(URL_NCOV + province);
    QNetworkReply *reply = manager.get(request);

    connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();

    if (reply->error()) { // Error happened during network request
        qWarning() << "[E] Failed to get infection data for:" << province;
        emit ncovUnavailable();
    } else { // Successfully got reply from remote server, save them to JSON document
        ncov_province = QJsonDocument::fromJson(reply->readAll())["results"][0];
        ncov_capital = ncov_province["cities"][0];
        emit ncovAvailable();
    }
}

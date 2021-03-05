#include "media.h"
#include "notification.h"
#include "weather.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QtQml>

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    QQuickStyle::setStyle(QStringLiteral("Material"));

    engine.rootContext()->setContextProperty(QStringLiteral("media"), new Media(app.applicationDirPath()));
    engine.rootContext()->setContextProperty(QStringLiteral("notification"), new Notification(app.applicationDirPath()));
    engine.load(QStringLiteral("qrc:/main.qml"));

    return app.exec();
}

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
    QQuickStyle::setStyle("Material");

    engine.rootContext()->setContextProperty("media", new Media(app.applicationDirPath()));
    engine.rootContext()->setContextProperty("notification", new Notification(app.applicationDirPath()));
    engine.load("qrc:/main.qml");

    return app.exec();
}

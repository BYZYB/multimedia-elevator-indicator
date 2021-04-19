#include "elevator.h"
#include "media.h"
#include "ncov.h"
#include "notification.h"
#include "weather.h"
#include <QFont>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QtQml>

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QQuickStyle::setStyle("Material");
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    app.setFont(QFont("Noto Sans CJK SC"));
    engine.rootContext()->setContextProperty("path_dir", app.applicationDirPath());
    engine.rootContext()->setContextProperty("Elevator", new Elevator());
    engine.rootContext()->setContextProperty("Media", new Media());
    engine.rootContext()->setContextProperty("Ncov", new Ncov());
    engine.rootContext()->setContextProperty("Notification", new Notification());
    engine.rootContext()->setContextProperty("Weather", new Weather());
    engine.load("qrc:/main.qml");

    return app.exec();
}

#include "media.h"
#include "notification.h"
#include "weather.h"
#include <QFont>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QtQml>

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QFont font("Noto Sans CJK SC");
    QQuickStyle::setStyle("Material");
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    app.setFont(font);
    engine.rootContext()->setContextProperty("Media", new Media(app.applicationDirPath()));
    engine.rootContext()->setContextProperty("Notification", new Notification(app.applicationDirPath()));
    engine.rootContext()->setContextProperty("Weather", new Weather("广州市"));
    engine.load("qrc:/main.qml");

    return app.exec();
}

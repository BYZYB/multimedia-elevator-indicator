#include "notification.h"
#include "weather.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine(QStringLiteral("qrc:/main.qml"));

    engine.rootContext()->setContextProperty("notification", new Notification());

    return app.exec();
}

CONFIG += c++latest

HEADERS += \
    notification.h \
    weather.h

QT += quick

SOURCES += main.cpp \
    notification.cpp \
    weather.cpp

RC_ICONS += res/app.ico

RESOURCES += \
    app.qrc \
    res.qrc

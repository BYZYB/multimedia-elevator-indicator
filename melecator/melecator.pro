CONFIG += c++latest ltcg optimize_full

HEADERS += \
    notification.h \
    player.h \
    weather.h

QT += quick quickcontrols2

SOURCES += main.cpp \
    notification.cpp \
    player.cpp \
    weather.cpp

RC_ICONS += res/icon/app.ico

RESOURCES += app.qrc

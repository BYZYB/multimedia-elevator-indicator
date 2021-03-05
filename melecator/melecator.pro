CONFIG += c++latest ltcg optimize_full

HEADERS += \
    media.h \
    notification.h \
    weather.h

QT += quick quickcontrols2

SOURCES += main.cpp \
    media.cpp \
    notification.cpp \
    weather.cpp

RC_ICONS += res/icon/app.ico

RESOURCES += app.qrc

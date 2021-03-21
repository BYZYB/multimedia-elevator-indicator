CONFIG += c++latest ltcg optimize_full

HEADERS += \
    calendar.h \
    media.h \
    notification.h \
    weather.h

QT += quick quickcontrols2

SOURCES += main.cpp \
    calendar.cpp \
    media.cpp \
    notification.cpp \
    weather.cpp

RC_ICONS = res/icons/app_icon.ico

RESOURCES += app.qrc

CONFIG += \
    c++latest \
    ltcg \
    optimize_full

HEADERS += \
    media.h \
    ncov.h \
    notification.h \
    weather.h

QT += \
    quick \
    quickcontrols2

SOURCES += \
    main.cpp \
    media.cpp \
    ncov.cpp \
    notification.cpp \
    weather.cpp

RESOURCES += app.qrc

VERSION = 0.5.0

windows {
    RC_ICONS = res/icons/app_icon.ico
}

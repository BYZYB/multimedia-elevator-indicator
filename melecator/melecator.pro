CONFIG += \
    c++latest \
    ltcg \
    optimize_full

HEADERS += \
    media.h \
    notification.h \
    weather.h

QT += \
    multimedia \
    multimediawidgets \
    quick \
    quickcontrols2

SOURCES += \
    main.cpp \
    media.cpp \
    notification.cpp \
    weather.cpp

RESOURCES += app.qrc

windows {
    RC_ICONS = res/icons/app_icon.ico
}

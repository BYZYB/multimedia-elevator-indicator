QT += quick

CONFIG += c++latest

SOURCES += main.cpp \
    notification.cpp \
    weather.cpp

RC_ICONS += res/app.ico

RESOURCES += \
    app.qrc \
    res.qrc

# Default rules for deployment.
unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

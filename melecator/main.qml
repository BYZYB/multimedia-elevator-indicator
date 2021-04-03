import QtMultimedia 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    minimumHeight: 720
    minimumWidth: 1280
    title: "电梯多媒体指示系统 - " + width + "×" + height
    visible: true

    Rectangle {
        id: background_player

        anchors {
            left: parent.left
            leftMargin: 16
            top: parent.top
            topMargin: 16
        }
        color: "#80000000"
        height: parent.height - background_datetime.height - background_weather.height - 48
        radius: 8
        width: parent.width * 2 / 3 - 32

        BusyIndicator {
            id: indicator_player

            anchors.centerIn: parent
        }

        VideoOutput {
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
            source: MediaPlayer {
                id: media_player

                playlist: Playlist {
                    id: list_player

                    playbackMode: Playlist.Random
                }
            }
        }

        Button {
            id: button_next

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            height: parent.height / 5
            icon.source: "qrc:/res/icons/player/next.png"
            opacity: 0.5
            visible: false
            width: height * 2 / 3

            ToolTip {
                text: "下一个"
                timeout: 3000
                visible: button_next.hovered || button_next.pressed
            }

            onClicked: {
                list_player.next()
            }
        }

        Button {
            id: button_previous

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            height: button_next.height
            icon.source: "qrc:/res/icons/player/previous.png"
            opacity: 0.5
            visible: false
            width: button_next.width

            ToolTip {
                text: "上一个"
                timeout: 3000
                visible: button_previous.hovered || button_previous.pressed
            }

            onClicked: {
                list_player.previous()
            }
        }

        Text {
            id: text_player

            anchors.centerIn: parent
            color: "#ffffff"
            font.pixelSize: parent.height / 8
            text: "⚠ 无媒体文件"
            visible: false
        }

        Timer {
            id: timer_player

            interval: 3600000
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                Media.read_media_file()
                var video_amount = Media.get_video_amount(
                            ), video_path = Media.get_video_path()
                list_player.clear()

                if (video_amount > 0) {
                    for (var i = 0; i < video_amount; i++) {
                        list_player.addItem(video_path[i])
                    }

                    button_previous.visible = button_next.visible = true
                    text_player.visible = false
                    media_player.play()
                } else {
                    button_previous.visible = button_next.visible = false
                    text_player.visible = true
                    media_player.stop()
                }

                indicator_player.destroy()
            }
        }
    }

    Rectangle {
        id: background_weather

        anchors {
            left: background_player.left
            top: background_player.bottom
            topMargin: 16
        }
        color: "#80000000"
        height: (parent.height - background_datetime.height) / 4
        radius: 8
        width: parent.width / 3 - 24

        BusyIndicator {
            id: indicator_weather

            anchors.centerIn: parent
        }

        SwipeView {
            id: swipeview_weather

            anchors.fill: parent
            clip: true

            Item {
                Row {
                    anchors.fill: parent

                    Item {
                        id: item_weather_current_left

                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height - 32
                        width: parent.width / 3

                        Image {
                            id: image_weather_current

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                            }
                            fillMode: Image.PreserveAspectFit
                            height: parent.height * 2 / 3
                        }

                        Text {
                            id: text_weather_current_city

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: image_weather_current.height / 3
                                weight: Font.Bold
                            }
                        }
                    }

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        height: item_weather_current_left.height
                        width: parent.width - item_weather_current_left.width

                        Text {
                            id: text_weather_current_title

                            color: "#ffffff"
                            font {
                                pixelSize: text_weather_current_city.font.pixelSize
                                weight: Font.Bold
                            }
                        }

                        Text {
                            id: text_weather_current_realtime

                            anchors {
                                bottom: parent.bottom
                                bottomMargin: -parent.height / 9
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: image_weather_current.height
                                weight: Font.Light
                            }
                        }

                        Item {
                            id: item_weather_current_humidity

                            anchors {
                                left: text_weather_current_realtime.right
                                leftMargin: parent.width / 9
                                top: text_weather_current_title.bottom
                            }
                            height: (parent.height - text_weather_current_title.height) / 2
                            width: parent.width - text_weather_current_realtime.width

                            Image {
                                id: image_weather_current_humidity

                                anchors.verticalCenter: parent.verticalCenter
                                fillMode: Image.PreserveAspectFit
                                height: parent.height * 2 / 3
                                source: "qrc:/res/icons/weather/humidity.png"
                                visible: false
                            }

                            Text {
                                id: text_weather_current_humidity

                                anchors {
                                    left: image_weather_current_humidity.right
                                    leftMargin: 8
                                    verticalCenter: image_weather_current_humidity.verticalCenter
                                }
                                color: "#ffffff"
                                font.pixelSize: image_weather_current_humidity.height
                            }
                        }

                        Item {
                            anchors {
                                left: item_weather_current_humidity.left
                                top: item_weather_current_humidity.bottom
                            }
                            height: item_weather_current_humidity.height
                            width: item_weather_current_humidity.width

                            Image {
                                id: image_weather_current_windpower

                                anchors.verticalCenter: parent.verticalCenter
                                fillMode: Image.PreserveAspectFit
                                height: image_weather_current_humidity.height
                                source: "qrc:/res/icons/weather/wind.png"
                                visible: false
                            }

                            Text {
                                id: text_weather_current_windpower

                                anchors {
                                    left: image_weather_current_windpower.right
                                    leftMargin: 8
                                    verticalCenter: image_weather_current_windpower.verticalCenter
                                }
                                color: "#ffffff"
                                font.pixelSize: image_weather_current_windpower.height
                            }
                        }
                    }
                }
            }

            Item {
                Row {
                    anchors.fill: parent

                    Item {
                        id: item_weather_forecast_0

                        anchors.verticalCenter: parent.verticalCenter
                        height: parent.height - 32
                        width: parent.width / 4

                        Text {
                            id: text_weather_forecast_0_date

                            anchors {
                                horizontalCenter: image_weather_forecast_0.horizontalCenter
                                top: parent.top
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: parent.height / 6
                                weight: Font.Bold
                            }
                            text: "今 天"
                        }

                        Image {
                            id: image_weather_forecast_0

                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            height: parent.height / 2.5
                        }

                        Text {
                            id: text_weather_forecast_0_temperature

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: image_weather_forecast_0.horizontalCenter
                            }
                            color: "#ffffff"
                            font.pixelSize: text_weather_forecast_0_date.font.pixelSize
                        }
                    }

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        height: item_weather_forecast_0.height
                        width: item_weather_forecast_0.width

                        Text {
                            id: text_weather_forecast_1_date

                            anchors {
                                horizontalCenter: image_weather_forecast_1.horizontalCenter
                                top: parent.top
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_weather_forecast_0_date.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "明 天"
                        }

                        Image {
                            id: image_weather_forecast_1

                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            height: image_weather_forecast_0.height
                        }

                        Text {
                            id: text_weather_forecast_1_temperature

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: image_weather_forecast_1.horizontalCenter
                            }
                            color: "#ffffff"
                            font.pixelSize: text_weather_forecast_0_temperature.font.pixelSize
                        }
                    }

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        height: item_weather_forecast_0.height
                        width: item_weather_forecast_0.width

                        Text {
                            id: text_weather_forecast_2_date

                            anchors {
                                horizontalCenter: image_weather_forecast_2.horizontalCenter
                                top: parent.top
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_weather_forecast_0_date.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "后 天"
                        }

                        Image {
                            id: image_weather_forecast_2

                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            height: image_weather_forecast_0.height
                        }

                        Text {
                            id: text_weather_forecast_2_temperature

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: image_weather_forecast_2.horizontalCenter
                            }
                            color: "#ffffff"
                            font.pixelSize: text_weather_forecast_0_temperature.font.pixelSize
                        }
                    }

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        height: item_weather_forecast_0.height
                        width: item_weather_forecast_0.width

                        Text {
                            id: text_weather_forecast_3_date

                            anchors {
                                horizontalCenter: image_weather_forecast_3.horizontalCenter
                                top: parent.top
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_weather_forecast_0_date.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "大后天"
                        }

                        Image {
                            id: image_weather_forecast_3

                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            height: image_weather_forecast_0.height
                        }

                        Text {
                            id: text_weather_forecast_3_temperature

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: image_weather_forecast_3.horizontalCenter
                            }
                            color: "#ffffff"
                            font.pixelSize: text_weather_forecast_0_temperature.font.pixelSize
                        }
                    }
                }
            }
        }

        PageIndicator {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            count: swipeview_weather.count
            currentIndex: swipeview_weather.currentIndex
        }

        Timer {
            id: timer_weather

            interval: 3600000
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                Weather.request_weather_data()

                if (Weather.is_weather_available()) {
                    var weather_current = Weather.get_weather_current(
                                ), weather_forecast = Weather.get_weather_forecast()
                    image_weather_current.source = Weather.get_weather_image(0)
                    image_weather_forecast_0.source = Weather.get_weather_image(
                                1, 0)
                    image_weather_forecast_1.source = Weather.get_weather_image(
                                1, 1)
                    image_weather_forecast_2.source = Weather.get_weather_image(
                                1, 2)
                    image_weather_forecast_3.source = Weather.get_weather_image(
                                1, 3)
                    image_weather_current_humidity.visible
                            = image_weather_current_windpower.visible = true
                    text_weather_current_city.text = weather_current["city"]
                    text_weather_current_title.text = weather_current["weather"]
                            + " | " + weather_forecast[0]["nighttemp"] + "°~"
                            + weather_forecast[0]["daytemp"] + "°"
                    text_weather_current_realtime.text = weather_current["temperature"]
                    text_weather_current_humidity.text = weather_current["humidity"] + "%"
                    text_weather_current_windpower.text = weather_current["windpower"] + " 级"
                    text_weather_forecast_0_temperature.text = weather_forecast[0]["nighttemp"]
                            + "°/" + weather_forecast[0]["daytemp"] + "°"
                    text_weather_forecast_1_temperature.text = weather_forecast[1]["nighttemp"]
                            + "°/" + weather_forecast[1]["daytemp"] + "°"
                    text_weather_forecast_2_temperature.text = weather_forecast[2]["nighttemp"]
                            + "°/" + weather_forecast[2]["daytemp"] + "°"
                    text_weather_forecast_3_temperature.text = weather_forecast[3]["nighttemp"]
                            + "°/" + weather_forecast[3]["daytemp"] + "°"
                } else {
                    image_weather_current.source = image_weather_forecast_0.source
                            = image_weather_forecast_1.source = image_weather_forecast_2.source
                            = image_weather_forecast_3.source = "qrc:/res/icons/weather/unknown.png"
                    image_weather_current_humidity.visible
                            = image_weather_current_windpower.visible = false
                    text_weather_current_city.text = "无数据"
                    text_weather_current_title.text = text_weather_current_realtime.text
                            = text_weather_current_humidity.text
                            = text_weather_current_windpower.text = ""
                    text_weather_forecast_0_temperature.text
                            = text_weather_forecast_1_temperature.text
                            = text_weather_forecast_2_temperature.text
                            = text_weather_forecast_3_temperature.text = "--°/--°"
                }

                indicator_weather.destroy()
            }
        }
    }

    Rectangle {
        id: background_calendar

        anchors {
            right: background_player.right
            top: background_player.bottom
            topMargin: 16
        }
        color: "#80000000"
        height: background_weather.height
        radius: 8
        width: background_weather.width

        SwipeView {
            id: swipeview_calendar

            anchors.fill: parent
            clip: true

            Item {}

            Item {}
        }

        PageIndicator {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            count: swipeview_calendar.count
            currentIndex: swipeview_calendar.currentIndex
        }
    }

    Rectangle {
        id: background_datetime

        anchors.bottom: parent.bottom
        clip: true
        color: "#bfff0000"
        height: parent.height / 9 - 16
        width: parent.width / 8

        BusyIndicator {
            id: indicator_datetime

            anchors.centerIn: parent
        }

        Text {
            id: text_datetime

            anchors.centerIn: parent
            color: "#ffffff"
            font {
                pixelSize: parent.height / 3
                weight: Font.Medium
            }
            horizontalAlignment: Text.AlignHCenter
        }

        Timer {
            id: timer_datetime

            interval: 60000
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                text_datetime.text = Qt.formatDateTime(new Date(),
                                                       "AP HH:mm\nyyyy-MM-dd")
                indicator_datetime.destroy()
            }
        }
    }

    Rectangle {
        id: background_scrolling_notification

        anchors {
            bottom: parent.bottom
            left: background_datetime.right
        }
        clip: true
        color: "#bf000000"
        height: background_datetime.height
        width: parent.width - background_datetime.width

        BusyIndicator {
            id: indicator_scrolling_notification

            anchors.centerIn: parent
        }

        Text {
            id: text_scrolling_notification

            anchors.verticalCenter: parent.verticalCenter
            color: "#ffffff"
            font.pixelSize: parent.height / 2
            verticalAlignment: Text.AlignVCenter

            onTextChanged: {
                anim_text_scrolling_notification.restart()
            }

            SequentialAnimation on x {
                id: anim_text_scrolling_notification

                loops: Animation.Infinite

                PropertyAnimation {
                    duration: 60000
                    from: background_scrolling_notification.width
                    to: -text_scrolling_notification.width
                }
            }
        }

        Timer {
            id: timer_scrolling_notification

            interval: 1800000
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                Notification.read_notification_file()
                text_scrolling_notification.text = Notification.get_notification_merged()
                indicator_scrolling_notification.destroy()
            }
        }
    }

    Timer {
        id: timer_async_0

        interval: 500
        running: true

        onTriggered: {
            timer_datetime.start()
            timer_async_0.destroy()
        }
    }

    Timer {
        id: timer_async_1

        interval: 1000
        running: true

        onTriggered: {
            timer_scrolling_notification.start()
            timer_async_1.destroy()
        }
    }

    Timer {
        id: timer_async_2

        interval: 1500
        running: true

        onTriggered: {
            timer_player.start()
            timer_async_2.destroy()
        }
    }

    Timer {
        id: timer_async_3

        interval: 2000
        running: true

        onTriggered: {
            timer_weather.start()
            timer_async_3.destroy()
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.75;height:720;width:1280}
}
##^##*/


import QtMultimedia 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    minimumHeight: 720
    minimumWidth: 1280
    title: "电梯多媒体指示系统"
    visible: true

    Flow {
        id: panel_media
        height: parent.height - panel_datetime_scrolling.height
        padding: 16
        spacing: 16
        width: parent.width * 2 / 3

        Rectangle {
            id: background_player
            color: "#80000000"
            height: panel_media.height - background_weather.height - 48
            radius: 8
            width: panel_media.width - 32

            BusyIndicator {
                id: indicator_player
                anchors.centerIn: background_player
            }

            VideoOutput {
                anchors.fill: background_player
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
                anchors.right: background_player.right
                anchors.verticalCenter: background_player.verticalCenter
                height: background_player.height / 5
                icon.source: "qrc:/res/icons/player/next.png"
                opacity: 0.5
                ToolTip.text: "下一个"
                ToolTip.timeout: 3000
                ToolTip.visible: hovered || pressed
                visible: false
                width: height * 2 / 3
                onClicked: {
                    list_player.next()
                }
            }

            Button {
                id: button_previous
                anchors.left: background_player.left
                anchors.verticalCenter: background_player.verticalCenter
                height: background_player.height / 5
                icon.source: "qrc:/res/icons/player/previous.png"
                opacity: 0.5
                ToolTip.text: "上一个"
                ToolTip.timeout: 3000
                ToolTip.visible: hovered || pressed
                visible: false
                width: height * 2 / 3
                onClicked: {
                    list_player.previous()
                }
            }

            Text {
                id: text_player
                anchors.centerIn: background_player
                color: "#ffffff"
                font.pixelSize: background_player.height / 8
                text: "🚫 无媒体文件"
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
                }
            }
        }

        Rectangle {
            id: background_weather
            color: "#80000000"
            height: panel_media.height / 4
            radius: 8
            width: panel_media.width / 2 - 24

            BusyIndicator {
                id: indicator_weather
                anchors.centerIn: background_weather
            }

            SwipeView {
                id: swipeview_weather
                anchors.fill: background_weather
                clip: true

                Item {
                    Image {
                        id: image_weather_current
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                        height: parent.height * 2 / 3
                    }

                    Text {
                        id: text_weather_current
                        anchors.left: image_weather_current.right
                        anchors.leftMargin: parent.width / 16
                        anchors.top: parent.top
                        anchors.topMargin: 16
                        color: "#ffffff"
                        font.pixelSize: parent.height / 6
                        font.weight: Font.Bold
                        lineHeight: height
                    }

                    Text {
                        id: text_weather_current_realtime
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 16
                        anchors.left: text_weather_current.left
                        color: "#ffffff"
                        font.pixelSize: parent.height / 2
                        font.weight: Font.Light
                    }

                    Image {
                        id: image_weather_current_humidity
                        anchors.left: text_weather_current_realtime.right
                        anchors.leftMargin: parent.width / 16
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -text_weather_current_humidity.height / 2 - 6
                        fillMode: Image.PreserveAspectFit
                        height: parent.height / 6
                        source: "qrc:/res/icons/weather/humidity.png"
                        visible: false
                    }

                    Text {
                        id: text_weather_current_humidity
                        anchors.left: image_weather_current_humidity.right
                        anchors.leftMargin: 8
                        anchors.top: image_weather_current_humidity.top
                        anchors.topMargin: -8
                        color: "#ffffff"
                        font.pixelSize: parent.height / 6
                        lineHeight: height
                    }

                    Image {
                        id: image_weather_current_windpower
                        anchors.left: image_weather_current_humidity.left
                        anchors.top: image_weather_current_humidity.bottom
                        anchors.topMargin: 12
                        fillMode: Image.PreserveAspectFit
                        height: parent.height / 6
                        source: "qrc:/res/icons/weather/wind.png"
                        visible: false
                    }

                    Text {
                        id: text_weather_current_windpower
                        anchors.left: image_weather_current_windpower.right
                        anchors.leftMargin: 8
                        anchors.top: image_weather_current_windpower.top
                        anchors.topMargin: -8
                        color: "#ffffff"
                        font.pixelSize: parent.height / 6
                        lineHeight: height
                    }
                }

                Item {
                    Row {
                        anchors.fill: parent
                        padding: 16

                        Item {
                            height: parent.height - 32
                            width: (parent.width - 32) / 4

                            Text {
                                id: text_weather_forecast_0_date
                                anchors.horizontalCenter: image_weather_forecast_0.horizontalCenter
                                anchors.top: parent.top
                                color: "#ffffff"
                                font.pixelSize: parent.height / 6
                                font.weight: Font.Bold
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
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: image_weather_forecast_0.horizontalCenter
                                color: "#ffffff"
                                font.pixelSize: parent.height / 6
                            }
                        }

                        Item {
                            height: parent.height - 32
                            width: (parent.width - 32) / 4

                            Text {
                                id: text_weather_forecast_1_date
                                anchors.horizontalCenter: image_weather_forecast_1.horizontalCenter
                                anchors.top: parent.top
                                color: "#ffffff"
                                font.pixelSize: parent.height / 6
                                font.weight: Font.Bold
                                text: "明 天"
                            }

                            Image {
                                id: image_weather_forecast_1
                                anchors.centerIn: parent
                                fillMode: Image.PreserveAspectFit
                                height: parent.height / 2.5
                            }

                            Text {
                                id: text_weather_forecast_1_temperature
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: image_weather_forecast_1.horizontalCenter
                                color: "#ffffff"
                                font.pixelSize: parent.height / 6
                            }
                        }

                        Item {
                            height: parent.height - 32
                            width: (parent.width - 32) / 4

                            Text {
                                id: text_weather_forecast_2_date
                                anchors.horizontalCenter: image_weather_forecast_2.horizontalCenter
                                anchors.top: parent.top
                                color: "#ffffff"
                                font.pixelSize: parent.height / 6
                                font.weight: Font.Bold
                                text: "后 天"
                            }

                            Image {
                                id: image_weather_forecast_2
                                anchors.centerIn: parent
                                fillMode: Image.PreserveAspectFit
                                height: parent.height / 2.5
                            }

                            Text {
                                id: text_weather_forecast_2_temperature
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: image_weather_forecast_2.horizontalCenter
                                color: "#ffffff"
                                font.pixelSize: parent.height / 6
                            }
                        }

                        Item {
                            height: parent.height - 32
                            width: (parent.width - 32) / 4

                            Text {
                                id: text_weather_forecast_3_date
                                anchors.horizontalCenter: image_weather_forecast_3.horizontalCenter
                                anchors.top: parent.top
                                color: "#ffffff"
                                font.pixelSize: parent.height / 6
                                font.weight: Font.Bold
                                text: "大后天"
                            }

                            Image {
                                id: image_weather_forecast_3
                                anchors.centerIn: parent
                                fillMode: Image.PreserveAspectFit
                                height: parent.height / 2.5
                            }

                            Text {
                                id: text_weather_forecast_3_temperature
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: image_weather_forecast_3.horizontalCenter
                                color: "#ffffff"
                                font.pixelSize: parent.height / 6
                            }
                        }
                    }
                }
            }

            PageIndicator {
                anchors.bottom: background_weather.bottom
                anchors.horizontalCenter: background_weather.horizontalCenter
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
                        image_weather_current.source = Weather.get_weather_image(
                                    0)
                        image_weather_forecast_0.source = image_weather_current.source
                                = Weather.get_weather_image(1, 0)
                        image_weather_forecast_1.source = image_weather_current.source
                                = Weather.get_weather_image(1, 1)
                        image_weather_forecast_2.source = image_weather_current.source
                                = Weather.get_weather_image(1, 2)
                        image_weather_forecast_3.source = image_weather_current.source
                                = Weather.get_weather_image(1, 3)
                        image_weather_current_humidity.visible
                                = image_weather_current_windpower.visible = true
                        text_weather_current.text = weather_current["weather"]
                                + " | " + weather_forecast[0]["nighttemp"]
                                + "° ~ " + weather_forecast[0]["daytemp"] + "°"
                        text_weather_current_realtime.text = weather_current["temperature"]
                        text_weather_current_humidity.text = weather_current["humidity"] + "%"
                        text_weather_current_windpower.text = weather_current["windpower"] + "级"
                        text_weather_forecast_0_temperature.text = weather_forecast[0]["nighttemp"]
                                + "°/" + weather_forecast[0]["daytemp"] + "°"
                        text_weather_forecast_1_temperature.text = weather_forecast[1]["nighttemp"]
                                + "°/" + weather_forecast[1]["daytemp"] + "°"
                        text_weather_forecast_2_temperature.text = weather_forecast[2]["nighttemp"]
                                + "°/" + weather_forecast[2]["daytemp"] + "°"
                        text_weather_forecast_3_temperature.text = weather_forecast[3]["nighttemp"]
                                + "°/" + weather_forecast[3]["daytemp"] + "°"
                    } else {
                        image_weather_current.source = "qrc:/res/icons/weather/unknown.png"
                        image_weather_current_humidity.visible
                                = image_weather_current_windpower.visible = false
                        text_weather_current.text = text_weather_current_realtime.text
                                = text_weather_current_humidity.text
                                = text_weather_current_windpower.text = ""
                    }
                }
            }
        }

        Rectangle {
            id: background_calendar
            color: "#80000000"
            height: panel_media.height / 4
            radius: 8
            width: panel_media.width / 2 - 24

            SwipeView {
                id: swipeview_right
                anchors.fill: background_calendar
                clip: true

                Item {}

                Item {}
            }

            PageIndicator {
                anchors.bottom: background_calendar.bottom
                anchors.horizontalCenter: background_calendar.horizontalCenter
                count: swipeview_right.count
                currentIndex: swipeview_right.currentIndex
            }
        }
    }

    Flow {
        id: panel_elevator
        height: parent.height - panel_datetime_scrolling.height
        padding: 16
        spacing: 16
        width: parent.width - panel_media.width
        x: parent.width * 2 / 3

        Item {
            height: panel_elevator.height / 10
            width: panel_elevator.width - 32

            Text {
                id: text_elevator_demomode
                anchors.verticalCenter: parent.verticalCenter
                color: "#80000000"
                font.pixelSize: parent.height / 2
                text: "调试"
            }

            Button {
                id: button_elevator_menu
                anchors.right: button_elevator_exit.left
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height * 4 / 5
                icon.source: "qrc:/res/icons/elevator/settings.png"
                text: "设置"
            }

            Button {
                id: button_elevator_exit
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height * 4 / 5
                icon.source: "qrc:/res/icons/elevator/close-window.png"
                text: "退出"
                onClicked: {
                    Qt.quit()
                }
            }
        }
    }

    Row {
        id: panel_datetime_scrolling
        height: parent.height / 9 - 16
        width: parent.width
        y: parent.height - height

        Rectangle {
            id: background_datetime
            color: "#bfff0000"
            height: panel_datetime_scrolling.height
            width: panel_datetime_scrolling.width / 8

            BusyIndicator {
                id: indicator_datetime
                anchors.centerIn: background_datetime
            }

            Text {
                id: text_datetime
                anchors.centerIn: background_datetime
                color: "#ffffff"
                font.pixelSize: background_datetime.height / 3
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Timer {
                id: timer_datetime
                interval: 60000
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    text_datetime.text = Qt.formatDateTime(
                                new Date(), "AP HH:mm\nyyyy-MM-dd")
                }
            }
        }

        Rectangle {
            id: background_scrolling_notification
            clip: true
            color: "#bf000000"
            height: panel_datetime_scrolling.height
            width: panel_datetime_scrolling.width - background_datetime.width

            BusyIndicator {
                id: indicator_scrolling_notification
                anchors.centerIn: background_scrolling_notification
            }

            Text {
                id: text_scrolling_notification
                anchors.verticalCenter: background_scrolling_notification.verticalCenter
                color: "#ffffff"
                font.pixelSize: background_scrolling_notification.height / 2
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
                }
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
            indicator_datetime.destroy()
        }
    }

    Timer {
        id: timer_async_1
        interval: 1000
        running: true
        onTriggered: {
            timer_scrolling_notification.start()
            timer_async_1.destroy()
            indicator_scrolling_notification.destroy()
        }
    }

    Timer {
        id: timer_async_2
        interval: 1500
        running: true
        onTriggered: {
            timer_player.start()
            timer_async_2.destroy()
            indicator_player.destroy()
        }
    }

    Timer {
        id: timer_async_3
        interval: 2000
        running: true
        onTriggered: {
            timer_weather.start()
            timer_async_3.destroy()
            indicator_weather.destroy()
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/


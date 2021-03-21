import QtCharts 2.3
import QtMultimedia 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 1280
    height: 720
    minimumWidth: 1280
    minimumHeight: 720
    title: "电梯多媒体指示系统"
    visible: true

    Flow {
        id: panel_media
        x: 0
        y: 0
        width: parent.width - panel_elevator.width
        height: parent.height - panel_datetime_scrolling.height
        padding: 16
        spacing: 16

        Rectangle {
            id: background_player
            width: panel_media.width - panel_media.spacing * 2
            height: panel_media.height - background_weather.height - panel_media.spacing * 3
            color: "#80000000"
            radius: 8

            BusyIndicator {
                id: indicator_player
                anchors.centerIn: parent
            }

            VideoOutput {
                id: videooutput_player
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
                width: height / 1.5
                height: background_player.height / 5
                visible: false
                anchors.right: background_player.right
                anchors.verticalCenter: background_player.verticalCenter
                font.pixelSize: height / 2
                icon.source: "qrc:/res/icons/player/next.png"
                opacity: 0.5
                ToolTip.text: "下一个"
                ToolTip.timeout: 3000
                ToolTip.visible: hovered || pressed
                onClicked: {
                    list_player.next()
                }
            }

            Button {
                id: button_previous
                width: button_next.width
                height: button_next.height
                visible: button_next.visible
                anchors.left: background_player.left
                anchors.verticalCenter: background_player.verticalCenter
                font.pixelSize: button_next.font.pixelSize
                icon.source: "qrc:/res/icons/player/previous.png"
                opacity: button_next.opacity
                ToolTip.text: "上一个"
                ToolTip.timeout: 3000
                ToolTip.visible: hovered || pressed
                onClicked: {
                    list_player.previous()
                }
            }

            Text {
                id: text_player
                text: "🚫 无媒体文件"
                height: background_player.height
                width: background_player.width
                color: "#ffffff"
                font.pixelSize: background_player.height / 8
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: false
            }

            Timer {
                id: timer_player
                interval: 3600000
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    Media.read_media_file()
                    var video_amount = Media.get_video_amount()
                    var video_path = Media.get_video_path()

                    if (video_amount > 0) {
                        for (var i = 0; i < video_amount; i++) {
                            list_player.addItem(video_path[i])
                        }

                        button_previous.visible = button_next.visible = true
                        media_player.play()
                    } else {
                        button_previous.visible = button_next.visible = false
                        text_player.visible = true
                        list_player.clear()
                        media_player.stop()
                    }
                }
            }
        }

        Rectangle {
            id: background_weather
            width: panel_media.width / 2 - panel_media.spacing * 1.5
            height: panel_media.height / 4
            color: background_player.color
            radius: background_player.radius

            SwipeView {
                id: swipeview_weather
                anchors.fill: background_weather
                clip: true

                Item {
                    BusyIndicator {
                        id: indicator_weather
                        anchors.centerIn: parent
                    }

                    Image {
                        id: image_weather
                        width: height
                        height: parent.height * 2 / 3
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Item {}
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
                        var weather_current = Weather.get_weather_current()
                        var weather_forecast = Weather.get_weather_forecast()
                        image_weather.source = Weather.get_weather_image(0)
                    } else {
                        image_weather.source = "qrc:/res/icons/weather/unknown.png"
                    }
                }
            }
        }

        Rectangle {
            id: background_calendar
            width: background_weather.width
            height: background_weather.height
            color: background_player.color
            radius: background_player.radius

            SwipeView {
                id: swipeview_right
                anchors.fill: background_calendar

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
        x: panel_media.width
        y: 0
        width: parent.width / 3
        height: panel_media.height
    }

    Row {
        id: panel_datetime_scrolling
        x: 0
        y: parent.height - height
        width: parent.width
        height: parent.height / 9 - panel_media.spacing

        Rectangle {
            id: background_datetime
            width: panel_datetime_scrolling.width / 8
            height: panel_datetime_scrolling.height
            color: "#bfff0000"

            BusyIndicator {
                id: indicator_datetime
                anchors.centerIn: background_datetime
            }

            Text {
                id: text_datetime
                height: background_datetime.height
                width: background_datetime.width
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
            width: panel_datetime_scrolling.width - background_datetime.width
            height: panel_datetime_scrolling.height
            clip: true
            color: "#bf000000"

            BusyIndicator {
                id: indicator_scrolling_notification
                anchors.centerIn: background_scrolling_notification
            }

            Text {
                id: text_scrolling_notification
                height: background_scrolling_notification.height
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
            indicator_datetime.destroy()
            timer_async_0.destroy()
        }
    }

    Timer {
        id: timer_async_1
        interval: 1000
        running: true
        onTriggered: {
            timer_scrolling_notification.start()
            indicator_scrolling_notification.destroy()
            timer_async_1.destroy()
        }
    }

    Timer {
        id: timer_async_2
        interval: 1500
        running: true
        onTriggered: {
            timer_player.start()
            indicator_player.destroy()
            timer_async_2.destroy()
        }
    }

    Timer {
        id: timer_async_3
        interval: 2000
        running: true
        onTriggered: {
            timer_weather.start()
            indicator_weather.destroy()
            timer_async_3.destroy()
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/


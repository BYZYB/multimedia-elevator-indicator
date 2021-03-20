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
            width: parent.width - parent.spacing * 2
            height: parent.height - background_weather.height - parent.spacing * 3
            color: "#80000000"
            radius: 8

            Text {
                id: text_player
                text: "▶ 点击播放"
                height: parent.height
                width: parent.width
                color: "#ffffff"
                font.pixelSize: parent.height / 8
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            VideoOutput {
                id: videooutput_player
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectCrop
                source: MediaPlayer {
                    id: media_player
                    playlist: Playlist {
                        id: list_player
                        playbackMode: Playlist.Random
                    }
                }

                MouseArea {
                    id: mousearea_player
                    anchors.fill: parent
                    onClicked: {
                        var video_amount = Media.get_video_amount()
                        var video_path = Media.get_video_path()

                        if (video_amount > 0) {
                            for (var i = 0; i < video_amount; i++) {
                                list_player.addItem(video_path[i])
                            }

                            button_previous.visible = button_next.visible = true
                            media_player.play()
                            text_player.destroy()
                            mousearea_player.destroy()
                        } else {
                            text_player.text = "🚫 无媒体文件"
                            button_previous.destroy()
                            button_next.destroy()
                            media_player.destroy()
                            videooutput_player.destroy()
                            mousearea_player.destroy()
                        }
                    }
                }
            }

            Button {
                id: button_next
                width: height / 1.5
                height: background_player.height / 5
                visible: false
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
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
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
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
        }

        Rectangle {
            id: background_weather
            width: parent.width / 2 - parent.spacing * 1.5
            height: parent.height / 4
            color: background_player.color
            radius: background_player.radius

            SwipeView {
                id: swipeview_weather
                anchors.fill: parent
                clip: true

                Item {
                    BusyIndicator {
                        id: indicator_weather
                        anchors.centerIn: parent
                    }

                    Image {
                        id: image_weather
                        width: height
                        height: parent.height - 32
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Timer {
                        interval: 1000
                        running: true
                        onTriggered: {
                            if (Weather.is_weather_available()) {
                                var weather_current = Weather.get_weather_current()
                                var weather_forecast = Weather.get_weather_forecast()
                                image_weather.source = Weather.get_weather_image(
                                            0)
                            } else {
                                image_weather.source = "qrc:/res/icons/weather/unknown.png"
                            }

                            indicator_weather.destroy()
                        }
                    }
                }

                Item {}
            }

            PageIndicator {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                count: swipeview_weather.count
                currentIndex: swipeview_weather.currentIndex
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
                anchors.fill: parent

                Item {}

                Item {}
            }

            PageIndicator {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
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
            width: parent.width / 8
            height: parent.height
            color: "#bfff0000"

            Text {
                id: text_datetime
                height: parent.height
                width: parent.width
                color: "#ffffff"
                font.pixelSize: parent.height / 3
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                Timer {
                    interval: 60000
                    repeat: true
                    running: true
                    triggeredOnStart: true
                    onTriggered: {
                        parent.text = Qt.formatDateTime(new Date(),
                                                        "AP HH:mm\nyyyy-MM-dd")
                    }
                }
            }
        }

        Rectangle {
            id: background_scrolling_notification
            width: parent.width - background_datetime.width
            height: parent.height
            clip: true
            color: "#bf000000"

            Text {
                id: text_scrolling_notification
                text: Notification.get_notification_merged()
                height: parent.height
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
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/


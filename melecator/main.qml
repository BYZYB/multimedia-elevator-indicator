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
                font.family: "Noto Sans CJK SC"
                font.pixelSize: parent.height / 8
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MediaPlayer {
                id: player
                playlist: Playlist {
                    id: list_player
                    playbackMode: Playlist.Random
                }
            }

            VideoOutput {
                id: videooutput_player
                source: player
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectCrop

                MouseArea {
                    id: mousearea_player
                    anchors.fill: parent
                    onClicked: {
                        var video_amount = media.get_video_amount()
                        var video_path = new Array(video_amount)

                        if (video_amount > 0) {
                            for (var i = 0; i < video_amount; i++) {
                                video_path[i] = media.get_video_path(i)
                            }

                            list_player.addItems(video_path)
                            button_back.visible = true
                            button_forward.visible = true
                            player.play()
                            text_player.destroy()
                            mousearea_player.destroy()
                        } else {
                            text_player.text = "🚫 无媒体文件"
                            button_back.destroy()
                            button_forward.destroy()
                            player.destroy()
                            videooutput_player.destroy()
                            mousearea_player.destroy()
                        }
                    }
                }
            }

            Button {
                id: button_back
                width: height / 1.5
                height: background_player.height / 5
                text: "<"
                visible: false
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: height / 2
                opacity: 0.5
                onClicked: {
                    list_player.previous()
                }
            }

            Button {
                id: button_forward
                width: height / 1.5
                height: background_player.height / 5
                text: ">"
                visible: false
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: height / 2
                opacity: 0.5
                onClicked: {
                    list_player.next()
                }
            }
        }

        Rectangle {
            id: background_weather
            width: parent.width / 2 - parent.spacing * 1.5
            height: parent.height / 4
            color: "#80000000"
            radius: 8
        }

        Rectangle {
            id: background_notification
            width: background_weather.width
            height: background_weather.height
            color: "#80000000"
            radius: 8
        }
    }

    Grid {
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
                font.family: "Noto Sans CJK SC"
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
                                                        "AP hh:mm\nyyyy-MM-dd")
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
                text: notification.get_all_notification()
                height: parent.height
                color: "#ffffff"
                font.family: "Noto Sans CJK SC"
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


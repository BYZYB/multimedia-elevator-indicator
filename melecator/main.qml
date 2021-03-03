import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 1280
    height: 720
    minimumWidth: 1280
    minimumHeight: 720
    title: "电梯多媒体指示系统"
    visible: true

    Grid {
        id: panel_media
        x: 0
        y: 0
        width: parent.width - panel_elevator.width
        height: parent.height - panel_datetime_scrolling.height
    }

    Grid {
        id: panel_elevator
        x: panel_media.width
        y: 0
        width: parent.width / 3
        height: parent.height - panel_datetime_scrolling.height
    }

    Row {
        id: panel_datetime_scrolling
        x: 0
        y: panel_elevator.height
        width: parent.width
        height: parent.height / 9

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
                font.pixelSize: parent.height / 3.2
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                Timer {
                    interval: 60000
                    repeat: true
                    running: true
                    triggeredOnStart: true
                    onTriggered: parent.text = Qt.formatDateTime(
                                     new Date(), "AP hh:mm\nyyyy-MM-dd")
                }
            }
        }

        Rectangle {
            id: background_scrolling
            width: parent.width - background_datetime.width
            height: parent.height
            clip: true
            color: "#bf000000"

            Text {
                id: text_scrolling
                text: notification.get_notification()
                height: parent.height
                color: "#ffffff"
                font.family: "Noto Sans CJK SC"
                font.pixelSize: parent.height / 2
                verticalAlignment: Text.AlignVCenter
                onTextChanged: anim_text_scrolling.running = true

                SequentialAnimation on x {
                    id: anim_text_scrolling
                    loops: Animation.Infinite
                    running: false

                    PropertyAnimation {
                        duration: text_scrolling.width * 3
                        from: background_scrolling.width
                        to: -text_scrolling.width
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


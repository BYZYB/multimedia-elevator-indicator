import QtMultimedia 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    minimumHeight: 720
    minimumWidth: 1280
    title: "电梯多媒体指示系统 - " + width + "×" + height
    visible: true

    Connections {
        target: Media

        function onMediaAvailable() {
            var video_amount = Media.get_video_amount(
                        ), video_path = Media.get_video_path()

            for (var i = 0; i < video_amount; i++) {
                list_media.addItem(video_path[i])
            }

            button_media_previous.visible = button_media_next.visible = true
            text_media.visible = false
            video_media.play()
            indicator_media.running = false
        }

        function onMediaUnavailable() {
            button_media_previous.visible = button_media_next.visible = false
            text_media.visible = true
            indicator_media.running = false
            dialog_media.open()
        }
    }

    Connections {
        target: Notification

        function onNotificationAvailable() {
            text_notification.text = Notification.get_notification_merged()
        }

        function onNotificationUnavailable() {
            text_notification.text = "🔕 无通知"
            dialog_notification.open()
        }
    }

    Connections {
        target: Weather

        function get_day_name(day) {
            switch (day) {
            case "1":
                return "星期一"
            case "2":
                return "星期二"
            case "3":
                return "星期三"
            case "4":
                return "星期四"
            case "5":
                return "星期五"
            case "6":
                return "星期六"
            case "7":
                return "星期日"
            default:
                return "——"
            }
        }

        function onWeatherAvailable() {
            var weather_current = Weather.get_weather_current(
                        ), weather_forecast = Weather.get_weather_forecast(
                               ), weather_forecast_0 = weather_forecast[0], weather_forecast_1 = weather_forecast[1], weather_forecast_2 = weather_forecast[2], weather_forecast_3 = weather_forecast[3], weather_forecast_0_daytemp = weather_forecast_0["daytemp"], weather_forecast_0_nighttemp = weather_forecast_0["nighttemp"]
            image_weather_current_humidity.visible = image_weather_current_windpower.visible = true
            image_weather_current.source = Weather.get_weather_image(false)
            image_weather_forecast_0.source = Weather.get_weather_image(true, 0)
            image_weather_forecast_1.source = Weather.get_weather_image(true, 1)
            image_weather_forecast_2.source = Weather.get_weather_image(true, 2)
            image_weather_forecast_3.source = Weather.get_weather_image(true, 3)
            text_weather_current_city.text = weather_current["city"]
            text_weather_current_title.text = weather_current["weather"] + " | "
                    + weather_forecast_0_nighttemp + "°~" + weather_forecast_0_daytemp
                    + "° | " + weather_current["winddirection"]
            text_weather_current_realtime.text = weather_current["temperature"]
            text_weather_current_humidity.text = weather_current["humidity"] + "%"
            text_weather_current_windpower.text = weather_current["windpower"] + " 级"
            text_weather_forecast_0_date.text = get_day_name(
                        weather_forecast_0["week"])
            text_weather_forecast_1_date.text = get_day_name(
                        weather_forecast_1["week"])
            text_weather_forecast_2_date.text = get_day_name(
                        weather_forecast_2["week"])
            text_weather_forecast_3_date.text = get_day_name(
                        weather_forecast_3["week"])
            text_weather_forecast_0_temperature.text = weather_forecast_0_nighttemp
                    + "°~" + weather_forecast_0_daytemp + "°"
            text_weather_forecast_1_temperature.text = weather_forecast_1["nighttemp"]
                    + "°~" + weather_forecast_1["daytemp"] + "°"
            text_weather_forecast_2_temperature.text = weather_forecast_2["nighttemp"]
                    + "°~" + weather_forecast_2["daytemp"] + "°"
            text_weather_forecast_3_temperature.text = weather_forecast_3["nighttemp"]
                    + "°~" + weather_forecast_3["daytemp"] + "°"
            indicator_weather.running = false
        }

        function onWeatherUnavailable() {
            image_weather_current_humidity.visible = image_weather_current_windpower.visible = false
            image_weather_current.source = image_weather_forecast_0.source
                    = image_weather_forecast_1.source = image_weather_forecast_2.source
                    = image_weather_forecast_3.source = "qrc:/res/icons/weather/unknown.png"
            text_weather_current_city.text = "无数据"
            text_weather_current_title.text = text_weather_current_realtime.text
                    = text_weather_current_humidity.text = text_weather_current_windpower.text = ""
            text_weather_forecast_0_date.text = text_weather_forecast_1_date.text
                    = text_weather_forecast_2_date.text = text_weather_forecast_3_date.text = "——"
            text_weather_forecast_0_temperature.text = text_weather_forecast_1_temperature.text
                    = text_weather_forecast_2_temperature.text
                    = text_weather_forecast_3_temperature.text = "--°/--°"
            indicator_weather.running = false
            dialog_weather.open()
        }
    }

    Rectangle {
        id: background_media

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

        Video {
            id: video_media

            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
            playlist: Playlist {
                id: list_media

                playbackMode: Playlist.Random
            }
        }

        Text {
            id: text_media

            anchors.centerIn: parent
            color: "#ffffff"
            font.pixelSize: parent.height / 8
            text: "⚠ 无媒体文件"
            visible: false
        }

        Button {
            id: button_media_next

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
                visible: button_media_next.hovered || button_media_next.pressed
            }

            onClicked: {
                list_media.next()
            }
        }

        Button {
            id: button_media_previous

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            height: button_media_next.height
            icon.source: "qrc:/res/icons/player/previous.png"
            opacity: 0.5
            visible: false
            width: button_media_next.width

            ToolTip {
                text: "上一个"
                timeout: 3000
                visible: button_media_previous.hovered
                         || button_media_previous.pressed
            }

            onClicked: {
                list_media.previous()
            }
        }

        BusyIndicator {
            id: indicator_media

            anchors.centerIn: parent
        }

        Timer {
            id: timer_media

            interval: 3600000
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                indicator_media.running = true
                video_media.stop()
                list_media.clear()
                Media.read_media_file()
            }
        }

        Component.onCompleted: {
            timer_media.start()
        }
    }

    Rectangle {
        id: background_weather

        anchors {
            left: background_media.left
            top: background_media.bottom
            topMargin: 16
        }
        color: "#80000000"
        height: (parent.height - background_datetime.height) / 4
        radius: 8
        width: parent.width / 3 - 24

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

        BusyIndicator {
            id: indicator_weather

            anchors.centerIn: parent
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
                indicator_weather.running = true
                Weather.request_weather_data("广州市")
            }
        }

        Component.onCompleted: {
            timer_weather.start()
        }
    }

    Rectangle {
        id: background_ncov

        anchors {
            right: background_media.right
            top: background_media.bottom
            topMargin: 16
        }
        color: "#80000000"
        height: background_weather.height
        radius: 8
        width: background_weather.width

        SwipeView {
            id: swipeview_ncov

            anchors.fill: parent
            clip: true

            Item {}

            Item {}
        }

        BusyIndicator {
            id: indicator_ncov

            anchors.centerIn: parent
        }

        PageIndicator {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }
            count: swipeview_ncov.count
            currentIndex: swipeview_ncov.currentIndex
        }

        Timer {
            id: timer_ncov

            interval: 3600000
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                indicator_ncov.running = true
            }
        }

        Component.onCompleted: {
            timer_ncov.start()
        }
    }

    Rectangle {
        id: background_datetime

        anchors.bottom: parent.bottom
        clip: true
        color: "#bfff0000"
        height: parent.height / 9 - 16
        width: parent.width / 8

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
                text_datetime.text = (new Date).toLocaleString(
                            Qt.locale(), "ddd HH:mm\nyyyy-MM-dd")
            }
        }

        Component.onCompleted: {
            timer_datetime.start()
        }
    }

    Rectangle {
        id: background_notification

        anchors {
            bottom: parent.bottom
            left: background_datetime.right
        }
        clip: true
        color: "#bf000000"
        height: background_datetime.height
        width: parent.width - background_datetime.width

        Text {
            id: text_notification

            anchors.verticalCenter: parent.verticalCenter
            color: "#ffffff"
            font.pixelSize: parent.height / 2
            verticalAlignment: Text.AlignVCenter

            onTextChanged: {
                anim_text_notification.restart()
            }

            SequentialAnimation on x {
                id: anim_text_notification

                loops: Animation.Infinite

                PropertyAnimation {
                    duration: 60000
                    from: background_notification.width
                    to: -text_notification.width
                }
            }
        }

        Timer {
            id: timer_notification

            interval: 1800000
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                Notification.read_notification_file()
            }
        }

        Component.onCompleted: {
            timer_notification.start()
        }
    }

    Dialog {
        id: dialog_media

        anchors.centerIn: parent
        focus: true
        height: parent.height / 3
        modal: true
        standardButtons: Dialog.Retry | Dialog.Cancel
        title: "⚠ 错误"
        width: parent.width / 3

        Text {
            anchors.fill: parent
            text: "获取媒体数据时发生异常，请检查应用程序输出以获取详细信息。\n\n是否重试？"
            wrapMode: Text.Wrap
        }

        onAccepted: {
            timer_media.restart()
        }

        onRejected: {
            timer_media.stop()
        }
    }

    Dialog {
        id: dialog_notification

        anchors.centerIn: parent
        focus: true
        height: dialog_media.height
        modal: true
        standardButtons: dialog_media.standardButtons
        title: "⚠ 错误"
        width: dialog_media.width

        Text {
            anchors.fill: parent
            text: "获取通知数据时发生异常，请检查应用程序输出以获取详细信息。\n\n是否重试？"
            wrapMode: Text.Wrap
        }

        onAccepted: {
            timer_notification.restart()
        }

        onRejected: {
            timer_notification.stop()
        }
    }

    Dialog {
        id: dialog_weather

        anchors.centerIn: parent
        focus: true
        height: dialog_media.height
        modal: true
        standardButtons: dialog_media.standardButtons
        title: "⚠ 错误"
        width: dialog_media.width

        Text {
            anchors.fill: parent
            text: "获取天气信息时发生异常，请检查应用程序输出以获取详细信息。\n\n是否重试？"
            wrapMode: Text.Wrap
        }

        onAccepted: {
            timer_weather.restart()
        }

        onRejected: {
            timer_weather.stop()
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:0.75;height:720;width:1280}
}
##^##*/


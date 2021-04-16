import QtMultimedia 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    minimumHeight: 720
    minimumWidth: 1280
    title: "Melecator - " + width + "×" + height
    visible: true

    Connections {
        target: Elevator

        function onElevatorStart() {
            var direction = Elevator.get_direction()
            image_elevator_direction.source = direction
                    > 0 ? direction === 1 ? "qrc:/res/icons/elevator/move-down.svg" : "qrc:/res/icons/elevator/move-up.svg" : "qrc:/res/icons/elevator/stop-left.svg"
            image_elevator_next_stop.source = direction
                    === 1 ? "qrc:/res/icons/elevator/stairs-down.svg" : "qrc:/res/icons/elevator/stairs-up.svg"
            progressbar_elevator_next_stop.value = Elevator.get_progress()
            text_elevator_capacity.text = Elevator.get_capacity() + "%"
            text_elevator_direction.text = direction
                    > 0 ? direction === 1 ? "正在下行" : "正在上行" : "左侧停靠"
            text_elevator_floor.text = Elevator.get_floor()
            text_elevator_next_stop.text = Elevator.get_next_stop()
            text_elevator_remain_time.text = Elevator.get_remain_time() + " 秒"
        }
    }

    Connections {
        target: Media

        function onMediaAvailable() {
            button_media_previous.visible = button_media_next.visible = true
            text_media.visible = false
            list_media.addItems(Media.get_url())
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
        target: Ncov

        function onNcovAvailable() {
            var ncov_capital = Ncov.get_capital_data(
                        ), ncov_capital_mid = ncov_capital["midDangerCount"], ncov_capital_high = ncov_capital["highDangerCount"], ncov_province = Ncov.get_province_data()
            text_ncov_capital_0_title.visible = text_ncov_capital_1_title.visible
                    = text_ncov_capital_2_title.visible = text_ncov_capital_3_title.visible
                    = text_ncov_province_0_title.visible = text_ncov_province_1_title.visible
                    = text_ncov_province_2_title.visible = text_ncov_province_3_title.visible = true
            text_ncov_province_title.text = "新冠疫情数据 | " + ncov_province["provinceName"]
            text_ncov_province_title_time.text = "🕓 更新时间 | "
                    + new Date(ncov_province["updateTime"]).toLocaleString(
                        Qt.locale(), "M月d日 HH:mm")
            text_ncov_province_0_number.text = ncov_province["currentConfirmedCount"]
            text_ncov_province_1_number.text = ncov_province["suspectedCount"]
            text_ncov_province_2_number.text = ncov_province["curedCount"]
            text_ncov_province_3_number.text = ncov_province["deadCount"]
            text_ncov_capital_title.text = text_ncov_province_title.text + " > "
                    + ncov_capital["cityName"]
            text_ncov_capital_title_risk.text = "📊 防控状况 | "
                    + (ncov_capital_high > 0 ? ncov_capital_high + " 个高风险地区" : ncov_capital_mid
                                               > 0 ? ncov_capital_mid + " 个中风险地区" : "低风险")
            text_ncov_capital_0_number.text = ncov_capital["currentConfirmedCount"]
            text_ncov_capital_1_number.text = ncov_capital["suspectedCount"]
            text_ncov_capital_2_number.text = ncov_capital["curedCount"]
            text_ncov_capital_3_number.text = ncov_capital["deadCount"]
            indicator_ncov.running = false
        }

        function onNcovUnavailable() {
            text_ncov_capital_0_title.visible = text_ncov_capital_1_title.visible
                    = text_ncov_capital_2_title.visible = text_ncov_capital_3_title.visible
                    = text_ncov_province_0_title.visible = text_ncov_province_1_title.visible
                    = text_ncov_province_2_title.visible
                    = text_ncov_province_3_title.visible = false
            text_ncov_capital_title.text = text_ncov_province_title.text = "⚠ 无数据"
            text_ncov_capital_title_risk.text = text_ncov_capital_0_number.text
                    = text_ncov_capital_1_number.text = text_ncov_capital_2_number.text
                    = text_ncov_capital_3_number.text = text_ncov_province_title_time.text
                    = text_ncov_province_0_number.text = text_ncov_province_1_number.text
                    = text_ncov_province_2_number.text = text_ncov_province_3_number.text = ""
            indicator_ncov.running = false
            dialog_ncov.open()
        }
    }

    Connections {
        target: Notification

        function onNotificationAvailable() {
            text_notification.text = Notification.get_data_merged()
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
            var weather_current = Weather.get_current_data(
                        ), weather_forecast = Weather.get_forecast_data(
                               ), weather_forecast_0 = weather_forecast[0], weather_forecast_0_daytemp = weather_forecast_0["daytemp"], weather_forecast_0_nighttemp = weather_forecast_0["nighttemp"], weather_forecast_1 = weather_forecast[1], weather_forecast_2 = weather_forecast[2], weather_forecast_3 = weather_forecast[3]
            image_weather_current_humidity.visible = image_weather_current_windpower.visible = true
            image_weather_current.source = Weather.get_image_url(false)
            image_weather_forecast_0.source = Weather.get_image_url(true, 0)
            image_weather_forecast_1.source = Weather.get_image_url(true, 1)
            image_weather_forecast_2.source = Weather.get_image_url(true, 2)
            image_weather_forecast_3.source = Weather.get_image_url(true, 3)
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
                    = image_weather_forecast_3.source = "qrc:/res/icons/weather/cloudy-alert.svg"
            text_weather_current_city.text = "无数据"
            text_weather_current_title.text = text_weather_current_realtime.text
                    = text_weather_current_humidity.text = text_weather_current_windpower.text = ""
            text_weather_forecast_0_date.text = text_weather_forecast_1_date.text
                    = text_weather_forecast_2_date.text = text_weather_forecast_3_date.text = "--"
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

                onCurrentIndexChanged: {
                    animation_video_media.start()
                }
            }

            ParallelAnimation {
                id: animation_video_media

                PropertyAnimation {
                    duration: 500
                    easing.type: Easing.InOutCubic
                    from: 0
                    property: "opacity"
                    target: video_media
                    to: 1
                }

                PropertyAnimation {
                    duration: 500
                    easing.type: Easing.InOutCubic
                    from: 0.85
                    property: "scale"
                    target: video_media
                    to: 1
                }
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
            icon.source: "qrc:/res/icons/player/next.svg"
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
            icon.source: "qrc:/res/icons/player/previous.svg"
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
                Media.read_file()
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
                            sourceSize {
                                height: parent.height * 2 / 3
                                width: height
                            }
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
                                source: "qrc:/res/icons/weather/humidity.svg"
                                sourceSize {
                                    height: parent.height * 2 / 3
                                    width: height
                                }
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
                                source: "qrc:/res/icons/weather/windsock.svg"
                                sourceSize {
                                    height: image_weather_current_humidity.height
                                    width: height
                                }
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
                            sourceSize {
                                height: parent.height / 2.5
                                width: height
                            }
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
                            sourceSize {
                                height: image_weather_forecast_0.height
                                width: height
                            }
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
                            sourceSize {
                                height: image_weather_forecast_0.height
                                width: height
                            }
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
                            sourceSize {
                                height: image_weather_forecast_0.height
                                width: height
                            }
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
                Weather.request_data("广州市")
            }
        }

        Component.onCompleted: {
            timer_weather.start()
        }
    }

    Rectangle {
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

            Item {
                Text {
                    id: text_ncov_province_title

                    anchors {
                        left: parent.left
                        leftMargin: 16
                        top: parent.top
                        topMargin: 16
                    }
                    color: "#ffffff"
                    font {
                        pixelSize: parent.height / 6
                        weight: Font.Bold
                    }
                }

                Text {
                    id: text_ncov_province_title_time

                    anchors {
                        left: text_ncov_province_title.left
                        top: text_ncov_province_title.bottom
                    }
                    color: "#ffffff"
                    font {
                        pixelSize: parent.height / 9
                        weight: Font.Medium
                    }
                }

                Row {
                    anchors.top: text_ncov_province_title_time.bottom
                    height: parent.height - text_ncov_province_title.height
                            - text_ncov_province_title_time.height - 32
                    width: parent.width

                    Item {
                        id: item_ncov_province_0

                        height: parent.height
                        width: parent.width / 4

                        Text {
                            id: text_ncov_province_0_number

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                                topMargin: -parent.height / 12
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: parent.height / 2
                                weight: Font.Medium
                            }
                        }

                        Text {
                            id: text_ncov_province_0_title

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_province_title_time.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "现存确诊"
                            visible: false
                        }
                    }

                    Item {
                        height: item_ncov_province_0.height
                        width: item_ncov_province_0.width

                        Text {
                            id: text_ncov_province_1_number

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                                topMargin: text_ncov_province_0_number.anchors.topMargin
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_province_0_number.font.pixelSize
                                weight: Font.Medium
                            }
                        }

                        Text {
                            id: text_ncov_province_1_title

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_province_0_title.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "疑似病例"
                            visible: false
                        }
                    }

                    Item {
                        height: item_ncov_province_0.height
                        width: item_ncov_province_0.width

                        Text {
                            id: text_ncov_province_2_number

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                                topMargin: text_ncov_province_0_number.anchors.topMargin
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_province_0_number.font.pixelSize
                                weight: Font.Medium
                            }
                        }

                        Text {
                            id: text_ncov_province_2_title

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_province_0_title.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "已治愈"
                            visible: false
                        }
                    }

                    Item {
                        height: item_ncov_province_0.height
                        width: item_ncov_province_0.width

                        Text {
                            id: text_ncov_province_3_number

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                                topMargin: text_ncov_province_0_number.anchors.topMargin
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_province_0_number.font.pixelSize
                                weight: Font.Medium
                            }
                        }

                        Text {
                            id: text_ncov_province_3_title

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_province_0_title.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "死亡"
                            visible: false
                        }
                    }
                }
            }

            Item {
                Text {
                    id: text_ncov_capital_title

                    anchors {
                        left: parent.left
                        leftMargin: 16
                        top: parent.top
                        topMargin: 16
                    }
                    color: "#ffffff"
                    font {
                        pixelSize: parent.height / 6
                        weight: Font.Bold
                    }
                }

                Text {
                    id: text_ncov_capital_title_risk

                    anchors {
                        left: text_ncov_capital_title.left
                        top: text_ncov_capital_title.bottom
                    }
                    color: "#ffffff"
                    font {
                        pixelSize: parent.height / 9
                        weight: Font.Medium
                    }
                }

                Row {
                    anchors.top: text_ncov_capital_title_risk.bottom
                    height: parent.height - text_ncov_capital_title.height
                            - text_ncov_capital_title_risk.height - 32
                    width: parent.width

                    Item {
                        id: item_ncov_capital_0

                        height: parent.height
                        width: parent.width / 4

                        Text {
                            id: text_ncov_capital_0_number

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                                topMargin: -parent.height / 12
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: parent.height / 2
                                weight: Font.Medium
                            }
                        }

                        Text {
                            id: text_ncov_capital_0_title

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_capital_title_risk.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "现存确诊"
                            visible: false
                        }
                    }

                    Item {
                        height: item_ncov_capital_0.height
                        width: item_ncov_capital_0.width

                        Text {
                            id: text_ncov_capital_1_number

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                                topMargin: text_ncov_capital_0_number.anchors.topMargin
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_capital_0_number.font.pixelSize
                                weight: Font.Medium
                            }
                        }

                        Text {
                            id: text_ncov_capital_1_title

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_capital_0_title.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "疑似病例"
                            visible: false
                        }
                    }

                    Item {
                        height: item_ncov_capital_0.height
                        width: item_ncov_capital_0.width

                        Text {
                            id: text_ncov_capital_2_number

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                                topMargin: text_ncov_capital_0_number.anchors.topMargin
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_capital_0_number.font.pixelSize
                                weight: Font.Medium
                            }
                        }

                        Text {
                            id: text_ncov_capital_2_title

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_capital_0_title.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "已治愈"
                            visible: false
                        }
                    }

                    Item {
                        height: item_ncov_capital_0.height
                        width: item_ncov_capital_0.width

                        Text {
                            id: text_ncov_capital_3_number

                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                top: parent.top
                                topMargin: text_ncov_capital_0_number.anchors.topMargin
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_capital_0_number.font.pixelSize
                                weight: Font.Medium
                            }
                        }

                        Text {
                            id: text_ncov_capital_3_title

                            anchors {
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                            }
                            color: "#ffffff"
                            font {
                                pixelSize: text_ncov_capital_0_title.font.pixelSize
                                weight: Font.Bold
                            }
                            text: "死亡"
                            visible: false
                        }
                    }
                }
            }
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

            interval: 21600000
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                indicator_ncov.running = true
                Ncov.request_data("广东省")
            }
        }

        Component.onCompleted: {
            timer_ncov.start()
        }
    }

    Button {
        id: button_elevator_client_floor

        anchors {
            left: background_media.right
            leftMargin: 16
        }
        flat: true
        height: button_elevator_exit.height
        icon.source: "qrc:/res/icons/elevator/building.svg"
        text: "设置楼层"

        ToolTip {
            text: "楼层信息"
            timeout: 3000
            visible: button_elevator_client_floor.hovered
                     || button_elevator_client_floor.pressed
        }

        onClicked: {
            dialog_elevator_client_floor.open()
        }
    }

    Button {
        id: button_elevator_setting

        anchors.right: button_elevator_exit.left
        flat: true
        height: button_elevator_exit.height
        icon.source: "qrc:/res/icons/elevator/settings.svg"

        ToolTip {
            text: "设置"
            timeout: 3000
            visible: button_elevator_setting.hovered
                     || button_elevator_setting.pressed
        }

        onClicked: {
            dialog_elevator_setting.open()
        }
    }

    Button {
        id: button_elevator_exit

        anchors {
            right: parent.right
            rightMargin: 16
        }
        flat: true
        height: parent.height / 12
        icon.source: "qrc:/res/icons/elevator/exit.svg"

        ToolTip {
            text: "退出"
            timeout: 3000
            visible: button_elevator_exit.hovered
                     || button_elevator_exit.pressed
        }

        onClicked: {
            Qt.quit()
        }
    }

    Text {
        id: text_elevator_floor

        anchors {
            horizontalCenter: button_downstairs.horizontalCenter
            top: button_elevator_exit.bottom
        }
        font {
            pixelSize: parent.height / 4
            weight: Font.Light
        }
        text: "--"
    }

    Item {
        anchors {
            horizontalCenter: button_downstairs.horizontalCenter
            top: text_elevator_floor.top
        }
        height: text_elevator_floor.height / 6
        width: image_elevator_direction.width + text_elevator_direction.width + 16

        Image {
            id: image_elevator_direction

            source: "qrc:/res/icons/elevator/link-off.svg"
            sourceSize {
                height: parent.height
                width: height
            }
        }

        Text {
            id: text_elevator_direction

            anchors {
                left: image_elevator_direction.right
                leftMargin: 16
                verticalCenter: image_elevator_direction.verticalCenter
            }
            font {
                pixelSize: parent.height
                weight: Font.Bold
            }
            text: "未连接"
        }
    }

    Item {
        id: item_elevator_name

        anchors {
            left: button_elevator_client_floor.left
            top: text_elevator_floor.bottom
        }
        height: button_elevator_exit.height / 2
        width: image_elevator_name.width + text_elevator_name.width + 8

        Image {
            id: image_elevator_name

            source: "qrc:/res/icons/elevator/elevator.svg"
            sourceSize {
                height: parent.height
                width: height
            }
        }

        Text {
            id: text_elevator_name

            anchors {
                left: image_elevator_name.right
                leftMargin: 8
                verticalCenter: image_elevator_name.verticalCenter
            }
            font.pixelSize: parent.height
            text: "--"
        }
    }

    Item {
        anchors {
            horizontalCenter: button_downstairs.horizontalCenter
            verticalCenter: item_elevator_name.verticalCenter
        }
        height: item_elevator_name.height
        width: image_elevator_remain_time.width + text_elevator_remain_time.width + 8

        Image {
            id: image_elevator_remain_time

            source: "qrc:/res/icons/elevator/clock.svg"
            sourceSize {
                height: parent.height
                width: height
            }
        }

        Text {
            id: text_elevator_remain_time

            anchors {
                left: image_elevator_remain_time.right
                leftMargin: 8
                verticalCenter: image_elevator_remain_time.verticalCenter
            }
            font.pixelSize: parent.height
            text: "-- 秒"
        }
    }

    Item {
        anchors {
            right: button_elevator_exit.right
            verticalCenter: item_elevator_name.verticalCenter
        }
        height: item_elevator_name.height
        width: image_elevator_capacity.width + text_elevator_capacity.width + 8

        Image {
            id: image_elevator_capacity

            source: "qrc:/res/icons/elevator/capacity.svg"
            sourceSize {
                height: parent.height
                width: height
            }
        }

        Text {
            id: text_elevator_capacity

            anchors {
                left: image_elevator_capacity.right
                leftMargin: 8
                verticalCenter: image_elevator_capacity.verticalCenter
            }
            font.pixelSize: parent.height
            text: "--%"
        }
    }

    Item {
        anchors {
            left: button_elevator_client_floor.left
            top: item_elevator_name.bottom
            topMargin: 16
        }
        height: button_elevator_exit.height
        width: parent.width - background_media.width - 48

        Image {
            id: image_elevator_next_stop

            source: "qrc:/res/icons/elevator/stairs-up.svg"
            sourceSize {
                height: item_elevator_name.height
                width: height
            }
        }

        Text {
            id: text_elevator_next_stop

            anchors {
                left: image_elevator_next_stop.right
                leftMargin: 8
                verticalCenter: image_elevator_next_stop.verticalCenter
            }
            font.pixelSize: image_elevator_next_stop.height
            text: "--"
        }

        ProgressBar {
            id: progressbar_elevator_next_stop

            anchors {
                top: image_elevator_next_stop.bottom
                topMargin: 8
            }
            value: 0.5
            width: parent.width
        }
    }

    Button {
        id: button_upstairs

        anchors {
            bottom: button_downstairs.top
            bottomMargin: height / 4
            horizontalCenter: button_downstairs.horizontalCenter
        }
        height: button_downstairs.height
        icon.source: "qrc:/res/icons/elevator/arrow-up.svg"
        text: "上楼"
        width: button_downstairs.width

        onClicked: {
            Elevator.add_next_stop_up(spinbox_elevator_client_floor.value)
        }
    }

    Button {
        id: button_downstairs

        anchors {
            bottom: background_datetime.top
            bottomMargin: 16
            right: parent.right
            rightMargin: 32
        }
        height: parent.height / 8
        icon.source: "qrc:/res/icons/elevator/arrow-down.svg"
        text: "下楼"
        width: parent.width - background_media.width - 80

        onClicked: {
            Elevator.add_next_stop_down(spinbox_elevator_client_floor.value)
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
                text_datetime.text = new Date().toLocaleString(
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
                animation_text_notification.restart()
            }

            PropertyAnimation on x {
                id: animation_text_notification

                duration: 60000
                from: background_notification.width
                loops: Animation.Infinite
                to: -text_notification.width
            }
        }

        Timer {
            id: timer_notification

            interval: 3600000
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                Notification.read_file()
            }
        }

        Component.onCompleted: {
            timer_notification.start()
        }
    }

    Dialog {
        id: dialog_elevator_client_floor

        anchors.centerIn: parent
        focus: true
        height: parent.height / 2
        modal: true
        standardButtons: Dialog.Cancel | Dialog.Ok
        title: "⚙ 设备信息"
        width: parent.width / 3

        Column {
            anchors.fill: parent
            spacing: 16

            Text {
                font.weight: Font.Medium
                text: "🏠 当前设备所在楼层"
            }

            SpinBox {
                id: spinbox_elevator_client_floor

                editable: true
                from: 1
                to: 12
                width: parent.width
            }

            Text {
                font.weight: Font.Medium
                text: "🏷 自定义电梯名称"
            }

            TextField {
                id: textfield_elevator_client_floor

                text: "客梯"
                width: parent.width
            }
        }

        onAccepted: {
            button_elevator_client_floor.text = "第 " + spinbox_elevator_client_floor.value + " 层"
            text_elevator_name.text = textfield_elevator_client_floor.text
        }
    }

    Dialog {
        id: dialog_elevator_setting

        anchors.centerIn: parent
        focus: true
        height: parent.height * 2 / 3
        modal: true
        standardButtons: dialog_elevator_client_floor.standardButtons
        title: "⚙ 设置"
        width: dialog_elevator_client_floor.width

        onAccepted: {
            Elevator.start(12, 6, 3, 3, 10)
        }
    }

    Dialog {
        id: dialog_media

        anchors.centerIn: parent
        focus: true
        height: parent.height / 3
        modal: true
        standardButtons: Dialog.Cancel | Dialog.Retry
        title: "⚠ 错误"
        width: dialog_elevator_client_floor.width

        Text {
            anchors.fill: parent
            text: "获取媒体数据失败，在指定目录下未找到媒体文件。\n\n是否重试？"
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
        id: dialog_ncov

        anchors.centerIn: parent
        focus: true
        height: dialog_media.height
        modal: true
        standardButtons: dialog_media.standardButtons
        title: "⚠ 错误"
        width: dialog_elevator_client_floor.width

        Text {
            anchors.fill: parent
            text: "获取疫情信息时发生异常，请检查应用程序输出以获取详细信息。\n\n是否重试？"
            wrapMode: Text.Wrap
        }

        onAccepted: {
            timer_ncov.restart()
        }

        onRejected: {
            timer_ncov.stop()
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
        width: dialog_elevator_client_floor.width

        Text {
            anchors.fill: parent
            text: "获取通知数据失败，在指定目录下未找到通知文件。\n\n是否重试？"
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
        width: dialog_elevator_client_floor.width

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


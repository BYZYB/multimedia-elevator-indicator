import QtMultimedia 5.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Window {
    id: window_root

    property string city: "广州市"
    property int client_floor: 1
    property string client_name: "客梯"
    property int floor_max: 12
    property int floor_min: 1
    property int interval_media: 3600000
    property int interval_ncov: 21600000
    property int interval_notification: 3600000
    property int interval_weather: 3600000
    property int mode_capacity: 1
    property int mode_playback: 1
    property int mode_side: 1
    property int notification_speed: 60000
    readonly property string path_media_default: Qt.platform.os === "windows" ? "../videos/" : path_application_dir + "/../videos/"
    property string path_media: path_media_default
    readonly property string path_notification_default: "../notifications/"
    property string path_notification: path_notification_default
    property string province: "广东省"
    property int time_door_move: 3
    property int time_next_floor: 3
    property int time_stop: 5
    readonly property string url_ncov_default: "https://lab.isaaclin.cn/nCoV/api/area?province="
    property string url_ncov: url_ncov_default
    readonly property string url_weather_current_default: "https://restapi.amap.com/v3/weather/weatherInfo?key=9e24a5b9641a7b9bd139940b7212cdfa&city="
    property string url_weather_current: url_weather_current_default
    readonly property string url_weather_forecast_default: "https://restapi.amap.com/v3/weather/weatherInfo?key=9e24a5b9641a7b9bd139940b7212cdfa&extensions=all&city="
    property string url_weather_forecast: url_weather_forecast_default
    property int window_flags: 0

    maximumHeight: Screen.height
    maximumWidth: Screen.width
    minimumHeight: 720
    minimumWidth: 1280
    title: "Melecator"
    visible: true

    Connections {
        target: Elevator

        function onElevatorCapacityUpdate() {
            if (mode_capacity === 1) {
                text_elevator_capacity.text = Elevator.get_capacity() + "%"
            } else {
                text_elevator_capacity.text = Elevator.get_capacity(
                            ) > 100 ? "超载" : "正常"
            }
        }

        function onElevatorDirectionUpdate() {
            switch (Elevator.get_direction_current()) {
            case 0:
                switch (mode_side) {
                case 0:
                    image_elevator_direction.source = "qrc:/res/icons/elevator/stop-right.svg"
                    text_elevator_direction.text = "电梯停靠"
                    break
                case 1:
                    image_elevator_direction.source = "qrc:/res/icons/elevator/stop-left.svg"
                    text_elevator_direction.text = "左侧停靠"
                    break
                case 2:
                    image_elevator_direction.source = "qrc:/res/icons/elevator/stop-right.svg"
                    text_elevator_direction.text = "右侧停靠"
                    break
                }
                break
            case 1:
                image_elevator_direction.source = "qrc:/res/icons/elevator/move-down.svg"
                text_elevator_direction.text = "正在下行"
                break
            case 2:
                image_elevator_direction.source = "qrc:/res/icons/elevator/move-up.svg"
                text_elevator_direction.text = "正在上行"
                break
            }
        }

        function onElevatorDoorClose() {
            if (client_floor === Elevator.get_floor()) {
                if (Elevator.get_direction_planned() === 1) {
                    button_downstairs.enabled = true
                } else {
                    button_upstairs.enabled = true
                }
            }

            image_elevator_direction.source = "qrc:/res/icons/elevator/arrow-collapse.svg"
            text_elevator_direction.text = "关门请注意"
        }

        function onElevatorDoorOpen() {
            if (client_floor === Elevator.get_floor()) {
                if (Elevator.get_direction_planned() === 1) {
                    button_downstairs.enabled = button_downstairs.highlighted = false
                } else {
                    button_upstairs.enabled = button_upstairs.highlighted = false
                }
            }

            image_elevator_direction.source = "qrc:/res/icons/elevator/arrow-expand.svg"
            text_elevator_direction.text = "开门请注意"
        }

        function onElevatorFloorUpdate() {
            text_elevator_floor.text = Elevator.get_floor()
        }

        function onElevatorNextStopUpdate() {
            if (Elevator.get_direction_planned() === 1) {
                image_elevator_next_stop.source = "qrc:/res/icons/elevator/stairs-down.svg"
                text_elevator_next_stop.text = Elevator.get_next_stop_down()
            } else {
                image_elevator_next_stop.source = "qrc:/res/icons/elevator/stairs-up.svg"
                text_elevator_next_stop.text = Elevator.get_next_stop_up()
            }
        }

        function onElevatorTimeRemainUpdate() {
            text_elevator_time_remain.text = Elevator.get_time_remain() + " 秒"
            progressbar_elevator_next_stop.value = Elevator.get_progress()
        }

        function onElevatorStart() {
            button_downstairs.enabled = client_floor === floor_min ? false : true
            button_downstairs.highlighted = button_upstairs.highlighted = false
            button_elevator_client_floor.enabled = true
            button_upstairs.enabled = client_floor === floor_max ? false : true
            client_floor = spinbox_elevator_client_floor_0.value
            image_elevator_direction.source = mode_side
                    === 1 ? "qrc:/res/icons/elevator/stop-left.svg" : "qrc:/res/icons/elevator/stop-right.svg"
            progressbar_elevator_next_stop.value = 0
            text_elevator_capacity.text = mode_capacity === 1 ? "0%" : "正常"
            text_elevator_direction.text = mode_side
                    === 1 ? "左侧停靠" : mode_side === 2 ? "右侧停靠" : "电梯停靠"
            text_elevator_floor.text = floor_min
            text_elevator_next_stop.text = "…"
            text_elevator_time_remain.text = "0 秒"
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
            text_ncov_capital_0_number.text = ncov_capital["currentConfirmedCount"]
            text_ncov_capital_1_number.text = ncov_capital["suspectedCount"]
            text_ncov_capital_2_number.text = ncov_capital["curedCount"]
            text_ncov_capital_3_number.text = ncov_capital["deadCount"]
            text_ncov_capital_0_title.visible = text_ncov_capital_1_title.visible
                    = text_ncov_capital_2_title.visible = text_ncov_capital_3_title.visible
                    = text_ncov_province_0_title.visible = text_ncov_province_1_title.visible
                    = text_ncov_province_2_title.visible = text_ncov_province_3_title.visible = true
            text_ncov_capital_title_risk.text = "📊 防控状况 | "
                    + (ncov_capital_high > 0 ? ncov_capital_high + " 个高风险地区" : ncov_capital_mid
                                               > 0 ? ncov_capital_mid + " 个中风险地区" : "低风险")
            text_ncov_province_0_number.text = ncov_province["currentConfirmedCount"]
            text_ncov_province_1_number.text = ncov_province["suspectedCount"]
            text_ncov_province_2_number.text = ncov_province["curedCount"]
            text_ncov_province_3_number.text = ncov_province["deadCount"]
            text_ncov_province_title.text = "新冠疫情数据 | " + ncov_province["provinceName"]
            text_ncov_province_title_time.text = "🕓 更新时间 | "
                    + new Date(ncov_province["updateTime"]).toLocaleString(
                        Qt.locale(), "M月d日 HH:mm")
            text_ncov_capital_title.text = text_ncov_province_title.text + " > "
                    + ncov_capital["cityName"]
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
        property var weather_current
        property var weather_forecast

        target: Weather

        function onWeatherCurrentAvailable() {
            weather_current = Weather.get_current_data()

            if (weather_forecast) {
                text_weather_current_title.text = weather_current["weather"]
                        + " | " + weather_forecast[0]["nighttemp"] + "°~"
                        + weather_forecast[0]["daytemp"] + "° | " + weather_current["winddirection"]
            } else {
                text_weather_current_title.text = weather_current["weather"]
                        + " | " + weather_current["winddirection"] + "风"
            }

            image_weather_current.source = Weather.get_image_url(false)
            image_weather_current_humidity.visible = image_weather_current_windpower.visible = true
            text_weather_current_city.text = weather_current["city"]
            text_weather_current_humidity.text = weather_current["humidity"] + "%"
            text_weather_current_realtime.text = weather_current["temperature"]
            text_weather_current_windpower.text = weather_current["windpower"] + " 级"
            indicator_weather.running = false
        }

        function onWeatherForecastAvailable() {
            weather_forecast = Weather.get_forecast_data()
            var weather_forecast_0 = weather_forecast[0], weather_forecast_1 = weather_forecast[1], weather_forecast_2 = weather_forecast[2], weather_forecast_3 = weather_forecast[3]

            if (weather_current) {
                text_weather_current_title.text = weather_current["weather"]
                        + " | " + weather_forecast_0["nighttemp"] + "°~"
                        + weather_forecast_0["daytemp"] + "° | " + weather_current["winddirection"]
            }

            image_weather_forecast_0.source = Weather.get_image_url(true, 0)
            image_weather_forecast_1.source = Weather.get_image_url(true, 1)
            image_weather_forecast_2.source = Weather.get_image_url(true, 2)
            image_weather_forecast_3.source = Weather.get_image_url(true, 3)
            text_weather_forecast_0_date.text = Weather.get_day_name(
                        weather_forecast_0["week"])
            text_weather_forecast_0_temperature.text = weather_forecast_0["nighttemp"]
                    + "°~" + weather_forecast_0["daytemp"] + "°"
            text_weather_forecast_1_date.text = Weather.get_day_name(
                        weather_forecast_1["week"])
            text_weather_forecast_1_temperature.text = weather_forecast_1["nighttemp"]
                    + "°~" + weather_forecast_1["daytemp"] + "°"
            text_weather_forecast_2_date.text = Weather.get_day_name(
                        weather_forecast_2["week"])
            text_weather_forecast_2_temperature.text = weather_forecast_2["nighttemp"]
                    + "°~" + weather_forecast_2["daytemp"] + "°"
            text_weather_forecast_3_date.text = Weather.get_day_name(
                        weather_forecast_3["week"])
            text_weather_forecast_3_temperature.text = weather_forecast_3["nighttemp"]
                    + "°~" + weather_forecast_3["daytemp"] + "°"
            indicator_weather.running = false
        }

        function onWeatherCurrentUnavailable() {
            weather_current = null
            image_weather_current.source = "qrc:/res/icons/weather/cloudy-alert.svg"
            image_weather_current_humidity.visible = image_weather_current_windpower.visible = false
            text_weather_current_city.text = "无数据"
            text_weather_current_realtime.text = text_weather_current_humidity.text
                    = text_weather_current_windpower.text = ""
            text_weather_current_title.text = "⚠ 实时天气不可用"
            indicator_weather.running = false
            dialog_weather.open()
        }

        function onWeatherForecastUnavailable() {
            weather_forecast = null
            image_weather_forecast_0.source = image_weather_forecast_1.source
                    = image_weather_forecast_2.source = image_weather_forecast_3.source
                    = "qrc:/res/icons/weather/cloudy-alert.svg"
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

        color: "#80000000"
        height: parent.height - background_datetime.height - background_weather.height - 48
        radius: 8
        width: parent.width * 2 / 3 - 32
        x: 16
        y: 16

        Video {
            id: video_media

            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
            playlist: Playlist {
                id: list_media

                playbackMode: mode_playback === 1 ? Playlist.Random : Playlist.Loop

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

            interval: interval_media
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                indicator_media.running = true
                video_media.stop()
                list_media.clear()
                Media.read_file(path_media)
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

            Row {
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

            Row {
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

            interval: interval_weather
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                indicator_weather.running = true
                Weather.set_url(url_weather_current, url_weather_forecast)
                Weather.request_data(city)
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

            interval: interval_ncov
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                indicator_ncov.running = true
                Ncov.set_url(url_ncov)
                Ncov.request_data(province)
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
        enabled: false
        flat: true
        height: button_elevator_exit.height
        icon.source: "qrc:/res/icons/elevator/building.svg"
        text: "第 " + client_floor + " 层"

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

        Behavior on text {
            ParallelAnimation {
                PropertyAnimation {
                    duration: 500
                    easing.type: Easing.InOutCubic
                    from: 0
                    property: "opacity"
                    target: text_elevator_floor
                    to: 1
                }

                PropertyAnimation {
                    duration: 500
                    easing.type: Easing.InOutCubic
                    from: 0.75
                    property: "scale"
                    target: text_elevator_floor
                    to: 1
                }
            }
        }
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

            Behavior on text {
                PropertyAnimation {
                    duration: 500
                    easing.type: Easing.InOutCubic
                    from: 0
                    property: "opacity"
                    targets: [image_elevator_direction, text_elevator_direction]
                    to: 1
                }
            }
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
            text: client_name
        }
    }

    Item {
        anchors {
            horizontalCenter: button_downstairs.horizontalCenter
            verticalCenter: item_elevator_name.verticalCenter
        }
        height: item_elevator_name.height
        width: image_elevator_time_remain.width + text_elevator_time_remain.width + 8

        Image {
            id: image_elevator_time_remain

            source: "qrc:/res/icons/elevator/clock.svg"
            sourceSize {
                height: parent.height
                width: height
            }
        }

        Text {
            id: text_elevator_time_remain

            anchors {
                left: image_elevator_time_remain.right
                leftMargin: 8
                verticalCenter: image_elevator_time_remain.verticalCenter
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

            Behavior on source {
                PropertyAnimation {
                    duration: 500
                    easing.type: Easing.InOutCubic
                    from: 0
                    property: "opacity"
                    target: image_elevator_next_stop
                    to: 1
                }
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
            text: "…"

            Behavior on text {
                PropertyAnimation {
                    duration: 500
                    easing.type: Easing.InOutCubic
                    from: 0
                    property: "opacity"
                    target: text_elevator_next_stop
                    to: 1
                }
            }
        }

        ProgressBar {
            id: progressbar_elevator_next_stop

            anchors {
                top: image_elevator_next_stop.bottom
                topMargin: 8
            }
            width: parent.width

            Behavior on value {
                NumberAnimation {
                    easing.type: Easing.InOutCubic
                    duration: 500
                }
            }
        }
    }

    Button {
        id: button_upstairs

        anchors {
            bottom: button_downstairs.top
            bottomMargin: height / 4
            horizontalCenter: button_downstairs.horizontalCenter
        }
        enabled: false
        height: button_downstairs.height
        icon.source: "qrc:/res/icons/elevator/arrow-up.svg"
        text: "上楼"
        width: button_downstairs.width

        onClicked: {
            highlighted = highlighted ? false : true
            Elevator.update_next_stop_up(client_floor)
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
        enabled: false
        height: parent.height / 8
        icon.source: "qrc:/res/icons/elevator/arrow-down.svg"
        text: "下楼"
        width: parent.width - background_media.width - 80

        onClicked: {
            highlighted = highlighted ? false : true
            Elevator.update_next_stop_down(client_floor)
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

                duration: notification_speed
                from: background_notification.width
                loops: Animation.Infinite
                to: -text_notification.width
            }
        }

        Timer {
            id: timer_notification

            interval: interval_notification
            repeat: true
            triggeredOnStart: true

            onTriggered: {
                Notification.read_file(path_notification)
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
        height: parent.height * 2 / 3
        modal: true
        standardButtons: Dialog.Cancel | Dialog.Ok
        title: "⚙ 楼层信息"
        width: parent.width / 3

        Column {
            anchors.fill: parent
            spacing: 16

            Text {
                font.weight: Font.Medium
                text: "当前设备所在楼层（仅限测试）"
            }

            SpinBox {
                id: spinbox_elevator_client_floor_0

                editable: true
                from: floor_min
                to: floor_max
                value: client_floor
                width: parent.width
            }

            Text {
                font.weight: Font.Medium
                text: "自定义电梯名称"
            }

            TextField {
                id: textfield_elevator_client_floor_1

                placeholderText: "未命名"
                text: client_name
                width: parent.width
            }
        }

        onAccepted: {
            if (client_floor !== spinbox_elevator_client_floor_0.value) {
                client_floor = spinbox_elevator_client_floor_0.value
                button_downstairs.enabled = client_floor === floor_min ? false : true
                button_downstairs.highlighted = Elevator.get_is_next_stop_down(
                            client_floor) ? true : false
                button_upstairs.enabled = client_floor === floor_max ? false : true
                button_upstairs.highlighted = Elevator.get_is_next_stop_up(
                            client_floor) ? true : false
            }

            if (client_name !== textfield_elevator_client_floor_1.text) {
                client_name = textfield_elevator_client_floor_1.length ? textfield_elevator_client_floor_1.text : "--"
            }
        }
    }

    Dialog {
        id: dialog_elevator_setting

        anchors.centerIn: parent
        focus: true
        header: TabBar {
            id: tabbar_elevator_setting

            TabButton {
                text: "🛠 常规"
            }

            TabButton {
                text: "🎞 媒体"
            }

            TabButton {
                text: "🔔 信息栏"
            }

            TabButton {
                text: "🕹 模拟电梯"
            }
        }
        height: dialog_elevator_client_floor.height
        modal: true
        standardButtons: dialog_elevator_client_floor.standardButtons
        width: dialog_elevator_client_floor.width

        StackLayout {
            anchors.fill: parent
            currentIndex: tabbar_elevator_setting.currentIndex

            Column {
                spacing: 16

                Text {
                    font.weight: Font.Medium
                    text: "界面高度（像素）"
                }

                SpinBox {
                    id: spinbox_elevator_setting_0_0

                    editable: true
                    from: window_root.minimumHeight
                    to: window_root.maximumHeight
                    value: window_root.height
                    width: parent.width
                }

                Text {
                    font.weight: Font.Medium
                    text: "界面宽度（像素）"
                }

                SpinBox {
                    id: spinbox_elevator_setting_0_1

                    editable: true
                    from: window_root.minimumWidth
                    to: window_root.maximumWidth
                    value: window_root.width
                    width: parent.width
                }

                Text {
                    font.weight: Font.Medium
                    text: "窗口模式"
                }

                ComboBox {
                    id: combobox_elevator_setting_0_2

                    currentIndex: window_flags
                    model: ["窗口化", "无边框", "全屏幕"]
                    width: parent.width
                }
            }

            Column {
                spacing: 16

                Text {
                    font.weight: Font.Medium
                    text: "播放模式"
                }

                ComboBox {
                    id: combobox_elevator_setting_1_0

                    currentIndex: mode_playback
                    model: ["列表循环", "随机播放"]
                    width: parent.width
                }

                Text {
                    font.weight: Font.Medium
                    text: "更新时间（分钟）"
                }

                SpinBox {
                    id: spinbox_elevator_setting_1_1

                    editable: true
                    from: 1
                    to: 1440
                    value: interval_media / 60000
                    width: parent.width
                }

                Text {
                    font.weight: Font.Medium
                    text: "媒体文件查找路径"
                }

                TextField {
                    id: textfield_elevator_setting_1_2

                    placeholderText: path_media_default
                    text: path_media
                    width: parent.width
                }
            }

            ScrollView {
                id: scrollview_elevator_setting_2

                clip: true
                width: parent.width

                Column {
                    spacing: 16

                    Text {
                        font.weight: Font.Medium
                        text: "所在省份"
                    }

                    TextField {
                        id: textfield_elevator_setting_2_0

                        placeholderText: "广东省"
                        text: province
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "所在城市"
                    }

                    TextField {
                        id: textfield_elevator_setting_2_1

                        placeholderText: "广州市"
                        text: city
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "天气更新时间（分钟）"
                    }

                    SpinBox {
                        id: spinbox_elevator_setting_2_2

                        editable: true
                        from: 1
                        to: 1440
                        value: interval_weather / 60000
                        width: parent.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "通知更新时间（分钟）"
                    }

                    SpinBox {
                        id: spinbox_elevator_setting_2_3

                        editable: true
                        from: 1
                        to: 1440
                        value: interval_notification / 60000
                        width: parent.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "疫情信息更新时间（分钟）"
                    }

                    SpinBox {
                        id: spinbox_elevator_setting_2_4

                        editable: true
                        from: 1
                        to: 1440
                        value: interval_ncov / 60000
                        width: parent.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "通知滚动速度"
                    }

                    Slider {
                        id: textfield_elevator_setting_2_5

                        from: 120000
                        to: 30000
                        stepSize: 3000
                        value: notification_speed
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "通知文件查找路径"
                    }

                    TextField {
                        id: textfield_elevator_setting_2_6

                        placeholderText: path_notification_default
                        text: path_notification
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "自定义实时天气 API"
                    }

                    TextField {
                        id: textfield_elevator_setting_2_7

                        placeholderText: url_weather_current_default
                        text: url_weather_current
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "自定义预报天气 API"
                    }

                    TextField {
                        id: textfield_elevator_setting_2_8

                        placeholderText: url_weather_forecast_default
                        text: url_weather_forecast
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "自定义疫情信息 API"
                    }

                    TextField {
                        id: textfield_elevator_setting_2_9

                        placeholderText: url_ncov_default
                        text: url_ncov
                        width: scrollview_elevator_setting_2.width
                    }
                }
            }

            ScrollView {
                clip: true
                width: parent.width

                Column {
                    spacing: 16

                    Text {
                        font.weight: Font.Medium
                        text: "最高楼层"
                    }

                    SpinBox {
                        id: spinbox_elevator_setting_3_0

                        editable: true
                        from: floor_min
                        to: 255
                        value: floor_max
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "最低楼层"
                    }

                    SpinBox {
                        id: spinbox_elevator_setting_3_1

                        editable: true
                        from: 1
                        to: floor_max
                        value: floor_min
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "电梯所在方位"
                    }

                    ComboBox {
                        id: combobox_elevator_setting_3_2

                        currentIndex: mode_side
                        model: ["隐藏", "左侧", "右侧"]
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "电梯载重量显示方式"
                    }

                    ComboBox {
                        id: combobox_elevator_setting_3_3

                        currentIndex: mode_capacity
                        model: ["标准", "精确"]
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "轿厢门开关所需时间（秒）"
                    }

                    SpinBox {
                        id: spinbox_elevator_setting_3_4

                        editable: true
                        from: 1
                        to: 255
                        value: time_door_move
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "电梯前往新楼层所需时间（秒）"
                    }

                    SpinBox {
                        id: spinbox_elevator_setting_3_5

                        editable: true
                        from: 1
                        to: 255
                        value: time_next_floor
                        width: scrollview_elevator_setting_2.width
                    }

                    Text {
                        font.weight: Font.Medium
                        text: "电梯在各楼层停留所需时间（秒）"
                    }

                    SpinBox {
                        id: spinbox_elevator_setting_3_6

                        editable: true
                        from: 1
                        to: 255
                        value: time_stop
                        width: scrollview_elevator_setting_2.width
                    }
                }
            }
        }

        onAccepted: {
            if (city !== textfield_elevator_setting_2_1.text) {
                city = textfield_elevator_setting_2_1.length ? textfield_elevator_setting_2_1.text : "广州市"
                timer_weather.restart()
            }

            if (floor_max !== spinbox_elevator_setting_3_0.value) {
                floor_max = spinbox_elevator_setting_3_0.value
            }

            if (floor_min !== spinbox_elevator_setting_3_1.value) {
                floor_min = spinbox_elevator_setting_3_1.value
            }

            if (interval_media !== spinbox_elevator_setting_1_1.value * 60000) {
                interval_media = spinbox_elevator_setting_1_1.value * 60000
                timer_media.restart()
            }

            if (interval_ncov !== spinbox_elevator_setting_2_4.value * 60000) {
                interval_ncov = spinbox_elevator_setting_2_4.value * 60000
                timer_ncov.restart()
            }

            if (interval_notification !== spinbox_elevator_setting_2_3.value * 60000) {
                interval_notification = spinbox_elevator_setting_2_3.value * 60000
                timer_notification.restart()
            }

            if (interval_weather !== spinbox_elevator_setting_2_2.value * 60000) {
                interval_weather = spinbox_elevator_setting_2_2.value * 60000
                timer_weather.restart()
            }

            if (mode_capacity !== combobox_elevator_setting_3_3.currentIndex) {
                mode_capacity = combobox_elevator_setting_3_3.currentIndex
            }

            if (mode_playback !== combobox_elevator_setting_1_0.currentIndex) {
                mode_playback = combobox_elevator_setting_1_0.currentIndex
            }

            if (notification_speed !== textfield_elevator_setting_2_5.value) {
                notification_speed = textfield_elevator_setting_2_5.value
                animation_text_notification.restart()
            }

            if (path_media !== textfield_elevator_setting_1_2.text) {
                path_media = textfield_elevator_setting_1_2.length ? textfield_elevator_setting_1_2.text : path_media_default
                timer_media.restart()
            }

            if (path_notification !== textfield_elevator_setting_2_6.text) {
                path_notification = textfield_elevator_setting_2_6.length ? textfield_elevator_setting_2_6.text : path_notification_default
                timer_notification.restart()
                animation_text_notification.restart()
            }

            if (province !== textfield_elevator_setting_2_0.text) {
                province = textfield_elevator_setting_2_0.length ? textfield_elevator_setting_2_0.text : "广东省"
                timer_ncov.restart()
            }

            if (mode_side !== combobox_elevator_setting_3_2.currentIndex) {
                mode_side = combobox_elevator_setting_3_2.currentIndex
            }

            if (time_door_move !== spinbox_elevator_setting_3_4.value) {
                time_door_move = spinbox_elevator_setting_3_4.value
            }

            if (time_next_floor !== spinbox_elevator_setting_3_5.value) {
                time_next_floor = spinbox_elevator_setting_3_5.value
            }

            if (time_stop !== spinbox_elevator_setting_3_6.value) {
                time_stop = spinbox_elevator_setting_3_6.value
            }

            if (url_ncov !== textfield_elevator_setting_2_9.text) {
                url_ncov = textfield_elevator_setting_2_9.length ? textfield_elevator_setting_2_9.text : url_ncov_default
                timer_ncov.restart()
            }

            if (url_weather_current !== textfield_elevator_setting_2_7.text) {
                url_weather_current = textfield_elevator_setting_2_7.length ? textfield_elevator_setting_2_7.text : url_weather_current_default
                timer_weather.restart()
            }

            if (url_weather_forecast !== textfield_elevator_setting_2_8.text) {
                url_weather_forecast = textfield_elevator_setting_2_8.length ? textfield_elevator_setting_2_8.text : url_weather_forecast_default
                timer_weather.restart()
            }

            if (window_root.height !== spinbox_elevator_setting_0_0.value) {
                window_root.height = spinbox_elevator_setting_0_0.value

                if (window_flags === 1) {
                    window_root.setGeometry(
                                (window_root.maximumWidth - window_root.width) / 2,
                                (window_root.maximumHeight - window_root.height) / 2,
                                window_root.width, window_root.height)
                }
            }

            if (window_root.width !== spinbox_elevator_setting_0_1.value) {
                window_root.width = spinbox_elevator_setting_0_1.value

                if (window_flags === 1) {
                    window_root.setGeometry(
                                (window_root.maximumWidth - window_root.width) / 2,
                                (window_root.maximumHeight - window_root.height) / 2,
                                window_root.width, window_root.height)
                }
            }

            if (window_flags !== combobox_elevator_setting_0_2.currentIndex) {
                window_flags = combobox_elevator_setting_0_2.currentIndex

                switch (window_flags) {
                case 0:
                    window_root.flags = Qt.Window
                    window_root.height = window_root.minimumHeight = 720
                    window_root.width = window_root.minimumWidth = 1280
                    window_root.setGeometry(
                                (window_root.maximumWidth - window_root.width) / 2,
                                (window_root.maximumHeight - window_root.height) / 2,
                                window_root.width, window_root.height)
                    break
                case 1:
                    window_root.flags = Qt.FramelessWindowHint | Qt.Window
                    window_root.height = window_root.minimumHeight = 720
                    window_root.width = window_root.minimumWidth = 1280
                    window_root.setGeometry(
                                (window_root.maximumWidth - window_root.width) / 2,
                                (window_root.maximumHeight - window_root.height) / 2,
                                window_root.width, window_root.height)
                    break
                case 2:
                    window_root.flags = Qt.FramelessWindowHint
                    window_root.height = window_root.minimumHeight = window_root.maximumHeight
                    window_root.width = window_root.minimumWidth = window_root.maximumWidth
                    window_root.setGeometry(0, 0, window_root.width,
                                            window_root.height)
                    break
                }
            }

            Elevator.start(floor_max, floor_min, time_door_move,
                           time_next_floor, time_stop)
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

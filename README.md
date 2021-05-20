# 电梯多媒体指示系统 - Melecator

## 屏幕截图

* 我的电脑（v0.7.9-x64）
![screenshot](https://user-images.githubusercontent.com/34391595/117824905-6fcb3800-b2a1-11eb-8747-1ee6e378ca1b.png)
* 树莓派 4B（v0.7.9-arm64）
![screenshot](https://user-images.githubusercontent.com/34391595/117837180-cfc6dc00-b2ab-11eb-8330-a80836aa9381.png)

## 主要功能

* 跨平台支持
  * Windows 10 (x64) 可使用 `MinGW 8.1.0` 或 `MSVC 2019` 进行编译和运行
  * Linux Ubuntu 21.04 (arm64) 可使用 `GCC 10` 或 `Clang 12` 进行编译和运行
    * X11 窗口系统：正常运行（支持 XRDP 远程桌面连接）
    * Wayland 窗口系统：正常运行且帧率更高
  * 所有图片资源均为矢量（SVG）格式，支持自适应常见屏幕分辨率（建议宽高比接近 `16:9`，最小分辨率为 `1280×720`）和高 DPI 缩放
  * 对设备的 GPU 性能有一定需求（因为渲染方式与基于 OpenGL 的游戏类似），若硬件性能较低且分辨率过高将导致显示帧率下降
    * 可降低屏幕分辨率（不建议）或降低当前播放视频的分辨率以提升性能
    * 亦可使用“全屏幕”或“无边框”模式而不是“窗口化”，以降低绘制窗口装饰时产生的性能开销
* 本地视频循环播放
  * 从指定路径搜索视频文件，并使用本机解码器进行随机或循环播放
    * 由于 Qt Multimedia 直接使用系统提供的解码器播放媒体文件，因此目标操作系统需要安装适合的解码器以实现视频播放
    * 支持符合操作系统规则且视频解码器支持的任意类型路径（本地或远程均可），请查阅 FFMpeg/GStreamer/LAVFilters 的说明文档以获取支持的路径类型及更多信息
  * 自动进行等比例缩放以避免黑边
  * 支持上一个/下一个切换
  * 在切换视频时平滑过渡
* 天气信息展示
  * 使用高德地图天气 API
  * 实时天气（包括天气类型、温湿度、风力等）
  * 预报天气（四天内的天气概况）
* 新冠疫情数据展示
  * 使用由 [BlankerL](https://github.com/BlankerL/DXY-COVID-19-Crawler) 提供的疫情状况数据
  * 本省疫情数据（现存确诊、疑似病例、已治愈和死亡数量）
  * 省会疫情数据（包括地区风险等级）
* 时钟和滚动通知
  * 展示当前时间和日期
  * 从指定路径搜索通知文件（纯文本，首行为通知标题，后续为通知内容）
* 基本错误处理
  * 捕获数据获取异常（视频、通知、天气和疫情信息）并进行处理
  * 弹出对话框询问用户下一步操作（可选”重试“或”取消“）
* 程序设置
  * 各设置项按照“常规”、“媒体”、“通知和信息栏”和“模拟电梯选项”进行分组，界面直观且适合触摸操作
  * 支持自定义电梯名称和设备所在楼层（仅限测试）
* 模拟电梯功能
  * 电梯在本质上属于按照固定规则运行的有限状态机，因此可以通过有限个判断结构实现对电梯运行方式的模拟，且时间复杂度不超过常数 O(n)
  * 为保证用户界面可随时响应用户的操作，模拟电梯在设计上采用非阻塞方式，按特定间隔（默认为 1000 毫秒）定时更新运行状态，因此可确保用户与电梯之间的交互在不超出此间隔的时间内得到相应
  * 本程序在实现时采用的基本原则是“空间换时间”，通过在内存中存储将会多次使用的数据，尽可能避免重复的查询和操作
* 电梯运行状态指示
  * 电梯所在楼层和运行方向（包括停靠状态和开/关门提醒）
  * 电梯将要停靠的楼层和预计到达时间（包括进度指示）
  * 额外状态信息展示（电梯名称、负载情况、所在位置等）
* 电梯上/下行呼叫按钮
  * 在被选定时改变外观，再次点击即取消呼叫
  * 电梯到达时自动禁用以防止误触
  * 根据设备所在楼层自动启用或禁用对应按钮
  * 在设备切换到不同楼层时自动更新状态（仅限测试）

## 编译和运行

* 软件包和依赖
  * Qt 版本：`5.15.y`
  * 使用的 Qt 模块（最少情况）：`quick quickcontrols2 svg`
  * Debian/Ubuntu 软件包：`libqt5multimedia5-plugins libqt5svg5 libqt5svg5-dev qml-module-qtmultimedia qml-module-qtquick-controls2 qml-module-qtquick-layouts qml-module-qtquick-window2 qt5-qmake qtbase5-dev qtdeclarative5-dev qtquickcontrols2-5-dev`
* Windows
  * 使用 Qt Creator 打开本项目，根据实际情况配置构建设置后即可编译项目并运行
  * Qt Multimedia 在 Windows 下默认使用 DirectShow 进行视频播放，因此可能需要安装额外的 DirectShow 解码器（例如基于 FFMpeg 的 [LAVFilters](https://github.com/Nevcairiel/LAVFilters)）以对更多媒体格式提供支持
* Linux
  * 在本项目的 `melecator` 目录下运行命令：`qmake && make && ./melecator`
  * 使用本项目提供的 `build.sh` 脚本完成操作（示例：`./build.sh build` 或 `./build.sh clean`）
    * 无参数：编译并运行
    * 参数 `build`：仅编译而不运行（等同于 `qmake && make -j2`）
    * 参数 `clean`：清理编译生成的所有文件（基本等同于 `make clean`）
  * Qt Multimedia 在 Linux 下直接使用系统提供的解码器播放媒体文件（在 Debian/Ubuntu 下默认为 GStreamer），因此可能需要安装额外的 GStreamer 插件（例如同样由 FFMpeg 提供支持的 `gstreamer1.0-libav`）以对更多媒体格式提供支持

## 许可证

* 本项目使用 Qt 5.15 的开源（非商业许可）版本进行开发，遵循 [GPLv3](https://github.com/BYZYB/multimedia-elevator-indicator/blob/master/LICENSE) 开源许可协议

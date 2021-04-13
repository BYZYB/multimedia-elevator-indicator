# 电梯多媒体指示系统 - Melecator

## 屏幕截图（v0.5.0）

* Windows 电脑
![image](https://user-images.githubusercontent.com/34391595/114176394-a85bb700-996d-11eb-80f8-7dd5940caf71.png)
* 树莓派 4B
![屏幕截图 2021-04-09 222000](https://user-images.githubusercontent.com/34391595/114197229-b537d500-9984-11eb-8083-72f3c1dc5d0f.png)

## 已实现功能

* 跨平台支持
  * Windows 10 (x64) 可使用 `MinGW 8.1.0` 或 `MSVC 2019` 进行编译和运行
  * Linux Ubuntu 21.04 (arm64) 可使用 `GCC 10` 或 `Clang 12` 进行编译和运行
    * X11 窗口系统：正常运行（包括 XRDP 远程桌面连接）
    * Wayland 窗口系统：帧率较高但渲染异常（应该是 GPU 驱动对 Wayland 兼容性不佳的缘故）
  * 支持自适应常见屏幕分辨率（建议宽高比接近 `16:9`，最小分辨率为 `1280×720`）和高 DPI 缩放（已测试 `100% ~ 200%`）
  * 对设备的 GPU 性能有一定需求，若性能较低且分辨率较高将导致显示帧率下降
* 本地视频循环播放
  * 从指定路径搜索视频文件并进行随机播放
  * 自动进行等比例缩放以避免黑边
  * 支持上一个/下一个切换
  * 在切换视频时平滑过渡
* 天气信息展示
  * 使用高德地图天气 API
  * 实时天气（每小时更新，包括天气类型、温湿度、风力等）
  * 预报天气（四天内的天气概况）
* 新冠疫情数据展示
  * 使用来自 [BlankerL](https://github.com/BlankerL/DXY-COVID-19-Crawler) 的疫情状况数据
  * 本省疫情数据（现存确诊、疑似病例、已治愈和死亡数量）
  * 省会疫情数据（包括地区风险等级）
* 时钟与滚动通知
  * 展示当前时间与日期
  * 从指定路径搜索通知文件（纯文本，首行为通知标题，后续为通知内容）
* 基本错误处理
  * 捕获数据获取异常（视频、通知、天气和疫情信息）并进行处理
  * 弹出对话框询问用户下一步操作（可选”重试“或”取消“）

## 待实现功能

* 电梯运行状态指示
  * 电梯所在楼层和运行方向
  * 电梯将要停靠的楼层和预计到达时间
  * 常规状态信息展示（超载或负载情况、故障或停用、本层是否停靠等）
* 电梯上/下行呼叫按钮
  * 在被选定时改变外观，再次点击即取消呼叫
  * 电梯到达时自动切换为开/关门按钮
  * 展示提示信息（细节待定，例如上行电梯到达时在下行按钮上显示提醒，电梯未到达时显示预计到达时间等）

## 编译与运行

* 依赖
  * Qt 版本：`5.15`
  * 模块：`qt5-qmake qtdeclarative5 qtmultimedia5 qtquickcontrols2-5`
* Windows
  * 直接使用 Qt Creator 打开本项目，根据实际情况配置构建设置后即可编译项目并运行
  * 由于 Qt Multimedia 直接使用系统提供的解码器播放媒体文件，因此可能需要安装额外的 DirectShow 解码器（比如 [LAVFilters](https://github.com/Nevcairiel/LAVFilters)）以对更多媒体格式提供支持
* Linux
  * 在本项目的 `melecator` 目录下运行命令：`qmake && make && ./melecator`
  * 也可以使用本项目提供的 `build.sh` 脚本完成操作（示例：`./build.sh build`）
    * 无参数：编译并运行
    * 参数 `build`：仅编译而不运行（等同于 `qmake && make -j2`）
    * 参数 `clean`：清理编译生成的所有文件（基本等同于 `make clean`）

## 许可证

* 本项目使用 Qt 5.15 的开源（非商业许可）版本进行开发，遵循 [GPLv3](https://github.com/BYZYB/multimedia-elevator-indicator/blob/master/LICENSE) 开源许可协议

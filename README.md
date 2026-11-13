<p align="center"><img src="assets/covers/42-ai_toolkit.jpg" alt="全能工具箱 项目封面" width="100%"></p>

<h1 align="center">AiToolkit · 全能工具箱</h1>

<p align="center">Flutter 跨端小工具集合，离线可用，APK 体积精简</p>

<p align="center">
  <a href="LICENSE">MIT 许可</a>
</p>

## 简介

一个把日常小工具塞进同一个 App 的 Android / iOS 应用：算一下、转个单位、开个番茄钟、生成密码、格式化 JSON，都不用再装一堆独立应用。全部功能本地完成，不需要联网。

## 功能

| 模块 | 说明 |
|---|---|
| 登录 | 本地演示账户，数据仅存本机 |
| 计算器 | 四则运算，支持括号 |
| 单位换算 | 长度 / 重量 / 温度 |
| 倒计时 | 番茄钟预设 + 自定义时长 |
| 密码生成 | 可配置长度与字符集 |
| JSON 格式化 | 美化 / 压缩 |
| 笔记 | 本地 Hive 存储 |
| 打卡 | 习惯追踪，累计天数 |
| 设置 | 深色模式、关于页 |

## 技术栈

Flutter 3.x · Material 3 · Provider（状态管理）· Hive（本地存储）

## 快速开始

```bash
flutter pub get
flutter run
```

默认演示账户：`demo` / `1234`。

## 构建 APK

```bash
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/debug-info
```

产物在 `build/app/outputs/flutter-apk/`：

- `app-armeabi-v7a-release.apk` — 32 位 ARM，约 8–12 MB
- `app-arm64-v8a-release.apk` — 64 位 ARM，推荐，约 10–15 MB

## 许可证

[MIT](LICENSE) ｜ [@aiyangdie](https://github.com/aiyangdie) · aike1015@qq.com

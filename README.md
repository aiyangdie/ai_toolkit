# AiToolkit

轻量全能工具箱 Android/iOS App —— Flutter 跨端，离线可用，APK 体积精简。

## 功能

| 模块 | 说明 |
|------|------|
| 登录 | 本地演示账户，数据仅存本机 |
| 计算器 | 四则运算，支持括号 |
| 单位换算 | 长度 / 重量 / 温度 |
| 倒计时 | 番茄钟预设 + 自定义 |
| 密码生成 | 可配置长度与字符集 |
| JSON 格式化 | 美化 / 压缩 |
| 笔记 | 本地 Hive 存储 |
| 打卡 | 习惯追踪，累计天数 |
| 设置 | 深色模式、关于 |

## 快速体验

默认账户：`demo` / `1234`

## 构建 APK（体积优化）

```bash
flutter pub get
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/debug-info
```

输出目录：`build/app/outputs/flutter-apk/`

- `app-armeabi-v7a-release.apk` — 32 位 ARM（约 8–12 MB）
- `app-arm64-v8a-release.apk` — 64 位 ARM（推荐，约 10–15 MB）

## 开发

```bash
flutter pub get
flutter run
```

## 技术栈

- Flutter 3.x + Material 3
- Hive（本地存储）
- Provider（状态管理）

## 开源协议

MIT License

## 作者

- GitHub: [@aiyangdie](https://github.com/aiyangdie)
- Email: aike1015@qq.com

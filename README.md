# WeGame - 文本到语音转换桌面应用

## 项目概述
WeGame 是一个基于 Flutter 的跨平台桌面应用程序，专注于文本到语音转换（TTS）功能。它提供了模型选择、语音参数调整和转换结果管理等功能。

## 主要功能
- 文本到语音转换
- 模型选择和管理
- 语音参数调整（语速、音量）
- 转换结果展示
- 用户认证和API密钥管理

## 技术栈
- **前端框架**: Flutter
- **状态管理**: GetX
- **后端服务**: PocketBase
- **TTS API**: FishAudio
- **窗口管理**: bitsdojo_window
- **网络请求**: Dio
- **本地存储**: sqflite

## 运行说明
1. 确保已安装 Flutter SDK
2. 克隆项目仓库
3. 安装依赖：
   ```bash
   flutter pub get
   ```
4. 运行项目：
   ```bash
   flutter run
   ```

## 依赖安装
项目依赖在 `pubspec.yaml` 文件中定义。运行以下命令安装所有依赖：
```bash
flutter pub get
```

## 项目结构
```
lib/
├── controllers/        # 控制器
├── services/           # 服务层
├── utils/              # 工具类
├── widgets/            # 自定义组件
└── main.dart           # 应用入口

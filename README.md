# 太阳系模拟 (Solar System Simulation)

中文 | [English](README_EN.md)

一个使用Flutter开发的交互式太阳系模拟应用，展示行星运动和特性。

## 项目介绍

本项目是一个太阳系模拟应用，通过精美的动画和交互效果，直观地展示太阳系中各个行星的运动轨迹、自转特性以及物理特征。应用采用了Flutter框架开发，具有流畅的动画效果和响应式的用户界面。

## 功能特点

- **行星模拟**：模拟太阳系中八大行星的运动轨迹和自转
- **视觉效果**：精美的行星渲染，包括特殊特征（如土星环、木星大红斑等）
- **交互控制**：
  - 缩放和平移功能，自由探索太阳系
  - 点击选择行星，查看详细信息
  - 动画速度调节
  - 暂停/播放控制
- **行星信息**：展示每个行星的基本数据和特性描述
- **沉浸式体验**：星空背景和引力场视觉效果

## 技术实现

- **Flutter框架**：使用Flutter开发跨平台应用
- **自定义绘制**：通过CustomPainter实现行星系统的绘制
- **动画系统**：使用AnimationController控制行星运动
- **物理模型**：模拟行星轨道运动和自转
- **响应式UI**：适配不同屏幕尺寸的用户界面
- **手势识别**：实现缩放、平移和点击交互

## 项目结构

```
lib/
├── main.dart              # 应用入口
├── models/               # 数据模型
│   ├── planet.dart       # 行星模型
│   └── solar_system.dart # 太阳系模型
├── painters/             # 自定义绘制
│   └── solar_system_painter.dart # 太阳系绘制器
└── screens/              # 界面
    └── solar_system_screen.dart  # 主屏幕
```

## 行星特性

应用模拟了太阳系中的八大行星，每个行星都有以下特性：

- 轨道半径和周期
- 行星大小和颜色
- 自转周期和角度
- 特殊视觉特征（如土星环、木星大红斑等）
- 行星描述信息

## 运行项目

确保已安装Flutter开发环境，然后执行：

```bash
# 获取依赖
flutter pub get

# 运行应用
flutter run
```

## 系统要求

- Flutter SDK: ^3.7.0
- Dart SDK: ^3.0.0
- 支持平台: Android, iOS, Web, Windows

## 开发与贡献

欢迎提交问题和改进建议！如果您想为项目做出贡献，请遵循以下步骤：

1. Fork 项目
2. 创建您的特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交您的更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 打开一个 Pull Request

## 许可证

本项目采用 MIT 许可证 - 详情请参阅 LICENSE 文件。

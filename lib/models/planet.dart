import 'dart:math' as math;

class Planet {
  final String name;
  final double radius; // 行星半径（像素）
  final double orbitRadius; // 轨道半径（像素）
  final double orbitPeriod; // 轨道周期（秒）
  final int color; // 行星颜色
  final int secondaryColor; // 行星辅助颜色（用于特殊特征）
  final String description; // 行星描述
  final String specialFeature; // 行星特殊特征（如土星环、木星红斑）
  final double rotationPeriod; // 自转周期（秒）
  double angle = 0.0; // 当前角度位置
  double rotationAngle = 0.0; // 自转角度

  Planet({
    required this.name,
    required this.radius,
    required this.orbitRadius,
    required this.orbitPeriod,
    required this.color,
    required this.description,
    this.secondaryColor = 0xFFFFFFFF,
    this.specialFeature = '',
    this.rotationPeriod = 10.0,
  });

  // 更新行星位置和自转
  void update(double deltaTime) {
    // 根据轨道周期计算角速度（弧度/秒）
    final angularVelocity = 2 * math.pi / orbitPeriod;
    // 更新角度位置
    angle += angularVelocity * deltaTime;
    // 保持角度在 0-2π 之间
    if (angle > 2 * math.pi) {
      angle -= 2 * math.pi;
    }
    
    // 更新自转角度
    final rotationVelocity = 2 * math.pi / rotationPeriod;
    rotationAngle += rotationVelocity * deltaTime;
    // 保持自转角度在 0-2π 之间
    if (rotationAngle > 2 * math.pi) {
      rotationAngle -= 2 * math.pi;
    }
  }

  // 获取行星当前的 x 坐标
  double get x => orbitRadius * math.cos(angle);

  // 获取行星当前的 y 坐标
  double get y => orbitRadius * math.sin(angle);
}
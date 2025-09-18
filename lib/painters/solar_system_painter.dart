import 'package:flutter/material.dart';
import '../models/solar_system.dart';
import '../models/planet.dart';
import 'dart:math' show Random;
import 'dart:math' as math;

class SolarSystemPainter extends CustomPainter {
  final SolarSystem solarSystem;
  final double scale;
  final Offset offset;
  final Planet? selectedPlanet;
  
  // 太阳半径
  final double sunRadius = 30.0;
  
  SolarSystemPainter({
    required this.solarSystem,
    this.scale = 1.0,
    this.offset = Offset.zero,
    this.selectedPlanet,
  });
  
  final _orbitPaint = Paint()
    ..color = const Color(0x668A2BE2) // 引力紫色，半透明
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;
  final _highlightPaint = Paint()
    ..color = const Color(0xFF00FFFF) // 能量青色
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;
  final Map<int, Paint> _planetPaints = {};
  final Map<int, Paint> _secondaryPaints = {};
  
  @override
  void paint(Canvas canvas, Size size) {
    // 绘制动态星云背景
    _drawStarryBackground(canvas, size);
    
    // 将坐标系移到屏幕中心
    final centerX = size.width / 2 + offset.dx;
    final centerY = size.height / 2 + offset.dy;
    
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.scale(scale, scale);
    
    // 绘制行星轨道和引力场
    _drawOrbitsAndGravityFields(canvas);
    
    // 绘制太阳
    _drawSun(canvas);
    
    // 绘制行星
    for (var planet in solarSystem.planets) {
      final planetPosition = Offset(planet.x, planet.y);
      
      // 获取或创建行星的Paint对象
      final planetPaint = _getPlanetPaint(planet.color);
      final secondaryPaint = _getSecondaryPaint(planet.secondaryColor);
      
      // 如果是选中的行星，绘制引力场和高亮边框
      if (selectedPlanet == planet) {
        _drawPlanetHighlight(canvas, planetPosition, planet);
      }
      
      // 绘制行星及其特殊特征
      _drawPlanetWithFeatures(canvas, planetPosition, planet, planetPaint, secondaryPaint);
    }
    
    canvas.restore();
  }
  
  // 绘制星空背景
  void _drawStarryBackground(Canvas canvas, Size size) {
    // 创建深空渐变背景
    final Rect rect = Offset.zero & size;
    final Paint backgroundPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.2,
        colors: const [
          Color(0xFF0A0D2C),  // 深蓝中心
          Color(0xFF1A1F4A),  // 中等蓝
          Color(0xFF0F1133),  // 暗紫蓝
          Color(0xFF000000),  // 黑色边缘
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(rect);
    
    canvas.drawRect(rect, backgroundPaint);
    
    // 绘制星云效果
    _drawNebula(canvas, size);
    
    // 绘制多层次星星
    _drawStars(canvas, size);
  }
  
  // 绘制星云效果
  void _drawNebula(Canvas canvas, Size size) {
    final Random random = Random(42);
    final nebulaPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    for (int i = 0; i < 8; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 50 + random.nextDouble() * 100;
      
      nebulaPaint.color = [
        const Color(0x1A8A2BE2),  // 紫色星云
        const Color(0x1A00FFFF),  // 青色星云
        const Color(0x1AFF69B4),  // 粉色星云
        const Color(0x1A9370DB),  // 中紫色星云
      ][random.nextInt(4)];
      
      canvas.drawCircle(Offset(x, y), radius, nebulaPaint);
    }
  }
  
  // 绘制多层次星星
  void _drawStars(Canvas canvas, Size size) {
    final Random random = Random(42);
    
    // 大星星（亮星）
    final brightStarPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 1.5 + random.nextDouble() * 1.0;
      
      // 星星闪烁效果
      brightStarPaint.color = Colors.white.withOpacity(0.8 + random.nextDouble() * 0.2);
      canvas.drawCircle(Offset(x, y), radius, brightStarPaint);
      
      // 添加十字光芒
      _drawStarGlow(canvas, Offset(x, y), radius * 2);
    }
    
    // 中等星星
    final mediumStarPaint = Paint()..color = Colors.white.withOpacity(0.6);
    for (int i = 0; i < 80; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 0.8 + random.nextDouble() * 0.7;
      canvas.drawCircle(Offset(x, y), radius, mediumStarPaint);
    }
    
    // 小星星（背景）
    final smallStarPaint = Paint()..color = Colors.white.withOpacity(0.4);
    for (int i = 0; i < 150; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = 0.3 + random.nextDouble() * 0.5;
      canvas.drawCircle(Offset(x, y), radius, smallStarPaint);
    }
  }
  
  // 绘制星星光芒
  void _drawStarGlow(Canvas canvas, Offset center, double size) {
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 0.5;
    
    // 水平光芒
    canvas.drawLine(
      Offset(center.dx - size, center.dy),
      Offset(center.dx + size, center.dy),
      glowPaint,
    );
    
    // 垂直光芒
    canvas.drawLine(
      Offset(center.dx, center.dy - size),
      Offset(center.dx, center.dy + size),
      glowPaint,
    );
  }
  
  // 绘制轨道和引力场
  void _drawOrbitsAndGravityFields(Canvas canvas) {
    for (var planet in solarSystem.planets) {
      // 绘制基础轨道
      final baseOrbitPaint = Paint()
        ..color = const Color(0x338A2BE2) // 引力紫色，更透明
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      
      canvas.drawCircle(Offset.zero, planet.orbitRadius, baseOrbitPaint);
      
      // 为选中的行星绘制增强轨道效果
      if (selectedPlanet == planet) {
        // 主轨道高亮
        final selectedOrbitPaint = Paint()
          ..color = const Color(0xCC00FFFF) // 亮青色
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);
        
        canvas.drawCircle(Offset.zero, planet.orbitRadius, selectedOrbitPaint);
        
        // 轨道光晕效果
        final orbitGlowPaint = Paint()
          ..color = const Color(0x4400FFFF) // 半透明青色
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
        
        canvas.drawCircle(Offset.zero, planet.orbitRadius, orbitGlowPaint);
        
        // 绘制轨道上的能量粒子
        _drawOrbitParticles(canvas, planet);
      }
    }
  }
  
  // 绘制轨道粒子效果
  void _drawOrbitParticles(Canvas canvas, Planet planet) {
    final Random random = Random(planet.name.hashCode);
    final particlePaint = Paint()
      ..color = const Color(0x6600FFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);
    
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * (math.pi / 180); // 每30度一个粒子
      final x = planet.orbitRadius * math.cos(angle);
      final y = planet.orbitRadius * math.sin(angle);
      final size = 1.0 + random.nextDouble() * 1.5;
      
      canvas.drawCircle(Offset(x, y), size, particlePaint);
    }
  }
  
  // 绘制太阳
  void _drawSun(Canvas canvas) {
    // 太阳外层光晕（最大范围）
    final sunOuterGlowPaint = Paint()
      ..color = const Color(0x1AFFD700) // 极浅透明金色
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25.0);
    canvas.drawCircle(Offset.zero, sunRadius * 2.5, sunOuterGlowPaint);
    
    // 太阳中层光晕
    final sunMidGlowPaint = Paint()
      ..color = const Color(0x33FFD700) // 半透明金色
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);
    canvas.drawCircle(Offset.zero, sunRadius * 1.8, sunMidGlowPaint);
    
    // 太阳内层光晕
    final sunInnerGlowPaint = Paint()
      ..color = const Color(0x66FFD700) // 中等透明金色
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawCircle(Offset.zero, sunRadius * 1.3, sunInnerGlowPaint);
    
    // 太阳主体渐变
    final sunGradientPaint = Paint()
      ..shader = RadialGradient(
        colors: const [
          Color(0xFFFFFFFF),  // 白色中心（最热）
          Color(0xFFFFEB3B),  // 亮黄色
          Color(0xFFFFD700),  // 金色
          Color(0xFFFF8C00),  // 橙色
          Color(0xFFFF6347),  // 红橙色边缘
        ],
        stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: sunRadius));
    
    canvas.drawCircle(Offset.zero, sunRadius, sunGradientPaint);
    
    // 太阳表面耀斑效果
    _drawSolarFlares(canvas);
    
    // 太阳黑子效果
    _drawSunspots(canvas);
  }
  
  // 绘制太阳耀斑
  void _drawSolarFlares(Canvas canvas) {
    final Random random = Random(123);
    final flarePaint = Paint()
      ..color = const Color(0x44FFFF00)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180); // 转换为弧度
      final distance = sunRadius * (0.8 + random.nextDouble() * 0.4);
      final x = distance * math.cos(angle);
      final y = distance * math.sin(angle);
      final size = 2 + random.nextDouble() * 3;
      
      canvas.drawCircle(Offset(x, y), size, flarePaint);
    }
  }
  
  // 绘制太阳黑子
  void _drawSunspots(Canvas canvas) {
    final Random random = Random(456);
    final sunspotPaint = Paint()
      ..color = const Color(0x44000000);
    
    for (int i = 0; i < 4; i++) {
      final angle = random.nextDouble() * 2 * 3.14159;
      final distance = sunRadius * (0.3 + random.nextDouble() * 0.4);
      final x = distance * math.cos(angle);
      final y = distance * math.sin(angle);
      final size = 1 + random.nextDouble() * 2;
      
      canvas.drawCircle(Offset(x, y), size, sunspotPaint);
    }
  }
  
  // 绘制行星高亮效果
  void _drawPlanetHighlight(Canvas canvas, Offset position, Planet planet) {
    // 外层选择环
    final outerRingPaint = Paint()
      ..color = const Color(0x8800FFFF) // 半透明青色
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    
    canvas.drawCircle(position, planet.radius + 8, outerRingPaint);
    
    // 内层选择环
    final innerRingPaint = Paint()
      ..color = const Color(0xFF00FFFF) // 亮青色
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawCircle(position, planet.radius + 4, innerRingPaint);
    
    // 绘制脉冲波纹效果
    _drawPulseRipples(canvas, position, planet);
    
    // 绘制选择指示器
    _drawSelectionIndicator(canvas, position, planet);
  }
  
  // 绘制脉冲波纹
  void _drawPulseRipples(Canvas canvas, Offset position, Planet planet) {
    final ripplePaint = Paint()
      ..color = const Color(0x3300FFFF) // 非常透明的青色
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    for (int i = 1; i <= 4; i++) {
      final radius = planet.radius + (i * 12);
      final opacity = (5 - i) / 5; // 逐渐减弱
      ripplePaint.color = Color.fromRGBO(0, 255, 255, opacity * 0.3);
      canvas.drawCircle(position, radius, ripplePaint);
    }
  }
  
  // 绘制选择指示器
  void _drawSelectionIndicator(Canvas canvas, Offset position, Planet planet) {
    final indicatorPaint = Paint()
      ..color = const Color(0xFF00FFFF)
      ..style = PaintingStyle.fill;
    
    // 绘制四个小三角形作为指示器
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2; // 90度间隔
      final distance = planet.radius + 15;
      final x = position.dx + distance * math.cos(angle);
      final y = position.dy + distance * math.sin(angle);
      
      final path = Path();
      final size = 3.0;
      path.moveTo(x, y - size);
      path.lineTo(x - size, y + size);
      path.lineTo(x + size, y + size);
      path.close();
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + math.pi / 2);
      canvas.translate(-x, -y);
      canvas.drawPath(path, indicatorPaint);
      canvas.restore();
    }
  }
  
  // 获取行星的Paint对象
  Paint _getPlanetPaint(int color) {
    if (!_planetPaints.containsKey(color)) {
      _planetPaints[color] = Paint()..color = Color(color);
    }
    return _planetPaints[color]!;
  }
  
  // 获取行星辅助特征的Paint对象
  Paint _getSecondaryPaint(int color) {
    if (!_secondaryPaints.containsKey(color)) {
      _secondaryPaints[color] = Paint()..color = Color(color);
    }
    return _secondaryPaints[color]!;
  }
  
  // 绘制行星及其特殊特征
  void _drawPlanetWithFeatures(Canvas canvas, Offset position, Planet planet, Paint planetPaint, Paint secondaryPaint) {
    // 绘制行星阴影（在行星后面）
    _drawPlanetShadow(canvas, position, planet);
    
    // 增强行星主体渐变效果
    _drawEnhancedPlanet(canvas, position, planet);
    
    // 根据行星名称绘制特殊特征
    switch (planet.name) {
      case '土星':
        _drawSaturnRings(canvas, position, planet, secondaryPaint);
        break;
      case '木星':
        _drawJupiterFeatures(canvas, position, planet, secondaryPaint);
        break;
      case '地球':
        _drawEarthFeatures(canvas, position, planet, secondaryPaint);
        break;
      case '火星':
        _drawMarsFeatures(canvas, position, planet, secondaryPaint);
        break;
      case '金星':
        _drawVenusFeatures(canvas, position, planet, secondaryPaint);
        break;
      case '天王星':
        _drawUranusFeatures(canvas, position, planet, secondaryPaint);
        break;
      case '海王星':
        _drawNeptuneFeatures(canvas, position, planet, secondaryPaint);
        break;
      default:
        // 为其他行星添加简单的光影效果
        _drawSimpleShadow(canvas, position, planet);
    }
    
    // 绘制行星光晕
    _drawPlanetGlow(canvas, position, planet);
  }
  
  // 绘制增强的行星主体
  void _drawEnhancedPlanet(Canvas canvas, Offset position, Planet planet) {
    // 创建径向渐变画笔
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3), // 光源在左上方
        radius: 1.2,
        colors: [
          Color(planet.color).withOpacity(1.0),
          Color(planet.color).withOpacity(0.9),
          Color(planet.color).withOpacity(0.7),
          Color(planet.color).withOpacity(0.5),
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: position, radius: planet.radius));
    
    canvas.drawCircle(position, planet.radius, gradientPaint);
  }
  
  // 绘制行星阴影
  void _drawPlanetShadow(Canvas canvas, Offset position, Planet planet) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    
    // 阴影稍微偏移
    final shadowOffset = Offset(position.dx + 1, position.dy + 1);
    canvas.drawCircle(shadowOffset, planet.radius, shadowPaint);
  }
  
  // 绘制行星光晕
  void _drawPlanetGlow(Canvas canvas, Offset position, Planet planet) {
    final glowPaint = Paint()
      ..color = Color(planet.color).withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    
    canvas.drawCircle(position, planet.radius * 1.4, glowPaint);
  }
  
  // 绘制土星环
  void _drawSaturnRings(Canvas canvas, Offset position, Planet planet, Paint ringPaint) {
    final rect = Rect.fromCenter(
      center: position,
      width: planet.radius * 2.5,
      height: planet.radius * 0.8,
    );
    
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(planet.rotationAngle * 0.2); // 环的旋转速度较慢
    canvas.translate(-position.dx, -position.dy);
    
    canvas.drawOval(rect, ringPaint);
    
    // 环的内部透明区域
    final innerRingPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    final innerRect = Rect.fromCenter(
      center: position,
      width: planet.radius * 2.2,
      height: planet.radius * 0.7,
    );
    
    canvas.drawOval(innerRect, innerRingPaint);
    canvas.restore();
  }
  
  // 绘制木星特征（条纹和大红斑）
  void _drawJupiterFeatures(Canvas canvas, Offset position, Planet planet, Paint spotPaint) {
    // 绘制大红斑
    final redSpotPaint = Paint()..color = Colors.redAccent.withOpacity(0.7);
    
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(planet.rotationAngle);
    
    final redSpotRect = Rect.fromCenter(
      center: Offset(planet.radius * 0.4, 0),
      width: planet.radius * 0.7,
      height: planet.radius * 0.4,
    );
    
    canvas.drawOval(redSpotRect, redSpotPaint);
    canvas.restore();
  }
  
  // 绘制地球特征（陆地）
  void _drawEarthFeatures(Canvas canvas, Offset position, Planet planet, Paint landPaint) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(planet.rotationAngle);
    
    // 简化的大陆形状
    final path = Path();
    path.moveTo(-planet.radius * 0.3, -planet.radius * 0.2);
    path.lineTo(planet.radius * 0.1, -planet.radius * 0.5);
    path.lineTo(planet.radius * 0.5, -planet.radius * 0.1);
    path.lineTo(planet.radius * 0.2, planet.radius * 0.3);
    path.lineTo(-planet.radius * 0.4, planet.radius * 0.4);
    path.close();
    
    canvas.drawPath(path, landPaint);
    
    // 另一块大陆
    final path2 = Path();
    path2.moveTo(-planet.radius * 0.1, planet.radius * 0.1);
    path2.lineTo(planet.radius * 0.3, planet.radius * 0.2);
    path2.lineTo(planet.radius * 0.1, planet.radius * 0.5);
    path2.lineTo(-planet.radius * 0.2, planet.radius * 0.3);
    path2.close();
    
    canvas.drawPath(path2, landPaint);
    canvas.restore();
  }
  
  // 绘制火星特征（极冠）
  void _drawMarsFeatures(Canvas canvas, Offset position, Planet planet, Paint capPaint) {
    final poleCap = Paint()..color = Colors.white.withOpacity(0.7);
    
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(planet.rotationAngle);
    
    // 北极冠
    canvas.drawCircle(Offset(0, -planet.radius * 0.6), planet.radius * 0.3, poleCap);
    
    // 南极冠（较小）
    canvas.drawCircle(Offset(0, planet.radius * 0.6), planet.radius * 0.25, poleCap);
    canvas.restore();
  }
  
  // 绘制金星特征（浓密云层）
  void _drawVenusFeatures(Canvas canvas, Offset position, Planet planet, Paint cloudPaint) {
    final venus1Paint = Paint()..color = const Color(0x66FFF8DC);
    final venus2Paint = Paint()..color = const Color(0x44FFFACD);
    
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(planet.rotationAngle * 0.3); // 云层旋转较慢
    
    // 绘制云层条纹
    for (int i = 0; i < 3; i++) {
      final y = (i - 1) * planet.radius * 0.4;
      final rect = Rect.fromCenter(
        center: Offset(0, y),
        width: planet.radius * 1.8,
        height: planet.radius * 0.3,
      );
      canvas.drawOval(rect, i % 2 == 0 ? venus1Paint : venus2Paint);
    }
    canvas.restore();
  }
  
  // 绘制天王星特征（倾斜环）
  void _drawUranusFeatures(Canvas canvas, Offset position, Planet planet, Paint ringPaint) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(math.pi / 2); // 天王星环垂直
    
    // 绘制细环
    for (int i = 0; i < 3; i++) {
      final radius = planet.radius * (1.3 + i * 0.2);
      final thinRingPaint = Paint()
        ..color = const Color(0x66C2E0F2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;
      
      canvas.drawCircle(Offset.zero, radius, thinRingPaint);
    }
    canvas.restore();
  }
  
  // 绘制海王星特征（大黑斑和风暴）
  void _drawNeptuneFeatures(Canvas canvas, Offset position, Planet planet, Paint stormPaint) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(planet.rotationAngle);
    
    // 大黑斑
    final darkSpotPaint = Paint()..color = const Color(0x88001122);
    final spotRect = Rect.fromCenter(
      center: Offset(planet.radius * 0.3, planet.radius * 0.2),
      width: planet.radius * 0.6,
      height: planet.radius * 0.4,
    );
    canvas.drawOval(spotRect, darkSpotPaint);
    
    // 风暴云纹
    final cloudPaint = Paint()..color = const Color(0x444B61D1);
    for (int i = 0; i < 2; i++) {
      final y = (i - 0.5) * planet.radius * 0.6;
      final cloudRect = Rect.fromCenter(
        center: Offset(0, y),
        width: planet.radius * 1.6,
        height: planet.radius * 0.2,
      );
      canvas.drawOval(cloudRect, cloudPaint);
    }
    
    canvas.restore();
  }
  
  // 为普通行星添加简单的光影效果
  void _drawSimpleShadow(Canvas canvas, Offset position, Planet planet) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(planet.rotationAngle);
    
    final shadowRect = Rect.fromCenter(
      center: Offset(planet.radius * 0.3, 0),
      width: planet.radius * 1.2,
      height: planet.radius * 2,
    );
    
    canvas.drawOval(shadowRect, shadowPaint);
    canvas.restore();
  }
  
  @override
  bool shouldRepaint(SolarSystemPainter oldDelegate) {
    return oldDelegate.solarSystem != solarSystem ||
           oldDelegate.scale != scale ||
           oldDelegate.offset != offset ||
           oldDelegate.selectedPlanet != selectedPlanet;
  }
  
  @override
  bool shouldRebuildSemantics(SolarSystemPainter oldDelegate) => false;
}
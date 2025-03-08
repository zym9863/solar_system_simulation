import 'package:flutter/material.dart';
import '../models/solar_system.dart';
import '../models/planet.dart';
import 'dart:math' show Random;

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
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [Color(0xFF0A0D2C), Color(0xFF1A1F4A)],
      ).createShader(rect);
    
    canvas.drawRect(rect, backgroundPaint);
    
    // 绘制随机星星
    final Random random = Random(42); // 固定种子以保持一致性
    final starPaint = Paint()..color = Colors.white.withOpacity(0.8);
    
    for (int i = 0; i < 200; i++) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;
      final double radius = random.nextDouble() * 1.5;
      
      canvas.drawCircle(Offset(x, y), radius, starPaint);
    }
  }
  
  // 绘制轨道和引力场
  void _drawOrbitsAndGravityFields(Canvas canvas) {
    for (var planet in solarSystem.planets) {
      // 绘制轨道
      canvas.drawCircle(Offset.zero, planet.orbitRadius, _orbitPaint);
      
      // 为选中的行星绘制更明显的轨道
      if (selectedPlanet == planet) {
        final selectedOrbitPaint = Paint()
          ..color = const Color(0xFF8A2BE2) // 引力紫色
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        
        canvas.drawCircle(Offset.zero, planet.orbitRadius, selectedOrbitPaint);
      }
    }
  }
  
  // 绘制太阳
  void _drawSun(Canvas canvas) {
    // 太阳主体
    final sunGradientPaint = Paint()
      ..shader = RadialGradient(
        colors: const [Color(0xFFFFD700), Color(0xFFFF8C00)],
        stops: const [0.5, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: sunRadius));
    
    canvas.drawCircle(Offset.zero, sunRadius, sunGradientPaint);
    
    // 太阳光晕
    final sunGlowPaint = Paint()
      ..color = const Color(0x33FFD700) // 半透明金色
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);
    
    canvas.drawCircle(Offset.zero, sunRadius * 1.5, sunGlowPaint);
  }
  
  // 绘制行星高亮效果
  void _drawPlanetHighlight(Canvas canvas, Offset position, Planet planet) {
    // 绘制选中高亮
    canvas.drawCircle(position, planet.radius + 4, _highlightPaint);
    
    // 绘制引力涟漪
    final ripplePaint = Paint()
      ..color = const Color(0x2200FFFF) // 非常透明的青色
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(position, planet.radius + (i * 8), ripplePaint);
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
    // 绘制行星主体
    canvas.drawCircle(position, planet.radius, planetPaint);
    
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
      default:
        // 为其他行星添加简单的光影效果
        _drawSimpleShadow(canvas, position, planet);
    }
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
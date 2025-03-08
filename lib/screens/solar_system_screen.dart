import 'package:flutter/material.dart';
import '../models/solar_system.dart';
import '../models/planet.dart';
import '../painters/solar_system_painter.dart';

class SolarSystemScreen extends StatefulWidget {
  const SolarSystemScreen({super.key});

  @override
  State<SolarSystemScreen> createState() => _SolarSystemScreenState();
}

class _SolarSystemScreenState extends State<SolarSystemScreen> with SingleTickerProviderStateMixin {
  // 构建行星数据项
  Widget _buildPlanetDataItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A3D66).withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF8A2BE2).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF00FFFF),
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFC0C0C0),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  // 太阳系数据
  final SolarSystem _solarSystem = SolarSystem();
  
  // 动画控制器
  late AnimationController _animationController;
  
  // 视图缩放和偏移
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  
  // 选中的行星
  Planet? _selectedPlanet;
  
  // 动画速度控制
  double _speedFactor = 1.0;
  bool _isPaused = false;
  
  @override
  void initState() {
    super.initState();
    
    // 初始化动画控制器
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    
    // 添加动画监听器，用于更新行星位置
    _animationController.addListener(_updatePlanets);
    
    // 开始动画循环
    _animationController.repeat();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // 更新行星位置
  void _updatePlanets() {
    if (!_isPaused) {
      // 计算时间增量（秒）
      final deltaTime = 0.016 * _speedFactor; // 假设 60fps，约 16ms 每帧
      
      // 更新太阳系中所有行星的位置
      _solarSystem.update(deltaTime);
      
      // 触发重绘
      setState(() {});
    }
  }
  
  // 处理缩放手势
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // 更新缩放比例
      _scale *= details.scale;
      
      // 限制缩放范围
      _scale = _scale.clamp(0.5, 3.0);
      
      // 更新偏移量
      _offset += details.focalPointDelta;
    });
  }
  
  // 处理点击事件，选择行星
  void _handleTapDown(TapDownDetails details) {
    // 计算点击位置相对于中心的坐标
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2 + _offset.dx;
    final centerY = size.height / 2 + _offset.dy;
    
    final localX = (details.globalPosition.dx - centerX) / _scale;
    final localY = (details.globalPosition.dy - centerY) / _scale;
    final tapPosition = Offset(localX, localY);
    
    // 检查是否点击了行星或其轨道
    Planet? tappedPlanet;
    double minDistance = double.infinity;
    
    for (var planet in _solarSystem.planets) {
      final planetPosition = Offset(planet.x, planet.y);
      final distanceToPlanet = (planetPosition - tapPosition).distance;
      
      // 计算点击位置到轨道的距离
      final distanceToCenter = tapPosition.distance;
      final distanceToOrbit = (distanceToCenter - planet.orbitRadius).abs();
      
      // 如果点击了行星本身
      if (distanceToPlanet <= planet.radius) {
        tappedPlanet = planet;
        break;
      }
      
      // 如果点击了轨道附近（允许5像素的误差范围）
      if (distanceToOrbit <= 5.0 && distanceToOrbit < minDistance) {
        minDistance = distanceToOrbit;
        tappedPlanet = planet;
      }
    }
    
    setState(() {
      _selectedPlanet = tappedPlanet;
    });
  }
  
  // 切换动画暂停/播放状态
  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }
  
  // 调整动画速度
  void _adjustSpeed(double value) {
    setState(() {
      _speedFactor = value;
    });
  }
  
  // 重置视图
  void _resetView() {
    setState(() {
      _scale = 1.0;
      _offset = Offset.zero;
      _selectedPlanet = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          '太阳系模拟',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 24,
            color: Color(0xFF2A3D66),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isPaused ? Icons.play_arrow : Icons.pause,
              color: const Color(0xFF00FFFF),
            ),
            onPressed: _togglePause,
            tooltip: _isPaused ? '播放' : '暂停',
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Color(0xFF00FFFF),
            ),
            onPressed: _resetView,
            tooltip: '重置视图',
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0A0D2C),
      body: Column(
        children: [
          // 太阳系动画区域
          Expanded(
            child: GestureDetector(
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: _handleTapDown,
              child: CustomPaint(
                painter: SolarSystemPainter(
                  solarSystem: _solarSystem,
                  scale: _scale,
                  offset: _offset,
                  selectedPlanet: _selectedPlanet,
                ),
                child: Container(),
              ),
            ),
          ),
          
          // 行星信息面板
          if (_selectedPlanet != null)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black87.withOpacity(0.85),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FFFF).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
                // 毛玻璃效果
                backgroundBlendMode: BlendMode.srcOver,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedPlanet!.name,
                        style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 24, 
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Color(0xFF00FFFF),
                              blurRadius: 8,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3D66),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '特征: ${_selectedPlanet!.specialFeature}',
                          style: const TextStyle(
                            fontSize: 14, 
                            color: Color(0xFFC0C0C0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF2A3D66).withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _selectedPlanet!.description,
                      style: const TextStyle(
                        fontSize: 16, 
                        color: Color(0xFFC0C0C0),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 行星数据可视化
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPlanetDataItem('自转周期', '${_selectedPlanet!.rotationPeriod.toStringAsFixed(1)}秒', Icons.rotate_right),
                      _buildPlanetDataItem('公转周期', '${_selectedPlanet!.orbitPeriod.toStringAsFixed(1)}秒', Icons.sync),
                      _buildPlanetDataItem('半径', '${_selectedPlanet!.radius.toStringAsFixed(1)}px', Icons.radio_button_unchecked),
                    ],
                  ),
                ],
              ),
            ),
          
          // 速度控制滑块
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.black87.withOpacity(0.85),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.speed, color: Color(0xFF00FFFF)),
                    const SizedBox(width: 8),
                    const Text(
                      '时间流速',
                      style: TextStyle(
                        fontFamily: 'Exo 2.0',
                        fontSize: 14,
                        color: Color(0xFFC0C0C0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A3D66),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_speedFactor.toStringAsFixed(1)}x',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF00FFFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF00FFFF),
                    inactiveTrackColor: const Color(0xFF2A3D66),
                    thumbColor: const Color(0xFF00FFFF),
                    overlayColor: const Color(0xFF00FFFF).withOpacity(0.2),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  ),
                  child: Slider(
                    value: _speedFactor,
                    min: 0.1,
                    max: 5.0,
                    divisions: 49,
                    onChanged: _adjustSpeed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
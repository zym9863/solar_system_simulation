import 'planet.dart';

class SolarSystem {
  final List<Planet> planets = [];
  
  // 初始化太阳系行星数据
  SolarSystem() {
    // 添加太阳系行星（使用近似比例，但不是完全真实比例）
    // 太阳不作为行星添加，将在绘制时单独处理
    
    // 水星
    planets.add(Planet(
      name: '水星',
      radius: 8,
      orbitRadius: 60,
      orbitPeriod: 10, // 模拟周期（秒）
      color: 0xFFA8A8A8, // 深灰色
      secondaryColor: 0xFFD4D4D4, // 浅灰色
      rotationPeriod: 15, // 自转周期
      description: '水星是太阳系中最小的行星，也是离太阳最近的行星。',
      specialFeature: '表面环形山',
    ));
    
    // 金星
    planets.add(Planet(
      name: '金星',
      radius: 12,
      orbitRadius: 90,
      orbitPeriod: 15,
      color: 0xFFE3B04B, // 金星主色
      secondaryColor: 0xFFFFE3A3, // 金星辅助色
      rotationPeriod: 20, // 自转周期
      description: '金星是太阳系中第二颗行星，也是除了月球外最亮的天体。',
      specialFeature: '浓密云层',
    ));
    
    // 地球
    planets.add(Planet(
      name: '地球',
      radius: 12.5,
      orbitRadius: 120,
      orbitPeriod: 20,
      color: 0xFF3A6B8C, // 地球主色
      secondaryColor: 0xFF4CAF50, // 陆地色
      rotationPeriod: 12, // 自转周期
      description: '地球是太阳系中第三颗行星，是目前已知唯一孕育和支持生命的天体。',
      specialFeature: '海洋与陆地',
    ));
    
    // 火星
    planets.add(Planet(
      name: '火星',
      radius: 10,
      orbitRadius: 150,
      orbitPeriod: 25,
      color: 0xFFC67C6D, // 火星主色
      secondaryColor: 0xFFE8A798, // 火星辅助色
      rotationPeriod: 13, // 自转周期
      description: '火星是太阳系中第四颗行星，被称为"红色星球"。',
      specialFeature: '极冠与峡谷',
    ));
    
    // 木星
    planets.add(Planet(
      name: '木星',
      radius: 25,
      orbitRadius: 200,
      orbitPeriod: 30,
      color: 0xFFBC987E, // 木星条纹色
      secondaryColor: 0xFFE0C9A6, // 木星辅助色
      rotationPeriod: 5, // 自转周期
      description: '木星是太阳系中最大的行星，是一个气态巨行星。',
      specialFeature: '大红斑',
    ));
    
    // 土星
    planets.add(Planet(
      name: '土星',
      radius: 22,
      orbitRadius: 250,
      orbitPeriod: 35,
      color: 0xFFE0C9A6, // 土星主色
      secondaryColor: 0xFFB89F7D, // 土星环色
      rotationPeriod: 6, // 自转周期
      description: '土星是太阳系中第六颗行星，以其明显的环系统而闻名。',
      specialFeature: '行星环',
    ));
    
    // 天王星
    planets.add(Planet(
      name: '天王星',
      radius: 18,
      orbitRadius: 300,
      orbitPeriod: 40,
      color: 0xFFC2E0F2, // 天王星主色
      secondaryColor: 0xFF4B61D1, // 天王星辅助色
      rotationPeriod: 8, // 自转周期
      description: '天王星是太阳系中第七颗行星，是一个冰巨行星，其自转轴几乎与公转平面垂直。',
      specialFeature: '倾斜自转轴',
    ));
    
    // 海王星
    planets.add(Planet(
      name: '海王星',
      radius: 17,
      orbitRadius: 350,
      orbitPeriod: 45,
      color: 0xFF4B61D1, // 海王星主色
      secondaryColor: 0xFFC2E0F2, // 海王星辅助色
      rotationPeriod: 9, // 自转周期
      description: '海王星是太阳系中第八颗行星，也是最远的行星，是一个风暴活跃的冰巨行星。',
      specialFeature: '大黑斑',
    ));
    

  }
  
  // 更新所有行星的位置
  void update(double deltaTime) {
    for (var planet in planets) {
      planet.update(deltaTime);
    }
  }
}
import 'package:flutter/material.dart';
import 'screens/solar_system_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '太阳系模拟',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SolarSystemScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 主页面已移至 screens/solar_system_screen.dart
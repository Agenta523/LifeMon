import 'package:flutter/material.dart';
import 'package:life_mon/screen/home_screen.dart';
import 'package:life_mon/screen/food_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeMon App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // 初期画面は HomeScreen
      home: const HomeScreen(),

      // 名前付きルートの定義
      routes: {
        '/home': (context) => const HomeScreen(),
        '/food': (context) => const FoodScreen(),
      },
    );
  }
}

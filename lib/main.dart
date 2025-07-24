// main.dart

import 'package:flutter/material.dart';
import 'presentation/navigator/analyze_navigator.dart';
import 'presentation/navigator/home_navigator.dart';
import 'presentation/navigator/food_navigator.dart';
import 'presentation/widget/bottom_navigation.dart';

// 1. HomeScreenのStateを参照するためにインポートを追加
import 'presentation/screen/home_screen/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nested Navigator App',
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;

  // 2. HomeScreenのStateにアクセスするためのGlobalKeyを作成
  final GlobalKey<HomeScreenState> _homeScreenKey =
      GlobalKey<HomeScreenState>();

  // 3. _screensリストをfinalではなくし、non-constにする
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // 4. initStateで_screensを初期化し、HomeNavigatorにkeyを渡す
    _screens = [
      const AnalyzeNavigator(),
      HomeNavigator(homeScreenKey: _homeScreenKey), // ◀️ ここでKeyを渡す
      const FoodNavigator(),
    ];
  }

  void _onItemTapped(int index) {
    // 5. ホームタブ（インデックス1）がタップされ、かつそれが現在のタブでない場合に更新
    if (index == 1 && _currentIndex != 1) {
      _homeScreenKey.currentState?.loadTodaysNutrition();
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        // 6. 更新したメソッドを渡す
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

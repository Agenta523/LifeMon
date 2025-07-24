// main.dart

import 'package:flutter/material.dart';
import 'presentation/navigator/analyze_navigator.dart';
import 'presentation/navigator/home_navigator.dart';
import 'presentation/navigator/food_navigator.dart';
import 'presentation/widget/bottom_navigation.dart';
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

  final GlobalKey<HomeScreenState> _homeScreenKey =
      GlobalKey<HomeScreenState>();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const AnalyzeNavigator(),
      HomeNavigator(homeScreenKey: _homeScreenKey),
      const FoodNavigator(),
    ];
  }

  void _onItemTapped(int index) {
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
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

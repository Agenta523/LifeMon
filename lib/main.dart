import 'package:flutter/material.dart';
import 'presentation/navigator/analyze_navigator.dart';
import 'presentation/navigator/home_navigator.dart';
import 'presentation/navigator/food_navigator.dart';
import 'presentation/widget/bottom_navigation.dart';

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

  final List<Widget> _screens = const [
    AnalyzeNavigator(),
    HomeNavigator(),
    FoodNavigator(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
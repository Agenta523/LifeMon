import 'package:flutter/material.dart';
import 'screen/home_screen/home_screen.dart';
import 'screen/analyze_screen/analyze_screen.dart';
import 'screen/food_screen/food_screen.dart';
import 'screen/food_screen/maindish_reg.dart'; // 主菜画面をインポート
import 'screen/food_screen/sidedish_reg.dart';
import 'screen/food_screen/vegetable_reg.dart';
import 'screen/food_screen/other_reg.dart';
import 'screen/food_screen/soup_reg.dart';
import 'widget/bottom_navigation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Navigation App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/maindish': (context) => const MainDishScreen(), // 主菜画面ルート
        '/sidedish': (context) => const SideDishScreen(),
        '/soup': (context) => const SoupScreen(),
        '/other': (context) => const OtherScreen(),
        '/vegetable': (context) => const VegetableScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // 最初のインデックスはhome

  final List<Widget> _screens = [
    const AnalyzeScreen(),
    const HomeScreen(),
    const FoodScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

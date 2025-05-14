import 'package:flutter/material.dart';
import 'package:life_mon/widget/calorie_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Homeを初期タブに

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, '/food'); // Food画面へ遷移
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            CalorieBar(), // カロリーバーを表示
          ],
        ),
      ),
    );
  }
}

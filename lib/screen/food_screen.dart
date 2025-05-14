import 'package:flutter/material.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8DAB5),
      body: Center(child: _buildFoodCard()),
    );
  }

  // 食事登録カード部分を関数として切り出し
  Widget _buildFoodCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          const SizedBox(height: 10),
          _buildDescription(),
          const SizedBox(height: 20),
          _buildFoodIcons(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4B400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          '食事を登録',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return const Text(
      'ここでは今日のあなたの食事を登録できます。\nあなたの食事がモンスターの餌になります！',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 13),
    );
  }

  Widget _buildFoodIcons() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: const [
        Icon(Icons.set_meal, size: 50, color: Color(0xFF9C6520)),
        Icon(Icons.ramen_dining, size: 50, color: Color(0xFF9C6520)),
        Icon(Icons.rice_bowl, size: 50, color: Color(0xFF9C6520)),
        Icon(Icons.local_florist, size: 40, color: Color(0xFF9C6520)),
      ],
    );
  }
}
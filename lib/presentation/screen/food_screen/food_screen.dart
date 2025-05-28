import 'package:flutter/material.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA8DAB5), // 背景色（淡緑）
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2D9), // メイン背景（ベージュ）
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // タイトルバー
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4B400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      '食事を登録',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 説明文
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'ここでは今日のあなたの食事を登録できます。\nあなたの食事がモンスターの餌になります！',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),
                // アイコンボタン群
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildFoodButton(
                      context,
                      Icons.set_meal,
                      "主菜",
                      '/maindish',
                    ),
                    _buildFoodButton(
                      context,
                      Icons.rice_bowl,
                      "副菜",
                      '/sidedish',
                    ),
                    _buildFoodButton(
                      context,
                      Icons.soup_kitchen,
                      "汁物",
                      '/soup',
                    ),
                    _buildFoodButton(context, Icons.eco, "野菜", '/vegetable'),
                    _buildFoodButton(
                      context,
                      Icons.emoji_food_beverage,
                      "その他",
                      '/other',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodButton(
    BuildContext context,
    IconData icon,
    String label,
    String routeName,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Icon(icon, color: Color(0xFF9C6520), size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Color(0xFF9C6520))),
        ],
      ),
    );
  }
}

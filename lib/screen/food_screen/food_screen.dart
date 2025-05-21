import 'package:flutter/material.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFA8DAB5), // 背景色
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2D9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
              ),
              const SizedBox(height: 10),
              const Text(
                'ここでは今日のあなたの食事を登録できます。\nあなたの食事がモンスターの餌になります！',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 20),

              // カテゴリごとのアイコン表示
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildFoodCategory(
                    context,
                    Icons.set_meal,
                    "主菜",
                    '/maindish',
                  ),
                  _buildFoodCategory(
                    context,
                    Icons.rice_bowl,
                    "副菜",
                    '/sidedish',
                  ),
                  _buildFoodCategory(
                    context,
                    Icons.soup_kitchen,
                    "汁物",
                    '/soup',
                  ),
                  _buildFoodCategory(
                    context,
                    Icons.soup_kitchen,
                    "野菜",
                    '/vegetable',
                  ),
                  _buildFoodCategory(context, Icons.fastfood, "その他", '/other'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔽 ここに定義します（FoodScreenの下）
Widget _buildFoodCategory(
  BuildContext context,
  IconData icon,
  String label,
  String route,
) {
  return GestureDetector(
    onTap: () => Navigator.pushNamed(context, route),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 50, color: const Color(0xFF9C6520)),
        Text(label, style: const TextStyle(color: Color(0xFF9C6520))),
      ],
    ),
  );
}

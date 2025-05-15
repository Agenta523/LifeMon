import 'package:flutter/material.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFA8DAB5),
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
              // タイトル
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

              // 食事カテゴリーアイコン群
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/maindish');
                    },
                    child: Column(
                      children: const [
                        Icon(
                          Icons.set_meal,
                          size: 50,
                          color: Color(0xFF9C6520),
                        ),
                        Text("主菜", style: TextStyle(color: Color(0xFF9C6520))),
                      ],
                    ),
                  ),
                  Column(
                    children: const [
                      Icon(Icons.set_meal, size: 50, color: Color(0xFF9C6520)),
                      Text("魚", style: TextStyle(color: Color(0xFF9C6520))),
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(
                        Icons.ramen_dining,
                        size: 50,
                        color: Color(0xFF9C6520),
                      ),
                      Text("麺", style: TextStyle(color: Color(0xFF9C6520))),
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(Icons.rice_bowl, size: 50, color: Color(0xFF9C6520)),
                      Text("ごはん", style: TextStyle(color: Color(0xFF9C6520))),
                    ],
                  ),
                  Column(
                    children: const [
                      Icon(
                        Icons.local_florist,
                        size: 40,
                        color: Color(0xFF9C6520),
                      ),
                      Text("野菜", style: TextStyle(color: Color(0xFF9C6520))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

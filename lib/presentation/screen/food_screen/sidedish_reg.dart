import 'package:flutter/material.dart';
import 'package:life_mon/widget/food_register_template.dart'; // ← 実際のプロジェクト名に置き換える

class SideDishScreen extends StatelessWidget {
  const SideDishScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FoodRegisterTemplate(
      title: '副菜を登録',
      message: '副菜を登録してください',
      icon: Icons.ramen_dining,
    );
  }
}

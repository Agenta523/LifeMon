import 'package:flutter/material.dart';
import 'package:life_mon/presentation/widget/Food_Register_Template.dart';

class VegetableScreen extends StatelessWidget {
  const VegetableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FoodRegisterTemplate(
      title: '野菜を登録',
      message: '野菜を登録してください',
      icon: Icons.eco, // アイコンは好みに応じて変更可能
    );
  }
}

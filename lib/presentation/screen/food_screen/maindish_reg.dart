import 'package:flutter/material.dart';
import '../../widget/food_register_template.dart';

class MainDishScreen extends StatelessWidget {
  const MainDishScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FoodRegisterTemplate(
      title: '主菜を登録',
      message: '主菜の内容を入力してください',
      icon: Icons.restaurant,
    );
  }
}

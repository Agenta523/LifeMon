import 'package:flutter/material.dart';
import 'package:life_mon/presentation/widget/food_register_template.dart';

class OtherScreen extends StatelessWidget {
  const OtherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FoodRegisterTemplate(
      title: 'その他を登録',
      message: 'その他の食事を登録してください',
      icon: Icons.fastfood,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:life_mon/presentation/widget/Food_Register_Template.dart';

class SoupScreen extends StatelessWidget {
  const SoupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FoodRegisterTemplate(
      title: '汁物を登録',
      message: '汁物を登録してください',
      icon: Icons.soup_kitchen,
    );
  }
}

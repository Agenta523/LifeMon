import 'package:flutter/material.dart';
import 'package:life_mon/presentation/widget/calorie_bar.dart';
import 'package:life_mon/presentation/widget/body_icon.dart';
import 'package:life_mon/presentation/widget/eat_value.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<IconData> icons = [Icons.fitness_center, Icons.bolt, Icons.school];
  List<String> labels = ["タンパク質", "脂質", "炭水化物"];
  List<int> eat_value = [20, 30, 50];
  final colors_list = <Color>[
    Color.fromARGB(255, 255, 123, 134),
    Color.fromARGB(255, 255, 187, 0),
    Color.fromARGB(255, 123, 134, 255),
  ];

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final ellipseWidth = screenWidth * 2.5;
    final ellipseHeight = screenHeight * 0.7;
    final ellipseLeft = (screenWidth - ellipseWidth) / 2;
    final ellipseTop = screenHeight * 0.4;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Positioned(
              top: screenHeight * 0.1,
              left: screenWidth * 0.1,
              right: 0,
              child: BodyIcons(
                icons: icons,
                labels: labels,
                colors_list: colors_list,
                selectedIndex: selectedIndex,
                onSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
            CalorieBar(), // カロリーバーを表示
          ],
        ),
      ),
    );
  }
}

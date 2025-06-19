


import 'package:flutter/material.dart';
import 'package:life_mon/presentation/widget/calorie_bar.dart';
import 'package:life_mon/presentation/widget/body_icon.dart';
import 'package:life_mon/presentation/widget/eat_value.dart';
import 'package:rive/rive.dart';

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

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // RiveAnimationの配置
          Positioned(
            top: screenHeight * 0.3,
            left: screenWidth * 0.5 - (screenWidth * 0.2 / 2),
            child: SizedBox(
              height: screenHeight * 0.2,
              width: screenWidth * 0.2,
              child: RiveAnimation.asset(
                'lib/presentation/animations/teddycat.riv',
                animations: const['Timeline1'],
                fit: BoxFit.contain,
              ),
            ),
          ),
          // BodyIconsの配置 (RiveAnimationより上に調整)
          Positioned(
            top: screenHeight * 0.6, // こちらの値を調整して、RiveAnimationと重ならないようにします
            left: screenWidth * 0,
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
          // CalorieBarの配置
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: CalorieBar(),
            ),
          ),
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:life_mon/presentation/widget/calorie_bar.dart';
import 'package:life_mon/presentation/widget/body_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<IconData> icons = [Icons.fitness_center, Icons.bolt, Icons.school];
  List<String> labels = ["タンパク質", "脂質", "炭水化物"];
  List<int> eat_value = [60, 30, 120];
  List<int> eat_value_base = [90, 60, 250];

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
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/presentation/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CalorieBar(),
              BodyIcons(
                icons: icons,
                labels: labels,
                colors_list: colors_list,
                selectedIndex: selectedIndex,
                icons_length: icons.length,
                eat_values: eat_value,
                eat_values_base: eat_value_base,
                onSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
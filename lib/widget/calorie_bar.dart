import 'package:flutter/material.dart';

class CalorieBar extends StatelessWidget {
  const CalorieBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade300,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6, // 仮の摂取カロリー割合
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

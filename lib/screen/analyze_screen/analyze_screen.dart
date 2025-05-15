import 'package:flutter/material.dart';

class AnalyzeScreen extends StatefulWidget{
  const AnalyzeScreen({Key? key}) : super(key: key);

  @override
  State<AnalyzeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AnalyzeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 253, 253),
      body: Center(
        child: LifeGage(
          currentHp: 75,
          maxHp: 100,
        ),
      ),
    );
  }
}

class LifeGage extends StatelessWidget {
  final double currentHp;
  final double maxHp;

  const LifeGage({
    Key? key,
    required this.currentHp,
    required this.maxHp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double hpPercent = currentHp / maxHp;

    return Container(
      width: 200,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: hpPercent.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: hpPercent > 0.5
                    ? Colors.green
                    : hpPercent > 0.2
                        ? Colors.orange
                        : Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Center(
            child: Text(
              '${currentHp.toInt()} / ${maxHp.toInt()}',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}


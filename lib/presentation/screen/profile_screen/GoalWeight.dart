import 'package:flutter/material.dart';

class GoalWeight extends StatefulWidget {
  final String goalType;
  final String weight;
  final ValueChanged<String>? onGoalTypeChanged;
  final ValueChanged<String>? onWeightChanged;

  const GoalWeight({
    Key? key,
    required this.goalType,
    required this.weight,
    this.onGoalTypeChanged,
    this.onWeightChanged,
  }) : super(key: key);

  @override
  State<GoalWeight> createState() => _GoalWeightState();
}

class _GoalWeightState extends State<GoalWeight> {
  late String goalType;
  late TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    goalType = widget.goalType;
    weightController = TextEditingController(text: widget.weight);
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xffE6B45E)),
          child: const ListTile(
            title: Text(
              "目標増量/減量\n(一か月あたり)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.3,
                child: TextField(
                  controller: weightController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'kg',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (widget.onWeightChanged != null) {
                      widget.onWeightChanged!(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text("増量"),
                selected: goalType == "増量",
                selectedColor: const Color(0xff33C5D0),
                onSelected: (_) {
                  setState(() {
                    goalType = "増量";
                  });
                  if (widget.onGoalTypeChanged != null) {
                    widget.onGoalTypeChanged!("増量");
                  }
                },
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text("減量"),
                selected: goalType == "減量",
                selectedColor: const Color(0xff33C5D0),
                onSelected: (_) {
                  setState(() {
                    goalType = "減量";
                  });
                  if (widget.onGoalTypeChanged != null) {
                    widget.onGoalTypeChanged!("減量");
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
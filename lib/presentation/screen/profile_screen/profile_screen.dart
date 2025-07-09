import 'package:flutter/material.dart';
import 'package:life_mon/presentation/screen/profile_screen/ActivityLevel.dart';
import 'package:life_mon/presentation/screen/profile_screen/GoalWeight.dart';

class Profile extends StatefulWidget {
  final int? initialActivityIndex;
  final String initialGoalType;
  final String initialWeight;

  const Profile({
    super.key,
    this.initialActivityIndex,
    required this.initialGoalType,
    required this.initialWeight,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late int? selectedActivityIndex;
  late String goalType;
  late TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    selectedActivityIndex = widget.initialActivityIndex;
    goalType = widget.initialGoalType;
    weightController = TextEditingController(text: widget.initialWeight);
  }

  void _closeModal() {
    Navigator.of(context).pop({
      'activityIndex': selectedActivityIndex,
      'goalType': goalType,
      'weight': weightController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        _closeModal();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // ヘッダー
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'あなたについて教えて',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 32),
                      onPressed: _closeModal,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 本体
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        ActivityLevel(
                          initialActivityIndex: selectedActivityIndex,
                          onChanged: (index) {
                            setState(() {
                              selectedActivityIndex = index;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        GoalWeight(
                          goalType: goalType,
                          weight: weightController.text,
                          onGoalTypeChanged: (type) {
                            setState(() {
                              goalType = type;
                            });
                          },
                          onWeightChanged: (w) {
                            setState(() {
                              weightController.text = w;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
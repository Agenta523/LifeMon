import 'package:flutter/material.dart';
import 'activityLevel.dart';
import 'goalWeight.dart';
import 'height.dart';
import 'age.dart';
import 'sex.dart';

class Profile extends StatefulWidget {
  final int? initialActivityIndex;
  final String initialGoalType;
  final String initialWeight;
  final String initialHeight;
  final String initialAge;
  final String initialSex;

  const Profile({
    super.key,
    this.initialActivityIndex,
    required this.initialGoalType,
    required this.initialWeight,
    required this.initialHeight,
    required this.initialAge,
    required this.initialSex,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late int? selectedActivityIndex;
  late String goalType;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController ageController;
  late String sexType;

  @override
  void initState() {
    super.initState();
    selectedActivityIndex = widget.initialActivityIndex;
    goalType = widget.initialGoalType;
    weightController = TextEditingController(text: widget.initialWeight);
    heightController = TextEditingController(text: widget.initialHeight);
    ageController = TextEditingController(text: widget.initialAge);
    sexType = widget.initialSex;
  }

  void _closeModal() {
    Navigator.of(context).pop({
      'activityIndex': selectedActivityIndex,
      'goalType': goalType,
      'weight': weightController.text,
      'height': heightController.text,
      'age':ageController.text,
      'sex':sexType,
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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                          onGoalTypeChanged: (g) {
                            setState(() {
                              goalType = g;
                            });
                          },
                          onWeightChanged: (w) {
                            setState(() {
                              weightController.text = w;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Height(
                          height: heightController.text,
                          onHeightChanged: (h) {
                            setState(() {
                              heightController.text = h;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Age(
                          age: ageController.text,
                          onAgeChanged: (a) {
                            setState(() {
                              ageController.text = a;
                            });
                          },
                        ),
                        Sex(
                          sexType: sexType,
                          onSexTypeChanged: (s) {
                            setState(() {
                              sexType = s;
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
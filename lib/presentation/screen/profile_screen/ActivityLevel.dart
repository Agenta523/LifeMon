import 'package:flutter/material.dart';
import 'package:life_mon/presentation/screen/profile_screen/profile_screen.dart';

class ActivityLevel extends StatefulWidget {
  final int? initialActivityIndex;
  final ValueChanged<int>? onChanged;

  const ActivityLevel({
    Key? key,
    required this.initialActivityIndex,
    this.onChanged,
  }) : super(key: key);

  @override
  State<ActivityLevel> createState() => _ActivityLevelState();
}

class _ActivityLevelState extends State<ActivityLevel> {
  late int? selectedActivityIndex;

  final List<String> activityOptions = [
    "1. ほとんど運動しない",
    "2. 立位で仕事や通勤、軽い運動を週1-2回行う",
    "3. 力仕事や、活発な運動習慣を持つ"
  ];

  @override
  void initState() {
    super.initState();
    selectedActivityIndex = widget.initialActivityIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xffE6B45E)),
          child: const ListTile(
            title: Text(
              "活動レベル",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activityOptions.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedActivityIndex = index;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(index);
                }
              },
              child: Container(
                color: selectedActivityIndex == index
                    ? Colors.orange[100]
                    : null,
                child: ListTile(
                  title: Text(
                    activityOptions[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
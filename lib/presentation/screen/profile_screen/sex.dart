import 'package:flutter/material.dart';

class Sex extends StatefulWidget {
  final String sexType;
  final ValueChanged<String>? onSexTypeChanged;

  const Sex({
    Key? key,
    required this.sexType,
    this.onSexTypeChanged,
  }) : super(key: key);

  @override
  State<Sex> createState() => _SexState();
}

class _SexState extends State<Sex> {
  late String sexType;
  late TextEditingController weightController;

  void initState() {
    super.initState();
    sexType = widget.sexType;
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
              "医学的性別",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text("男"),
                selected: sexType == "男",
                selectedColor: const Color(0xff33C5D0),
                onSelected: (_) {
                  setState(() {
                  sexType = "男";
                  });
                  if (widget.onSexTypeChanged != null) {
                    widget.onSexTypeChanged!("男");
                  }
                },
              ),
              const SizedBox(width: 10),
              ChoiceChip(
                label: const Text("女"),
                selected: sexType == "女",
                selectedColor: const Color(0xff33C5D0),
                onSelected: (_) {
                  setState(() {
                  sexType = "女";
                  });
                  if (widget.onSexTypeChanged != null) {
                    widget.onSexTypeChanged!("女");
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
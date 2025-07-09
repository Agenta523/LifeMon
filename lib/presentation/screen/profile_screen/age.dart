import 'package:flutter/material.dart';

class Age extends StatefulWidget {
  final String age;
  final ValueChanged<String>? onAgeChanged;

  const Age({
    Key? key,
    required this.age,
    this.onAgeChanged,
  }) : super(key: key);

  @override
  State<Age> createState() => _HeightState();
}

class _HeightState extends State<Age> {
  late TextEditingController heightController;

  @override
  void initState() {
    super.initState();
    heightController = TextEditingController(text: widget.age);
  }

  @override
  void dispose() {
    heightController.dispose();
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
              "年齢",
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
                  controller: heightController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '歳',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (widget.onAgeChanged != null) {
                      widget.onAgeChanged!(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
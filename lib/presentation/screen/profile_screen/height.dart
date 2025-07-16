import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Height extends StatefulWidget {
  final String height;
  final ValueChanged<String>? onHeightChanged;

  const Height({
    Key? key,
    required this.height,
    this.onHeightChanged,
  }) : super(key: key);

  @override
  State<Height> createState() => _HeightState();
}

class _HeightState extends State<Height> {
  late TextEditingController heightController;

  @override
  void initState() {
    super.initState();
    heightController = TextEditingController(text: widget.height);
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
              "身長",
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
                    labelText: 'cm',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    if (widget.onHeightChanged != null) {
                      widget.onHeightChanged!(value);
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
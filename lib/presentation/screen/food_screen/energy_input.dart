import 'package:flutter/material.dart';

class EnergyInput extends StatefulWidget {
  final TextEditingController proteinController;
  final TextEditingController fatController;
  final TextEditingController carbController;

  const EnergyInput({
    super.key,
    required this.proteinController,
    required this.fatController,
    required this.carbController,
  });

  @override
  State<EnergyInput> createState() => _EnergyInputState();
}

class _EnergyInputState extends State<EnergyInput>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '$label を入力',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
            ),
          ),
          const Text(
            'g',
            style: TextStyle(
              color: Color(0xFFF4B400),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4B400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                '栄養を入力',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child:
              _expanded
                  ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        _buildInputField(
                          label: 'タンパク質',
                          controller: widget.proteinController,
                        ),
                        _buildInputField(
                          label: '脂質',
                          controller: widget.fatController,
                        ),
                        _buildInputField(
                          label: '炭水化物',
                          controller: widget.carbController,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF4B400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final protein = widget.proteinController.text;
                            final fat = widget.fatController.text;
                            final carb = widget.carbController.text;

                            print('登録: タンパク質=$protein, 脂質=$fat, 炭水化物=$carb');

                            FocusScope.of(context).unfocus();
                            setState(() {
                              _expanded = false;
                            });
                          },
                          child: const Text(
                            '登録',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

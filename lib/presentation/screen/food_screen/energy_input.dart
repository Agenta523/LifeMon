import 'package:flutter/material.dart';
import 'energy_repository.dart';
import 'energy_input_field.dart';

class EnergyInput extends StatefulWidget {
  const EnergyInput({super.key});

  @override
  State<EnergyInput> createState() => _EnergyInputState();
}

class _EnergyInputState extends State<EnergyInput>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  final _repo = EnergyRepository();

  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _repo.load();
    setState(() {
      _proteinController.text = data['protein'] ?? '';
      _fatController.text = data['fat'] ?? '';
      _carbController.text = data['carb'] ?? '';
    });
  }

  Future<void> _save() async {
    DateTime now = DateTime.now();
    String date =
        '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}';

    await _repo.save(
      protein: _proteinController.text,
      fat: _fatController.text,
      carb: _carbController.text,
      date: date,
    );

    _proteinController.clear();
    _fatController.clear();
    _carbController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        EnergyInputField(
                          label: 'タンパク質',
                          controller: _proteinController,
                          onChanged: _save,
                        ),
                        EnergyInputField(
                          label: '脂質',
                          controller: _fatController,
                          onChanged: _save,
                        ),
                        EnergyInputField(
                          label: '炭水化物',
                          controller: _carbController,
                          onChanged: _save,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // ✅ 保存処理
                            await _save();
                            setState(() {
                              _expanded = false;
                            });
                          },
                          child: const Text('登録'),
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

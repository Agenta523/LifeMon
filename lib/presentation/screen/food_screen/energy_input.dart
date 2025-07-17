import 'package:flutter/material.dart';
import 'package:life_mon/data/FoodLogStorage.dart';
import 'energy_input_field.dart';

class EnergyInput extends StatefulWidget {
  const EnergyInput({super.key});

  @override
  State<EnergyInput> createState() => _EnergyInputState();
}

class _EnergyInputState extends State<EnergyInput>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  final _repo = DateValueStorage();

  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repo.init(); // 初期化は必要
  }

  Future<void> _save() async {
    final now = DateTime.now();

    final int protein = int.tryParse(_proteinController.text) ?? 0;
    final int fat = int.tryParse(_fatController.text) ?? 0;
    final int carbo = int.tryParse(_carbController.text) ?? 0;

    await _repo.addData(now, protein: protein, fat: fat, carbo: carbo);

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
                          onChanged: () {},
                        ),
                        EnergyInputField(
                          label: '脂質',
                          controller: _fatController,
                          onChanged: () {},
                        ),
                        EnergyInputField(
                          label: '炭水化物',
                          controller: _carbController,
                          onChanged: () {},
                        ),
                        ElevatedButton(
                          onPressed: () async {
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dish_catalog_screen.dart';
import 'food_button.dart';
import 'energy_input.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final Map<String, List<String>> selectedDishes = {};

  Future<void> _openCatalog(String category) async {
    final result = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder:
            (_) => DishCatalogScreen(
              dishCategory: category,
              initialSelection: selectedDishes[category] ?? [],
            ),
      ),
    );

    if (result != null) {
      setState(() {
        selectedDishes[category] = result;
      });
    }
  }

  void _registerMeals() {
    debugPrint('登録する料理: $selectedDishes');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('食事を登録しました！')));
    setState(() {
      selectedDishes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': '主食', 'icon': 'lib/presentation/images/maindish.svg'},
      {'label': '主菜', 'icon': 'lib/presentation/images/sidedish.svg'},
      {'label': '汁物', 'icon': 'lib/presentation/images/soup.svg'},
      {'label': '副菜', 'icon': 'lib/presentation/images/vegetable.svg'},
      {'label': 'その他', 'icon': 'lib/presentation/images/other.svg'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFA8DAB5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2D9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4B400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '食事を登録',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '今日の食事を登録してモンスターを育てよう！',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final category in categories)
                        FoodButton(
                          imagePath: category['icon']!,
                          label: category['label']!,
                          onPressed: () => _openCatalog(category['label']!),
                        ),
                      const EnergyInput(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (selectedDishes.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          selectedDishes.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                '${entry.key}: ${entry.value.join(', ')}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          }).toList(),
                    ),
                  const SizedBox(height: 12),
                  Center(
                    child: ElevatedButton(
                      onPressed: selectedDishes.isEmpty ? null : _registerMeals,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF4B400),
                      ),
                      child: const Text(
                        'すべて登録する',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

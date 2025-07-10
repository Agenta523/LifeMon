import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dish_catalog_screen.dart';
import 'food_button.dart';
import 'energy_input.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _proteinController = TextEditingController();
    final TextEditingController _fatController = TextEditingController();
    final TextEditingController _carbController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFA8DAB5),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2D9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      'ここでは今日の食事を登録できます。\nあなたの食事がモンスターの餌になります！',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      FoodButton(
                        imagePath: 'lib/presentation/images/maindish.svg',
                        label: "主菜",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const DishCatalogScreen(
                                    dishCategory: '主菜',
                                  ),
                            ),
                          );
                        },
                      ),
                      FoodButton(
                        imagePath: 'lib/presentation/images/sidedish.svg',
                        label: "副菜",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const DishCatalogScreen(
                                    dishCategory: '副菜',
                                  ),
                            ),
                          );
                        },
                      ),
                      FoodButton(
                        imagePath: 'lib/presentation/images/soup.svg',
                        label: "汁物",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const DishCatalogScreen(
                                    dishCategory: '汁物',
                                  ),
                            ),
                          );
                        },
                      ),
                      FoodButton(
                        imagePath: 'lib/presentation/images/vegetable.svg',
                        label: "野菜",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const DishCatalogScreen(
                                    dishCategory: '野菜',
                                  ),
                            ),
                          );
                        },
                      ),
                      FoodButton(
                        imagePath: 'lib/presentation/images/other.svg',
                        label: "その他",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const DishCatalogScreen(
                                    dishCategory: 'その他',
                                  ),
                            ),
                          );
                        },
                      ),
                      EnergyInput(),
                    ],
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

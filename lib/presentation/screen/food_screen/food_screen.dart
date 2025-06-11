import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dish_catalog_screen.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _energyController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFA8DAB5),
      body: SafeArea(
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
                    'ここでは今日のあなたの食事を登録できます。\nあなたの食事がモンスターの餌になります！',
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
                    _buildFoodButton(
                      context,
                      'lib/presentation/images/maindish.svg',
                      "主菜",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DishCatalogScreen(dishCategory: '主菜'),
                          ),
                        );
                      },
                    ),
                    _buildFoodButton(
                      context,
                      'lib/presentation/images/sidedish.svg',
                      "副菜",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DishCatalogScreen(dishCategory: '副菜'),
                          ),
                        );
                      },
                    ),
                    _buildFoodButton(
                      context,
                      'lib/presentation/images/soup.svg',
                      "汁物",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DishCatalogScreen(dishCategory: '汁物'),
                          ),
                        );
                      },
                    ),
                    _buildFoodButton(
                      context,
                      'lib/presentation/images/vegetable.svg',
                      "野菜",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DishCatalogScreen(dishCategory: '野菜'),
                          ),
                        );
                      },
                    ),
                    _buildFoodButton(
                      context,
                      'lib/presentation/images/other.svg',
                      "その他",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DishCatalogScreen(dishCategory: 'その他'),
                          ),
                        );
                      },
                    ),
                    _buildEnergyInput('エネルギー', _energyController),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodButton(
    BuildContext context,
    String imagePath,
    String label,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: SvgPicture.asset(imagePath, width: 32, height: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Color(0xFF9C6520))),
        ],
      ),
    );
  }

  Widget _buildEnergyInput(String label, TextEditingController controller) {
    return Container(
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
                hintStyle: const TextStyle(
                  color: Colors.grey, // 👈 ここが薄くするポイント
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
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
}

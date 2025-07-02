import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dish_catalog_screen.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ ここで3つのコントローラーを定義
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
                      // ✅ EnergyInput を正しいパラメータで呼ぶ
                      EnergyInput(
                        proteinController: _proteinController,
                        fatController: _fatController,
                        carbController: _carbController,
                      ),
                      const SizedBox(height: 24),
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
}

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
        /// 折りたたみボタン
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

        /// 展開部分
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child:
              _expanded
                  ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        /// タンパク質
                        _buildInputField(
                          label: 'タンパク質',
                          controller: widget.proteinController,
                        ),

                        /// 脂質
                        _buildInputField(
                          label: '脂質',
                          controller: widget.fatController,
                        ),

                        /// 炭水化物
                        _buildInputField(
                          label: '炭水化物',
                          controller: widget.carbController,
                        ),

                        /// 登録ボタン
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

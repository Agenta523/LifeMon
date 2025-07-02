import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:life_mon/presentation/widget/calorie_bar.dart';
import 'package:life_mon/presentation/widget/body_icon.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class CustomProfileBar extends StatelessWidget {
  final String name;
  final String message;

  const CustomProfileBar({
    super.key,
    required this.name,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.5;
    double height = 80;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              // 白い丸背景（プロフィール画像の下）
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),

              // プロフィール画像
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/profile_icon.png'),
              ),

              // 赤ポチ（左上）
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // 名前 + コメント
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<IconData> icons = [Icons.fitness_center, Icons.bolt, Icons.school];
  List<String> labels = ["タンパク質", "脂質", "炭水化物"];
  List<int> eat_value = [60, 30, 120];
  List<int> eat_value_base = [90, 60, 250];

  final colors_list = <Color>[
    Color.fromARGB(255, 255, 123, 134),
    Color.fromARGB(255, 255, 187, 0),
    Color.fromARGB(255, 123, 134, 255),
  ];

  int selectedIndex = 0;

  // キャラクターアセット（Riveファイル）リスト
  final List<String> characterRives = [
    'lib/presentation/images/character1.riv',
    'lib/presentation/images/character2.riv',
    'lib/presentation/images/character3.riv',
  ];

  final List<String> characterIcons = [
    'lib/presentation/images/character1_icon.png',
    'lib/presentation/images/character2_icon.png',
    'lib/presentation/images/character3_icon.png',
  ];

  int selectedCharacterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/presentation/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // キャラクター画像表示（中央あたりに重ねて表示）
          Positioned(
            top: screenHeight * 0.2,
            left: screenWidth * 0.5 - 100,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(-1.0, 1.0),
                child: RiveAnimation.asset(
                  characterRives[selectedCharacterIndex],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Positioned(
            top: 40,
            left: 20,
            child: CustomProfileBar(name: "ハルオ", message: "元気に頑張ってます！"),
          ),

          // キャラクター選択アイコン（右上）
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                _showCharacterSelectionDialog(
                  context: context,
                  characterRivePaths: characterRives,
                  currentIndex: selectedCharacterIndex,
                  onCharacterSelected: (index) {
                    setState(() {
                      selectedCharacterIndex = index;
                    });
                  },
                );
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  characterIcons[selectedCharacterIndex],
                ),
                radius: 25,
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CalorieBar(),
              BodyIcons(
                icons: icons,
                labels: labels,
                colors_list: colors_list,
                selectedIndex: selectedIndex,
                icons_length: icons.length,
                eat_values: eat_value,
                eat_values_base: eat_value_base,
                onSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // キャラクター選択画面
  void _showCharacterSelectionDialog({
    required BuildContext context,
    required List<String> characterRivePaths,
    required Function(int selectedIndex) onCharacterSelected,
    int currentIndex = 0,
  }) {
    int tempIndex = currentIndex;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 420,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'キャラクターを選んでください',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // キャラ表示スライダー
                    Expanded(
                      child: PageView.builder(
                        itemCount: characterRivePaths.length,
                        controller: PageController(viewportFraction: 0.8),
                        onPageChanged: (index) {
                          setModalState(() {
                            tempIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Transform.scale(
                            scale: index == tempIndex ? 1.0 : 0.85,
                            child: RiveAnimation.asset(
                              characterRivePaths[index],
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: () {
                        onCharacterSelected(tempIndex);
                        Navigator.pop(context);
                      },
                      child: const Text("呼ぶ"),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

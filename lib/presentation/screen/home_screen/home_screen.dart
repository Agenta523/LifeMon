import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

import 'package:life_mon/presentation/widget/calorie_bar.dart';
import 'package:life_mon/presentation/widget/body_icon.dart';

class CharacterInfo {
  final String name;
  final String description;
  final String riveFile;
  final String iconImage;

  CharacterInfo({
    required this.name,
    required this.description,
    required this.riveFile,
    required this.iconImage,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<CharacterInfo> characters = [
    CharacterInfo(
      name: 'ハルオ',
      description: '元気でやさしい筋トレ好きキャラ',
      riveFile: 'lib/presentation/images/character3.riv',
      iconImage: 'lib/presentation/images/character3_icon.png',
    ),
    CharacterInfo(
      name: 'ユウコ',
      description: '冷静で賢い分析キャラ',
      riveFile: 'lib/presentation/images/character2.riv',
      iconImage: 'lib/presentation/images/character2_icon.png',
    ),
    CharacterInfo(
      name: 'モフィメット',
      description: '植物と話す自然派キャラ',
      riveFile: 'lib/presentation/images/character3.riv',
      iconImage: 'lib/presentation/images/character3_icon.png',
    ),
  ];

  final List<IconData> icons = [Icons.fitness_center, Icons.bolt, Icons.school];
  final List<String> labels = ["タンパク質", "脂質", "炭水化物"];
  final List<Color> colors_list = [
    Color.fromARGB(255, 255, 123, 134),
    Color.fromARGB(255, 255, 187, 0),
    Color.fromARGB(255, 123, 134, 255),
  ];
  final List<int> eat_value_base = [90, 60, 250];
  List<int> eat_value = [70, 50, 200];
  int selectedIndex = 0;

  int selectedCharacterIndex = 0;
  Artboard? _artboard;
  RiveAnimationController? _controller;

  double characterX = 100.0;
  double characterY = 300.0;
  late AnimationController _animationController;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  bool isFacingLeft = false;

  @override
  void initState() {
    super.initState();
    _loadRive(characters[selectedCharacterIndex].riveFile);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _loadRive(String path) async {
    final data = await rootBundle.load(path);
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;
    final controller = SimpleAnimation('待機');
    artboard.addController(controller);

    setState(() {
      _artboard = artboard;
      _controller = controller;
    });
  }

  void _moveCharacterTo(Offset target) {
    if (_artboard == null) return;

    final distance = (Offset(characterX, characterY) - target).distance;
    final duration = Duration(
      milliseconds: (distance * 5).clamp(300, 2000).toInt(),
    );

    setState(() {
      isFacingLeft = target.dx < characterX;
    });

    _artboard!.removeController(_controller!);
    final walk = SimpleAnimation('歩く');
    _artboard!.addController(walk);
    _controller = walk;

    _xAnimation = Tween<double>(
      begin: characterX,
      end: target.dx,
    ).animate(_animationController);
    _yAnimation = Tween<double>(
      begin: characterY,
      end: target.dy,
    ).animate(_animationController);

    _animationController.stop();
    _animationController.reset();

    _animationController.removeListener(_updateCharacterPosition);
    _animationController.removeStatusListener(_handleAnimationStatus);

    _animationController.addListener(_updateCharacterPosition);
    _animationController.addStatusListener(_handleAnimationStatus);

    _animationController.forward(from: 0.0);
  }

  void _updateCharacterPosition() {
    setState(() {
      characterX = _xAnimation.value;
      characterY = _yAnimation.value;
    });
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _artboard!.removeController(_controller!);
      final idle = SimpleAnimation('待機');
      _artboard!.addController(idle);
      _controller = idle;
    }
  }

  void _showCharacterSelectionDialog() {
    int tempIndex = selectedCharacterIndex;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 480,
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
                    Text(
                      characters[tempIndex].name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      characters[tempIndex].description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: PageView.builder(
                        itemCount: characters.length,
                        controller: PageController(viewportFraction: 0.8),
                        onPageChanged: (index) {
                          setModalState(() => tempIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return Transform.scale(
                            scale: index == tempIndex ? 1.0 : 0.85,
                            child: RiveAnimation.asset(
                              characters[index].riveFile,
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCharacterIndex = tempIndex;
                        });
                        _loadRive(characters[tempIndex].riveFile);
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 背景
          Positioned.fill(
            child: Image.asset(
              'lib/presentation/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 全画面タップでキャラ移動
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                final local = details.localPosition;
                _moveCharacterTo(Offset(local.dx - 100, local.dy - 100));
              },
            ),
          ),

          /// キャラクター
          Positioned(
            left: characterX,
            top: characterY,
            child: SizedBox(
              width: 200,
              height: 200,
              child:
                  _artboard != null
                      ? Transform(
                        alignment: Alignment.center,
                        transform:
                            Matrix4.identity()
                              ..scale(isFacingLeft ? 1.0 : -1.0, 1.0),
                        child: Rive(artboard: _artboard!),
                      )
                      : const SizedBox(),
            ),
          ),

          /// キャラ選択ボタン（必ず一番上！）
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _showCharacterSelectionDialog,
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  characters[selectedCharacterIndex].iconImage,
                ),
                radius: 25,
              ),
            ),
          ),

          /// ユーザープロフィール
          Positioned(
            top: 40,
            left: 20,
            child: Row(
              children: const [
                CircleAvatar(backgroundColor: Colors.grey, radius: 24),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ユーザー名",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("今日も元気に活動中", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          /// 下部 UI
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const CalorieBar(),
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
}

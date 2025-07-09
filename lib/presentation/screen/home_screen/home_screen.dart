import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

import 'package:life_mon/presentation/widget/calorie_bar.dart';
import 'package:life_mon/presentation/widget/body_icon.dart';
import 'package:life_mon/presentation/screen/profile_screen/profile_screen.dart';

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
      name: 'モフィメット',
      description: '元気でやさしい筋トレ好きキャラ',
      riveFile: 'lib/presentation/images/mohu.riv',
      iconImage: 'lib/presentation/images/character3_icon.png',
    ),
    CharacterInfo(
      name: 'テディキャット',
      description: '冷静で賢い分析キャラ',
      riveFile: 'lib/presentation/images/cat.riv',
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

  double? characterX;
  double? characterY;
  late AnimationController _animationController;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  bool isFacingLeft = false;

  final double characterSize = 200.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初期位置を画面中央に設定
    if (characterX == null || characterY == null) {
      final size = MediaQuery.of(context).size;
      characterX = (size.width / 2) - (characterSize / 2);
      characterY = (size.height / 2) - (characterSize / 2);
    }
    _loadRive(characters[selectedCharacterIndex].riveFile);
  }

  Future<void> _loadRive(String path) async {
    final data = await rootBundle.load(path);
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    // 前のコントローラーがあれば削除
    if (_controller != null) {
      artboard.removeController(_controller!);
    }

    final controller = SimpleAnimation('state'); // 必ず新しく生成
    artboard.addController(controller);

    setState(() {
      _artboard = artboard;
      _controller = controller;
    });
  }

  void _moveCharacterTo(Offset target) {
    if (_artboard == null) return;

    final distance = (Offset(characterX!, characterY!) - target).distance;
    final duration = Duration(
      milliseconds: (distance * 5).clamp(300, 2000).toInt(),
    );

    setState(() {
      isFacingLeft = target.dx < characterX!;
    });

    _artboard!.removeController(_controller!);
    final walk = SimpleAnimation('walk');
    _artboard!.addController(walk);
    _controller = walk;

    _xAnimation = Tween<double>(
      begin: characterX!,
      end: target.dx,
    ).animate(_animationController);
    _yAnimation = Tween<double>(
      begin: characterY!,
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
      if (_controller != null && _artboard != null) {
        _artboard!.removeController(_controller!);
      }
      final idle = SimpleAnimation('state'); // 止まらないように新しく生成
      _artboard!.addController(idle);
      setState(() {
        _controller = idle;
      });
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
            height: 500,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
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
                                  fit: BoxFit.contain,
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
                    ),

                    // 一覧ボタン（右上に重ねて表示）
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.grid_view_rounded),
                        onPressed: () {
                          Navigator.pop(context); // 現在のダイアログを閉じる
                          _showCharacterGridSelectionDialog(); // グリッド表示に切り替え
                        },
                      ),
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

  void _showCharacterGridSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('キャラクター一覧'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: characters.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCharacterIndex = index;
                    });
                    _loadRive(characters[index].riveFile);
                    Navigator.pop(context); // グリッドモーダルを閉じる
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          characters[index].iconImage,
                        ),
                        radius: 30,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        characters[index].name,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
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

  /// プロフィール関連の変数
  String height = ""; // 身長
  String age = ""; // 年齢
  int? sex = 0; // 0: 男性, 1: 女性
  int? selectedActivityIndex; //活動レベル
  String goalType = "増量"; // 増減量
  String weight = ""; // 目標体重変化量

  @override
  Widget build(BuildContext context) {
    //profileを非同期で呼び出し（モーダル表示）
    void _openProfileDialog() async {
      final result = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 1.0,
            child: Profile(
              initialActivityIndex: selectedActivityIndex,
              initialGoalType: goalType,
              initialWeight: weight,
              /*
              これから追加
              initialHeight: height,
              initialAge: age,
              initialSex: sex
              */
            ),
          );
        },
      );

      if (result != null) {
        setState(() {
          selectedActivityIndex = result['activityIndex'];
          goalType = result['goalType'];
          weight = result['weight'];
        });
      }
      debugPrint(
        "✅ initState called: $selectedActivityIndex, $goalType, $weight",
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/presentation/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                final local = details.localPosition;
                _moveCharacterTo(
                  Offset(
                    local.dx - characterSize / 2,
                    local.dy - characterSize / 2,
                  ),
                );
              },
            ),
          ),

          if (_artboard != null && characterX != null && characterY != null)
            Positioned(
              left: characterX!,
              top: characterY!,
              child: SizedBox(
                width: characterSize,
                height: characterSize,
                child: Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()..scale(isFacingLeft ? 1.0 : -1.0, 1.0),
                  child: Rive(artboard: _artboard!),
                ),
              ),
            ),

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

          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => _openProfileDialog(),
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
          ),

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

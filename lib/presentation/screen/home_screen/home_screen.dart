import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'package:life_mon/presentation/screen/home_screen/widget/character_info.dart';
import 'package:life_mon/presentation/widget/calorie_bar.dart';
import 'package:life_mon/presentation/widget/body_icon.dart';
import 'package:life_mon/presentation/screen/profile_screen/profile_screen.dart';
import 'package:life_mon/presentation/screen/home_screen/widget/character_display.dart';
import 'package:life_mon/presentation/screen/home_screen/widget/character_selection_dialog.dart';
import 'package:life_mon/presentation/screen/home_screen/widget/character_grid_dialog.dart';
import 'package:life_mon/presentation/screen/home_screen/widget/user_profile_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Data
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
    const Color.fromARGB(255, 255, 123, 134),
    const Color.fromARGB(255, 255, 187, 0),
    const Color.fromARGB(255, 123, 134, 255),
  ];
  final List<int> eat_value_base = [90, 60, 250];
  List<int> eat_value = [70, 50, 200];
  int selectedIndex = 0;

  // Character State
  int selectedCharacterIndex = 0;
  Artboard? _artboard;
  RiveAnimationController? _controller; // ★ 修正: 現在のコントローラーを保持
  late AnimationController _animationController;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  double? characterX;
  double? characterY;
  bool isFacingLeft = false;
  final double characterSize = 200.0;

  // Profile State
  String height = "";
  String age = "";
  int? sex = 0;
  int? selectedActivityIndex;
  String goalType = "増量";
  String weight = "";

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1500),
          )
          ..addListener(_updateCharacterPosition)
          ..addStatusListener(_handleAnimationStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (characterX == null) {
      final size = MediaQuery.of(context).size;
      characterX = (size.width / 2) - (characterSize / 2);
      characterY = (size.height / 2) - (characterSize / 2);
    }
    _loadRive(characters[selectedCharacterIndex].riveFile);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller?.dispose(); // ★ 修正: コントローラーをdispose
    super.dispose();
  }

  // --- Core Logic Methods ---

  Future<void> _loadRive(String path) async {
    final data = await rootBundle.load(path);
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    // ★ 修正: 古いコントローラーが存在すれば削除
    if (_controller != null) {
      artboard.removeController(_controller!);
      _controller!.dispose();
    }

    final newController = SimpleAnimation('state');
    artboard.addController(newController);

    setState(() {
      _artboard = artboard;
      _controller = newController; // ★ 修正: 新しいコントローラーを保持
    });
  }

  void _moveCharacterTo(Offset target) {
    if (_artboard == null) return;

    setState(() {
      isFacingLeft = target.dx < characterX!;
    });

    // ★ 修正: 現在のコントローラーを削除
    if (_controller != null) {
      _artboard!.removeController(_controller!);
    }

    // ★ 修正: 新しい'walk'コントローラーを作成し、保持する
    final walkController = SimpleAnimation('walk');
    _artboard!.addController(walkController);
    _controller = walkController;

    _xAnimation = Tween<double>(
      begin: characterX!,
      end: target.dx,
    ).animate(_animationController);
    _yAnimation = Tween<double>(
      begin: characterY!,
      end: target.dy,
    ).animate(_animationController);

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
      // ★ 修正: 'walk'コントローラーを削除
      if (_controller != null) {
        _artboard?.removeController(_controller!);
      }

      // ★ 修正: 新しい'state'コントローラーを作成し、保持する
      final idleController = SimpleAnimation('state');
      _artboard?.addController(idleController);
      _controller = idleController;
    }
  }

  void _onCharacterSelected(int index) {
    if (selectedCharacterIndex == index) return;
    setState(() {
      selectedCharacterIndex = index;
    });
    _loadRive(characters[index].riveFile);
  }

  // --- Dialog Methods (変更なし) ---
  void _showCharacterSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CharacterSelectionDialog(
          characters: characters,
          initialIndex: selectedCharacterIndex,
          onCharacterSelected: _onCharacterSelected,
          onSwitchToGrid: () {
            Navigator.pop(context);
            _showCharacterGridSelectionDialog();
          },
        );
      },
    );
  }

  void _showCharacterGridSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CharacterGridDialog(
          characters: characters,
          onCharacterSelected: _onCharacterSelected,
          onGoBack: () {
            Navigator.pop(context);
            _showCharacterSelectionDialog();
          },
        );
      },
    );
  }

  void _openProfileDialog() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => FractionallySizedBox(
            heightFactor: 1.0,
            child: Profile(
              initialActivityIndex: selectedActivityIndex,
              initialGoalType: goalType,
              initialWeight: weight,
            ),
          ),
    );
    if (result != null) {
      setState(() {
        selectedActivityIndex = result['activityIndex'];
        goalType = result['goalType'];
        weight = result['weight'];
      });
    }
  }

  // --- Build Method (変更なし) ---
  @override
  Widget build(BuildContext context) {
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
              onTapDown:
                  (details) => _moveCharacterTo(
                    Offset(
                      details.localPosition.dx - characterSize / 2,
                      details.localPosition.dy - characterSize / 2,
                    ),
                  ),
            ),
          ),
          if (_artboard != null && characterX != null && characterY != null)
            CharacterDisplay(
              artboard: _artboard!,
              x: characterX!,
              y: characterY!,
              size: characterSize,
              isFacingLeft: isFacingLeft,
            ),
          UserProfileHeader(onTap: _openProfileDialog),
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
                onSelected: (index) => setState(() => selectedIndex = index),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
